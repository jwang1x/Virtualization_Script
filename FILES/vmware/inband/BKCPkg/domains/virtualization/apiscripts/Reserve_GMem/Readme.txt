Set vm memory locked [ Reserve all guest memory (All locked)] 

-d : which datastore vm inside.(defalut datastore1)
-n : vm_name
-s : Lock guest memory (True: lock False:unlock)



[root@localhost:/vmfs/volumes/6261ac7d-0162c420-d5ba-a4bf016ad6ae/BKCPkg/domains/vt_hls/apiscripts/Reserve_GMem] ./Reserve_GMem.sh -n win_2022 -s True -d datastore1
Locksuccessful!

[root@localhost:/vmfs/volumes/6261ac7d-0162c420-d5ba-a4bf016ad6ae/BKCPkg/domains/vt_hls/apiscripts/Reserve_GMem] ./Reserve_GMem.sh -n win_2022 -s False -d datastore1
Unlock guest memory successful!



