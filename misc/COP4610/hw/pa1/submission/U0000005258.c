#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(int argc, char *argv[])
{
    if(argc < 2)
    {
        printf("No args\n");
        return -1;
    }
    
    int num_children = atoi(argv[1]);
    int total_elements = argc - 2;
    int subdiv_elements = total_elements / num_children;
    int *vals = malloc(sizeof(int) * (argc - 2));
    
    int k;
    for(k = 2; k < argc; k++)
    {
        vals[k-2] = atoi(argv[k]);
        //printf("Val: %d\n", vals[k-2]);
    }
    
    //initialize pipes
    //2 pipes per child, 2 spots for each pipe
    int *plumbing = malloc(sizeof(int) * 2 * 2 * num_children);
    int i;
    for(i = 0; i < num_children * 2; i+=2)
    {
        int status = pipe(plumbing + 2 * i);
        if (status == -1)
        {
            printf("No pipes left?!\n");
            return -1;
        }
        status = pipe(plumbing + 2 * i + 2);
        
    }
    //pipe ordering from parent: out to child first, then in from child
    
    int *subvals = malloc(sizeof(int) * subdiv_elements);
    
    int family, allpids;
    int status = 0;
    int fsum = 0;
    for(i = 0; i < num_children * 2; i+= 2)
    {
        if(num_children > 1)
        {
            int j;
            for(j = 0; j < subdiv_elements; j++)
            {
                //printf("\n%d", vals[(i / 2 * subdiv_elements) + j]);
                subvals[j] = vals[(i / 2 * subdiv_elements) + j];
                //printf("%d ", subvals[j]);
            }
            
            write(*(plumbing + 2 * i + 1), &subvals, sizeof(subvals));
            close(*(plumbing + 2 * i + 1));
        }
        else
        {
            write(*(plumbing + 2 * i + 1), &vals, sizeof(vals));
            close(*(plumbing + 2 * i + 1));
        }
        
        family = fork();
        if(family < 0)
        {
            printf("No forks left?!\n");
            return -2;
        }
        else if(family == 0)
        {
            close(*(plumbing + 2 * i + 1));
            close(*(plumbing + 2 * (i + 1) + 0));
            
            int *recvals;
            //printf("\nattempt read...");
            read(*(plumbing + 2 * i + 0), &recvals, sizeof(recvals));
            close(*(plumbing + 2 * i + 0));
            
            // compute the sum
            int sum = 0;
            printf("I am child with pid: %d adding the array ", getpid());
            int j;
            for(j = 0; j < subdiv_elements; j++)
            {
                printf("%d ", recvals[j]);
                sum += recvals[j];
            }
            printf("and sending partial sum %d.\n", sum);
            
            // send result to parent
            write(*(plumbing + 2 * (i + 1) + 1), &sum, sizeof(sum));
            close(*(plumbing + 2 * (i + 1) + 1));
            
            free(vals);
            free(subvals);
            free(plumbing);
            exit(0);
        }
        else
        {
            // parent
            printf("I am the parent pid: %d sending the array: ", getpid());
            int j;
            if(num_children > 1)
            {
                for(j = 0; j < subdiv_elements; j++)
                {
                    printf("%d ", subvals[j]);
                }
            }
            else
            {
                for(j = 0; j < total_elements; j++)
                {
                    printf("%d ", vals[j]);
                }
            }
            printf("to child %d.\n", family);
            close(*(plumbing + 2 * i + 0));//close out read
            close(*(plumbing + 2 * (i + 1) + 1));//close in write
        }
    }
    while ((allpids = wait(&status)) > 0);
    // receive and print the final value
    printf("I am the parent pid %d: receiving partial sum ", getpid());
    for(i = 0; i < num_children * 2; i+= 2)
    {
        int recval;
        read(*(plumbing + 2 * (i + 1) + 0), &recval, sizeof(recval));
        close(*(plumbing + 2 * (i + 1) + 0));
        printf("%d and ", recval);
        fsum += recval;
    }
    
    printf("printing %d.\n", fsum);
    free(vals);
    free(subvals);
    free(plumbing);
    return 0;
}


