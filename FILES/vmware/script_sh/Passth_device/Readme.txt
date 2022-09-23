Parameter:
-n Virtual machine name
-r Remove Passthrough device , set True (default: False)
-d Virtual machine in datastore name
-p Filtering PCI passthrough devices. 

QAT: 4940
IAA: 0cfe
DSA: 0b25

-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

Format:
TOGGLE,4940,1:4




TOGGLE : 
Passthrough type：TOGGLE 

4940 : 
lspci -p | grep -i 4940
0000:6b:00.0 8086:4940 8086:0000                V qat
0000:70:00.0 8086:4940 8086:0000                V qat
0000:75:00.0 8086:4940 8086:0000                V qat
0000:7a:00.0 8086:4940 8086:0000                V qat
0000:e8:00.0 8086:4940 8086:0000                V qat
0000:ed:00.0 8086:4940 8086:0000                V qat
0000:f2:00.0 8086:4940 8086:0000                V qat
0000:f7:00.0 8086:4940 8086:0000                V qat

1:1
passthrough device id
0000:6b:00.0

1:4
passthrough device id
0000:6b:00.0 0000:70:00.0 0000:75:00.0 0000:7a:00.0

5:8
passthrough device id
0000:e8:00.0 0000:ed:00.0 0000:f2:00.0 0000:f7:00.0

e.g.

./Passth -n centos_dsa_2  -p  TOGGLE,4940,5:8 -r
 False
V_Name:centos_dsa_2
P_BDF :TOGGLE,4940,5:8
D_Name:datastore1
R_emove:False
Get vm path /vmfs/volumes/datastore1/centos_dsa_2
Format VM passthrough config


type: TOGGLE
0000:6b:00.0 8086:4940 8086:0000                P pciPassthru
0000:70:00.0 8086:4940 8086:0000                V qat
0000:75:00.0 8086:4940 8086:0000                V qat
0000:7a:00.0 8086:4940 8086:0000                V qat
0000:e8:00.0 8086:4940 8086:0000                P pciPassthru
0000:ed:00.0 8086:4940 8086:0000                V qat
0000:f2:00.0 8086:4940 8086:0000                V qat
0000:f7:00.0 8086:4940 8086:0000                V qat
0000:e8:00.0 0000:ed:00.0 0000:f2:00.0 0000:f7:00.0
Get System Id:
Execute command: esxcli system uuid get
Result: 6285bf8d-50bc-f1db-2430-b496919885a8


Set Pci Bdf Id : 0000:e8:00.0
Toggle passthrough device
Execute command: esxcli hardware pci pcipassthru set -d=0000:e8:00.0 -e=on  -a
Unable to configure the PCI device: Device owner is already configured to passthru.
Get Vendor Id:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:e8:00.0 | grep -iw Vendor ID: | grep -i 0x | awk '{print $3}'
Result: 0x8086
Get Device ID:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:e8:00.0 | grep -iw Device ID: | grep -i 0x | awk '{print $3}'
Result: 0x4940
Get Dependent Device:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:e8:00.0 | grep -iw Dependent Device: | awk '{print $4}'
Result: 0:232:0:0



Set Pci Bdf Id : 0000:ed:00.0
Toggle passthrough device
Execute command: esxcli hardware pci pcipassthru set -d=0000:ed:00.0 -e=on  -a
Get Vendor Id:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:ed:00.0 | grep -iw Vendor ID: | grep -i 0x | awk '{print $3}'
Result: 0x8086
Get Device ID:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:ed:00.0 | grep -iw Device ID: | grep -i 0x | awk '{print $3}'
Result: 0x4940
Get Dependent Device:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:ed:00.0 | grep -iw Dependent Device: | awk '{print $4}'
Result: 0:237:0:0



Set Pci Bdf Id : 0000:f2:00.0
Toggle passthrough device
Execute command: esxcli hardware pci pcipassthru set -d=0000:f2:00.0 -e=on  -a
Get Vendor Id:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:f2:00.0 | grep -iw Vendor ID: | grep -i 0x | awk '{print $3}'
Result: 0x8086
Get Device ID:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:f2:00.0 | grep -iw Device ID: | grep -i 0x | awk '{print $3}'
Result: 0x4940
Get Dependent Device:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:f2:00.0 | grep -iw Dependent Device: | awk '{print $4}'
Result: 0:242:0:0



Set Pci Bdf Id : 0000:f7:00.0
Toggle passthrough device
Execute command: esxcli hardware pci pcipassthru set -d=0000:f7:00.0 -e=on  -a
Get Vendor Id:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:f7:00.0 | grep -iw Vendor ID: | grep -i 0x | awk '{print $3}'
Result: 0x8086
Get Device ID:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:f7:00.0 | grep -iw Device ID: | grep -i 0x | awk '{print $3}'
Result: 0x4940
Get Dependent Device:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:f7:00.0 | grep -iw Dependent Device: | awk '{print $4}'
Result: 0:247:0:0





