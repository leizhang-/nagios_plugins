#!/bin/bash

USAGE="`basename $0` [-n|--name]<eth name>"
name=""
# print usage
if [ $# -ne 2 ]; then
    echo ""
    echo "Wrong Syntax: `basename $0` $*"
    echo ""
    echo "Usage: $USAGE"
    echo ""
    exit 0
fi

while [[ $# -gt 0 ]]
   do
        case "$1" in
               -n|--name)
               shift
               name=$1
        ;;
        esac
        shift
   done
tmp=`sudo /sbin/mii-tool $name`
result=`echo $tmp|grep -o "link ok"`
if [ "$result" == "link ok" ]; then
    echo "$tmp" 
    exit 0
fi

result=`echo $tmp|grep -o "no link"`
if [ "$result" == "no link" ]; then
    echo "$tmp"
    exit 2
else
    echo "SIOCGMIIPHY on '$name' failed"
    exit 3
fi

