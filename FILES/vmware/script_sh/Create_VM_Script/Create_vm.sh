#!/bin/sh


VM_name=None
Cores=1
Memsize=2048
#Source=None
Datastore=datastore1
Firmware=efi
#Eth_VDevType=vmxnet3
#Guest_OS=centos8-64
Type=None

while getopts "s:n:c:d:m:f:e:g:t:h" arg #选项后面的冒号表示该选项需要参数
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
	     
#		e) #Set Network adapter 1 type(default: vmxnet3)
#			#echo $OPTARG
#			Eth_VDevType=$OPTARG
#			;;

#		g) #set Guest OS type (linux: centos8-64 / windows: windows2019srvNext-64)
#			#echo $OPTARG			
#			Guest_OS=$OPTARG
#			;;

		t) #OS type (windows:w centos:c)
			#echo $OPTARG
			Type=$OPTARG			
			;;
		
		h) # for help
			

			echo "-n : Name of VM"
			echo "-c : Cores of VM (default 1) "
			echo "-d : Datastore (default datastore1)"
			echo "-m : Memory size of VM (default 1024MB)"
			echo "-f : Boot type (firmware:efi/bios default:efi)"
#			echo "-e : vm network adapter 1 type (type:vmxnet3/e1000e default: vmxnet3)"
#			echo "-g : set Guest OS type (linux: centos8-64 / windows: windows2019srvNext-64)"
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


echo "Check if the source file exists : $Source "
if [ $Source == None ]
        then
                echo "Error: Please input -s parameter"
		exit 1 
fi

echo "Check vm name : $VM_name "	
if [ $VM_name == None ]
	then
		echo "Vm name is invalid"
		exit 1
fi  



echo "Check vm type: $Type"
if [ $Type == w ]
	then
		Guest_OS=windows2019srvNext-64
		Eth_VDevType=e1000e		
		Scsi_vdev=lsisas1068
elif [ $Type == c ]
	then 
		Guest_OS=centos8-64
		Eth_VDevType=vmxnet3				 
		Scsi_vdev=pvscsi

elif [ $Type == r ]
        then
                Guest_OS=rhel8-64
                Eth_VDevType=vmxnet3
                Scsi_vdev=pvscsi


elif [ $Type == None ]
	then 
		echo "OS type is None"
		exit 1
else
	echo "OS type is invalid"	
	exit 1
fi
		 



echo "Check if the vm file exists : /vmfs/volumes/${Datastore}/${VM_name} "
file=/vmfs/volumes/${Datastore}/${VM_name}

if [ -d $file ] 
	then
    	echo "$file exist"
	exit 1
fi


echo "Create vm file"
echo "Copy vm files to /vmfs/volumes/${Datastore}/${VM_name} "
#cp -r  /vmfs/volumes/datastore1/BKCPkg/domains/vt_tools/esxi_create_vm_config/centos_vm/ /vmfs/volumes/${Datastore}/${VM_name}


cp -r  $Source  /vmfs/volumes/${Datastore}/${VM_name}

mv /vmfs/volumes/${Datastore}/${VM_name}/*.vmx /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.vmx
mv /vmfs/volumes/${Datastore}/${VM_name}/*flat.vmdk /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.tmp
mv /vmfs/volumes/${Datastore}/${VM_name}/*.vmdk /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.vmdk
mv /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.tmp /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}-flat.vmdk



echo "Set VM Name" 
echo -e  >> /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.vmx
echo -e displayName = \"${VM_name}\" >>  /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.vmx

echo "Set VM cores: $Cores"
echo -e numvcpus = \"${Cores}\" >>  /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.vmx


echo "Set VM memory size: $Memsize"
echo -e memSize = \"${Memsize}\" >>  /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.vmx


echo "Set vm boot firmware: $Firmware"
echo -e firmware  = \"${Firmware}\" >>  /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.vmx


echo "Set virtual device type: ${Eth_VDevType}"
echo -e ethernet0.virtualDev = \"${Eth_VDevType}\" >>  /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.vmx

echo "Set Guest OS type: ${Guest_OS}"
echo -e guestOS = \"${Guest_OS}\" >>  /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.vmx

echo "Set vmdk file: ${VM_name}"
echo -e scsi0:0.fileName = \"${VM_name}.vmdk\" >>  /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.vmx
echo -e scsi0.virtualDev = \"${Scsi_vdev}\" >>  /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.vmx



echo "Resetting ${VM_name}.vmdk files"
add_1=`cat /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.vmdk  | grep -i RW | awk '{print $1}'`
add_2=`cat /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.vmdk  | grep -i RW | awk '{print $2}'`
add_3=`cat /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.vmdk  | grep -i RW | awk '{print $3}'`


sed '/RW/d' /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.vmdk > /vmfs/volumes/${Datastore}/${VM_name}/tmp.tmp

echo $add_1 $add_2 $add_3 \"${VM_name}-flat.vmdk\" >> /vmfs/volumes/${Datastore}/${VM_name}/tmp.tmp
mv  /vmfs/volumes/${Datastore}/${VM_name}/tmp.tmp /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.vmdk

echo "Register VM "
vim-cmd solo/registervm /vmfs/volumes/${Datastore}/${VM_name}/${VM_name}.vmx


