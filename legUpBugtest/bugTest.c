/****************
    This file contains the implementation of the SHA-3 (Keccak) Hashing Algorithm
    using the LegUp Framework.

    The SHA-3 round functions used in this source file and an explanation
    of the algorithm can be found at http://keccak.noekeon.org/.
*****************/

unsigned long long rotateLeft(unsigned long long lane, int rotateCount)
{
    return (lane << (rotateCount % 64)) ^ (lane >> (64 - (rotateCount % 64))) ; 
}



#include <stdio.h>
int main() 
{
    unsigned long long test64Bit = 1;
    unsigned long test32Bit = 1;
    unsigned short test16Bit = 1;
    unsigned long long new64Bit = 1;
    unsigned long new32Bit = 1;
    unsigned short new16Bit = 1;
    unsigned long long _64Minus0Mod64 = (64 - (0 % 64));
    unsigned short _16Minus0Mod16 = (16 - (0 % 16));
    printf("Verify unsign long long size = %u, unsigned long size = %d, unsigned short size = %d\n", sizeof(unsigned long long), sizeof(unsigned long), sizeof(unsigned short));
    
    //solved using literal equation
    printf("=====Shift Right by bit size\n");
    new64Bit = test64Bit >> 64;
    printf("Unsigned long long value %llu >> 64 = %llu\n",test64Bit,  new64Bit);
    new16Bit = test16Bit >> 16;
    printf("Unsigned short value %u >> 16 = %u\n",test16Bit, new16Bit);
    new32Bit = test32Bit >> 32;
    printf("Unsigned long value %lu >> 32 = %lu\n",test32Bit,  new32Bit);
    printf("=====Shift Right by 1/2 bit size\n");
    new64Bit = test64Bit >> 32;
    printf("Unsigned long long value %llu >> 32 = %llu\n",test64Bit,  new64Bit);
    new16Bit = test16Bit >> 8;
    printf("Unsigned short value %u >> 8 = %u\n",test16Bit, new16Bit);
    new32Bit = test32Bit >> 16;
    printf("Unsigned long value %lu >> 16 = %lu\n",test32Bit,  new32Bit);
    printf("=====Shift Right by 2x bit size\n");
    new64Bit = test64Bit >> 128;
    printf("Unsigned long long value %llu >> 128 = %llu\n",test64Bit,  new64Bit);
    new16Bit = test16Bit >> 32;
    printf("Unsigned short value %u >> 32 = %u\n",test16Bit, new16Bit);
    new32Bit = test32Bit >> 64;
    printf("Unsigned long value %lu >> 64 = %lu\n",test32Bit,  new32Bit);
    printf("=====Shift Right by bit size with different value\n");
    test64Bit = 1337;
    test32Bit = 1337;
    test16Bit = 1337;
    new64Bit = test64Bit >> 64;
    printf("Unsigned long long value %llu >> 64 = %llu\n",test64Bit,  new64Bit);
    new16Bit = test16Bit >> 16;
    printf("Unsigned short value %u >> 16 = %u\n",test16Bit, new16Bit);
    new32Bit = test32Bit >> 32;
    printf("Unsigned long value %lu >> 32 = %lu\n",test32Bit,  new32Bit);










    
   // while (counter <= 64)
   // {
   //     printf("UNSIGNED LONG LONG: %llu >> %d = %llu\n", test64Bit, counter, test64Bit >> counter );
      //  printf("UNSIGNED SHORT: %u >> %d = %u\n", test16Bit, counter, test16Bit >> counter );
     //   counter++;
   // }

    return 0;
}
