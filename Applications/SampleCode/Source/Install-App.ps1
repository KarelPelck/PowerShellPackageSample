<#
Version 1.0 
Author: Karel Pelckmans
Script: Install-App.ps1

Dscription: 
Install application script template to deploy applications with Microsoft Intune. 

Release notes: 
version 1.0: Original published version 

Script provided As Is with no warranties. 

Credits: 
Oliver Kiezelbach 
Tabs-not-spaces (GitHub)
#>

#Check if 64bit and restart script under 64bit if necessary 
if (![System.Environment]::Is64BitProcess) {

    # start new PowerShell as x64 bit process, wait for it and gather exit code and standard error output
    $sysNativePowerShell = "$($PSHOME.ToLower().Replace("syswow64", "sysnative"))\powershell.exe"

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $sysNativePowerShell
    $pinfo.Arguments = "-ex bypass -file `"$PSCommandPath`""
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.CreateNoWindow = $true
    $pinfo.UseShellExecute = $false
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null

    $exitCode = $p.ExitCode

    $stderr = $p.StandardError.ReadToEnd()

    if ($stderr) { Write-Error -Message $stderr }

} 

Else
{ #Script region

    #region Config
    $appName = "Sample-App"
    $logFile = "$env:temp\$appName`.log" #for system user this will normally be C:/Windows/TEMP
    #endregion
    #region Logging
    Start-Transcript -Path $logFile -Force
    #endregion

    #region Process
    try {
        Write-Host "Let's throw a file in the temp folder and verify it's there.."
        Get-Date | Out-File "$env:temp\$appName`.txt" -Encoding ascii -NoNewline -Force
        if (Test-Path "$env:temp\$appName`.txt" -ErrorAction SilentlyContinue) {
            Write-Host "Found the file - as expected.."
        } 
        else {
            Throw "Sample file not found.."
        }
    }
    catch {
        $errorMsg = $_.Exception.Message
    }
    finally {
        if ($errorMsg) {
            Write-Host $errorMsg
            Stop-Transcript
            throw $errorMsg
        }
        else {
            Write-Host "Script completed successfully.."
            Stop-Transcript
        }
    }
    #endregion
    
} #End Script region
