#!/bin/bash

vm_addr=$1
vm_passwd=$2
mstnode_account=$3


dir_exist=`sshpass -p ${vm_passwd} ssh IEUser@${vm_addr} "powershell Test-Path C:\Users\IEUser\.ssh"`
if [ $(echo "$dir_exist" | grep -e 'True') ]; then
    echo "## .ssh exist"
    :
else
    echo "## .ssh not exist. make .ssh"
    sshpass -p ${vm_passwd} ssh IEUser@${vm_addr} "mkdir C:\Users\IEUser\.ssh"
fi


dir_exist=`sshpass -p ${vm_passwd} ssh IEUser@${vm_addr} "powershell Test-Path C:\Users\IEUser\.ssh\authorized_keys"`
if [ $(echo "$dir_exist" | grep -e 'True') ]; then
    echo "## authorized_keys exist"
else
    echo "## authorized_keys not exist. make authorized_keys"
    sshpass -p ${vm_passwd} ssh IEUser@${vm_addr} "type nul > C:\Users\IEUser\.ssh\authorized_keys"
fi


echo "## add sshkey in authorized_keys"
sshkey=`cat ~/.ssh/id_rsa.pub`
sshpass -p ${vm_passwd} ssh IEUser@${vm_addr} "echo ${sshkey} >> C:\Users\IEUser\.ssh\authorized_keys"


echo "## create change acl script"
sshpass -p ${vm_passwd} ssh IEUser@${vm_addr} "type nul > C:\Users\IEUser\.ssh\create_ch_acl.ps1"
sshpass -p ${vm_passwd} ssh IEUser@${vm_addr} 'echo $authorizedKeyPath = "C:\users\IEUser\.ssh\authorized_keys" >> C:\Users\IEUser\.ssh\create_ch_acl.ps1'
sshpass -p ${vm_passwd} ssh IEUser@${vm_addr} 'echo $acl = Get-Acl $authorizedKeyPath >> C:\Users\IEUser\.ssh\create_ch_acl.ps1'
sshpass -p ${vm_passwd} ssh IEUser@${vm_addr} 'echo $ar = New-Object System.Security.AccessControl.FileSystemAccessRule("NT Service\sshd", "Read", "Allow") >> C:\Users\IEUser\.ssh\create_ch_acl.ps1'
sshpass -p ${vm_passwd} ssh IEUser@${vm_addr} 'echo $acl.SetAccessRule($ar) >> C:\Users\IEUser\.ssh\create_ch_acl.ps1'
sshpass -p ${vm_passwd} ssh IEUser@${vm_addr} 'echo Set-Acl $authorizedKeyPath $acl >> C:\Users\IEUser\.ssh\create_ch_acl.ps1'


echo "## exe change acl script"
sshpass -p ${vm_passwd} ssh IEUser@${vm_addr} "powershell C:\Users\IEUser\.ssh\create_ch_acl.ps1"

echo "## delete acl script"
sshpass -p ${vm_passwd} ssh IEUser@${vm_addr} "del /Q C:\Users\IEUser\.ssh\create_ch_acl.ps1"
