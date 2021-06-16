//Grace Tantra
//COEN20 Lab 11E
//June 1, 2021

    .syntax unified
    .cpu    cortex-m4
    .text

// ----------------------------------------------------------
// Q16 __attribute__((weak)) Q16GoodRoot(Q16 radicand) {
//    uint32_t residue, sqroot, bit ;
//    // set 'bit' to highest bit position less than radicand
//    bit = (1 << 30) >> (__CLZ(radicand) & ~1) ;
//    residue = (uint32_t) radicand ;     // residue will be the 'remainder'
//    sqroot  = 0 ;                       // sqroot will be integer square root
//    while (bit != 0) {
//        uint32_t temp ;
//        temp = sqroot + bit ;           // Compute once, use twice
//        if (residue >= temp)            // Room to subtract?
//            {
//            residue -= temp ;           // Yes - deduct from residue
//            sqroot += (bit << 1) ;      // and step sqroot
//            }
//
//        sqroot >>= 1 ;                  // Slide evolving sqroot 1 bit down the residue
//        bit >>= 2 ;                     // Slide the bitpick 1 bit down the sqroot
//        }
//
//    return (Q16) (sqroot << 8) ;        // scale result for Q16 format
//    }
// ----------------------------------------------------------

// R0 = residue, R1 = bit, R2 = sqroot, R3 = temp

    .global Q16GoodRoot
    .thumb_func
    .align
Q16GoodRoot:
    CLZ     R1,R0           // R1 = CLZ(radicand)
    BIC     R2,R1,1         // R2 = R1 & ~1
    LDR     R1,=1           // R1 = 1
    LSL     R1,R1,30        // R1 = 1 << 30
    LSR     R1,R1,R2        // R1 = R1 >> R2        <-- bit
    LDR     R2,=0           // R2 = 0               <-- sqroot
L:  CMP     R1,0            // while(bit != 0)
    BEQ     D
    ADD     R3,R2,R1        // temp = sqroot + bit
    CMP     R0,R3           // if(residue >= temp)
    BLO     C
    SUB     R0,R0,R3        // residue -= temp
    ADD     R2,R2,R1,LSL1   // sqroot += (bit << 1)
C:  LSR     R2,R2,1
    LSR     R1,R1,2
    B       L
D:  LSL     R0,R2,8
    BX      LR
  
