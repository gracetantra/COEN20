//Grace Tantra
//COEN20 Lab 9B
//May 25, 2021

    .syntax unified
    .cpu    cortex-m4
    .text

// ----------------------------------------------------------
// void __attribute__((weak)) Integrate(void) {
//   float x, v, r, prev, a, dx ;
//   int n ;
//   dx = DeltaX() ;
//   v = a = 0.0 ;
//   x = r = 1.0 ;
//   n = 0 ;
//   do {
//     UpdateDisplay(n, r, v, a) ;
//     prev = v ;
//     r = (1/x + 1/(x + dx))/2 ;
//     v += r*r ;
//     a += r ;
//     n++ ;
//     x += dx ;
//   } while (v != prev) ;
// }
// ----------------------------------------------------------

// S16 = r, S17 = v, S18 = a, S19 = x, S20 = dx, S21 = prev, R0 = n

    .global Integrate
    .thumb_func
    .align
Integrate:
    PUSH        {R4,LR}
    VPUSH       {S16,S17,S18,S19,S20,S21}
    BL          DeltaX
    VMOV        S20,S0          // dx = result from DeltaX
    VSUB.F32    S17,S17,S17     // v = 0.0
    VSUB.F32    S18,S18,S18     // a = 0.0
    VMOV        S19,1.0         // x = 1.0
    VMOV        S16,1.0         // r = 1.0
    LDR         R4,=0           // n = 0

L:  // move for updatedisplay
    MOV         R0,R4
    VMOV        S0,S16
    VMOV        S1,S17
    VMOV        S2,S18
    BL          UpdateDisplay
    VMOV        S21,S17         // prev = v
    // r calculations
    VMOV        S8,1.0
    VDIV.F32    S6,S8,S19       // 1/x
    VADD.F32    S7,S19,S20      // x+dx
    VDIV.F32    S7,S8,S7        // 1/(x+dx)
    VADD.F32    S6,S6,S7        // 1/x + 1/(x+dx)
    VMOV        S8,2.0
    VDIV.F32    S16,S6,S8       // r = above result /2
    // v calculations
    VMUL.F32    S6,S16,S16      // S6 = r*r
    VADD.F32    S17,S17,S6      // v += r*r
    // a calculations
    VADD.F32    S18,S18,S16     // a += r
    // increment, comp for loop
    ADD         R4,R4,1         // n++
    VADD.F32    S19,S19,S20     // x += dx
    BL          UpdateDisplay
    VCMP.F32    S17,S21         // compare v and prev
    VMRS        APSR_nzcv,FPSCR
    BNE         L               // if not equal, loop

    VPOP        {S16,S17,S18,S19,S20,S21}
    POP         {R4,PC}
  

.end
