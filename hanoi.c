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

int count=0;

int hanoi(int n, int source, int target, int aux);
void pMoves(int source, int target);

int main()
{
	int n;
	printf("Enter the number of disks: ");
	scanf("%d", &n);
	hanoi(n, 1, 3, 2);
	printf("Number of moves: %d\n", count);
	return 0;
}

int hanoi(int n, int source, int target, int aux){
	if(n == 1){		//base case
		pMoves(source, target);
	}else{
		hanoi(n-1, source, aux, target);
		pMoves(source, target);
		hanoi(n-1, aux, target, source);
	}
}

void pMoves(int source, int target){
	printf("%d -> %d\n", source, target);
	count++;
}