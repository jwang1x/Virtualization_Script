#!/bin/sh


VM_name=None
Cores=1
Memsize=2048
Source=None
Datastore=datastore1
Firmware=efi
#Eth_VDevType=vmxnet3
#Guest_OS=centos8-64
Type=None
VM_numbers=1

while getopts "s:n:c:d:m:f:e:g:t:p:h" arg #选项后面的冒号表示该选项需要参数
do
        case $arg in

                s) #Set source path ()
                        #echo $OPTARG
                        Source=$OPTARG
                        ;;

                n)
                        #echo $OPTARG
                        VM_name=$OPTARG
                        ;;

                c) #Cores (default: 1)
                        #echo $OPTARG
                        Cores=$OPTARG
                        ;;

                d) #Datastore (default: datastore1)
                        #echo $OPTARG
                        Datastore=$OPTARG
                        ;;

                m) #Memory size (default: 2048MB)
                        #echo $OPTARG
                        Memsize=$OPTARG
                        ;;

                f) #Set firmware type (default: efi(bios))
                        #echo $OPTARG
                        Firmware=$OPTARG
                        ;;

#               e) #Set Network adapter 1 type(default: vmxnet3)
#                       #echo $OPTARG
#                       Eth_VDevType=$OPTARG
#                       ;;

#               g) #set Guest OS type (linux: centos8-64 / windows: windows2019srvNext-64)
#                       #echo $OPTARG
#                       Guest_OS=$OPTARG
#                       ;;

                t) #OS type (windows:w centos:c)
                        #echo $OPTARG
                        Type=$OPTARG
                        ;;

		p)
			VM_numbers=$OPTARG
			;;		

                h) # for help


                        echo "-n : Name of VM"
                        echo "-c : Cores of VM (default 1) "
                        echo "-d : Datastore (default datastore1)"
                        echo "-m : Memory size of VM (default 1024MB)"
                        echo "-f : Boot type (firmware:efi/bios default:efi)"
#                       echo "-e : vm network adapter 1 type (type:vmxnet3/e1000e default: vmxnet3)"
#                       echo "-g : set Guest OS type (linux: centos8-64 / windows: windows2019srvNext-64)"
                        echo "-t : OS type (windows:w centos:c)"
                        exit 1
                        ;;

                ?) #

                        echo "Error: Invalid input parameter"
                        echo "Input -h for help"
                        exit 1
                        ;;
        esac
done

#./Create_vm.sh  -s $Source  -n $VM_name  -c $Cores  -m $Memsize  -t $Type


for i in $(seq 1 $VM_numbers)
do
	./Create_vm.sh  -s $Source  -n ${VM_name}_${i}  -c $Cores  -m $Memsize  -t $Type

done

