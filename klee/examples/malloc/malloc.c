/*
 * =====================================================================================
 *
 *       Filename:  malloc.c
 *
 *    Description:  test  malloc in klee
 *
 *        Version:  1.0
 *        Created:  2014年02月12日 14时03分56秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Xiao Qixue (XQX), xiaoqixue_1@163.com
 *   Organization:  Tsinghua University
 *
 * =====================================================================================
 */


#include	<stdlib.h>

int doSomething(int x, void * buf)
{
   if (x%3 == 2)
   {
      free((void*)buf);
      return 0;
   }

   return 1;
}
/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  main
 *  Description:  
 * =====================================================================================
 */
	int
main ( int argc, char *argv[] )
{
	int size;
	int x;
	
	if ( argc < 3 )
		return 0;

	size = atoi( argv[1] );
	x = atoi( argv[2] );

	int * myBuf = (int *)malloc(sizeof(int)*size);
	/*if (myBuf != NULL)*/
		/*free((void *)myBuf);*/

	if (!doSomething(x, myBuf))
	{
		free((void *)myBuf);
	}

	return EXIT_SUCCESS;
}				/* ----------  end of function main  ---------- */
