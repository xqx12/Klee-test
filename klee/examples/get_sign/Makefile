
#LLVMGCC=/home/xqx/data/xqx/projects/klee-test/llvm-gcc4.2-2.9-x86_64-linux/bin/llvm-gcc
#KLEE=/home/xqx/data/xqx/projects/klee-test/klee/Release+Asserts/bin/klee
LLVMGCC=llvm-gcc
KLEE=klee

CFILES := $(wildcard *.c)
OBJECTS := $(patsubst %.c, %.o,  ${CFILES})
GCCOBJECTS := $(patsubst %.c, %.out,  ${CFILES})


all: 
	$(LLVMGCC) --emit-llvm -c ${CFILES} 
	gcc ${CFILES} -o ${GCCOBJECTS}
#	klee --libc=uclibc -posix-runtime --emit-all-errors bench_test.o --sym-args 2 2 5
	$(KLEE) --libc=uclibc -posix-runtime --emit-all-errors ${OBJECTS} --sym-args 1 1 1
	
gcov:
	$(LLVMGCC) --emit-llvm -c ${CFILES} 
	gcc ${CFILES} -g -fprofile-arcs -ftest-coverage -o ${GCCOBJECTS}
	$(KLEE) --libc=uclibc -posix-runtime --emit-all-errors ${OBJECTS} --sym-args 1 1 1


m32: 
	$(LLVMGCC) -m32 --emit-llvm -c ${CFILES} 
	gcc ${CFILES} -m32 -o ${GCCOBJECTS}
#	klee --libc=uclibc -posix-runtime --emit-all-errors bench_test.o --sym-args 2 2 5
	$(KLEE) --libc=uclibc -posix-runtime --emit-all-errors ${OBJECTS} --sym-args 1 1 1

clean:
	rm -rf *.o
	rm -rf klee-* 
	rm -rf *.out *.gc* *.info
	rm -rf html
