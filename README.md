# Make Windows 10 Great Again
Tweaks to make Windows 10 less annoying and more usable.

Here's what this script does:

1. Disables Cortana
2. Disables Notification Center
3. Disables automatic reboots after Windows Updates have been installed
4. Disables Microsoft.com accounts from Windows Login
5. Shows file extensions for known file types
6. Sets Explorer to open to "This PC"
7. Shows hidden files (not including OS files)
8. Uninstalls OneDrive
9. Shows "This PC" icon on Desktop
10. Enables developer mode (required for Linux Subsystem)
11. Installs the Linux Subsystem
12. Updates the Powershell Get-Help items
13. Disables SMBv1
14. Unpin all Start Menu items
15. Disables WPAD 

## Installation
Unfortunately you'll have to set your execution policy to unrestricted to use this script.

From an Administrator Powershell prompt:
```
Set-ExecutionPolicy Unrestricted
cd MakeWindows10GreatAgain
.\MakeWindows10GreatAgain.ps1
Set-ExecutionPolicy Restricted
```

## Notes
I considered adding some tweaks to remove the default apps/tiles that come installed with the Win10 start menu, but I've been pleasantly surprised by [Classic Shell](http://classicshell.net/). It's an excellent start menu replacement for Win10. I recommend just installing that.

This script doesn't address any of the privacy issues of Windows 10 because there are already a [bunch of tools](http://www.ghacks.net/2015/08/14/comparison-of-windows-10-privacy-tools/) that already do that.
