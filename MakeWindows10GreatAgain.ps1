# Check to see if Anniversary Update is installed
if ([System.Environment]::OSVersion.Version.Build -lt 14393) {
  Write-Host "Build version 14393 or greater is required to continue. Exiting."
  Exit
}

$user = $(whoami).split('\')[1]

# Import the registry keys
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Importing registry keys..."
regedit /s MakeWindows10GreatAgain.reg

# Install Powershell Help items
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Installing Powershell help..."
Update-Help -Force -ErrorAction SilentlyContinue

# Remove OneDrive from the System
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Removing OneDrive..."
taskkill /f /im OneDrive.exe
c:\Windows\SysWOW64\OneDriveSetup.exe /uninstall

# Disable SMBv1
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Disabling SMBv1..."
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Confirm:$false

# Add Emacs Edit Mode to Powershell Profile
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Updating Powershell Profile..."
Set-Content $PsHome\Profile.ps1 'Set-PSReadlineOption -EditMode Emacs'

# Remove all pinned items from Start Menu
# https://community.spiceworks.com/topic/post/7417573
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Cleaning up start menu..."
(New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items()| foreach { ($_).Verbs() | ?{$_.Name.Replace('&', '') -match 'From "Start" UnPin|Unpin from Start'} | %{$_.DoIt()}  }

# Download and install ShutUp10
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Downloading ShutUp10..."
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
$shutUp10DownloadUrl = "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe"
$shutUp10RepoPath = "$home\AppData\Local\Temp\OOSU10.exe"
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Installing ShutUp10..."
Invoke-WebRequest -Uri "$shutUp10DownloadUrl" -OutFile $shutUp10RepoPath
. $shutUp10RepoPath shutup10.cfg /quiet /force

# Install Linux Subsystem
# https://docs.microsoft.com/en-us/windows/wsl/install-win10
Write-Host "Installing the Linux Subsystem..."
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
if ([System.Environment]::OSVersion.Version.Build -lt 19041) {
  Write-Host "Build 19041 or greated required to upgrade to WSL2"
  Exit
} else {
  Write-Host "Good news! This OS version supports WSL2. Enabling now..."
  try {
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    wsl --set-default-version 2
    Write-Host "WSLv2 Enabled!"
  } catch {
    Write-Host "Something went wrong while updating to WSL2..."
  }
}

# Disable WPAD 
# https://docs.microsoft.com/en-us/security-updates/securitybulletins/2016/ms16-077#workarounds
Add-Content "c:\windows\system32\drivers\etc\hosts" "        255.255.255.255  wpad."
