#!/bin/bash
#Filename: timeout.sh
#Last modified: 2014-02-19 22:55
# Author: Qixue Xiao <xiaoqixue_1@163.com>
#Description: kill the process when time out


WAITTIME=3600
PIDISEXIST=0

if [ "W$1" == W ]
then
	exit
fi

PID=$1

if [ "W$2" != W ]
then
	WAITTIME=$2
fi

function checkPIDExsit() {
	CHECKPID=$1
	for i in $(ps aux | awk '{ print $2}'); do
		if [ $i == $CHECKPID ]
		then
			$PIDISEXIST=1
		fi
	done
}

function timeout() {
	count=`expr $WAITTIME / 60`
	
	echo "count="$count
	while (($count > 0))
	do
		sleep 60
		#checkPIDExsit $PID	
		#ps -ax | awk '{ print $1} ' | grep -e "^${PID}$"
		ps -p $PID
		if [ $? -eq 1 ]
		then
			echo "PID has exit by itself."
			break
		fi
		count=`expr $count - 1`
		echo "count="$count

	done


	#sleep $WAITTIME
	kill -9 $PID > /dev/null 2>&1 
	echo "kill pid "$PID

}

timeout


