#Requires -Version 3.0
<#
.SYNOPSIS
    Dismiss-CumulusError-Simple.ps1
    Monitors for the Cumulus "Error -32701" dialog and automatically kills/restarts
    Cumulus. Uses Win32 API instead of UI Automation for broader compatibility.

.DESCRIPTION
    Uses Win32 FindWindow API to detect the error dialog window, then kills the
    Cumulus process and restarts it. Works on minimal Windows 10 installations
    without UI Automation assemblies.

.NOTES
    - Run as: powershell -WindowStyle Hidden -File "Dismiss-CumulusError-Simple.ps1"
    - Or set up as a Task Scheduler job (see comments at bottom of script).
    - Logs to: C:\Logs\CumulusErrorDismiss.log
#>

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
$LogFile         = "C:\Logs\CumulusErrorDismiss.log"
$TargetTitle     = "Error"                          # The dialog window title
$PollInterval    = 2                                # Seconds between scans
$CumulusExePath  = "C:\Cumulus\Cumulus.exe"         # *** ADJUST THIS PATH TO YOUR CUMULUS INSTALL ***
$RestartDelay    = 5                                # Seconds to wait before restarting Cumulus

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
# Load Win32 API functions for window enumeration
# ---------------------------------------------------------------------------
$Win32Source = @"
using System;
using System.Runtime.InteropServices;
using System.Text;

public class Win32 {
    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
    
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool IsWindowVisible(IntPtr hWnd);
    
    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);
    
    [DllImport("user32.dll", SetLastError = true)]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
}
"@

try {
    Add-Type -TypeDefinition $Win32Source -Language CSharp
    Write-Log "Win32 API loaded successfully."
} catch {
    Write-Log "FATAL: Could not load Win32 API. Error: $_"
    exit 1
}

# ---------------------------------------------------------------------------
# Helper function to check if error dialog exists
# ---------------------------------------------------------------------------
function Test-ErrorDialog {
    # Look for a window titled "Error"
    $hwnd = [Win32]::FindWindow($null, $TargetTitle)
    
    if ($hwnd -ne [IntPtr]::Zero) {
        # Found a window with title "Error", check if it's visible
        if ([Win32]::IsWindowVisible($hwnd)) {
            return $true
        }
    }
    
    return $false
}

# ---------------------------------------------------------------------------
# Main loop — polls for the error dialog
# ---------------------------------------------------------------------------
Write-Log "Script started. Watching for Cumulus Error dialog (title: '$TargetTitle')..."

while ($true) {
    try {
        if (Test-ErrorDialog) {
            Write-Log "Detected Error dialog. Checking if Cumulus is running..."
            
            # Check if Cumulus is actually running (sanity check)
            $cumulusProcesses = Get-Process -Name "Cumulus" -ErrorAction SilentlyContinue
            
            if ($cumulusProcesses) {
                Write-Log "Cumulus is running. Restarting Cumulus to clear error state..."
                
                # Step 1: Kill all Cumulus processes
                foreach ($proc in $cumulusProcesses) {
                    Write-Log "Terminating Cumulus process (PID: $($proc.Id))..."
                    $proc.Kill()
                }
                Write-Log "Cumulus processes terminated."
                
                # Step 2: Wait for clean shutdown
                Write-Log "Waiting $RestartDelay seconds before restart..."
                Start-Sleep -Seconds $RestartDelay
                
                # Step 3: Restart Cumulus
                if (Test-Path $CumulusExePath) {
                    Write-Log "Restarting Cumulus from: $CumulusExePath"
                    Start-Process -FilePath $CumulusExePath
                    Write-Log "Cumulus restarted successfully."
                } else {
                    Write-Log "ERROR: Cumulus executable not found at: $CumulusExePath"
                    Write-Log "       Please update the CumulusExePath variable in the script."
                }
                
                # Give some time for restart before resuming monitoring
                Start-Sleep -Seconds 5
            } else {
                Write-Log "WARNING: Error dialog detected but Cumulus is not running. Ignoring."
                Start-Sleep -Seconds 5
            }
        }
    } catch {
        Write-Log "ERROR in scan loop: $_"
    }
    
    Start-Sleep -Seconds $PollInterval
}

# ---------------------------------------------------------------------------
# TASK SCHEDULER SETUP (run these commands once, manually, in an elevated
# PowerShell prompt to create the scheduled task):
#
#   $scriptPath = "C:\Scripts\Dismiss-CumulusError-Simple.ps1"   # adjust as needed
#
#   $action = New-ScheduledTaskAction `
#       -Execute "powershell.exe" `
#       -Argument "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
#
#   $trigger = New-ScheduledTaskTrigger -AtLogon
#
#   $settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Days 365)
#
#   Register-ScheduledTask `
#       -TaskName "Dismiss Cumulus Error Dialog" `
#       -Action $action `
#       -Trigger $trigger `
#       -Settings $settings `
#       -RunLevel Highest `
#       -User "SYSTEM"
#
# ---------------------------------------------------------------------------
