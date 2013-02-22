#include <stdio.h>

#define ARRAY_WIDTH 5
#define B_SIZE 1600 
#define ROUNDS 24
#define LANE_BIT_SIZE 64 
#define PERM_WIDTH 25 * LANE_WIDTH 

typedef unsigned long long UINT64;
typedef UINT64 Lane;
Lane inputOne[5][5]= {1, 0, 0, 0, 0,
                        0, 0, 0, 0, 0,
                        0, 0, 0, 0, 0,
                        8000000000000000, 0, 0, 0, 0,
                        0, 0, 0, 0, 0};

/*
Round Constants
*/
UINT64 RC[24];
/*
Rotation Offset 2d Array
*/
Lane rotateArray[25] = {0, 1, 62, 28, 27,
                         36, 44, 6, 55, 20,
                         3, 10, 43, 25, 39,
                         41, 45, 15, 21, 8,
                         18, 2, 61, 56, 14};
//Rotate a  LANE SIZE-bit integer
Lane rotateLeft(Lane lane, int rotateCount)
{
    return (lane << (rotateCount % LANE_BIT_SIZE)) ^ (lane >> (LANE_BIT_SIZE - (rotateCount % LANE_BIT_SIZE))) ; 
}

int getIndex(unsigned int x, unsigned int y)
{
    return (x % 5) + (5 * (y % 5));
}
// Simple loop with an array
void roundFunction (Lane *A)
{
    //Theta step
    unsigned int x,y;
    UINT64 C[ARRAY_WIDTH], D[ARRAY_WIDTH];
    Lane B[ARRAY_WIDTH * ARRAY_WIDTH];
    //xor every lane within a column together
    //repeat this for all columns
    for (x = 0; x < ARRAY_WIDTH; x++)
    {
        C[x] = A[getIndex(x,0)] ^ A[getIndex(x,1)] ^ A[getIndex(x,2)] ^ A[getIndex(x,3)] ^ A[getIndex(x,4)];
    }
	printf("C Value :%d, %d, %d, %d, %d\n", C[0], C[1],C[2],C[3],C[4]);
    for (x = 0; x < ARRAY_WIDTH; x++)
    {
        D[x] = (rotateLeft(C[(x+1) % 5], 1) ^ C[(x+4) % 5]) ;
	    printf("D Value: %d, %d, %d, %d, %d\n", D[0], D[1],D[2],D[3],D[4]);
        printf("x:%d RotVal:%llx, VAR:%llx,other:%llx, D[x]: %llx \n ",x, C[(x+1)%5], rotateLeft(C[(x+1)%5],1),C[(x+4) % ARRAY_WIDTH],C[(x+4) % ARRAY_WIDTH] ^ rotateLeft(C[(x+1) % ARRAY_WIDTH], 1));

	    //printf("C x-1 %d, Rotate Left Value = %d, value being rotated %d\n ", C[(x+4)%ARRAY_WIDTH], rotateLeft(C[(x+1)%ARRAY_WIDTH], 1), C[(x+1) % ARRAY_WIDTH]);
    }
	
    for (x = 0; x < ARRAY_WIDTH; x++)
    {
        for (y = 0; y < ARRAY_WIDTH; y++)
        {
            A[getIndex(x,y)] =  A[getIndex(x,y)] ^ D[x];
        }
    }
    printf("after Theta step\n");
	printf("1st Row: %llx, %llx, %llx, %llx, %llx\n", A[0],A[1],A[2],A[3],A[4]);
    printf("2st Row: %llx, %llx, %llx, %llx, %llx\n", A[5],A[6],A[7],A[8],A[9]);
    printf("3st Row: %llx, %llx, %llx, %llx, %llx\n", A[10],A[11],A[12],A[13],A[14]);
    printf("4st Row: %llx, %llx, %llx, %llx, %llx\n", A[15],A[16],A[17],A[18],A[19]);
    printf("5st Row: %llx, %llx, %llx, %llx, %llx\n", A[20],A[21],A[22],A[23],A[24]);


    //rho and pi steps
    for (x = 0; x < ARRAY_WIDTH; x++)
    {
        for (y = 0; y < ARRAY_WIDTH; y++)
        {
            B[getIndex(y ,(2*x+3*y) % 5)] = rotateLeft(A[getIndex(x,y)], rotateArray[getIndex(x,y)]);
        }
    }
    printf("B after Rho and Pi\n");
	printf("1st Row: %llx, %llx, %llx, %llx, %llx\n", B[0],B[1],B[2],B[3],B[4]);
    printf("2st Row: %llx, %llx, %llx, %llx, %llx\n", B[5],B[6],B[7],B[8],B[9]);
    printf("3st Row: %llx, %llx, %llx, %llx, %llx\n", B[10],B[11],B[12],B[13],B[14]);
    printf("4st Row: %llx, %llx, %llx, %llx, %llx\n", B[15],B[16],B[17],B[18],B[19]);
    printf("5st Row: %llx, %llx, %llx, %llx, %llx\n", B[20],B[21],B[22],B[23],B[24]);


        //chi step
    for (x = 0; x < ARRAY_WIDTH; x++)
    {
        for (y = 0; y < ARRAY_WIDTH; y++)
        {
            A[getIndex(x,y)] = B[getIndex(x,y)] ^ ((~B[getIndex((x+1) % 5,y)]) & B[getIndex((x+2) % 5,y)]);
	        //printf("%d, %d, %d\n",B[getIndex(x,y)], ~B[getIndex((x+1) % 5,y)], B[getIndex((x+2) % 5,y)]);
        }
    }
	printf("after Chi step\n");
	printf("1st Row: %llx, %llx, %llx, %llx, %llx\n", A[0],A[1],A[2],A[3],A[4]);
    printf("2st Row: %llx, %llx, %llx, %llx, %llx\n", A[5],A[6],A[7],A[8],A[9]);
    printf("3st Row: %llx, %llx, %llx, %llx, %llx\n", A[10],A[11],A[12],A[13],A[14]);
    printf("4st Row: %llx, %llx, %llx, %llx, %llx\n", A[15],A[16],A[17],A[18],A[19]);
    printf("5st Row: %llx, %llx, %llx, %llx, %llx\n", A[20],A[21],A[22],A[23],A[24]);


    return;
    
}

