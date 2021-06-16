//
//  Lab2A-Self.c
//  
//
//  Created by Grace Tantra on 4/6/21.
//

#include <stdio.h>
#include <math.h>

int32_t Bits2Signed(int8_t bits[8]) { // Convert array of bits to signed int.
    int32_t result = 0;
    
    //carries over below with the *2 multiplier
    if(bits[7] == 1)
        result = -1;
    
    for(int i = 6; i >= 0; i--) {
        result = 2 * result + bits[i];
    }
    return result;
}

uint32_t Bits2Unsigned(int8_t bits[8]) { // Convert array of bits to unsigned int
    uint32_t result = 0;
    for(int i = 7; i >= 0; i--) {
        result = 2 * result + bits[i];
    }
    return result;
}

void Increment(int8_t bits[8]) { // Add 1 to value represented by bit pattern
    //if 1, change to 0, if 0, change to 1 then done
    for(int i = 0; i < 8; i++) {
        if(bits[i] == 0) {
            bits[i] = 1;
            break;
        }
        bits[i] = 0;
    }
}

void Unsigned2Bits(uint32_t n, int8_t bits[8]) { // Opposite of Bits2Unsigned.
    //fills in as many bits starting from index 0
    int i = 0;
    while(n != 0) {
        bits[i] = n % 2;
        n /= 2;
        i++;
    }
    //when runs out (n = 0) fills the rest with 0's
    for(int k = i; k < 8; k++) {
        bits[k] = 0;
    }
}
