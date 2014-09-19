/*
 * First KLEE tutorial: testing a small function
 */


int get_sign(int x) {
  if (x == 0){
     return 0;
  }
  
  if (x < 0){
     return -1;
  }
  else
  {
     return 1;
  }
} 

int main(int argc, char *argv[]) {
  int a;
  klee_make_symbolic(&a, sizeof(a), "a");
  /*a = atoi(argv[1]);*/
  return get_sign(a);
} 
