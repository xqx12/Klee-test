/*
 * First KLEE tutorial: testing a small function
 */


int get_sign(unsigned int x) {
  if (x == 0)
     return 0;
  
  if (x < 0)
     return -1;
  else 
     return 1;
} 

int main() {
  int a;
  char buf[10];
  char *p = buf;
  klee_make_symbolic(&a, sizeof(a), "a");
  get_sign(a);

  char c = *(p+a);
  return 1;
} 
