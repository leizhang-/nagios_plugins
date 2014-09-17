#! /bin/bash

PROGNAME=`/bin/basename $0`
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`
STATE_OK=0
STATE_WARNING=1
STATE_CRIT=2
STATE_UNKNOW=3
file_num=0
USER="user"
SYSTEM="system"
type=""
warning=""
critical=""
detail=""

get_user_files() {
    detail=`sudo sh -c 'lsof -n'|awk '{print $3}'|sort|uniq -c |sort -nr|head -1`
    file_num=`echo $detail|awk '{print $1}'`
}

get_sys_files() {
    file_num=`sudo sh -c "cat /proc/sys/fs/file-nr"| awk '{print $1}'`
}

print_usage() {
    echo "Usage: $PROGNAME -t <type user or system> -w <warning> -c <critical>"
    echo "Usage: $PROGNAME --help"
}

while test -n "$1"; do
    case "$1" in
	-t)
	    type=$2
	    shift
	    ;;
	-c)
	    critical=$2
	    shift
	    ;;
	-w)
	    warning=$2
	    shift
	    ;;
	*)
	    echo "Unknown argument: $1"
	    print_usage
	    exit 
	    ;;
    esac
    shift
done

if [ $type = $USER ];then
    get_user_files
    if [ $file_num -gt $critical ]; then
        echo "STAT CRITICAL:$detail"
        exit $STATE_CRIT
    elif [ $file_num -le $critical -a $file_num -gt $warning ]; then
        echo "STAT WARNING:$detail"
        exit $STATE_WARNING
    else
        echo "STAT OK:$detail"
        exit $STATE_OK
    fi
fi

if [ $type = $SYSTEM ];then
    get_sys_files
    if [ $file_num -gt $critical ]; then
        echo "STAT CRITICAL: $file_num"
        exit $STATE_CRIT
    elif [ $file_num -le $critical -a $file_num -gt $warning ]; then
        echo "STAT WARNING: $file_num"
        exit $STATE_WARNING
    else
        echo "STAT OK: $file_num"
        exit $STATE_OK
    fi
fi
