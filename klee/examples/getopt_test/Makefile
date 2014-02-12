
#LLVMGCC=/home/xqx/data/xqx/projects/klee-test/llvm-gcc4.2-2.9-x86_64-linux/bin/llvm-gcc
#KLEE=/home/xqx/data/xqx/projects/klee-test/klee/Release+Asserts/bin/klee
LLVMGCC=llvm-gcc
KLEE=klee

CFILES := $(wildcard *.c)
OBJECTS := $(patsubst %.c, %.bc,  ${CFILES})

all: 
	$(LLVMGCC) --emit-llvm -c ${CFILES} -o ${OBJECTS} 
	klee --libc=uclibc -posix-runtime --emit-all-errors ${OBJECTS} --sym-args 2 5 3
	#$(KLEE) --libc=uclibc -posix-runtime --emit-all-errors ${OBJECTS} 
	
clean:
	rm *.o
	rm -rf klee-* 
