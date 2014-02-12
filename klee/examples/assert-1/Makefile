
#LLVMGCC=/home/xqx/data/xqx/projects/klee-test/llvm-gcc4.2-2.9-x86_64-linux/bin/llvm-gcc
#KLEE=/home/xqx/data/xqx/projects/klee-test/klee/Release+Asserts/bin/klee
LLVMGCC=llvm-gcc
KLEE=klee
rsklee="klee --optimize --libc=uclibc --posix-runtime -max-time=60 -search=random-state "

CFILES := $(wildcard *.c)
OBJECTS := $(patsubst %.c, %.bc,  ${CFILES})

all: 
	$(LLVMGCC) --emit-llvm -c ${CFILES} -o ${OBJECTS} 
	#klee --libc=uclibc -posix-runtime --emit-all-errors ${OBJECTS} --sym-args 2 2 2
	#$(KLEE) --libc=uclibc -posix-runtime --emit-all-errors ${OBJECTS} 
	klee --libc=uclibc -posix-runtime --emit-all-errors -max-time=60 -search=nurs:covnew ${OBJECTS} --sym-args 4 4 2
	
clean:
	rm *.o
	rm -rf klee-* 
