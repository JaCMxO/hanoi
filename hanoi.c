/**
 * @file hanoi.c
 * 
 * @brief Hanoi towers solution algorithm
 * 
 * @author Jaime Camacho
 * Contact: jaime.albertogdl@gmail.com
 * 
 **/

#include <stdio.h>

#define N 3

int A[N] = {3, 2, 1};
int B[N] = {0};
int C[N] = {0};


int hanoi(int n, int source, int target, int aux);

int main()
{
	hanoi(N, 1, 3, 2);
	return 0;
}

int hanoi(int n, int source, int target, int aux){
	int auxiliary;
	if(n == 1){		//base case
		printf("%d -> %d\n", source, target);
	}else{
		hanoi(n-1, source, aux, target);
		printf("%d -> %d\n", source, target);
		hanoi(n-1, aux, target, source);
	}
}
