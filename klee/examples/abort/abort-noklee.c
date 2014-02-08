/*
 * =====================================================================================
 *
 *       Filename:  abort.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2014年02月08日 20时38分14秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Xiao Qixue (XQX), xiaoqixue_1@163.com
 *   Organization:  Tsinghua University
 *
 * =====================================================================================
 */

#include <string.h>
#include <stdlib.h>

int main (int argc, char * argv[])
{

	char myStr[5];

	/*klee_make_symbolic(&myStr, sizeof(myStr), "myStr");*/
	if(strcmp(myStr, "bye!") == 0)
	{
		// someone said bye, time to go!
		abort();
	}

	return 0;
}

