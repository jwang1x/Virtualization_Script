#!/bin/sh

source=/tmp/Save_tmip.txt

while getopts "s:h" arg #选项后面的冒号表示该选项需要参数
do
        case $arg in

                s)
                        source=$OPTARG
			;;

                h) # for help

                        echo "-n : "Get the specified VM IP"
                        echo "-a : "Get all VM IP "
                        ;;
                ?) #

                        echo "Error: Invalid input parameter"
                        echo "Input -h for help"
                        exit 1
                        ;;
        esac
done

rm -rf $source
for item in `vim-cmd vmsvc/getallvms |grep -v Vmid | awk '{print $1}'`
	do
		vm=`vim-cmd vmsvc/get.summary $item | grep -iw name | awk '{print $3}'`
		ip=`vim-cmd vmsvc/get.summary $item | grep -i "ipAddress" | awk '{print $3}'`
		
		echo ${vm:1:-2} ${ip:1:-2} >> ${source}
done

