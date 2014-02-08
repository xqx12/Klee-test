
LLVMGCC=/home/xqx/projects/llvm-gcc4.2-2.9-x86_64-linux/bin/llvm-gcc
KLEE=/home/xqx/projects/klee-test/klee/Release+Asserts/bin/klee

all:
	$(LLVMGCC) --emit-llvm -c -I/home/xqx/projects/klee-test/klee/include islower.c
#	$(KLEE) --libc=uclibc -posix-runtime --emit-all-errors bench_test.o --sym-args 2 2 5
	$(KLEE) --libc=uclibc  --emit-all-errors --use-query-log=all:pc islower.o 
	
clean:
	rm *.o
	rm -rf klee-* 
