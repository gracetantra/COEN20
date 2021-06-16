//Grace Tantra
//COEN20 Lab 8A
//May 18, 2021

    .syntax unified
    .cpu    cortex-m4
    .text

// ----------------------------------------------------------
// uint32_t Zeller1(uint32_t k, uint32_t m, uint32_t D, uint32_t C) ;
// Uses Div and Mul
// ----------------------------------------------------------

    .global Zeller1
    .thumb_func
    .align
Zeller1:
    // Note: We start with R0 = k

    // + (13*m-1)/5
    LDR     R12,=13
    MUL     R1,R1,R12   // R1 = 13*m
    SUB     R1,R1,1     // R1 = 13*m-1
    LDR     R12,=5
    UDIV    R1,R1,R12   // R1 = (13*m-1)/5
    ADD     R0,R0,R1    // R0 += (13*m-1)/5

    // + D + D/4
    ADD     R0,R0,R2    // R0 += D
    LDR     R12,=4
    UDIV    R2,R2,R12   // R2 = D/4
    ADD     R0,R0,R2    // R0 += D/4

    // + C/4 - 2*C
    UDIV    R2,R3,R12   // R2 = C/4
    ADD     R0,R0,R2    // R0 += C/4
    LDR     R12,=2      //
    MUL     R2,R3,R12   // R2 = 2*C
    SUB     R0,R0,R2    // R0 -= 2*C

    // % 7 and check
    LDR     R12,=7
    SDIV    R1,R0,R12   // with MLS, R0 = R0 % 7
    MLS     R0,R12,R1,R0
    CMP     R0,0
    IT      LT          // if remainder < 0
    ADDLT   R0,R0,7     // R0 += 7
    
    BX      LR
  

// ----------------------------------------------------------
// uint32_t Zeller2(uint32_t k, uint32_t m, uint32_t D, uint32_t C) ;
// No divide instructions
// ----------------------------------------------------------

    .global Zeller2
    .thumb_func
    .align
Zeller2:
    // Note: We start with R0 = k

    // + D + D/4
    ADD     R0,R0,R2        // R0 += D
    ADD     R0,R0,R2,LSR 2  // R0 += D/4

    // + C/4 - 2*C
    ADD     R0,R0,R3,LSR 2  // R0 += C/4
    LDR     R12,=2          //
    MUL     R2,R3,R12       // R2 = 2*C
    SUB     R0,R0,R2        // R0 -= 2*C

    // + (13*m-1)/5
    LDR     R12,=13
    MUL     R1,R1,R12       // R1 = 13*m
    SUB     R1,R1,1         // R1 = 13*m-1
    LDR     R12,=3435973837 // from website (unsigned, divide by 5)
    UMULL   R2,R12,R12,R1
    LSR     R1,R12,2
    ADD     R0,R0,R1        // R0 += (13*m-1)/5
 
    // % 7 and check
    LDR     R12,=2454267027 // from website (signed, divide by 7)
    SMMLA   R12,R12,R0,R0
    LSR     R1,R0,31
    ADD     R1,R1,R12,ASR 2
    // used with below for %
    LDR     R12,=7
    MLS     R0,R12,R1,R0
    CMP     R0,0
    IT      LT              // if remainder < 0
    ADDLT   R0,R0,7         // R0 += 7

    BX      LR


// ----------------------------------------------------------
// uint32_t Zeller3(uint32_t k, uint32_t m, uint32_t D, uint32_t C) ;
// No multiply instructions
// ----------------------------------------------------------

    .global Zeller3
    .thumb_func
    .align
Zeller3:
    // Note: We start with R0 = k

    // + (13*m-1)/5
    ADD     R12,R1,R1,LSL 3 // R12 = R1*9 (1+2^3)
    ADD     R1,R12,R1,LSL 2 // R1 = R12 + R1*4 (2^2)
    SUB     R1,R1,1         // R1 = 13*m-1
    LDR     R12,=5
    UDIV    R1,R1,R12       // R1 = (13*m-1)/5
    ADD     R0,R0,R1        // R0 += (13*m-1)/5

    // + D + D/4
    ADD     R0,R0,R2        // R0 += D
    LDR     R12,=4
    UDIV    R2,R2,R12       // R2 = D/4
    ADD     R0,R0,R2        // R0 += D/4

    // + C/4 - 2*C
    UDIV    R2,R3,R12       // R2 = C/4
    ADD     R0,R0,R2        // R0 += C/4
    SUB     R0,R0,R3,LSL 1  // R0 -= 2*C

    // % 7 and check
    LDR     R12,=7
    SDIV    R1,R0,R12       // with below, R0 = R0 % 7
    RSB     R1,R1,R1,LSL 3  // R1 = R1 (rounded result) * 7
    SUB     R0,R0,R1
    CMP     R0,0
    IT      LT              // if remainder < 0
    ADDLT   R0,R0,7         // R0 += 7

    BX      LR

.end
