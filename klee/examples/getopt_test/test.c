/*
 * =====================================================================================
 *
 *       Filename:  test.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2014年02月10日 16时50分11秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Xiao Qixue (XQX), xiaoqixue_1@163.com
 *   Organization:  Tsinghua University
 *
 * =====================================================================================
 */

//getopttest.c  
#include <stdio.h>  
#include <unistd.h>  

int main(int argc,char *argv[])  
{  

	int opt=0;  
	int i=0;  
	const char *optstring=":vgt:";  
	//非选项参数的个数  
	const int num=1;  
	//调用getopt前打印argv数组  
	for(i=0;i<argc;i++)  
		printf("%d:%s\n",i,argv[i]);  

	//处理选项参数  
	while((opt=getopt(argc,argv,optstring)) != -1)  
	{  
		switch(opt)  
		{  

			case 'v':  
			case 'g':  
				printf("option：%c\n",opt);  
				break;  
			case 't':  
				printf("option:%c = %s\n",opt,optarg);  
				break;  
			case ':':  
				printf("the option need a value\n");  
				break;  
			case '?':  
				printf("unknow option：%c\n",optopt);  
				break;  
		}  
	}  

	//处理非选项参数  
	for(i=0;optind<argc;i++,optind++)  
	{  
		if(i<num)  
			printf("argument:%s\n",argv[optind]);  
		else  
			printf("excess argument:%s\n",argv[optind]);  
	}  

	//调用getopt后打印argv数组  
	for(i=0;i<argc;i++)  
		printf("%d:%s\n",i,argv[i]);  

	return 0;  
} 
