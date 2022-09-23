#!/bin/sh




while getopts "an:h" arg #选项后面的冒号表示该选项需要参数
do
        case $arg in
	
		a) 
			for item in `vim-cmd vmsvc/getallvms |grep -v Vmid | awk '{print $1}'`
			        do
                		ip=`vim-cmd vmsvc/get.summary $item | grep -i "ipAddress" | awk '{print $3}'`
				ping ${ip:1:-2} 
				if [ $? == 0 ]
					then	
						continue
				else
					exit 1
				
				fi		
			done
			;;			

		n)
             		vm=$OPTARG
			vmid=`vim-cmd vmsvc/getallvms | grep -iw $vm | awk '{print $1}'`
			ip=`vim-cmd vmsvc/get.summary $vmid | grep -i "ipAddress" | awk '{print $3}'`
			ping ${ip:1:-2}
                        if [ $? == 0 ]
                        	then
                        	continue
                        else
                                exit 1
                        fi
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