Remove TOGGLE Passthrough device:

./Passth -n centos_dsa_2  -p  TOGGLE,4940,5:8 -r
 True
V_Name:centos_dsa_2
P_BDF :TOGGLE,4940,5:8
D_Name:datastore1
R_emove:True
Get vm path /vmfs/volumes/datastore1/centos_dsa_2
Format VM passthrough config


type: TOGGLE
0000:6b:00.0 8086:4940 8086:0000                P pciPassthru
0000:70:00.0 8086:4940 8086:0000                V qat
0000:75:00.0 8086:4940 8086:0000                V qat
0000:7a:00.0 8086:4940 8086:0000                V qat
0000:e8:00.0 8086:4940 8086:0000                P pciPassthru
0000:ed:00.0 8086:4940 8086:0000                P pciPassthru
0000:f2:00.0 8086:4940 8086:0000                P pciPassthru
0000:f7:00.0 8086:4940 8086:0000                P pciPassthru
0000:e8:00.0 0000:ed:00.0 0000:f2:00.0 0000:f7:00.0
Set  device type:  TOGGLE
Execute command: esxcli hardware pci pcipassthru set -d=0000:e8:00.0 -e=off  -a
Remove passthrough device finished!
Execute command: esxcli hardware pci pcipassthru set -d=0000:ed:00.0 -e=off  -a
Remove passthrough device finished!
Execute command: esxcli hardware pci pcipassthru set -d=0000:f2:00.0 -e=off  -a
Remove passthrough device finished!
Execute command: esxcli hardware pci pcipassthru set -d=0000:f7:00.0 -e=off  -a
Remove passthrough device finished!

-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

Format:
SRIOV,4940,1:4

SRIOV : 
Passthrough type ： SRIOV passthrough

4940 : 
lspci -p | grep -i 4940
0000:6b:00.0 8086:4940 8086:0000                V qat
0000:70:00.0 8086:4940 8086:0000                V qat
0000:75:00.0 8086:4940 8086:0000                V qat
0000:7a:00.0 8086:4940 8086:0000                V qat
0000:e8:00.0 8086:4940 8086:0000                V qat
0000:ed:00.0 8086:4940 8086:0000                V qat
0000:f2:00.0 8086:4940 8086:0000                V qat
0000:f7:00.0 8086:4940 8086:0000                V qat

1:4
passthrough device id 0000:6b:00.0, set 4 vfs.


2:8
passthrough device id 0000:70:00.0, set 8 vfs.

5:6
passthrough device id 0000:e8:00.0, set 6 vfs.


e.g.
 ./Passth -n centos_dsa_2  -p  SRIOV,4940,1:4 -r
False
V_Name:centos_dsa_2
P_BDF :SRIOV,4940,1:4
D_Name:datastore1
R_emove:False
Get vm path /vmfs/volumes/datastore1/centos_dsa_2
Format VM passthrough config


type: SRIOV
0000:6b:00.0 8086:4940 8086:0000                V qat
0000:70:00.0 8086:4940 8086:0000                V qat
0000:75:00.0 8086:4940 8086:0000                V qat
0000:7a:00.0 8086:4940 8086:0000                V qat
0000:e8:00.0 8086:4940 8086:0000                V qat
0000:ed:00.0 8086:4940 8086:0000                V qat
0000:f2:00.0 8086:4940 8086:0000                V qat
0000:f7:00.0 8086:4940 8086:0000                V qat
Set Sriov device bdf number:  0000:6b:00.0
Set Sriov vf count:           4
Execute command: esxcli hardware pci sriov maxvfs set -d 0000:6b:00.0 -v 4 -a
Get System Id:
Execute command: esxcli system uuid get
Result: 6285bf8d-50bc-f1db-2430-b496919885a8


