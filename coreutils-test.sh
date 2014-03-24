#!/bin/bash
#Filename: coreutils-test.sh
#Last modified: 2014-02-07 16:35
# Author: Qixue Xiao <xiaoqixue_1@163.com>
#Description: 
#Refer:https://www.cs.purdue.edu/homes/kim1051/cs490/proj3/description.html

CWD=/home/xqx/projects/coreutils-6.10
TARGET_DIR=${CWD}
LLVM_DIR=${TARGET_DIR}/obj-llvm
GCOV_DIR=${TARGET_DIR}/obj-gcov

TIMESTAMP=$(date +%Y%m%d%H%M%S)
RESULT_DIR=${CWD}/results/$TIMESTAMP

KLEE=/home/xqx/projects/klee-test/klee/Release+Asserts/bin/klee
KLEE_STATS=/home/xqx/projects/klee-test/klee/Release+Asserts/bin/klee-stats
KTEST_TOOL=/home/xqx/projects/klee-test/klee/Release+Asserts/bin/ktest-tool
KLEE_REPLAY=/home/xqx/projects/klee-test/klee/Release+Asserts/bin/klee-replay
KLEE_PATH=/home/xqx/projects/klee-test/klee/Release+Asserts/bin/


# --sym-args is different with what is meaning in her paper.
#$KLEE --optimize --libc=uclibc --posix-runtime -max-time=60 -use-batching-search --max-sym-array-size=512 ./mkdir.bc -sym-args 3 3 3
ARGS="--sym-args 3 3 3 --sym-files 2 2 --max-fail 1 "
UMDARGS="--optimize --libc=uclibc --posix-runtime -max-time=60 -use-batching-search --max-sym-array-size=512 "
#KLEE_ARGS="--only-output-states-covering-new --optimize --use-forked-stp \
	# --libc=uclibc --max-time=1800 --posix-runtime"

KLEE_ARGS="--simplify-sym-indices --max-memory=12288 --use-cex-cache \
	--disable-inlining --allow-external-sym-calls --watchdog \
	--max-memory-inhibit=false --only-output-states-covering-new \
	--optimize --use-forked-stp --libc=uclibc \
	--max-time=60 --posix-runtime"

function runtest() {
	BINARY=$1
	if [ ! "W$2" = W ]
	then
		ARGS=$2
	fi

	echo "====testing $BINARY : $ARGS"

	START=$(date +%s)
	TEST_DIR=${RESULT_DIR}/${BINARY}/
	mkdir -p ${TEST_DIR}

	#run klee 
	cd ${LLVM_DIR}/src
	${KLEE} ${UMDARGS} ./${BINARY}.bc ${ARGS} &> ${TEST_DIR}/klee.log
	${KLEE_STATS} klee-last &> ${TEST_DIR}/klee-stats.log
	${KTEST_TOOL} klee-last/*.ktest &> ${TEST_DIR}/ktest-tool.log
	cp -Lr klee-last ${TEST_DIR}/

	#calculate coverage of test
	cd ${GCOV_DIR}/src
	${KLEE_REPLAY} ./${BINARY} ${TEST_DIR}/klee-last/*.ktest &> ${TEST_DIR}/kreplay.log
	gcov ./${BINARY} &> ${TEST_DIR}/gcov.log

	END=$(date +%s)
	TIMES=$(($END - $START ))
	echo "=====exec time: $TIMES s" | tee ${TEST_DIR}/time.log
	egrep "(executed|File)" ${TEST_DIR}/gcov.log | cut -f 2 -d ':'
	echo "==========================================="

}

cd ${LLVM_DIR}/src
echo ${RESULT_DIR}
mkdir -p ${RESULT_DIR}
echo $1 > ${RESULT_DIR}/type
for i in $(ls *.bc ); do
	#echo date "--sym-args 0 ${i%.bc} 16" $i
	runtest ${i%.bc} "--sym-args 0 2 4 --sym-files 2 2"
done


cd ${RESULT_DIR}
find -name *.err
