#include <stdio.h>

#define ARRAY_WIDTH 5
#define ROUNDS 22 
#define LANE_WIDTH 32
#define PERM_WIDTH 25 * LANE_WIDTH 

//Rotate a 32bit integer
int rotateLeft(int lane, int rotateCount)
{
    return (lane << rotateCount) | (lane >> (LANE_WIDTH - rotateCount));
}
// Simple loop with an array
void roundFunction (int A[ARRAY_WIDTH][ARRAY_WIDTH])
{
    //Theta step
    int C[ARRAY_WIDTH], D[ARRAY_WIDTH];
    //xor every lane within a column together
    //repeat this for all columns
    for (int x = 0; x < ARRAY_WIDTH; x++)
    {
        C[x] = A[x][0] ^ A[x][1] ^ A[x][2] ^ A[x][3] ^ A[x][4];
    }
    for (int x = 0; x < ARRAY_WIDTH; x++)
    {
        D[x] = C[(x-1) % ARRAY_WIDTH] ^ rotateLeft(C[(x+1) % ARRAY_WIDTH], 1);
    }
    for (int x = 0; x < ARRAY_WIDTH; x++)
    {
        for (int y = 0; y < ARRAY_WIDTH; y++)
        {
            A[x][y] =  A[x][y] ^ D[x];
        }
    }
    
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
    int A[ARRAY_WIDTH][ARRAY_WIDTH], B[ARRAY_WIDTH][ARRAY_WIDTH];
    A[0][0] = 1;
    A[0][1] = 2;
    A[0][2] = 3;
    A[0][3] = 4;
    A[0][4] = 5;
    A[1][0] = 2;
    A[1][1] = 3;
    A[1][2] = 4;
    A[1][3] = 5;
    A[1][4] = 6;
    A[2][0] = 2;
    A[2][1] = 4;
    A[2][2] = 6;
    A[2][3] = 7;
    A[2][4] = 8;
    A[3][4] = 1;
    A[4][2] = 1;
    //loop: for (int round = 0; round <1; round++)
    for (int round = 0; round < ROUNDS; round++)
    {
        roundFunction(A);
        printf("%x, %x, %x, %x, %x\n", A[0][0], A[0][1],A[0][2],A[0][3],A[0][4]);
        printf("%x, %x, %x, %x, %x\n", A[1][0], A[1][1],A[1][2],A[1][3],A[1][4]);
        printf("%x, %x, %x, %x, %x\n", A[2][0], A[2][1],A[2][2],A[2][3],A[2][4]);
        printf("%x, %x, %x, %x, %x\n", A[3][0], A[3][1],A[3][2],A[3][3],A[3][4]);
        printf("%x, %x, %x, %x, %x\n", A[4][0], A[4][1],A[4][2],A[4][3],A[4][4]);
    }
    printf("Done!\n");
    return result;
}
