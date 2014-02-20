#!/bin/bash
#Filename: for-klee-test.sh
#Last modified: 2014-02-19 21:40
# Author: Qixue Xiao <xiaoqixue_1@163.com>
#Description: 

CWD=`pwd`
TARGET_DIR=${CWD}
TIMESTAMP=$(date +%Y%m%d%H%M%S)
RESULT_DIR=${CWD}/results/$TIMESTAMP

MAX_THREADS=40
TIMEOUT=3600

#echo ${RESULT_DIR}
#mkdir -p ${RESULT_DIR}
#echo $@ > ${RESULT_DIR}/cmdinfo

if [ ! "W$1" = W ]
then
	TARGET_DIR=$1	
fi


function run_mul_test() {

	#this code will test multi in time
	for i in $(find ${TARGET_DIR} -name "*.bc" ); do
		NAME=`basename $i`
		echo $NAME
		./runklee.sh $i $1 $RESULT_DIR &
		CMDPID=$!
		echo "pid is :"$CMDPID
		./timeout.sh $CMDPID $TIMEOUT &
		PIDINFO=`pidof -x runklee.sh`
		PIDNUMS=`pidof -x runklee.sh | sed "s/ /\n/g" |wc -l`
		echo "running test.sh: "$PIDNUMS
		while (($PIDNUMS > $MAX_THREADS))
		do
			sleep 10
			PIDNUMS=`pidof -x runklee.sh | sed "s/ /\n/g" |wc -l`
		done

	done
}

# mainrun p1 p2
# p1: target dir
# p2: opt
function mainrun() {
	echo ${RESULT_DIR}
	mkdir -p ${RESULT_DIR}
	echo $1 > ${RESULT_DIR}/type
	if [ ! "W$1" = W ]
	then
		TARGET_DIR=$1	
	fi

	run_mul_test $2

	#case $2 in
		#"s1")
			#run_mul_test "--sym-args 1 1 4  --sym-files 1 4 --max-fail 1"
			#;;
		#"s2")
			#run_mul_test "--sym-args 3 3 3 --sym-files 1 4 --max-fail 1"
			#;;
		#"m1")
			#run_mul_test "--sym-args 1 3 3 --sym-files 2 4 --max-fail 1"
			#;;
		#"m2")
			#run_mul_test "--sym-args 5 5 10 --sym-files 2 4 --max-fail 1"
			#;;
	#esac


}


mainrun $@



cd ${RESULT_DIR}
find -name *.err

