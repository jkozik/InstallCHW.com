#Requires -Version 3.0
<#
.SYNOPSIS
    Test-CumulusErrorDialog.ps1
    Spawns a fake "Error -32701" dialog AND a fake Cumulus process.
    Use this to test that Dismiss-CumulusError.ps1 properly kills and restarts
    Cumulus when the error is detected.

.HOW TO TEST
    1. Start the dismiss script in one PowerShell window:
           powershell -WindowStyle Normal -File "Dismiss-CumulusError.ps1"
           (Use Normal instead of Hidden so you can see its console output while testing)

    2. In a SECOND PowerShell window, run this test script:
           powershell -File "Test-CumulusErrorDialog.ps1"

    3. This script will:
       - Launch a fake "Cumulus.exe" background process (actually just notepad renamed)
       - Pop up the error dialog
       - The dismiss script should detect the dialog, kill the fake Cumulus process,
         wait 5 seconds, then restart it
       - You'll see console output confirming the process was killed and restarted

    4. Run the test script multiple times to verify consistent behavior.

    5. Check C:\Logs\CumulusErrorDismiss.log to confirm logging is working.

.NOTES
    Before running this in production, make sure to update the $CumulusExePath
    variable in Dismiss-CumulusError.ps1 to point to your actual Cumulus.exe!
#>

# ---------------------------------------------------------------------------
# Load WinForms so we can create a proper modal dialog window
# ---------------------------------------------------------------------------
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ---------------------------------------------------------------------------
# Step 1: Launch a fake "Cumulus" process so the dismiss script has something
#         to kill and restart. We'll just use notepad and rename the process.
# ---------------------------------------------------------------------------
Write-Host "Starting fake Cumulus process (using notepad)..."

# Create a copy of notepad.exe named Cumulus.exe in TEMP
$tempDir = [System.IO.Path]::GetTempPath()
$fakeCumulusPath = Join-Path $tempDir "Cumulus.exe"

if (-not (Test-Path $fakeCumulusPath)) {
    Copy-Item "C:\Windows\System32\notepad.exe" -Destination $fakeCumulusPath -Force
}

# Launch it minimized so it doesn't clutter the screen
$fakeProcess = Start-Process -FilePath $fakeCumulusPath -WindowStyle Minimized -PassThru
Write-Host "Fake Cumulus process started (PID: $($fakeProcess.Id))"
Write-Host ""

# Give it a moment to fully start
Start-Sleep -Seconds 1

# ---------------------------------------------------------------------------
# Build the dialog to match the real Cumulus error dialog:
#   - Window title: "Error"
#   - Red X icon on the left
#   - Message text: "Error -32701 while trying to initialise the station.
#                    Please check your connections and settings."
#   - An "OK" button, lower-right area
# ---------------------------------------------------------------------------
$form = [System.Windows.Forms.Form]::new()
$form.Text            = "Error"                        # <-- This is the window title UIA sees
$form.Size            = [System.Drawing.Size]::new(370, 150)
$form.StartPosition   = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeButton  = $false
$form.MinimizeButton  = $false
$form.TopMost         = $true

# --- Icon (the red X circle, same as a standard Windows error dialog) --------
$form.Icon = [System.Drawing.SystemIcons]::Error.ToIcon()

# --- Error message label ------------------------------------------------------
$label = [System.Windows.Forms.Label]::new()
$label.Text     = "Error -32701 while trying to initialise the station. Please check your connections and settings."
$label.Location = [System.Drawing.Point]::new(50, 20)
$label.Size     = [System.Drawing.Size]::new(300, 60)
$label.Font     = [System.Drawing.Font]::new("Segoe UI", 9)
$form.Controls.Add($label)

# --- The red X icon as a PictureBox (matches the look of the real dialog) -----
$pic = [System.Windows.Forms.PictureBox]::new()
$pic.Image    = [System.Drawing.SystemIcons]::Error.ToImage()
$pic.Location = [System.Drawing.Point]::new(12, 30)
$pic.Size     = [System.Drawing.Size]::new(32, 32)
$form.Controls.Add($pic)

# --- OK button -----------------------------------------------------------------
$okBtn = [System.Windows.Forms.Button]::new()
$okBtn.Text     = "OK"                                 # <-- This is the button name UIA sees
$okBtn.Location = [System.Drawing.Point]::new(255, 95)
$okBtn.Size     = [System.Drawing.Size]::new(75, 30)
$okBtn.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.Controls.Add($okBtn)
$form.AcceptButton = $okBtn

# ---------------------------------------------------------------------------
# Show the dialog and wait. The dismiss script should:
#   1. Detect the dialog
#   2. Kill the fake Cumulus process we started
#   3. Wait 5 seconds
#   4. Restart Cumulus (which will fail because we're using a fake path, but
#      that's OK - we're just testing the detection and kill logic)
# ---------------------------------------------------------------------------
Write-Host "Test dialog is now showing. The dismiss script should:"
Write-Host "  1. Detect the dialog within ~2 seconds"
Write-Host "  2. Kill the fake Cumulus process (PID: $($fakeProcess.Id))"
Write-Host "  3. Close the dialog automatically"
Write-Host ""
Write-Host "Watch the dismiss script console for log output..."
Write-Host ""

$result = $form.ShowDialog()

# Check if the fake process was killed
Start-Sleep -Seconds 1
if ($fakeProcess.HasExited) {
    Write-Host ""
    Write-Host "SUCCESS: The fake Cumulus process was killed by the dismiss script!" -ForegroundColor Green
    Write-Host "Check C:\Logs\CumulusErrorDismiss.log to confirm full details." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "FAILURE: The fake Cumulus process is still running (PID: $($fakeProcess.Id))" -ForegroundColor Red
    Write-Host "The dismiss script may not be detecting the dialog correctly." -ForegroundColor Red
    Write-Host "Check the dismiss script console for errors." -ForegroundColor Red
    
    # Clean up the fake process since the dismiss script didn't kill it
    Write-Host "Cleaning up fake process manually..." -ForegroundColor Yellow
    $fakeProcess.Kill()
}
