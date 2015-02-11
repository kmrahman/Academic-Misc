//K. M. Sabidur Rahman @01343723 Email: wmr727@my.utsa.edu

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/sem.h>
//#include <sys/types.h>
#include <pthread.h>

double *sharedMemory;		
int sharedMemorySize;		
int semaphore_global;			

//http://www.kernel.org/doc/man-pages/online/pages/man2/semop.2.html
//http://art.cwru.edu/338.S12/example.semaphore.html

void semSignal(int semaphore)
{
                 struct sembuf vsembuf;
                 vsembuf.sem_op = 1;
                 vsembuf.sem_flg = 0;
                 vsembuf.sem_num = semaphore;
                 semop(semaphore_global,&vsembuf,1);
                 return;
} 

void semWait(int semaphore)
{
                     struct sembuf psembuf;
                     psembuf.sem_op = -1;
                     psembuf.sem_flg = 0;
                     psembuf.sem_num = semaphore;
                     semop(semaphore_global,&psembuf,1);
                     return;
}


void* child (void *p)
{
	int i, j;

	while (1) 
	{
		semWait(0);			
	
		// modify data
		for (i = 0; i < sharedMemorySize; i++)
		{
			for (j = 0; j < 1000; j++) 
			{
				sharedMemory[i]++;
				sharedMemory[i]--;
			}
		}

		semSignal(1);		
	}
}

int main() 
{
	FILE *dataFile, *outputFile;		// file pointers
	struct timeval startT, endT;	// time 
	int sharedMemID;// shared memory id
	pthread_t thread1,thread2,thread3,thread4,thread5;					
	//key_t key = 5678;
	
	// differe1nt batch sizes
	int shmSize[8] = {1, 10, 100, 500, 1000, 2000, 5000, 10000};
	

	// http://publib.boulder.ibm.com/infocenter/iseries/v5r3/index.jsp?topic=%2Fapis%2Fapiexusmem.htm

	//for  semaphore
	//http://cboard.cprogramming.com/c-programming/135151-putting-struct-into-shared-memory.html	
	if ((semaphore_global = semget((key_t)5678, 2, IPC_CREAT | 0666)) < 0) 
	{
		perror("semget");
		exit(-1);
	}
	

	printf("Shared Memory Size \tProcessing time (ms)\n");

	int i;
	// loop over all batch sizes and calculate execution time
	for (i = 0; i < 8; i++) 
	{
		sharedMemorySize = shmSize[i];
	
		// for shared mem
		if ((sharedMemID = shmget((key_t)5678, sizeof(double) * sharedMemorySize, IPC_CREAT|0666)) < 0) 
		{
			perror("shmget");
			exit(-1);
		}
	
		// attach http://www.lainoox.com/tag/shmat-example/

		if ((sharedMemory = shmat(sharedMemID, NULL, 0)) < 0) 
		{
			perror("shmat");
			exit(-1);
		}

		// semaphore init
		semctl(semaphore_global, 0, SETVAL, 0);	//  input
		semctl(semaphore_global, 1, SETVAL, 0);	//  output

		gettimeofday(&startT, NULL);		// data manipulation starts here
	
		//int cid = fork();				// create the child process
		// child thread
		int cthread = pthread_create(&thread1, NULL, child, (void *)0);
	
		if (cthread) 
		{
			printf("ERROR; return code from pthread_create() is %d\n", cthread);
			exit(-1);
		}
		cthread = pthread_create(&thread2, NULL, child, (void *)0);
	
		if (cthread) 
		{
			printf("ERROR; return code from pthread_create() is %d\n", cthread);
			exit(-1);
		}

		cthread = pthread_create(&thread3, NULL, child, (void *)0);
	
		if (cthread) 
		{
			printf("ERROR; return code from pthread_create() is %d\n", cthread);
			exit(-1);
		}
		cthread = pthread_create(&thread4, NULL, child, (void *)0);
	
		if (cthread) 
		{
			printf("ERROR; return code from pthread_create() is %d\n", cthread);
			exit(-1);
		}

		cthread = pthread_create(&thread5, NULL, child, (void *)0);
	
		if (cthread) 
		{
			printf("ERROR; return code from pthread_create() is %d\n", cthread);
			exit(-1);
		}

		// open input and output file
			dataFile = fopen("data.txt", "r");
			outputFile = fopen("output.txt", "w");
		 
			int pointer = 0;
	
			while (fscanf(dataFile, "%lf", &sharedMemory[pointer]) != EOF) 
			{
			
				// parent process reads data from the file
				for (pointer = 1; pointer < sharedMemorySize; pointer++) 
				{
					fscanf(dataFile, "%lf", &sharedMemory[pointer]);
				}
		
				semSignal(0);		// signal the semaphore input
				semWait(1);			// wait on semaphore output
		
				// parent process writing modified data
				for (pointer = 0; pointer < sharedMemorySize; pointer++) 
				{
					fprintf(outputFile, "%lf ", sharedMemory[pointer]);	
				}

				pointer = 0;
			}
	
			//kill(cid, SIGKILL);		// kill the child process
			pthread_cancel(thread1);
			pthread_cancel(thread2);
			pthread_cancel(thread3);
			pthread_cancel(thread4);
			pthread_cancel(thread5);

			// deallocate
			//http://www.cs.cf.ac.uk/Dave/C/node27.html
			shmctl(sharedMemID, IPC_RMID, (struct shmid_ds *)sharedMemory);
			
			
			fclose(dataFile);
			fclose(outputFile);
	
			gettimeofday(&endT, NULL);	// data manipulation ends here
		
			// calculation of the processing time
			double startTime = (double)startT.tv_sec * 1000000 + (double)startT.tv_usec;
			double endTime = (double)endT.tv_sec * 1000000 + (double)endT.tv_usec;

			printf("%d\t\t%lf\n", sharedMemorySize, (endTime - startTime) / 1000);
		

	}
	
	// Delete the semaphores
	semctl(semaphore_global, 0, IPC_RMID, 0);
	semctl(semaphore_global, 1, IPC_RMID, 0);


	return 0;
}



	
		
		
	
