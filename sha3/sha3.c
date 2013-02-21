#include <stdio.h>

#define ARRAY_WIDTH 5
#define B_SIZE 800
#define ROUNDS 22 
#define LANE_BIT_SIZE 32
#define PERM_WIDTH 25 * LANE_WIDTH 

/*
Round Constants
*/
unsigned int RC[24];
/*
Rotation Offset 2d Array
*/
unsigned int rotateArray[5][5] = {0, 1, 62, 28, 27,
                         36, 44, 6, 55, 20,
                         3, 10, 43, 25, 39,
                         41, 45, 15, 21, 8,
                         18, 2, 61, 56, 14};
//Rotate a  LANE SIZE-bit integer
unsigned int rotateLeft(long lane, int rotateCount)
{
    return (lane << (rotateCount % LANE_BIT_SIZE)) ^ (lane >> (LANE_BIT_SIZE - (rotateCount % LANE_BIT_SIZE))) ;
}
// Simple loop with an array
void roundFunction (unsigned int A[ARRAY_WIDTH][ARRAY_WIDTH])
{
    //Theta step
    unsigned int C[ARRAY_WIDTH], D[ARRAY_WIDTH];
    unsigned int B[5][5];
    //xor every lane within a column together
    //repeat this for all columns
    for (int x = 0; x < ARRAY_WIDTH; x++)
    {
        C[x] = A[x][0] ^ A[x][1] ^ A[x][2] ^ A[x][3] ^ A[x][4];
    }
	printf("%d, %d, %d, %d, %d\n", C[0], C[1],C[2],C[3],C[4]);
    for (int x = 0; x < ARRAY_WIDTH; x++)
    {
        D[x] = C[(x+4) % ARRAY_WIDTH] ^ rotateLeft(C[(x+1) % ARRAY_WIDTH], 1);
	printf("C x-1 %d, Rotate Left Value = %d, value being rotated %d\n ", C[(x+4)%ARRAY_WIDTH], rotateLeft(C[(x+1)%ARRAY_WIDTH], 1), C[(x+1) % ARRAY_WIDTH]);
    }
	printf("%d, %d, %d, %d, %d\n", D[0], D[1],D[2],D[3],D[4]);
	
    for (int x = 0; x < ARRAY_WIDTH; x++)
    {
        for (int y = 0; y < ARRAY_WIDTH; y++)
        {
            A[x][y] =  A[x][y] ^ D[x];
        }
    }

    //rho and pi steps
    for (int x = 0; x < ARRAY_WIDTH; x++)
    {
        for (int y = 0; y < ARRAY_WIDTH; y++)
        {
            B[y][ (2*x+3*y) % 5] = rotateLeft(A[x][y], rotateArray[y][x]);
        }
    }
        //chi step
    for (int x = 0; x < ARRAY_WIDTH; x++)
    {
        for (int y = 0; y < ARRAY_WIDTH; y++)
        {
            A[x][y] = B[x][y] ^ ((~B[(x+1) % 5][y]) & B[(x+2) % 5][y]);
	    printf("%d, %d, %d\n",B[x][y], ~B[(x+1) % 5][y], B[(x+2) % 5][y]);
        }
    }
	printf("after Chi step\n");
	printf("%d, %d, %d, %d, %d\n", A[0][0], A[0][1],A[0][2],A[0][3],A[0][4]);
        printf("%d, %d, %d, %d, %d\n", A[1][0], A[1][1],A[1][2],A[1][3],A[1][4]);
        printf("%d, %d, %d, %d, %d\n", A[2][0], A[2][1],A[2][2],A[2][3],A[2][4]);
        printf("%d, %d, %d, %d, %d\n", A[3][0], A[3][1],A[3][2],A[3][3],A[3][4]);
        printf("%d, %d, %d, %d, %d\n", A[4][0], A[4][1],A[4][2],A[4][3],A[4][4]);


    return;
    
}

int main() {
    //Implemented code on 32bit system so will utilize a lane width of 32
    // b will be 800   b = 25*w 
    // w = 32
    //number of rounds = 12 + 2 * 5
    //NOTE:Since using integers to represent lanes, certain permuation width sizes MIGHT 
    //     get distorted values. Will have to look into it and refactor if that is the case.
    //Look into using loops for repeated instructions
    int result = 0;
    unsigned int A[ARRAY_WIDTH][ARRAY_WIDTH], B[ARRAY_WIDTH][ARRAY_WIDTH];
    A[0][0] = 0;
    A[0][1] = 0;
    A[0][2] = 0;
    A[0][3] = 0;
    A[0][4] = 0;
    A[1][0] = 0;
    A[1][1] = 0;
    A[1][2] = 0;
    A[1][3] = 0;
    A[1][4] = 0;
    A[2][0] = 0;
    A[2][1] = 0;
    A[2][2] = 0;
    A[2][3] = 0;
    A[2][4] = 0;
    A[3][4] = 0;
    A[4][2] = 0;
    RC[0] = (unsigned int)0x0000000000000001;
    RC[1] = (unsigned int)0x0000000000008082;
    RC[2] = (unsigned int)0x800000000000808A;
    RC[3] = (unsigned int)0x8000000080008000;
    RC[4] = (unsigned int)0x000000000000808B;
    RC[5] = (unsigned int)0x0000000080000001;
    RC[6] = (unsigned int)0x8000000080008081;
    RC[7] = (unsigned int)0x8000000000008009;
    RC[8] = (unsigned int)0x000000000000008A;
    RC[9] = (unsigned int)0x0000000000000088;
    RC[10] = (unsigned int)0x0000000080008009;
    RC[11] = (unsigned int)0x000000008000000A;
    RC[12] = (unsigned int)0x000000008000808B;
    RC[13] = (unsigned int)0x800000000000008B;
    RC[14] = (unsigned int)0x8000000000008089;
    RC[15] = (unsigned int)0x8000000000008003;
    RC[16] = (unsigned int)0x8000000000008002;
    RC[17] = (unsigned int)0x8000000000000080;
    RC[18] = (unsigned int)0x000000000000800A;
    RC[19] = (unsigned int)0x800000008000000A;
    RC[20] = (unsigned int)0x8000000080008081;
    RC[21] = (unsigned int)0x8000000000008080;
    RC[22] = (unsigned int)0x0000000080000001;
    RC[23] = (unsigned int)0x8000000080008008;
    printf("sizeof %d", sizeof(unsigned int));
    printf("sizeof %d", sizeof(long));


    loop: for (int round = 0; round < ROUNDS; round++)
    {
        roundFunction(A);
        //Iota step
        A[0][0] = A[0][0] ^ RC[round];
	printf("A result = %x, RC = %x\n",A[0][0], RC[round]);
        printf("%x, %x, %x, %x, %x\n", A[0][0], A[0][1],A[0][2],A[0][3],A[0][4]);
        printf("%x, %x, %x, %x, %x\n", A[1][0], A[1][1],A[1][2],A[1][3],A[1][4]);
        printf("%x, %x, %x, %x, %x\n", A[2][0], A[2][1],A[2][2],A[2][3],A[2][4]);
        printf("%x, %x, %x, %x, %x\n", A[3][0], A[3][1],A[3][2],A[3][3],A[3][4]);
        printf("%x, %x, %x, %x, %x\n", A[4][0], A[4][1],A[4][2],A[4][3],A[4][4]);
    }
    printf("Done!\n");
    return result;
}