Get Vendor Id:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:6b:00.0 | grep -iw Vendor ID: | grep -i 0x | awk '{print $3}'
Result: 0x8086
Get Dependent Device:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:6b:00.0 | grep -iw Dependent Device: | awk '{print $4}'
Result: 0:107:0:0
Set Pci Bdf Id : 0000:6b:00.1
Toggle passthrough device
Execute command: esxcli hardware pci pcipassthru set -d=0000:6b:00.1 -e=on  -a
Unable to configure the PCI device: Device owner is already configured to passthru.
Get Device ID:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:6b:00.0 | grep -iw Device ID: | grep -i 0x | awk '{print $3}'
Result: 0x4941
Get Dependent Device:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:6b:00.0 | grep -iw Dependent Device: | awk '{print $4}'
Result: 0:107:0:1
Set Pci Bdf Id : 0000:6b:00.2
Toggle passthrough device
Execute command: esxcli hardware pci pcipassthru set -d=0000:6b:00.2 -e=on  -a
Unable to configure the PCI device: Device owner is already configured to passthru.
Get Device ID:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:6b:00.0 | grep -iw Device ID: | grep -i 0x | awk '{print $3}'
Result: 0x4941
Get Dependent Device:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:6b:00.0 | grep -iw Dependent Device: | awk '{print $4}'
Result: 0:107:0:2
Set Pci Bdf Id : 0000:6b:00.3
Toggle passthrough device
Execute command: esxcli hardware pci pcipassthru set -d=0000:6b:00.3 -e=on  -a
Unable to configure the PCI device: Device owner is already configured to passthru.
Get Device ID:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:6b:00.0 | grep -iw Device ID: | grep -i 0x | awk '{print $3}'
Result: 0x4941
Get Dependent Device:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:6b:00.0 | grep -iw Dependent Device: | awk '{print $4}'
Result: 0:107:0:3
Set Pci Bdf Id : 0000:6b:00.4
Toggle passthrough device
Execute command: esxcli hardware pci pcipassthru set -d=0000:6b:00.4 -e=on  -a
Unable to configure the PCI device: Device owner is already configured to passthru.
Get Device ID:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:6b:00.0 | grep -iw Device ID: | grep -i 0x | awk '{print $3}'
Result: 0x4941
Get Dependent Device:
Execute command: esxcli hardware pci list | grep -iw -A 38 0000:6b:00.0 | grep -iw Dependent Device: | awk '{print $4}'
Result: 0:107:0:4




Remove SRIOV Passthrough device:
./Passth -n centos_dsa_2  -p  SRIOV,4940,1:4 -r True
V_Name:centos_dsa_2
P_BDF :SRIOV,4940,1:4
D_Name:datastore1
R_emove:True
Get vm path /vmfs/volumes/datastore1/centos_dsa_2
Format VM passthrough config


type: SRIOV
0000:6b:00.0 8086:4940 8086:0000                V qat
0000:70:00.0 8086:4940 8086:0000                V qat
0000:75:00.0 8086:4940 8086:0000                V qat
0000:7a:00.0 8086:4940 8086:0000                V qat
0000:e8:00.0 8086:4940 8086:0000                V qat
0000:ed:00.0 8086:4940 8086:0000                V qat
0000:f2:00.0 8086:4940 8086:0000                V qat
0000:f7:00.0 8086:4940 8086:0000                V qat
Set  device type:  SRIOV
1233 0000:6b:00.0 4
pci_bdf:0:-4 0000:6b:
Set Pci Bdf Id : 0000:6b:00.1
Toggle passthrough device
Execute command: esxcli hardware pci pcipassthru set -d=0000:6b:00.1 -e=off  -a
pci_bdf:0:-4 0000:6b:
Set Pci Bdf Id : 0000:6b:00.2
Toggle passthrough device
Execute command: esxcli hardware pci pcipassthru set -d=0000:6b:00.2 -e=off  -a
pci_bdf:0:-4 0000:6b:
Set Pci Bdf Id : 0000:6b:00.3
Toggle passthrough device
Execute command: esxcli hardware pci pcipassthru set -d=0000:6b:00.3 -e=off  -a
pci_bdf:0:-4 0000:6b:
Set Pci Bdf Id : 0000:6b:00.4
Toggle passthrough device
Execute command: esxcli hardware pci pcipassthru set -d=0000:6b:00.4 -e=off  -a
Execute command: esxcli hardware pci sriov maxvfs set -d 0000:6b:00.0 -v 4 -a


-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

Format:
DSA,4
IAA,4

DSA : 
Passthrough type：SIOV


IAA : 
Passthrough type：SIOV

Set 4 vfs 

./Passth -n centos_dsa_2  -p  DSA,4 -r False
V_Name:centos_dsa_2
P_BDF :DSA,4
D_Name:datastore1
R_emove:False
Get vm path /vmfs/volumes/datastore1/centos_dsa_2
Format VM passthrough config


type: DSA
Set Siov device type:  DSA
Set Siov vf count:     4
Passthrough SIOV Config Finished!



./Passth -n centos_dsa_2  -p  IAA,4 -r False
V_Name:centos_dsa_2
P_BDF :IAA,4
D_Name:datastore1
R_emove:False
Get vm path /vmfs/volumes/datastore1/centos_dsa_2
Format VM passthrough config


type: IAA
Set Siov device type:  IAA
Set Siov vf count:     4
Passthrough SIOV Config Finished!




./Passth -n centos_dsa_2  -p  DSA,4 -r  True
V_Name:centos_dsa_2
P_BDF :DSA,4
D_Name:datastore1
R_emove:True
Get vm path /vmfs/volumes/datastore1/centos_dsa_2
Format VM passthrough config


type: DSA
Set  device type:  DSA
Format VM passthrough config
Remove passthrough device finished!



./Passth -n centos_dsa_2  -p  IAA,4 -r  True
V_Name:centos_dsa_2
P_BDF :IAA,4
D_Name:datastore1
R_emove:True
Get vm path /vmfs/volumes/datastore1/centos_dsa_2
Format VM passthrough config


type: IAA
Set  device type:  IAA
Format VM passthrough config
Remove passthrough device finished!





