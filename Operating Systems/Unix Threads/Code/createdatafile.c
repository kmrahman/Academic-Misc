#include <stdio.h>
#include <stdlib.h>


int main() 
{
	int count;
	double X;
	
	FILE * dataFile= fopen("data.txt", "w");
	

	if(dataFile != 0)
	{	
		srand((unsigned)time(NULL));
		for (count = 0; count < 1000000; count ++) 
		{
			X = drand48();
			fprintf(dataFile, "%lf ", X);
		}	
	}
	fclose(dataFile);
	return 0;
}
