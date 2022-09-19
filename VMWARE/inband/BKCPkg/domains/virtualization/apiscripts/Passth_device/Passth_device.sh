#!/bin/sh


function Set_PBDF_Info2vm()
{
        echo "Get System Id:"
        echo "Execute command: esxcli system uuid get"
        Sys_Id=`esxcli system uuid get`
        echo "Result: $Sys_Id"
	echo -e "\n"
        count=0
        for Pci_Bdf in $@
        do
                echo "Set Pci Bdf Id : $Pci_Bdf"

                echo "Toggle passthrough device"
                echo "Execute command: esxcli hardware pci pcipassthru set -d=${Pci_Bdf} -e=on  -a"
                esxcli hardware pci pcipassthru set -d=${Pci_Bdf} -e=on -a

                echo "Get Vendor Id:"
                echo "Execute command: esxcli hardware pci list | grep -iw -A 38 "${Pci_Bdf}" | grep -iw "Vendor ID:" | grep -i "0x" | awk '{print \$3}'"
                Ven_Id=`esxcli hardware pci list | grep -iw -A 38 "${Pci_Bdf}" | grep -iw "Vendor ID:" | grep -i "0x" | awk '{print $3}'`
                echo "Result: $Ven_Id"

                echo "Get Device ID:"
                echo "Execute command: esxcli hardware pci list | grep -iw -A 38 "${Pci_Bdf}" | grep -iw "Device ID:" | grep -i "0x" | awk '{print \$3}' "
                Dev_Id=`esxcli hardware pci list | grep -iw -A 38 "${Pci_Bdf}" | grep -iw "Device ID:" | grep -i "0x" | awk '{print $3}'`
                echo "Result: $Dev_Id"


                echo "Get Dependent Device:"
                echo "Execute command: esxcli hardware pci list | grep -iw -A 38 "${Pci_Bdf}" | grep -iw "Dependent Device:" | awk '{print \$4}'"
                Phy_Id=`esxcli hardware pci list | grep -iw -A 38 "${Pci_Bdf}" | grep -iw "Dependent Device:" | awk '{print $4}'`
                echo "Result: $Phy_Id"


                echo "pciPassthru${count}.deviceId = \"${Dev_Id}\"" >> ${file}/${V_Name}.vmx
                echo "pciPassthru${count}.vendorId = \"${Ven_Id}\"" >> ${file}/${V_Name}.vmx
                echo "pciPassthru${count}.present = \"TRUE\"" >> ${file}/${V_Name}.vmx
                echo "pciPassthru${count}.id = \"$Phy_Id\"" >> ${file}/${V_Name}.vmx
                echo "pciPassthru${count}.systemId = \"${Sys_Id}\"" >> ${file}/${V_Name}.vmx
		echo -e "\n\n"
                count=`expr ${count} + 1`

        done
        return 0

}


