/****************************************************************
 *  This is a simple example demonstrating an error with KLEE
 *    for a divide by zero error.  
 ***************************************************************/
/*#include <stdlib.h>*/

int main (int argc, char * argv[])
{

  int myInt = 0;
  int yourInt = atoi(argv[1]);
  /*int yourInt = 1;*/

  /*klee_make_symbolic(&yourInt, sizeof(yourInt), "yourInt");*/
  /*klee_make_symbolic(&myInt, sizeof(myInt), "myInt");*/

  myInt = yourInt-1;
  /*myInt = 2;*/

  // this will cause a divide by zero sometimes
  return yourInt/myInt;

}

