function Update-Windows11Build {
    param(
        [string]$targetBuild
    )

    # Import the PSWindowsUpdate module
    Import-Module PSWindowsUpdate

    # Get the current Windows build number
    $buildNumber = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild
    $buildRevision = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").UBR
    $currentBuild = "$buildNumber.$buildRevision"

    # Define the target build number (will target build less than or equal to)
    $targetBuild = $targetBuild

    # Compare the current build number with the target build number
    if ([version]$currentBuild -le [version]$targetBuild) {
        # Download and install the latest cumulative update without rebooting
        Get-WindowsUpdate -Install -AcceptAll -AutoReboot:$false -Confirm:$false -Title "Cumulative Update for Windows 11"
    } else {
        Write-Output "The current build number is greater than $targetBuild. No update needed."
    } 

}

Update-Windows11Build -targetBuild "26100.2314"
