
LLVMGCC=/home/xqx/data/xqx/projects/klee-test/llvm-gcc4.2-2.9-x86_64-linux/bin/llvm-gcc
KLEED=/home/xqx/data/xqx/projects/klee-test/klee/Debug/bin/klee
KLEESCA=/home/xqx/data/xqx/projects/size-control-malloc/alloc-klee/klee/Release+Asserts/bin/klee
#LLVMGCC=llvm-gcc
#KLEE=klee

CFILES := $(wildcard *.c)
OBJECTS := $(patsubst %.c, %.bc,  ${CFILES})

kleed: 
	$(LLVMGCC) --emit-llvm -c ${CFILES} -o ${OBJECTS} 
	$(KLEED) --libc=uclibc -posix-runtime --emit-all-errors ${OBJECTS} --sym-args 2 3 3
	#$(KLEE) --libc=uclibc -posix-runtime --emit-all-errors ${OBJECTS} 

scaklee:
	$(LLVMGCC) --emit-llvm -c ${CFILES} -o ${OBJECTS} 
	$(KLEESCA) --libc=uclibc -posix-runtime --emit-all-errors ${OBJECTS} --xqx-args 3 v g t: 
	
clean:
	rm *.o
	rm -rf klee-* 
