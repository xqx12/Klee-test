/*
 * First KLEE tutorial: testing a small function
 */

//#include <klee/klee.h>

#include	<stdlib.h>


int get_sign(int x) {
  char *buf = NULL;
  if (x == 0)
    return 0;
  
  if (x < 0)
     return -1;
  else 
	 buf = (char *)malloc( x * sizeof(int));
	 return 0;
} 

int main(int argc, char *argv[]) {
  int x; 
  char *buf = NULL;

  if(argc < 2) return 0;
  x = atoi(argv[1]);

  if (x == 0)
    return 0;
  if (x < 4)
     return -1;
  else 
	 buf = (char *)malloc( x * sizeof(int));
  if(buf!=NULL){
	memcpy(buf, "123456789abcdef" , 4*sizeof(int));
	printf(buf);
  }
	//dosomething 

  return 0;
} 
