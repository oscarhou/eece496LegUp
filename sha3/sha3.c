#include <stdio.h>

#define ARRAY_WIDTH 5
#define LANE_WIDTH 4
#define PERM_WIDTH 25 * LANE_WIDTH 
// Simple loop with an array
int roundFunction (int **A)
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
        D[x] = C[(x-1) % ARRAY_WIDTH];
    }
    return 0;
    
}
int main() {
    //NOTE:Since using integers to represent lanes, certain permuation width sizes MIGHT 
    //     get distorted values. Will have to look into it and refactor if that is the case.
    //Look into using loops for repeated instructions
    int result = 0;
    //loop: for (int round = 0; round <1; round++)
    for (int round = 0; round <1; round++)
    {
    }
    int A[ARRAY_WIDTH][ARRAY_WIDTH], B[ARRAY_WIDTH][ARRAY_WIDTH];
    printf("Done!\n");
    return result;
}
