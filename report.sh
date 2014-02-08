#!/bin/bash
#Filename: report.sh
#Last modified: 2014-02-08 16:29
# Author: Qixue Xiao <xiaoqixue_1@163.com>
#Description: report the result of klee

TARGET="klee-last"
BINARYDIR="/home/xqx/projects/coreutils-6.10/obj-gcov/src/"

function printerr() {
	ERRFILE=$1
	cat ${ERRFILE}
}

function myparse() {
	TMPFILE=$1
	ktest-tool ${TMPFILE}.ktest 
}

function replay() {
	TMPFILE=$1
	klee-replay ${BINARYDIR}$2 ${TMPFILE}.ktest 
}

if [ ! "W$1" = "W" ]
then
	TARGET=$1
fi


#find -name *.err 

cd $TARGET

for i in $( ls *.err ); do
	#
	echo "==========bug info ================="
	printerr $i
	echo "==========testcase ================="
	myparse ${i%.*.err} 
	if [ ! "W$2" = "W" ]
	then
		echo "==========replay ================="
		replay ${i%.*.err} $2 
	fi
	echo "------------------------------------"
done




