/*
 * First KLEE tutorial: testing a small function
 */

//#include <klee/klee.h>

#include	<stdlib.h>

char *buf;

int get_sign(int x) {
  if (x == 0)
    goto exit; // return 0;
  
  if (x < 0)
     return -1;
  else 
  {
	 buf = (char *)malloc(x-10);
	 /*return 1;*/
  }
exit:
	 free(buf);
	 return 0;
} 

int main(int argc, char *argv[]) {
  int a;
  if(argc < 2) return 0;
  a = atoi(argv[1]);
  /*klee_make_symbolic(&a, sizeof(a), "a");*/
  return get_sign(2*a-8);
} 
