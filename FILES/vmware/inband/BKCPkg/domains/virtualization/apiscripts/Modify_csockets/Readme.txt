Ensure that -p(Cores per Socket) can be divided by -c(Cores)

-d: datastore name (default datastore1)
-n: Virtual machine name
-p: Set Cores per Socket
-c: Set Cores


[root@localhost:/vmfs/volumes/6261ac7d-0162c420-d5ba-a4bf016ad6ae/BKCPkg/domains/vt_hls/apiscripts/Modify_csockets] ./Modify_csockets.sh -n cen_vm -c 8 -p 4
Modifying configuration file.
Modify file complete.
