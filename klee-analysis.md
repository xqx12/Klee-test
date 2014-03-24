Klee-Analysis
---------------------

1. klee supports --libc=uclibc  and --posix-runtime two options. what are the difference?

	POSIX is a standard for OS API which made by IEEE. Posix is supported by UNIX, DEC OPENVMS, Linux and Windows NT. 

	libc library provide a large part of POSIX API, 

2. klee-gcc.

	For using klee to test codes you need to compile it with llvm tool chain and generate the bc file format.
	But there are errors if we use klee-gcc to compile the target codes, such as it not know use which tool to work exactly, llvm-gcc or llvm-ld.
	this problem maybe resolved in newer llvm with clang.

	the main errors and fix methods as follows:

	1. configure cannot run klee-gcc normal, FIX: to modify the klee-gcc

	2. in some configure file have -V, and gcc could not run with it, FIX: delete -V

	3. klee-gcc not run llvm-gcc or llvm-ld correctly.
		FIX: 1) CCLD = "$CC -Wl"
			 2) AM_LDFLAGS= -Wl  , and so on
			 3)
			 \
	4. WARN_CFLAGS = Wshadow , such as it. FIX: delete it all.

	5. libtool -shared not be recognized . FIX: delete it.


