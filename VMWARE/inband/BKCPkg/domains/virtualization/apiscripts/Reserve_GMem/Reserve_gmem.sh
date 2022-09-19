#!/bin/sh

VM_name=None
Status=None
Datastore=datastore1
while getopts "n:s:d:" arg #选项后面的冒号表示该选项需要参数
do
        case $arg in
             s)
                #echo $OPTAG
                Status=$OPTARG
                ;;
           
	     n)
                # echo $OPTARG
                VM_name=$OPTARG
                ;;
           
	     d)
		Datastore=$OPTARG
                ;;

             ?)

                echo "Error: Invalid input parameter"
                echo "-s: Source file"
                echo "-n: Set virtual machine name"
                exit 1
                ;;
        esac
done

file=/vmfs/volumes/${Datastore}/${VM_name}/

memsize=`cat ${file}/${VM_name}.vmx | grep -i memSize | awk '{print $3}'`


sed -i '/sched.mem./d' ${file}/${VM_name}.vmx  

if [ $Status == True ] 
	then
		echo "sched.mem.min = ${memsize}" >> ${file}/${VM_name}.vmx
		echo "sched.mem.minSize = ${memsize}" >> ${file}/${VM_name}.vmx
		echo "sched.mem.shares = \"normal\"" >> ${file}/${VM_name}.vmx
		echo "sched.mem.pin = \"TRUE\"" >> ${file}/${VM_name}.vmx
		echo "Lock successful!"
elif [ $Status == False ]
	then
		echo "sched.mem.min = \"0\"" >> ${file}/${VM_name}.vmx
        	echo "sched.mem.minSize = \"0\"" >> ${file}/${VM_name}.vmx
        	echo "sched.mem.shares = \"normal\"" >> ${file}/${VM_name}.vmx
		echo "Unlock guest memory successful!"
else
	echo "Error: Invalid input parameter"
	exit 1

fi
