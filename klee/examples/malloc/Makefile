
LLVMGCC=/home/xqx/data/xqx/projects/klee-test/llvm-gcc4.2-2.9-x86_64-linux/bin/llvm-gcc
KLEE=/home/xqx/data/xqx/projects/klee-test/klee/Release+Asserts/bin/klee
#LLVMGCC=llvm-gcc
#KLEE=klee

CFILES := $(wildcard *.c)
OBJECTS := $(patsubst %.c, %.o,  ${CFILES})
GCCOBJECTS := $(patsubst %.c, %.out,  ${CFILES})

all: 
	$(LLVMGCC) --emit-llvm -c ${CFILES} 
	gcc ${CFILES} -o ${GCCOBJECTS}
#	klee --libc=uclibc -posix-runtime --emit-all-errors bench_test.o --sym-args 2 2 5
	$(KLEE) --libc=uclibc -posix-runtime --emit-all-errors -search=dfs ${OBJECTS} --sym-args 2 2 2  

nolibc:
	$(LLVMGCC) --emit-llvm -c ${CFILES} 
	$(KLEE) --emit-all-errors ${OBJECTS}   

	
clean:
	rm *.o
	rm -rf klee-* 
