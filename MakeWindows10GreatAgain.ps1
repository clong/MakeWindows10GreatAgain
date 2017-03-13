# Check to see if Anniversary Update is installed
if ([System.Environment]::OSVersion.Version.Build -lt 14393) {
  Write-Host "Anniversary Update is required and not installed. Exiting."
  Exit
}

# Import the registry keys
Write-Host "Importing registry keys..."
regedit /s MakeWindows10GreatAgain.reg

# Install Linux Subsystem
Write-Host "Installing the Linux Subsystem..."
Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux"
