
#LLVMGCC=/home/xqx/data/xqx/projects/klee-test/llvm-gcc4.2-2.9-x86_64-linux/bin/llvm-gcc
#KLEE=/home/xqx/data/xqx/projects/klee-test/klee/Release+Asserts/bin/klee
LLVMGCC=llvm-gcc
KLEE=klee

all:
	#$(LLVMGCC) --emit-llvm -c bench_test.c
	$(KLEE) --libc=uclibc -posix-runtime --emit-all-errors makeinfo.bc --sym-args 2 2 2
	#$(KLEE) --libc=uclibc -posix-runtime --emit-all-errors bench_test.o 
	
clean:
	rm *.o
	rm -rf klee-* 
