#include <stdlib.h>
#include <stdio.h>
//#include <unistd.h>
//#include <sys/types.h>
//#include <sys/wait.h>
#include <pthread.h>

/* Author:  Peter A. Dranishnikov
 * Course:  COP4610 
 * Section: 02
 * Assignment: 2
 */

pthread_mutex_t fib_seq_lock = PTHREAD_MUTEX_INITIALIZER;
volatile int *fib_seq;

void 
*fib_thd(void *arg)
{
	int fib_max = (*(int *)arg); //extracting an integer from a void pointer
	
	int i;
	pthread_mutex_lock(&fib_seq_lock);
	for(i = 0; i < fib_max; i++)
	{
		
		switch(i)
		{
			case 0:
			{
				*fib_seq = 0;
				break;
			}
			case 1:
			{
				*(fib_seq + i) = 1;
				break;
			}
			default:
			{
				*(fib_seq + i) = *(fib_seq + i - 1) + *(fib_seq + i - 2);
				break;
			}
		}
	}
	pthread_mutex_unlock(&fib_seq_lock);
	
	return NULL;
}

int 
main(int argc, char *argv[])
{
	pthread_t p1;
	int rc;

	if(argc < 2)
	{
		printf("No args\n");
		return -1;
	}
	
	int num_fib = atoi(argv[1]);
	
	pthread_mutex_lock(&fib_seq_lock);
	fib_seq = malloc(sizeof(int) * num_fib);
	pthread_mutex_unlock(&fib_seq_lock);
	
	void *num_fib_param = malloc(sizeof(int));
	*((int*)num_fib_param) = num_fib;
	//printf("%d\n",*((int*)num_fib_param));
	
	rc = pthread_create(&p1, NULL, &fib_thd, num_fib_param);
	//lock for child pthread to finish? (API)
	rc = pthread_join(p1, NULL);
	
	int i;
	pthread_mutex_lock(&fib_seq_lock);
	for(i = 0; i < num_fib; i++)
	{
		printf("%d ", *(fib_seq + i));
	}
	pthread_mutex_unlock(&fib_seq_lock);
	printf("\n");
	
	free((void*)fib_seq);
	
	return 0;
}
