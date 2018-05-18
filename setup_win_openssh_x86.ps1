Expand-Archive -Path .\OpenSSH-Win32.zip -DestinationPath C:\Program` Files
Rename-Item C:\Program` Files\OpenSSH-Win32 C:\Program` Files\OpenSSH
cd C:\Program` Files\OpenSSH
.\install-sshd.ps1
.\ssh-keygen.exe -A
.\FixHostFilePermissions.ps1 -Confirm:$false
netsh advfirewall firewall add rule name=SSHPort dir=in action=allow protocol=TCP localport=22
Set-Service sshd -StartupType Automatic
Set-Service ssh-agent -StartupType Automatic
echo "Please reboot this machine"