#include <stdio.h>
#include <string.h>
//#include "s2e.h"

void int_overflow(int size)
{
	char *buf ;
	buf = malloc(size * sizeof(int));
	memset(buf, 'A', size);
	printf("%s\n",buf);
	memset(buf+size, 'B', size*sizeof(int) - size - 1);
	printf("%s\n",buf);
}
int main(int argc, char *argv[])
{
  char str[3];
  // printf("Enter two characters: ");
  // if(!fgets(str, sizeof(str), stdin))
  //   return 1;
  str[0] = 'a';
  str[1] = 'a';

 // int argc ; //para numbers
  int argv1; //a int from user
  char argv2[16]; // a array char from user

  
//  argc =  3;
  argv1 = atoi(argv[1]); //simulate assign the value
  strcpy(argv2, argv[2] );

  klee_make_symbolic(argv2, 16, "argv2");
  klee_make_symbolic(argc, 4, "argc");


  if(argc < 3 ) 
	  return -1;

  if(strcmp(argv2, "hello") == 0 )
	  printf("hello body \n");
  else if(strcmp(argv2, "bug") == 0){
	  int_overflow(argv1);
	  printf("Congratulations, a bug here\n");
  }

//  s2e_disable_forking();

//  s2e_get_example(str, 2);
//  printf("'%c%c' %02x %02x\n", str[0], str[1],
//         (unsigned char) str[0], (unsigned char) str[1]);

//  s2e_kill_state(0, "kill state ");
  return 0;
}

