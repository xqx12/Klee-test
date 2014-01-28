
LLVMGCC=/home/xqx/data/xqx/projects/klee-test/llvm-gcc4.2-2.9-x86_64-linux/bin/llvm-gcc
KLEE=/home/xqx/data/xqx/projects/klee-test/klee/Release+Asserts/bin/klee

all:
	$(LLVMGCC) --emit-llvm -c bench_test.c
#	$(KLEE) --libc=uclibc -posix-runtime --emit-all-errors bench_test.o --sym-args 2 2 5
	$(KLEE) --libc=uclibc -posix-runtime --emit-all-errors --use-query-log=all:pc bench_test.o 3 aaaa 
	
clean:
	rm *.o
	rm -rf klee-* 
