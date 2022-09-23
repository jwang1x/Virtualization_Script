#!/bin/sh



if [ $1 == all ]
	then
		if [ $2 == poweroff ]
			then
				vm_list=`esxcli vm process list | grep -i -B 1 "World ID" | grep -iv "World ID" | grep -iv '-'`
				for vm in $vm_list
					do
						vmid=`vim-cmd vmsvc/getallvms | grep -iw $vm | awk '{print $1}'`
						vim-cmd vmsvc/power.off $vmid
				done
		elif [ $2 == poweron ]
			then 
				vmid=`vim-cmd vmsvc/getallvms | grep -iv "vmid" | awk '{print $1}'`				
				for id in $vmid
					do
						check=`vim-cmd vmsvc/power.getstate $id | grep -iE "off|Suspended"`
						if [[ "$check" != ""  ]]
							then
								vim-cmd vmsvc/power.on $id
									
						fi
				done

	        elif [ $2 == unregister ]
        	        then
				vmid=`vim-cmd vmsvc/getallvms | grep -iv "vmid" | awk '{print $1}'`
                                for id in $vmid
                                do	
	    	                        vim-cmd /vmsvc/unregister $id
                	                echo "$id shutdown vm successful!"
				done
		elif [ $2 == shutdown ]
			then
                       		vm_list=`esxcli vm process list | grep -i -B 1 "World ID" | grep -iv "World ID" | grep -iv '-'`
                                for vm in $vm_list
                                        do
                                                vmid=`vim-cmd vmsvc/getallvms | grep -iw $vm | awk '{print $1}'`
                                                vim-cmd vmsvc/power.shutdown $vmid
                                done


                elif [ $2 == suspend ]
                        then
                              
				vm_list=`esxcli vm process list | grep -i -B 1 "World ID" | grep -iv "World ID" | grep -iv '-'`
                                for vm in $vm_list
                                do
					
                               		vmid=`vim-cmd vmsvc/getallvms | grep -iw $vm | awk '{print $1}'`
                                        vim-cmd vmsvc/power.suspend $vmid
				done
		
		elif [ $2 == reset ]
                        then
                                vm_list=`esxcli vm process list | grep -i -B 1 "World ID" | grep -iv "World ID" | grep -iv '-'`
                                for vm in $vm_list
                                        do
                                                vmid=`vim-cmd vmsvc/getallvms | grep -iw $vm | awk '{print $1}'`
                                                vim-cmd vmsvc/power.reset $vmid
                                done


		else
			echo "$2:Parameter error"
			exit 1

		fi 		

else
	if [ $2 == poweroff ]
        	then              
			id=`vim-cmd vmsvc/getallvms | grep  -iw $1 | awk '{print $1}'`
			if [[ "$id" == "" ]]
                                then
                          		echo "No found the vm"
					exit 0            
			fi

			check_on=`vim-cmd vmsvc/power.getstate $id | grep -i on`
                        check_off=`vim-cmd vmsvc/power.getstate $id | grep -i off`
			
			if [[ "$check_on" != "" && "$check_off" == "" ]]
				then
                                       	vim-cmd vmsvc/power.off $id
			
			elif [[ "$check_on" == "" && "$check_off" != "" ]]
                                then
                                        echo "$1 already poweroff"

			elif [[ "$check_on" == "" && "$check_off" == "" ]]	
				then
					echo "$1:Parameter error"
                                	exit 1                  
			else
				exit 1
			fi

	elif [ $2 == poweron ]
                then
			id=`vim-cmd vmsvc/getallvms | grep  -iw $1 | awk '{print $1}'`
                        check_on=`vim-cmd vmsvc/power.getstate $id | grep -i on`
                        check_off=`vim-cmd vmsvc/power.getstate $id | grep -iE "off|Suspended"`
                        if [[ "$check_on" == "" && "$check_off" != "" ]]
                                then
                                        vim-cmd vmsvc/power.on $id

                        elif [[ "$check_on" != "" && "$check_off" == "" ]]
                                then
                                        echo "$1 already poweron"

                        elif [[ "$check_on" == "" && "$check_off" == "" ]]
                                then
                                        echo "$1:Parameter error"
                                        exit 1
                        else
                                exit 1
                        fi

        elif [ $2 == unregister ]
                then
                        id=`vim-cmd vmsvc/getallvms | grep  -iw $1 | awk '{print $1}'`
                        
                        if [[ "$id" != "" ]]
                                then
					
                                        vim-cmd /vmsvc/unregister $id

			fi

        elif [ $2 == shutdown ]
                then
                        id=`vim-cmd vmsvc/getallvms | grep  -iw $1 | awk '{print $1}'`
                        check_on=`vim-cmd vmsvc/power.getstate $id | grep -i on`
                        check_off=`vim-cmd vmsvc/power.getstate $id | grep -i off`
                        if [[ "$check_on" == "" && "$check_off" != "" ]]
                                then
					echo "$1 already shutdown"

                        elif [[ "$check_on" != "" && "$check_off" == "" ]]
                                then
					vim-cmd vmsvc/power.shutdown $id
                                        
                        elif [[ "$check_on" == "" && "$check_off" == "" ]]
                                then
                                        echo "$1:Parameter error"
                                        exit 1
                        else
                                exit 1
                        fi
			echo "shutdown $1 successful!"

	elif [ $2 == suspend ]
                then
                        id=`vim-cmd vmsvc/getallvms | grep  -iw $1 | awk '{print $1}'`
                        if [[ "$id" == "" ]]
                                then
                                        echo "No found the vm"
                                        exit 0
                        fi

                        check_on=`vim-cmd vmsvc/power.getstate $id | grep -i on`
                        check_off=`vim-cmd vmsvc/power.getstate $id | grep -iE "off|Suspended"`

                        if [[ "$check_on" != "" && "$check_off" == "" ]]
                                then
                                        vim-cmd vmsvc/power.suspend $id

                        elif [[ "$check_on" == "" && "$check_off" != "" ]]
                                then
                                        echo "$1 already poweroff"

                        elif [[ "$check_on" == "" && "$check_off" == "" ]]
                                then
                                        echo "$1:Parameter error"
                                        exit 1
                        else
                                exit 1
                        fi
                        echo "suspend $1 successful!"

        elif [ $2 == reset ]
                then
                        id=`vim-cmd vmsvc/getallvms | grep  -iw $1 | awk '{print $1}'`
                        if [[ "$id" == "" ]]
                                then
                                        echo "No found the vm"
                                        exit 0
                        fi

                        check_on=`vim-cmd vmsvc/power.getstate $id | grep -i on`
                        check_off=`vim-cmd vmsvc/power.getstate $id | grep -i off`

                        if [[ "$check_on" != "" && "$check_off" == "" ]]
                                then
                                        vim-cmd vmsvc/power.reset $id

                        elif [[ "$check_on" == "" && "$check_off" != "" ]]
                                then
                                        echo "$1 already poweroff"

                        elif [[ "$check_on" == "" && "$check_off" == "" ]]
                                then
                                        echo "$1:Parameter error"
                                        exit 1
                        else
                                exit 1
                        fi


        else
		echo "$2:Parameter error" 
               	exit 1

	fi	
fi


