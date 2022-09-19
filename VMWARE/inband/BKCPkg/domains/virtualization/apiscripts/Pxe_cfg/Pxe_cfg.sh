#!/bin/sh




V_Name=None
E_Thername="PXE Network"
D_Evname=vmxnet3
D_Name=datastore1
R_emove=False

while getopts "n:d:p:r:e:" arg #选项后面的冒号表示该选项需要参数
do
        case $arg in
        n)
        V_Name=$OPTARG
        ;;

        d)
        D_Name=$OPTARG
        ;;

        p)
        D_Evname=$OPTARG
        ;;

	e)
	E_Thername=$OPTARG
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



#ethernet1.virtualDev = "vmxnet3"
#ethernet1.networkName = "PXE Network"
#ethernet1.addressType = "generated"
#ethernet1.wakeOnPcktRcv = "FALSE"
#ethernet1.uptCompatibility = "TRUE"
#ethernet1.present = "TRUE"
echo V_Name:${V_Name}
echo D_Evname :${D_Evname}
echo E_Thername:${E_Thername}
echo R_emove:${R_emove}



file=/vmfs/volumes/${D_Name}/${V_Name}
echo "Get vm path $file"

sed -i '/ethernet1/d' ${file}/${V_Name}.vmx
echo "Format VM ethernet1 config"
echo -e "\n"

if [ $R_emove == False ]
then
	echo "ethernet1.virtualDev = \"${D_Evname}\"" >> ${file}/${V_Name}.vmx
	echo "ethernet1.networkName = \"${E_Thername}\"" >> ${file}/${V_Name}.vmx
	echo "ethernet1.addressType = \"generated\"" >> ${file}/${V_Name}.vmx
	echo "ethernet1.wakeOnPcktRcv = \"FALSE\"" >> ${file}/${V_Name}.vmx
	echo "ethernet1.uptCompatibility = \"TRUE\"" >> ${file}/${V_Name}.vmx
	echo "ethernet1.present = \"TRUE\"" >> ${file}/${V_Name}.vmx


elif [ $R_emove == True ]
then
	echo "Remove ethernet1 config successful!"


fi
