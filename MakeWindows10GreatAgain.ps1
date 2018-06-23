# Check to see if Anniversary Update is installed
if ([System.Environment]::OSVersion.Version.Build -lt 14393) {
  Write-Host "Anniversary Update is required and not installed. Exiting."
  Exit
}

# Import the registry keys
Write-Host "Importing registry keys..."
regedit /s MakeWindows10GreatAgain.reg

# Install Powershell Help items
Update-Help -Force -ErrorAction SilentlyContinue

# Remove OneDrive from the System
taskkill /f /im OneDrive.exe
c:\Windows\SysWOW64\OneDriveSetup.exe /uninstall

# Disable SMBv1
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Confirm:$false

# Remove all pinned items from Start Menu
# https://community.spiceworks.com/topic/post/7417573
(New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items()| foreach { ($_).Verbs() | ?{$_.Name.Replace('&', '') -match 'From "Start" UnPin|Unpin from Start'} | %{$_.DoIt()}  }

# Install Linux Subsystem
Write-Host "Installing the Linux Subsystem..."
Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux"

# Disable WPAD 
# https://docs.microsoft.com/en-us/security-updates/securitybulletins/2016/ms16-077#workarounds
Add-Content "c:\windows\system32\drivers\etc\hosts" "        255.255.255.255  wpad."