function Set_Sriov_Info2vm()
{

	#type=`echo $@ | awk '{print $1}'`
        Pci_Bdf=`echo $@ | awk '{print $1}'`
        Count=`echo $@ | awk '{print $2}'`
        echo "Set Sriov device bdf number:  $Pci_Bdf"
        echo "Set Sriov vf count:           $Count"

	echo "Execute command: esxcli hardware pci sriov maxvfs set -d ${Pci_Bdf} -v ${Count} -a"
	esxcli hardware pci sriov maxvfs set -d ${Pci_Bdf} -v ${Count} -a


	echo "Get System Id:"
	echo "Execute command: esxcli system uuid get"
	Sys_Id=`esxcli system uuid get`
	echo "Result: $Sys_Id"
	echo -e "\n"

	echo "Get Vendor Id:"
	echo "Execute command: esxcli hardware pci list | grep -iw -A 38 "${Pci_Bdf}" | grep -iw "Vendor ID:" | grep -i "0x" | awk '{print \$3}'"
	Ven_Id=`esxcli hardware pci list | grep -iw -A 38 "${Pci_Bdf}" | grep -iw "Vendor ID:" | grep -i "0x" | awk '{print $3}'`
	echo "Result: $Ven_Id"

	echo "Get Dependent Device:"
	echo "Execute command: esxcli hardware pci list | grep -iw -A 38 "${Pci_Bdf}" | grep -iw "Dependent Device:" | awk '{print \$4}'"
	Phy_Id=`esxcli hardware pci list | grep -iw -A 38 "${Pci_Bdf}" | grep -iw "Dependent Device:" | awk '{print $4}'`
	echo "Result: $Phy_Id"

	num=1
	for i in $(seq 0 $Count)
	do
		
		if [ $i == $Count ]
		then
			break
		fi

		#echo pci_bdf:0:-4 ${Pci_Bdf:0:-4}
		#lspci -p | grep -i ${Pci_Bdf:0:-4}
		#echo $i
		Vf_Bdf=`lspci -p | grep -i ${Pci_Bdf:0:-4} |  grep -i vf | sed -n ${num}p | awk '{print $1}'`
                echo "Set Pci Bdf Id : $Vf_Bdf"

                echo "Toggle passthrough device"
                echo "Execute command: esxcli hardware pci pcipassthru set -d=${Vf_Bdf} -e=on  -a"
                esxcli hardware pci pcipassthru set -d=${Vf_Bdf} -e=on -a


        	echo "Get Device ID:"
        	echo "Execute command: esxcli hardware pci list | grep -iw -A 38 "${Pci_Bdf}" | grep -iw "Device ID:" | grep -i "0x" | awk '{print \$3}' "
        	Dev_Id=`esxcli hardware pci list | grep -iw -A 38 "${Vf_Bdf}" | grep -iw "Device ID:" | grep -i "0x" | awk '{print $3}'`
	        echo "Result: $Dev_Id"
		
	        echo "Get Dependent Device:"
        	echo "Execute command: esxcli hardware pci list | grep -iw -A 38 "${Pci_Bdf}" | grep -iw "Dependent Device:" | awk '{print \$4}'"
        	Vir_Id=`esxcli hardware pci list | grep -iw -A 38 "${Vf_Bdf}" | grep -iw "Dependent Device:" | awk '{print $4}'`
        	echo "Result: $Vir_Id"



		echo "pciPassthru${i}.deviceId = \"${Dev_Id}\"" >> ${file}/${V_Name}.vmx
		echo "pciPassthru${i}.vendorId = \"${Ven_Id}\"" >> ${file}/${V_Name}.vmx
		echo "pciPassthru${i}.present = \"TRUE\"" >> ${file}/${V_Name}.vmx
		echo "pciPassthru${i}.id = \"${Vir_Id}\"" >> ${file}/${V_Name}.vmx
		echo "pciPassthru${i}.systemId = \"${Sys_Id}\"" >> ${file}/${V_Name}.vmx

		echo "pciPassthru${i}.MACAddressType = \"generated\"" >> ${file}/${V_Name}.vmx
		echo "pciPassthru${i}.networkName = \"VM Network\"" >> ${file}/${V_Name}.vmx
		echo "pciPassthru${i}.pfid = \"${Phy_Id}\"" >> ${file}/${V_Name}.vmx
		num=`expr ${num} + 1`
	done

}



function Set_Siov_Info2vm()
{
	
	type=`echo $@ | awk '{print $1}'`
	Count=`echo $@ | awk '{print $2}'`
	echo "Set Siov device type:  $type"
	echo "Set Siov vf count:     $Count"

	if [ $type == DSA ]
	then
		
		for i in $(seq 0 $Count)
		do
			if [ $i == $Count ]
			then
                		break
			fi
			echo "pciPassthru${i}.present = \"TRUE\"" >> ${file}/${V_Name}.vmx
			echo "pciPassthru${i}.virtualDev = \"dvx\"" >> ${file}/${V_Name}.vmx
			echo "pciPassthru${i}.dvx.deviceClass = \"com.intel.dsa\"" >> ${file}/${V_Name}.vmx
			echo "pciPassthru${i}.dvx.config.profile_id = \"1\"" >> ${file}/${V_Name}.vmx
		done

	elif [ $type == IAA ]
	then
                for i in $(seq 0 $Count)
                do
                        if [ $i == $Count ]
                        then
                                break
                        fi
                        echo "pciPassthru${i}.present = \"TRUE\"" >> ${file}/${V_Name}.vmx
                        echo "pciPassthru${i}.virtualDev = \"dvx\"" >> ${file}/${V_Name}.vmx
                        echo "pciPassthru${i}.dvx.deviceClass = \"com.intel.iaa\"" >> ${file}/${V_Name}.vmx
                        echo "pciPassthru${i}.dvx.config.profile_id = \"1\"" >> ${file}/${V_Name}.vmx
                done
	else
		echo "Input $type error, unrecognized device type"
		exit 1
	
	fi
        echo "Passthrough SIOV Config Finished!"
        exit 0
}





