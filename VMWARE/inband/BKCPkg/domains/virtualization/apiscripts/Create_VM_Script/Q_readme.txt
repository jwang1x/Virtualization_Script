./Q_create_vms.sh  -s /vmfs/volumes/datastore1/BKCPkg/domains/vt_tools/esxi_create_vm_config/centos_vm/ -n llll -c 1 -m 2048 -t c -p 3

note: Confirm create_vm.sh is in the same directory as this script.

-s : source vm file path (make sure *.vmx *.vmdk *flat.vmdk in this path)
-n : vm_name
-c : cores (default :1)
-m : memory (default 1024 MB)
-t : OS type(c: centos w:windows)
-p ：Set how many vms to create
