/*
 * First KLEE tutorial: testing a small function
 */


#include	<stdlib.h>

char *buf;

int get_sign(int x) {
  if (x == 0){
	printf("x=0\n");
    /*goto exit; */
	return 0;
  }
  
  if (x < 0)
     return -1;
  else 
     return 1;
  {
	 buf = (char *)malloc(x-10);
	 /*return 1;*/
  }
exit:
	 /*free(buf);*/
	 return 0;
} 

int main() {
  int a;
  char buf[10];
  char *p = buf;
  klee_make_symbolic(&a, sizeof(a), "a");
  get_sign(a);

  char c = *(p+a);
  return 1;
  /*if(argc < 2) return 0;*/
  /*a = atoi(argv[1]);*/
  klee_make_symbolic(&a, sizeof(a), "a");
  /*int b = get_sign(a);*/
 int b=  get_sign(2*a-8);

  memcpy(buf, "aaa", 3);
  printf("%d",b);
  return 0;
} 


