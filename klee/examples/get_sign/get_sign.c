/*
 * First KLEE tutorial: testing a small function
 */

//#include <klee/klee.h>

int get_sign(int x) {
  if (x == 0)
     return 0;
  
  if (x < 0)
     return -1;
  else 
     return 1;
} 

int main(int argc, char *argv[]) {
  int a;
  if(argc < 2) return 0;
  a = atoi(argv[1]);
  /*klee_make_symbolic(&a, sizeof(a), "a");*/
  return get_sign(a);
} 
