
#LLVMGCC=/home/xqx/data/xqx/projects/klee-test/llvm-gcc4.2-2.9-x86_64-linux/bin/llvm-gcc
#KLEE=/home/xqx/data/xqx/projects/klee-test/klee/Release+Asserts/bin/klee
LLVMGCC=$(which llvm-gcc)
KLEE=klee

all:
	gcc abort-noklee.c -o abort
	$(LLVMGCC) --emit-llvm -c abort.c
#	klee --libc=uclibc -posix-runtime --emit-all-errors bench_test.o --sym-args 2 2 5
	$(KLEE) --libc=uclibc -posix-runtime --emit-all-errors abort.o 
	
clean:
	rm *.o
	rm -rf klee-* 
