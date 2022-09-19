#!/bin/sh


source=/tmp/Get_vmip.txt
#echo "Execute command:  vim-cmd vmsvc/getallvms | grep -iw $1 | awk '{print $1}'"
vmid=`vim-cmd vmsvc/getallvms | grep -iw $1 | awk '{print $1}'`

#echo "Execute command:  vim-cmd vmsvc/get.summary ${vmid} | grep -i "ipAddress" | awk '{print $3}'"
ip=`vim-cmd vmsvc/get.summary ${vmid} | grep -i "ipAddress" | awk '{print $3}'`
echo "Get vm ip:   ${ip:1:-2}" 
echo ${1} ${ip:1:-2} >> ${source}

