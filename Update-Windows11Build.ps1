function Update-Windows11Build {
    param(
        [string]$targetBuild
    )
    
    # Check if PSWindowsUpdate module is installed
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Write-Output "PSWindowsUpdate module is not installed. Installing now..."
        
        # Install the PSWindowsUpdate module from the PowerShell Gallery
        Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
        
        # Import the module after installation
        Import-Module PSWindowsUpdate
        Write-Output "PSWindowsUpdate module installed and imported successfully."
    } else {
        Write-Output "PSWindowsUpdate module is already installed."
        
        # Import the module if it's already installed
        Import-Module PSWindowsUpdate
        Write-Output "PSWindowsUpdate module imported successfully."
    }

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
