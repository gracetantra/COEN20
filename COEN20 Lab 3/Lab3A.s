//Grace Tantra
//COEN20 Lab 3A
//April 13, 2021

    .syntax unified
    .cpu    cortex-m4
    .text

// ----------------------------------------------------------
// int32_t Add(int32_t a, int32_t b) { return a + b ; }
// ----------------------------------------------------------

    .global Add
    .thumb_func
    .align
Add:        // R0 = a, R1 = b
    ADD     R0,R0,R1    // R0 = R0 + R1
    BX      LR          // Copies LR into PC

// ----------------------------------------------------------
// int32_t Less1(int32_t a) { return a - 1 ; }
// ----------------------------------------------------------

    .global Less1
    .thumb_func
    .align
Less1:      // R0 = a, op2 is always 1 (always subtracts one)
    SUB     R0,R0,1     // R0 = R0 - 1
    BX      LR          // Copies LR into PC

// ----------------------------------------------------------
// int32_t Square2x(int32_t x) { return Square(x + x) ; }
// ----------------------------------------------------------

    .global Square2x
    .thumb_func
    .align
Square2x:	// R0 = x, add to itself, then Square
    ADD     R0,R0,R0    // R0 = R0 + R0
    B       Square      // R0 <-- Square(R0)

// ----------------------------------------------------------
// int32_t Last(int32_t x) { return x + SquareRoot(x) ; }
// ----------------------------------------------------------

    .global Last
    .thumb_func
    .align
Last:       // R0 = x, keep, then sum with its own SquareRoot
    PUSH    {R4,LR}     // Preserve R4
    MOV     R4,R0       // Keep x safe in R4
    BL      SquareRoot  // R0 <-- SquareRoot(R0)
    ADD     R0,R0,R4    // R0 = R0 + R4
    POP     {R4,PC}     // Restore R4

    .end


