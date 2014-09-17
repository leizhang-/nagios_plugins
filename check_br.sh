#!/bin/bash
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`
. $PROGPATH/utils.sh
USAGE="`basename $0` [-n|--name]<br name> [-w|--warning]<bytes/s> [-c|--critical]<bytes/s>"
critical=""
warning=""
name=""
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
# print usage
if [[ $# -lt 4 ]]
then
	echo ""
	echo "Wrong Syntax: `basename $0` $*"
	echo ""
	echo "Usage: $USAGE"
	echo ""
	exit 0
fi
# read input

while [[ $# -gt 0 ]]
  do
        case "$1" in
               -n|--name)
               shift
               name=$1
        ;;
        esac
        case "$2" in
               -w|--warning)
               shift
               warning=$2
        ;;
        esac
        case "$3" in
               -c|--critical)
               shift
               critical=$3
        ;;
        esac
        shift
  done
result=`sudo sh -c "ovs-ofctl benchmark $name 5 3|grep -o '[0-9]* bytes/s'|grep -o '[0-9]*'"`
if [ $result -gt $warning ]; then
    echo "$name $result bytes/s"
    exit $STATE_OK
fi

if [ $result -ge $critical -a $result -le $warning ]; then
    echo "$name $result bytes/s"
    exit $STATE_WARNING
fi

if [ $result -ge 0 -a $result -le $critical ]; then
    echo "$name $result bytes/s"
    exit $STATE_CRITICAL
fi

if [ "$result" == "" ]; then
    echo "test $name failed"
    exit $STATE_UNKNOWN
fi

