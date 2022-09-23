1.Make sure the vmware tool is installed on the vm.
2.Make sure the vm's firewall is disable

[root@localhost:/vmfs/volumes/6261ac7d-0162c420-d5ba-a4bf016ad6ae/BKCPkg/domains/vt_hls/apiscripts/Get_Vmip] ./Get_Vmip.sh  centos_vm
Execute command:  vim-cmd vmsvc/getallvms | grep -iw centos_vm | awk '{print centos_vm}'
Execute command:  vim-cmd vmsvc/get.summary 2 | grep -i ipAddress | awk '{print }'
Get vm ip:   "10.239.182.192",
