/****************
    This file contains the implementation of the SHA-3 (Keccak) Hashing Algorithm
    using the LegUp Framework.

    The SHA-3 round functions used in this source file and an explanation
    of the algorithm can be found at http://keccak.noekeon.org/.
*****************/

#include <stdio.h>

#define ARRAY_WIDTH 5
#define B_SIZE 400 
#define ROUNDS 20
#define LANE_BIT_SIZE 16
#define PERM_WIDTH 25 * LANE_WIDTH 

typedef unsigned short Lane;
Lane inputOne[5][5]= {1, 0, 0, 0, 0,
                      0, 0, 0, 0, 0,
                      0, 0, 0, 0, 0,
                      0, 0, 0, 0, 0,
                      0, 0, 0, 0, 0};
/*
Round Constants
*/
unsigned short RC[24];
/*
Rotation Offset 2d Array
*/
Lane rotateArray[ARRAY_WIDTH][ARRAY_WIDTH] = {0, 1, 62, 28, 27,
                         36, 44, 6, 55, 20,
                         3, 10, 43, 25, 39,
                         41, 45, 15, 21, 8,
                         18, 2, 61, 56, 14}; 
//Rotate a  LANE SIZE-bit integer to the left
Lane rotateLeft(Lane lane, int rotateCount)
{
    int rotate = rotateCount % LANE_BIT_SIZE;
    return ((Lane)lane << rotate) | ((Lane)lane >> (LANE_BIT_SIZE - rotate)) ; 
}

// Simple loop with an array
void roundFunction (Lane A[][ARRAY_WIDTH])
{
    //Theta step
    unsigned int x,y;
    Lane C[ARRAY_WIDTH], D[ARRAY_WIDTH];
    Lane B[ARRAY_WIDTH][ARRAY_WIDTH];
    //xor every lane within a column together

    //repeat this for all columns
    for (x = 0; x < ARRAY_WIDTH; x++)
    {
        C[x] = A[0][x] ^ A[1][x] ^ A[2][x] ^ A[3][x] ^ A[4][x];
    }

	printf("C Value  After theta :%d, %d, %d, %d, %d\n", C[0], C[1],C[2],C[3],C[4]);
    for (x = 0; x < ARRAY_WIDTH; x++)
    {
        D[x] = (rotateLeft(C[(x+1) % 5], 1) ^ C[(x+4) % 5]) ;
    }
	printf("D Value: %d, %d, %d, %d, %d\n", D[0], D[1],D[2],D[3],D[4]);
	
    for (x = 0; x < ARRAY_WIDTH; x++)
    {
        for (y = 0; y < ARRAY_WIDTH; y++)
        {
            A[y][x] =  A[y][x] ^ D[x];
        }
    }
    printf("State After Theta Step: \n");
	printf("1st Row: %d, %d, %d, %d, %d\n", A[0][0],A[0][1],A[0][2],A[0][3],A[0][4]);
    printf("2st Row: %d, %d, %d, %d, %d\n", A[1][0],A[1][1],A[1][2],A[1][3],A[1][4]);
    printf("3st Row: %d, %d, %d, %d, %d\n", A[2][0],A[2][1],A[2][2],A[2][3],A[2][4]);
    printf("4st Row: %d, %d, %d, %d, %d\n", A[3][0],A[3][1],A[3][2],A[3][3],A[3][4]);
    printf("5st Row: %d, %d, %d, %d, %d\n", A[4][0],A[4][1],A[4][2],A[4][3],A[4][4]);

    //rho and pi steps
    for (x = 0; x < ARRAY_WIDTH; x++)
    {
        for (y = 0; y < ARRAY_WIDTH; y++)
        {
            B[(2*x+3*y) % 5][y]= rotateLeft(A[y][x], rotateArray[y][x]);
        }
    }
    printf("Temporary State (B) after Rho and Pi:\n");
    printf("1st Row: %d, %d, %d, %d, %d\n", B[0][0],B[0][1],B[0][2],B[0][3],B[0][4]);
    printf("2st Row: %d, %d, %d, %d, %d\n", B[1][0],B[1][1],B[1][2],B[1][3],B[1][4]);
    printf("3st Row: %d, %d, %d, %d, %d\n", B[2][0],B[2][1],B[2][2],B[2][3],B[2][4]);
    printf("4st Row: %d, %d, %d, %d, %d\n", B[3][0],B[3][1],B[3][2],B[3][3],B[3][4]);
    printf("5st Row: %d, %d, %d, %d, %d\n", B[4][0],B[4][1],B[4][2],B[4][3],B[4][4]);


    //chi step
    for (x = 0; x < ARRAY_WIDTH; x++)
    {
        for (y = 0; y < ARRAY_WIDTH; y++)
        {
            A[y][x] = B[y][x] ^ ((~B[y][(x+1) % 5]) & B[y][(x+2) % 5]);
        }
    }
	printf("State after Chi step:\n");
	printf("1st Row: %d, %d, %d, %d, %d\n", A[0][0],A[0][1],A[0][2],A[0][3],A[0][4]);
    printf("2st Row: %d, %d, %d, %d, %d\n", A[1][0],A[1][1],A[1][2],A[1][3],A[1][4]);
    printf("3st Row: %d, %d, %d, %d, %d\n", A[2][0],A[2][1],A[2][2],A[2][3],A[2][4]);
    printf("4st Row: %d, %d, %d, %d, %d\n", A[3][0],A[3][1],A[3][2],A[3][3],A[3][4]);
    printf("5st Row: %d, %d, %d, %d, %d\n", A[4][0],A[4][1],A[4][2],A[4][3],A[4][4]);


    return;
    
}

int main() {
    int round = 0;
    int result = 0;
 /*   Lane A[ARRAY_WIDTH * ARRAY_WIDTH] = {1, 0, 0, 0, 0,
                        0, 0, 0, 0, 0,
                        0, 0, 0, 0, 0,
                        8000000000000000, 0, 0, 0, 0,
                        0, 0, 0, 0, 0};;*/
    Lane A[ARRAY_WIDTH][ARRAY_WIDTH] = {460, 0, 0, 0, 0,
                        0, 0, 32768, 0, 0,
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


    for (round = 0; round < ROUNDS; round++)
    {
        printf("---------------Round %d--------------\n", round);
        roundFunction(A);
        //Iota step
        A[0][0] = A[0][0] ^ RC[round];
        printf("Final state of round : \n");
        printf("1st Row: %d, %d, %d, %d, %d\n", A[0][0],A[0][1],A[0][2],A[0][3],A[0][4]);
        printf("2st Row: %d, %d, %d, %d, %d\n", A[1][0],A[1][1],A[1][2],A[1][3],A[1][4]);
        printf("3st Row: %d, %d, %d, %d, %d\n", A[2][0],A[2][1],A[2][2],A[2][3],A[2][4]);
        printf("4st Row: %d, %d, %d, %d, %d\n", A[3][0],A[3][1],A[3][2],A[3][3],A[3][4]);
        printf("5st Row: %d, %d, %d, %d, %d\n", A[4][0],A[4][1],A[4][2],A[4][3],A[4][4]);
    }
    printf("Done!\n");
    return result;
}
