./create_vm.sh  -s /vmfs/volumes/datastore1/BKCPkg/domains/vt_tools/esxi_create_vm_config/centos_vm/  -n cen_123444 -c 2 -m 4096 -t c

-s : source vm file path (make sure *.vmx *.vmdk *flat.vmdk in this path)
-n : vm_name
-c : cores (default :1)
-m : memory (default 1024 MB)
-t : OS type(c: centos w:windows r:rhel)