function Cancel_PBDF_Info2vm()
{
        type=`echo $@ | awk '{print $1}'`

        echo "Set  device type:  $type"

	if [ $type == IAA ] || [ $type == DSA ]
	then
		sed -i '/pciPassthru/d' ${file}/${V_Name}.vmx
		echo "Format VM passthrough config"
		echo "Remove passthrough device finished!"
		exit 0

	
	elif [ $type == SRIOV ]
	then
		sed -i '/pciPassthru/d' ${file}/${V_Name}.vmx
	
        	Pci_Bdf=`echo $@ | awk '{print $2}'`
	        Count=`echo $@ | awk '{print $3}'`
        	echo 1233 "$Pci_Bdf" "$Count"	
	        num=1
        	for i in $(seq 0 $Count)
        	do
	                if [ $i == $Count ]
        	        then
                	        break
	             	fi

	                echo pci_bdf:0:-4 ${Pci_Bdf:0:-4}
        	        #lspci -p | grep -i ${Pci_Bdf:0:-4}

                	Vf_Bdf=`lspci -p | grep -i ${Pci_Bdf:0:-4} |  grep -i vf | sed -n ${num}p | awk '{print $1}'`
                	echo "Set Pci Bdf Id : $Vf_Bdf"

	                echo "Toggle passthrough device"
        	        echo "Execute command: esxcli hardware pci pcipassthru set -d=${Vf_Bdf} -e=off  -a"
                	esxcli hardware pci pcipassthru set -d=${Vf_Bdf} -e=off -a
	                num=`expr ${num} + 1`
	        done


	        echo "Execute command: esxcli hardware pci sriov maxvfs set -d ${Pci_Bdf} -v ${Count} -a"
        	esxcli hardware pci sriov maxvfs set -d ${Pci_Bdf} -v 0 -a

	elif [ $type == TOGGLE ]
	then
		for Pci_Bdf in $@
	        do
			if [ $Pci_Bdf == TOGGLE ]
			then 
				continue
			fi
                	echo "Execute command: esxcli hardware pci pcipassthru set -d=${Pci_Bdf} -e=off  -a"
                	esxcli hardware pci pcipassthru set -d=${Pci_Bdf} -e=off -a
                	echo "Remove passthrough device finished!"
        	done				
	else
		echo "run Cancel_PBDF_Info2vm error type : $type"

	fi 

}




function Deal_P_Parameter()
{

        type=`echo $@ | awk '{print $1}'`
	echo type:  $type
        if [ $type == TOGGLE ]
        then
                Grep_Name=`echo $@ | awk '{print $2}'`
                Range=`echo $@ | awk '{print $3}'`
		Start=`echo $Range | awk -F":" '{print $1}'`
		End=`echo $Range | awk -F":" '{print $2}'`
		
                lspci -p | grep -i ${Grep_Name}
                Ret=' '
                for i in $(seq $Start $End)
                do
                        tmp_pci=`lspci -p | grep -i ${Grep_Name} | awk '{print $1}'| sed -n ${i}p`
                        Ret=${Ret}' '${tmp_pci}
			
                done

                echo $Ret
		if [ $R_emove == True ]
		then
			Ret=TOGGLE' '$Ret
			Cancel_PBDF_Info2vm ${Ret}
		else
			Set_PBDF_Info2vm $Ret
		fi
	
	elif [ $type == DSA ] || [ $type == IAA ]
	then
                if [ $R_emove == True ]
                then
                        Cancel_PBDF_Info2vm $@
                else
	                Set_Siov_Info2vm $@

                fi		
	
	elif [ $type == SRIOV ]
	then
		Grep_Name=`echo $@ | awk '{print $2}'`		
                Range=`echo $@ | awk '{print $3}'`
                Cut=`echo $Range | awk -F":" '{print $1}'`
                Vfs=`echo $Range | awk -F":" '{print $2}'`

                lspci -p | grep -i ${Grep_Name}
                P_Bdf=`lspci -p | grep -i ${Grep_Name} | awk '{print $1}'| sed -n ${Cut}p`
                if [ $R_emove == True ]
                then
                        Cancel_PBDF_Info2vm SRIOV ${P_Bdf} ${Vfs}
                else
			Set_Sriov_Info2vm $P_Bdf $Vfs

                fi
				

        else
                echo "$type error parameter"
        fi


}

V_Name=None
P_BDF=None
D_Name=datastore1
R_emove=False

while getopts "n:d:p:r:" arg #选项后面的冒号表示该选项需要参数
do
	case $arg in
	n)
	V_Name=$OPTARG
	;;

        d)
	D_Name=$OPTARG
        ;;

        p)
	P_BDF=$OPTARG
	;;
        
	r)
	R_emove=$OPTARG
        ;;

        ?)
	echo "Error: Invalid input parameter"
	echo "-d: datastore name (default datastore1)"
        echo "-n: Virtual machine name"
        echo "-p: Pci bus number"
        echo "-r: Add or remove pci device(default add /value:False)"
        exit 1
        ;;

        esac



done


#P_BDF=${P_BDF//,/ }
echo V_Name:${V_Name}
echo P_BDF :${P_BDF}
echo D_Name:${D_Name}
echo R_emove:${R_emove}



file=/vmfs/volumes/${D_Name}/${V_Name}
echo "Get vm path $file"

sed -i '/pciPassthru/d' ${file}/${V_Name}.vmx
echo "Format VM passthrough config"
echo -e "\n"

P_BDF=${P_BDF//,/ }
Deal_P_Parameter ${P_BDF}




