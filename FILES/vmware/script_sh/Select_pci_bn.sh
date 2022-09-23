#!/bin/sh

VM_name=None
Datastore=datastore1
Remove=None

while getopts "n:p:d:r:v:c:w:" arg #选项后面的冒号表示该选项需要参数
do
        case $arg in
             n)
                # echo $OPTARG
                VM_name=$OPTARG
                ;;

             d)
                Datastore=$OPTARG
                ;;

             v)
                Vf=$OPTARG
                ;;

             c)
                Count_vfs=$OPTARG
                ;;

             r)
                Remove=$OPTARG
                ;;
	     w)
		cmd=$OPTARG
		;;

             ?)

                echo "Error: Invalid input parameter"
                echo "-d: datastore name (default datastore1)"
                echo "-n: Virtual machine name"
                echo "-p: Pci bus number"
                echo "-r: Add or remove pci device(default add /value:False)"
                exit 1
                ;;
        esac
done





echo $cmd
`${cmd}`
