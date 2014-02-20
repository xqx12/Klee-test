#!/bin/bash
#Filename: runklee.sh
#Last modified: 2014-02-19 21:45
# Author: Qixue Xiao <xiaoqixue_1@163.com>
#Description: 


RESULT_DIR=

KLEE=/home/xqx/data/xqx/projects/size-control-malloc/Klee-test/klee/Release+Asserts/bin/klee
KLEE_STATS=/home/xqx/data/xqx/projects/size-control-malloc/Klee-test/klee/Release+Asserts/bin/klee-stats
KTEST_TOOL=/home/xqx/data/xqx/projects/size-control-malloc/Klee-test/klee/Release+Asserts/bin/ktest-tool
KLEE_REPLAY=/home/xqx/data/xqx/projects/size-control-malloc/Klee-test/klee/Release+Asserts/bin/klee-replay
KLEE_PATH=/home/xqx/data/xqx/projects/size-control-malloc/Klee-test/klee/Release+Asserts/bin/

#KLEE=/home/xqx/projects/klee-test/klee/Release+Asserts/bin/klee
#KLEE_STATS=/home/xqx/projects/klee-test/klee/Release+Asserts/bin/klee-stats
#KTEST_TOOL=/home/xqx/projects/klee-test/klee/Release+Asserts/bin/ktest-tool
#KLEE_REPLAY=/home/xqx/projects/klee-test/klee/Release+Asserts/bin/klee-replay
#KLEE_PATH=/home/xqx/projects/klee-test/klee/Release+Asserts/bin/


ARGS="--sym-args 3 3 3 --sym-files 2 2 --max-fail 1 "
UMDARGS="--optimize --libc=uclibc --posix-runtime -max-time=60 -use-batching-search --max-sym-array-size=512 "
#KLEE_ARGS="--only-output-states-covering-new --optimize --use-forked-stp \
	# --libc=uclibc --max-time=1800 --posix-runtime"

KLEE_ARGS="--simplify-sym-indices --max-memory=12288 --use-cex-cache \
	--disable-inlining --allow-external-sym-calls --watchdog \
	--max-memory-inhibit=false --only-output-states-covering-new \
	--optimize --libc=uclibc \
	--max-time=60 --posix-runtime"

function runtest() {
	BINARY=$1
	BINARY_NAME=`basename $1 | sed "s/.bc//g"`
	echo `basename $1 | sed "s/.bc//g"`
	echo $BINARY_NAME
	if [ ! "W$2" = W ]
	then
		ARGS=$2
	fi

	echo "====testing $BINARY : $ARGS"

	START=$(date +%s)
	TEST_DIR=${RESULT_DIR}/${BINARY_NAME}/
	KLEEOUT_DIR=$TEST_DIR/klee-out/
	echo $TEST_DIR
	mkdir -p ${TEST_DIR}

	#run klee 
	#cd ${LLVM_DIR}/src
	echo "${KLEE} ${UMDARGS} --output-dir=${KLEEOUT_DIR} ./${BINARY} ${ARGS} &> ${TEST_DIR}/klee.log"
	${KLEE} ${UMDARGS} --output-dir=${KLEEOUT_DIR} ./${BINARY} ${ARGS} &> ${TEST_DIR}/klee.log
	#${KLEE_STATS} klee-last &> ${TEST_DIR}/klee-stats.log
	#${KTEST_TOOL} klee-last/*.ktest &> ${TEST_DIR}/ktest-tool.log
	cp -Lr klee-last ${TEST_DIR}/

	#calculate coverage of test
	#cd ${GCOV_DIR}/src
	#${KLEE_REPLAY} ./${BINARY} ${TEST_DIR}/klee-last/*.ktest &> ${TEST_DIR}/kreplay.log
	#gcov ./${BINARY} &> ${TEST_DIR}/gcov.log

	END=$(date +%s)
	TIMES=$(($END - $START ))
	echo "=====exec time: $TIMES s" | tee ${TEST_DIR}/time.log
	#egrep "(executed|File)" ${TEST_DIR}/gcov.log | cut -f 2 -d ':'
	echo "==========================================="

}

function mainrun() {


	if [ "W$3" == W ]
	then
		echo "assert no result_dir"
		exit
	fi
	RESULT_DIR=$3

	case $2 in
		"s1")
			runtest $1 "--sym-args 1 1 4  --sym-files 1 4 --max-fail 1"
			;;
		"s2")
			runtest $1 "--sym-args 3 3 3 --sym-files 1 4 --max-fail 1"
			;;
		"m1")
			runtest $1 "--sym-args 1 3 3 --sym-files 2 4 --max-fail 1"
			;;
		"m2")
			runtest $1 "--sym-args 5 5 10 --sym-files 2 4 --max-fail 1"
			;;
	esac



}

mainrun $@

sleep 100
