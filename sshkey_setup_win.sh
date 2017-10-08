#!/bin/bash

dir_exist=`ssh IEUser@192.168.0.4 "powershell Test-Path C:\Users\IEUser\.ssh"`
if [ $(echo "$dir_exist" | grep -e 'True') ]; then
    echo ".ssh exist"
else
    echo ".ssh not exist. make .ssh"
    ssh IEUser@192.168.0.4 "mkdir C:\Users\IEUser\.ssh"
fi

dir_exist=`ssh IEUser@192.168.0.4 "powershell Test-Path C:\Users\IEUser\.ssh\authorized_keys"`
if [ $(echo "$dir_exist" | grep -e 'True') ]; then
    echo "authorized_keys exist"
else
    echo "authorized_keys not exist. make authorized_keys"
    ssh IEUser@192.168.0.4 "type nul > C:\Users\IEUser\.ssh\authorized_keys"
fi

echo "add sshkey in authorized_keys"
sshkey=`cat ~/.ssh/id_rsa.pub`
ssh IEUser@192.168.0.4 "echo ${sshkey} >> C:\Users\IEUser\.ssh\authorized_keys"

echo "create change acl script"
ssh IEUser@192.168.0.4 "type nul > C:\Users\IEUser\.ssh\create_ch_acl.ps1"
ssh IEUser@192.168.0.4 'echo $authorizedKeyPath = "C:\users\IEUser\.ssh\authorized_keys" >> C:\Users\IEUser\.ssh\create_ch_acl.ps1'
ssh IEUser@192.168.0.4 'echo $acl = Get-Acl $authorizedKeyPath >> C:\Users\IEUser\.ssh\create_ch_acl.ps1'
ssh IEUser@192.168.0.4 'echo $ar = New-Object System.Security.AccessControl.FileSystemAccessRule("NT Service\sshd", "Read", "Allow") >> C:\Users\IEUser\.ssh\create_ch_acl.ps1'
ssh IEUser@192.168.0.4 'echo $acl.SetAccessRule($ar) >> C:\Users\IEUser\.ssh\create_ch_acl.ps1'
ssh IEUser@192.168.0.4 'echo Set-Acl $authorizedKeyPath $acl >> C:\Users\IEUser\.ssh\create_ch_acl.ps1'

echo "exe change acl script"
ssh IEUser@192.168.0.4 "powershell C:\Users\IEUser\.ssh\create_ch_acl.ps1"

echo "delete acl script"
ssh IEUser@192.168.0.4 "del /Q C:\Users\IEUser\.ssh\create_ch_acl.ps1"
