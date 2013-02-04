#include <stdio.h>

#define ARRAY_WIDTH 5
#define LANE_WIDTH 4
#define PERM_WIDTH 25 * LANE_WIDTH 
// Simple loop with an array
int roundFunction (int **A)
{
    int C[ARRAY_WIDTH], D[ARRAY_WIDTH];
    for (int count = 0; count < ARRAY_WIDTH; count++)
    {
        C[count] = A[count][0] ^ A[count][1] ^ A[count][2] ^ A[count][3] ^ A[count][4];
    }
    for (int count = 0; count < ARRAY_WIDTH; count++)
    {
        C[count] = A[count][0] ^ A[count][1] ^ A[count][2] ^ A[count][3] ^ A[count][4];
    }
    return 0;
    
}
int main() {
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
