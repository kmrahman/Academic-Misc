//K. M. Sabidur Rahman @01343723 Email: wmr727@my.utsa.edu

#include <stdio.h>
#include <stdlib.h>



//finds minimum
double minimum(double a, double b) {
	if(a>b)
	 return b;
	else
	 return a;
}


double resolution()
{
	struct timeval t1, t2, t3, t4, t5;
	double tConvert1, tConvert2, tConvert3, tConvert4, tConvert5;
	
	gettimeofday(&t1, NULL); 	
	gettimeofday(&t2, NULL); 
	gettimeofday(&t3, NULL); 
	gettimeofday(&t4, NULL);
	gettimeofday(&t5, NULL); 

    	tConvert1 = (double)t1.tv_sec * 1000000 + (double)t1.tv_usec;
    	tConvert2 = (double)t2.tv_sec * 1000000 + (double)t2.tv_usec;
    	tConvert3 = (double)t3.tv_sec * 1000000 + (double)t3.tv_usec;
    	tConvert4 = (double)t4.tv_sec * 1000000 + (double)t4.tv_usec;
	tConvert5 = (double)t5.tv_sec * 1000000 + (double)t5.tv_usec;
    
     	return minimum(minimum(minimum(tConvert2 - tConvert1, tConvert3 - tConvert2), tConvert4 - tConvert3), tConvert5- tConvert4);
}



int main()
{
	
	printf("Resolution of the timer: %lf Microseconds\n",	resolution());

	
	return 0;
}

