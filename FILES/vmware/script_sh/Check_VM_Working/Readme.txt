1.Make sure the vmware tool is installed on the vm.
2.Make sure the vm's firewall is disable

Ping all vm,checking it's working
./Ping_vm.sh -a  

[root@localhost:/vmfs/volumes/62464c47-46920b0c-8efa-a4bf016ad6ae/BKCPkg/domains/vt_hls/apiscripts] ./Ping_vm.sh -a
PING 10.239.183.119 (10.239.183.119): 56 data bytes
64 bytes from 10.239.183.119: icmp_seq=0 ttl=64 time=0.664 ms
64 bytes from 10.239.183.119: icmp_seq=1 ttl=64 time=0.529 ms
64 bytes from 10.239.183.119: icmp_seq=2 ttl=64 time=0.666 ms

--- 10.239.183.119 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.529/0.620/0.666 ms

PING 10.239.182.166 (10.239.182.166): 56 data bytes
64 bytes from 10.239.182.166: icmp_seq=0 ttl=64 time=0.778 ms
64 bytes from 10.239.182.166: icmp_seq=1 ttl=64 time=0.444 ms
64 bytes from 10.239.182.166: icmp_seq=2 ttl=64 time=0.550 ms

--- 10.239.182.166 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.444/0.591/0.778 ms

PING 10.239.182.100 (10.239.182.100): 56 data bytes
64 bytes from 10.239.182.100: icmp_seq=0 ttl=128 time=0.423 ms
64 bytes from 10.239.182.100: icmp_seq=1 ttl=128 time=0.463 ms
64 bytes from 10.239.182.100: icmp_seq=2 ttl=128 time=0.665 ms

--- 10.239.182.100 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.423/0.517/0.665 ms


Ping vm 
./Ping_vm.sh -n centos

[root@localhost:/vmfs/volumes/62464c47-46920b0c-8efa-a4bf016ad6ae/BKCPkg/domains/vt_hls/apiscripts] ./Ping_vm.sh -n centos
PING 10.239.183.119 (10.239.183.119): 56 data bytes
64 bytes from 10.239.183.119: icmp_seq=0 ttl=64 time=0.566 ms
64 bytes from 10.239.183.119: icmp_seq=1 ttl=64 time=0.438 ms
64 bytes from 10.239.183.119: icmp_seq=2 ttl=64 time=0.647 ms

--- 10.239.183.119 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.438/0.550/0.647 ms


