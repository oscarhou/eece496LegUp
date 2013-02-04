#include <stdio.h>

#define ARRAY_WIDTH 5
#define LANE_WIDTH 4
#define PERM_WIDTH 25 * LANE_WIDTH 
// Simple loop with an array
int roundFunction ()
{
    int C[ARRAY_WIDTH], D[ARRAY_WIDTH];
    loop: for (int count = 0; count < ARRAY_WIDTH; count++)
    {
        C[count] = A[count][0] ^ A[count][1] ^ A[count][2] ^ A[count][3] ^ A[count][4];
    }
    loop: for (int count = 0; count < ARRAY_WIDTH; count++)
    {
        C[count] = A[count][0] ^ A[count][1] ^ A[count][2] ^ A[count][3] ^ A[count][4];
    }
    
}
int main() {
    loop: for (int round = 0; round <1)
    {
    }
    int A[ARRAY_WIDTH][ARRAY_WIDTH], B[ARRAY_WIDTH][ARRAY_WIDTH];
    printf("Done!\n");
    return sum;
}
