
#LLVMGCC=/home/xqx/data/xqx/projects/klee-test/llvm-gcc4.2-2.9-x86_64-linux/bin/llvm-gcc
#KLEE=/home/xqx/data/xqx/projects/klee-test/klee/Release+Asserts/bin/klee
LLVMGCC=llvm-gcc
KLEE=klee

CFILES := $(wildcard *.c)
OBJECTS := $(patsubst %.c, %.o,  ${CFILES})
GCCOBJECTS := $(patsubst %.c, %.out,  ${CFILES})


all: 
	$(LLVMGCC) -g --emit-llvm -c ${CFILES} 
	#gcc ${CFILES} -g -o ${GCCOBJECTS}
#	klee --libc=uclibc -posix-runtime --emit-all-errors bench_test.o --sym-args 2 2 5
	#$(KLEE) -write-paths -write-sym-paths -use-call-paths  --libc=uclibc -posix-runtime --emit-all-errors ${OBJECTS} --sym-args 1 1 1  1> klee.log 2>&1 && vim klee.log
	#$(KLEE)  --emit-all-errors ${OBJECTS} --sym-args 1 1 1 1> klee.log 2>&1 && vim klee.log
	#$(KLEE)  --libc=uclibc -posix-runtime --emit-all-errors ${OBJECTS} 2>&1 | tee  klee.log && vim klee.log
	$(KLEE)  --emit-all-errors ${OBJECTS} 2>&1 | tee  klee.log && vim klee.log
	
gcov:
	$(LLVMGCC) --emit-llvm -c ${CFILES} 
	gcc ${CFILES} -g -fprofile-arcs -ftest-coverage -o ${GCCOBJECTS}
	$(KLEE) --libc=uclibc -posix-runtime --emit-all-errors ${OBJECTS} --sym-args 1 1 2


m32: 
	$(LLVMGCC) -m32 --emit-llvm -c ${CFILES} 
	gcc ${CFILES} -m32 -o ${GCCOBJECTS}
#	klee --libc=uclibc -posix-runtime --emit-all-errors bench_test.o --sym-args 2 2 5
	$(KLEE) --libc=uclibc -posix-runtime --emit-all-errors ${OBJECTS} --sym-args 1 1 1 1> klee.log 2>&1 && vim klee.log


clean:
	rm -rf *.o *.out
	rm -rf *.gc* *.info *.log
	rm -rf klee-* 
	rm -rf html
