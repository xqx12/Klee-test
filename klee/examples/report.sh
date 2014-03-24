#!/bin/bash
#Filename: report.sh
#Last modified: 2014-02-08 16:29
# Author: Qixue Xiao <xiaoqixue_1@163.com>
#Description: report the result of klee
#Usage: ./report.sh dir bin "gcov|lcov"
#       dir is the klee-out-x , default is klee-last
#       bin : the binary will to replay, patten is bin.out
#       gcov or lcov : to report coverage by gcov or lcov

TARGET="klee-last"
#BINARYDIR="/home/xqx/projects/coreutils-6.10/obj-gcov/src/"
BINARYDIR=$(pwd)/

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
	klee-replay ${BINARYDIR}$2.out ${TMPFILE}.ktest 
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


if [  $3 == "gcov" ]
then
	klee-replay ${BINARYDIR}$2.out *.ktest 1> /dev/null 2>&1 
	echo "***************coverage *****************"
	cd ${BINARYDIR}
	gcov ${BINARYDIR}$2.out
	echo "***************coverage *****************"
fi

if [  $3 == "lcov" ]
then
	cd ${BINARYDIR}
	~/software/lcov-1.10/bin/lcov  -i -z -d .
	klee-replay ${BINARYDIR}$2.out ${TARGET}/*.ktest 1> /dev/null 2>&1 
	~/software/lcov-1.10/bin/lcov -c -d . > coverage.info
	~/software/lcov-1.10/bin/genhtml -o html coverage.info
	firefox ./html/index.html
fi





