#Import BitsTransfer module, to get the copy of the vhdx from the gold image of ubuntu
Import-Module BitsTransfer
#Prompt for user input, and save the input, to a variable, used to rename the VHDX and name the new VM
$vmname = Read-Host -Prompt 'Input VM Name'
#
#Create the new VM, Generation 2, with the ExtVSwitch from the server WSOverlord01
New-VM -Name $vmname -Path "D:\Hyper-V\Virtual Machines" -Generation 2 -SwitchName ExtVSwitch
#Set the processor count, and the min-max and startup RAM memory
Set-VM -Name $vmname -ProcessorCount 2 -DynamicMemory -MemoryStartupBytes 1024MB -MemoryMinimumBytes 1024MB -MemoryMaximumBytes 2048MB
#Copy the VHDX from the gold image, and rename to the name set
Start-BitsTransfer -Source "F:\ubuntu.generic.vhdx" -Destination "D:\Hyper-V\VHD\$vmname.vhdx"
#Disable the secure boot, and set the first boot device to the vhdx
Set-VMFirmware $vmname -EnableSecureBoot off 
Set-VMFirmware $vmname -FirstBootDevice $vmname.vhdx
#Atachs the new VHDX to the VM
Add-VMHardDiskDrive -VMName $vmname -Path "D:\Hyper-V\VHD\$vmname.vhdx"
#Automatic actions
Set-VM -Name $vmname -AutomaticStartAction StartIfRunning -AutomaticStopAction ShutDown
#start the vm
Start-VM -Name $vmname