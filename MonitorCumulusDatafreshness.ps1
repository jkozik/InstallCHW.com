#Requires -Version 3.0
<#
.SYNOPSIS
    Monitor-CumulusDataFreshness.ps1
    Monitors Cumulus realtime.txt file age and restarts Cumulus if data becomes stale.

.DESCRIPTION
    Checks if Cumulus has been running for more than the startup grace period, and
    if the realtime.txt file is older than the stale threshold, kills and restarts
    Cumulus. This is more reliable than trying to detect error dialogs.

.NOTES
    - Run as: powershell -WindowStyle Hidden -File "Monitor-CumulusDataFreshness.ps1"
    - Or set up as a Task Scheduler job (see comments at bottom of script).
    - Logs to: C:\Logs\CumulusMonitor.log
#>

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
$LogFile            = "C:\Logs\CumulusMonitor.log"
$CumulusExePath     = "C:\Cumulus\Cumulus.exe"         # *** ADJUST THIS PATH ***
$RealtimeFilePath   = "C:\Cumulus\realtime.txt"        # *** ADJUST THIS PATH ***
$StaleThreshold     = 5                                 # Minutes - if file older than this, restart
$StartupGracePeriod = 10                                # Minutes - allow Cumulus this long to start up
$RestartDelay       = 5                                 # Seconds to wait between kill and restart
$CheckInterval      = 60                                # Seconds between checks (check every minute)

# ---------------------------------------------------------------------------
# Ensure log directory exists
# ---------------------------------------------------------------------------
$LogDir = Split-Path $LogFile
if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

# ---------------------------------------------------------------------------
# Logging helper
# ---------------------------------------------------------------------------
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp  $Message" | Add-Content -Path $LogFile -Encoding UTF8
}

# ---------------------------------------------------------------------------
# Check if Cumulus data is stale
# ---------------------------------------------------------------------------
function Test-CumulusDataStale {
    # Check if Cumulus process is running
    $cumulusProcess = Get-Process -Name "Cumulus" -ErrorAction SilentlyContinue | Select-Object -First 1
    
    if (-not $cumulusProcess) {
        Write-Log "Cumulus is not running. Will attempt to start it."
        return $true
    }
    
    # Check how long Cumulus has been running
    $startTime = [DateTime]$cumulusProcess.StartTime
    $processRuntime = New-TimeSpan -Start $startTime -End (Get-Date)
    if ($processRuntime.TotalMinutes -lt $StartupGracePeriod) {
        Write-Log "Cumulus has only been running for $([math]::Round($processRuntime.TotalMinutes, 1)) minutes. Still in startup grace period."
        return $false
    }
    
    # Check if realtime.txt exists
    if (-not (Test-Path $RealtimeFilePath)) {
        Write-Log "WARNING: realtime.txt not found at $RealtimeFilePath. Cumulus may not be configured correctly."
        return $false
    }
    
    # Check file age
    $fileInfo = Get-Item $RealtimeFilePath
    $fileLastWrite = [DateTime]$fileInfo.LastWriteTime
    $fileAge = New-TimeSpan -Start $fileLastWrite -End (Get-Date)
    $fileAgeMinutes = [math]::Round($fileAge.TotalMinutes, 1)
    
    Write-Log "Cumulus runtime: $([math]::Round($processRuntime.TotalMinutes, 1)) min | realtime.txt age: $fileAgeMinutes min"
    
    if ($fileAge.TotalMinutes -gt $StaleThreshold) {
        Write-Log "DATA STALE: realtime.txt is $fileAgeMinutes minutes old (threshold: $StaleThreshold min)"
        return $true
    }
    
    return $false
}

# ---------------------------------------------------------------------------
# Restart Cumulus
# ---------------------------------------------------------------------------
function Restart-Cumulus {
    Write-Log "=== RESTARTING CUMULUS ==="
    
    # Step 1: Kill all Cumulus processes
    $cumulusProcesses = Get-Process -Name "Cumulus" -ErrorAction SilentlyContinue
    if ($cumulusProcesses) {
        foreach ($proc in $cumulusProcesses) {
            Write-Log "Terminating Cumulus process (PID: $($proc.Id))..."
            try {
                $proc.Kill()
                $proc.WaitForExit(10000)  # Wait up to 10 seconds for graceful exit
            } catch {
                Write-Log "ERROR killing process: $_"
            }
        }
        Write-Log "Cumulus processes terminated."
    }
    
    # Step 2: Wait for clean shutdown
    Write-Log "Waiting $RestartDelay seconds before restart..."
    Start-Sleep -Seconds $RestartDelay
    
    # Step 3: Restart Cumulus
    if (Test-Path $CumulusExePath) {
        try {
            Write-Log "Starting Cumulus from: $CumulusExePath"
            Start-Process -FilePath $CumulusExePath
            Write-Log "Cumulus started successfully."
        } catch {
            Write-Log "ERROR starting Cumulus: $_"
        }
    } else {
        Write-Log "ERROR: Cumulus executable not found at: $CumulusExePath"
    }
    
    Write-Log "=== RESTART COMPLETE ==="
}

# ---------------------------------------------------------------------------
# Main monitoring loop
# ---------------------------------------------------------------------------
Write-Log "===== Cumulus Data Freshness Monitor Started ====="
Write-Log "Configuration:"
Write-Log "  Realtime file: $RealtimeFilePath"
Write-Log "  Stale threshold: $StaleThreshold minutes"
Write-Log "  Startup grace period: $StartupGracePeriod minutes"
Write-Log "  Check interval: $CheckInterval seconds"

while ($true) {
    try {
        if (Test-CumulusDataStale) {
            Restart-Cumulus
            
            # After restart, wait a bit longer before next check to allow startup
            Write-Log "Waiting $StartupGracePeriod minutes before next check (startup grace period)..."
            Start-Sleep -Seconds ($StartupGracePeriod * 60)
        }
    } catch {
        Write-Log "ERROR in monitoring loop: $_"
    }
    
    Start-Sleep -Seconds $CheckInterval
}

# ---------------------------------------------------------------------------
# TASK SCHEDULER SETUP (run these commands once, manually, in an elevated
# PowerShell prompt to create the scheduled task):
#
#   $scriptPath = "C:\Scripts\Monitor-CumulusDataFreshness.ps1"   # adjust as needed
#
#   $action = New-ScheduledTaskAction `
#       -Execute "powershell.exe" `
#       -Argument "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
#
#   $trigger = New-ScheduledTaskTrigger -AtLogon
#
#   $settings = New-ScheduledTaskSettingsSet `
#       -ExecutionTimeLimit (New-TimeSpan -Days 365) `
#       -RestartCount 3 `
#       -RestartInterval (New-TimeSpan -Minutes 1)
#
#   Register-ScheduledTask `
#       -TaskName "Monitor Cumulus Data Freshness" `
#       -Action $action `
#       -Trigger $trigger `
#       -Settings $settings `
#       -RunLevel Highest `
#       -User "SYSTEM"
#
# ---------------------------------------------------------------------------