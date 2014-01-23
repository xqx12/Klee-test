all:
	llvm-gcc --emit-llvm -c bench_test.c
	klee --libc=uclibc -posix-runtime --emit-all-errors bench_test.o --sym-args 2 2 5
	
clean:
	rm *.o
	rm -rf klee-* 
