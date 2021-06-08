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
#include <stdlib.h>

int count=0;

void hanoi(int n, int source, int target, int aux, int *A, int *B, int *C, int discs);
void pMoves(int source, int target, int *A, int *B, int *C, int discs);
void viewMem(int *A, int *B, int *C, int discs);
void initHanoi(int *A, int *B, int *C, int discs);
void move(int source, int target, int *A, int *B, int *C, int discs);

int main(int argc, char *argv[])
{
	int n;
	if(argc != 2){
		printf("The number of command arguments is incorrect. Enter a number > 0\n");
	}else{
		n = atoi(argv[1]);
	}

	//Memoria donde van a suceder los cambios
	int *A = (int*)calloc(n, sizeof(int));
	int *B = (int*)calloc(n, sizeof(int));
	int *C = (int*)calloc(n, sizeof(int));
	initHanoi(A, B, C, n);
	hanoi(n, 1, 3, 2, A, B, C, n);
	viewMem(A, B, C, n);
	printf("Total moves: %d\n", count);
	return 0;
}

void hanoi(int n, int source, int target, int aux, int *A, int *B, int *C, int discs){
	if(n == 1){		//base case
		pMoves(source, target, A, B, C, discs);
	}else{
		hanoi(n-1, source, aux, target, A, B, C, discs);
		pMoves(source, target, A, B, C, discs);
		hanoi(n-1, aux, target, source, A, B, C, discs);
	}
}

void pMoves(int source, int target, int *A, int *B, int *C, int discs){
	viewMem(A, B, C, discs);
	printf("%c -> %c\n", source + 64, target + 64);
	move(source, target, A, B, C, discs);
	count++;
}

//initialize tower of Hanoi
void initHanoi(int *A, int *B, int *C, int discs){
	for(int i=0; i<discs; i++){
		A[i] = i + 1;
	}
}

//display current memory data
void viewMem(int *A, int *B, int *C, int discs){
	for(int i=0; i<discs; i++){
		printf("%d\t\t%d\t\t%d\n", A[i], B[i], C[i]);
	}
}

void move(int source, int target, int *A, int *B, int *C, int discs){
	int *ori, *dest, aux;
	if(source == 1){
		ori = A;
	}else if(source == 2){
		ori = B;
	}else if(source == 3){
		ori = C;
	}
	if(target == 1){
		dest = A;
	}else if(target == 2){
		dest = B;
	}else if(target == 3){
		dest = C;
	}
	for(int i=0; i<discs; i++){
		if(ori[i] != 0){
			aux = ori[i];
			ori[i] = 0;
			for(int j=1; j<=discs; j++){
				if(dest[discs-j] == 0){
					dest[discs-j] = aux;
					break;
				}
			}
			break;
		}
	}
}