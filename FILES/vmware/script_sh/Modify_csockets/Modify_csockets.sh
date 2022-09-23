#!/bin/sh

VM_name=None
Cores=1
Per_cs=1
Datastore=datastore1



while getopts "n:p:d:c:" arg #选项后面的冒号表示该选项需要参数
do
        case $arg in
             p)
                #echo $OPTAG
                Per_cs=$OPTARG
                ;;

             n)
                # echo $OPTARG
                VM_name=$OPTARG
                ;;

             d)
                Datastore=$OPTARG
                ;;

             c)
                Cores=$OPTARG
                ;;
             ?)

                echo "Error: Invalid input parameter"
                echo "-d: datastore name (default datastore1)"
                echo "-n: Virtual machine name"
                echo "-p: Set Cores per Socket"
                echo "-c: Set Cores"
                exit 1
                ;;
        esac
done



file=/vmfs/volumes/${Datastore}/${VM_name}/

if [ $((${Cores}%${Per_cs})) != 0 ]
	then
		echo "Error:Per_ CS must be divisible by Cores"
		exit 1
fi

echo "Modifying configuration file."
sed -i '/numvcpus =/d' ${file}/${VM_name}.vmx
sed -i '/cpuid.coresPerSocket =/d' ${file}/${VM_name}.vmx

echo "numvcpus = \"${Cores}\"" >> ${file}/${VM_name}.vmx
echo "cpuid.coresPerSocket = \"${Per_cs}\"" >> ${file}/${VM_name}.vmx


echo "Modify file complete."