int main() {
    //Implemented code on 32bit system so will utilize a lane width of 32
    // b will be 1600   b = 25*w 
    // w = 32
    //number of rounds = 12 + 2 * 5
    //NOTE:Since using integers to represent lanes, certain permuation width sizes MIGHT 
    //     get distorted values. Will have to look into it and refactor if that is the case.
    //Look into using loops for repeated instructions
    int round = 0;
    int result = 0;
    /*Lane A[ARRAY_WIDTH * ARRAY_WIDTH] = {1, 0, 0, 0, 0,
                        0, 0, 0, 0, 0,
                        0, 0, 0, 0, 0,
                        8000000000000000, 0, 0, 0, 0,
                        0, 0, 0, 0, 0};
   */ Lane A[ARRAY_WIDTH * ARRAY_WIDTH] = {0, 0, 0, 0, 0,
                        0, 0, 0, 0, 0,
                        0, 0, 0, 0, 0,
                        0, 0, 0, 0, 0,
                        0, 0, 0, 0, 0};;
    RC[0] = (Lane)0x0000000000000001;
    RC[1] = (Lane)0x0000000000008082;
    RC[2] = (Lane)0x800000000000808A;
    RC[3] = (Lane)0x8000000080008000;
    RC[4] = (Lane)0x000000000000808B;
    RC[5] = (Lane)0x0000000080000001;
    RC[6] = (Lane)0x8000000080008081;
    RC[7] = (Lane)0x8000000000008009;
    RC[8] = (Lane)0x000000000000008A;
    RC[9] = (Lane)0x0000000000000088;
    RC[10] = (Lane)0x0000000080008009;
    RC[11] = (Lane)0x000000008000000A;
    RC[12] = (Lane)0x000000008000808B;
    RC[13] = (Lane)0x800000000000008B;
    RC[14] = (Lane)0x8000000000008089;
    RC[15] = (Lane)0x8000000000008003;
    RC[16] = (Lane)0x8000000000008002;
    RC[17] = (Lane)0x8000000000000080;
    RC[18] = (Lane)0x000000000000800A;
    RC[19] = (Lane)0x800000008000000A;
    RC[20] = (Lane)0x8000000080008081;
    RC[21] = (Lane)0x8000000000008080;
    RC[22] = (Lane)0x0000000080000001;
    RC[23] = (Lane)0x8000000080008008;
    printf("sizeof %d", sizeof(Lane));
    printf("sizeof %d", sizeof(Lane));


    for (round = 0; round < ROUNDS; round++)
    {
        printf("---------------Round %d--------------\n", round);
        roundFunction(A);
        //Iota step
        A[getIndex(0,0)] = A[getIndex(0,0)] ^ RC[round];
        printf("state after completion change:\n");
        printf("1st Row: %llx, %llx, %llx, %llx, %llx\n", A[0],A[1],A[2],A[3],A[4]);
        printf("2st Row: %llx, %llx, %llx, %llx, %llx\n", A[5],A[6],A[7],A[8],A[9]);
        printf("3st Row: %llx, %llx, %llx, %llx, %llx\n", A[10],A[11],A[12],A[13],A[14]);
        printf("4st Row: %llx, %llx, %llx, %llx, %llx\n", A[15],A[16],A[17],A[18],A[19]);
        printf("5st Row: %llx, %llx, %llx, %llx, %llx\n", A[20],A[21],A[22],A[23],A[24]);
    }
    printf("Take output as input and run again.\n");
    for (round = 0; round < ROUNDS; round++)
    {
        printf("---------------Round %d--------------\n", round);
        roundFunction(A);
        //Iota step
        A[getIndex(0,0)] = A[getIndex(0,0)] ^ RC[round];
        printf("state after completion change:\n");
        printf("1st Row: %llx, %llx, %llx, %llx, %llx\n", A[0],A[1],A[2],A[3],A[4]);
        printf("2st Row: %llx, %llx, %llx, %llx, %llx\n", A[5],A[6],A[7],A[8],A[9]);
        printf("3st Row: %llx, %llx, %llx, %llx, %llx\n", A[10],A[11],A[12],A[13],A[14]);
        printf("4st Row: %llx, %llx, %llx, %llx, %llx\n", A[15],A[16],A[17],A[18],A[19]);
        printf("5st Row: %llx, %llx, %llx, %llx, %llx\n", A[20],A[21],A[22],A[23],A[24]);
    }

    printf("Done!\n");
    return result;
}
