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


int hanoi(int n, int source, int target);
void pMove(int source, int target);

int main()
{
	hanoi(N, 1, N);
	return 0;
}

int hanoi(int n, int source, int target){
	if(n == 1){		//base case
		pMove(source, target);
	}else{
		int auxiliary = 6 - (source + target);
		hanoi(n-1, source, target);
		pMove(source, target);
		hanoi(auxiliary, target);
	}
}

void pMove(int source, int target){
	printf("%d -> %d", source, target);
}