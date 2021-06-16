//Grace Tantra
//COEN20 Lab 4C
//April 20, 2021

    .syntax unified
    .cpu    cortex-m4
    .text

// ----------------------------------------------------------
// void __attribute__((weak)) HalfWordAccess(int16_t *src) { tbd[0] = 1 ; }
// ----------------------------------------------------------

    .global HalfWordAccess
    .thumb_func
    .align
HalfWordAccess:
    .rept       100
    LDRH        R1,[R0]
    .endr
    BX          LR

// ----------------------------------------------------------
// void __attribute__((weak)) FullWordAccess(int32_t *src) { tbd[1] = 1 ; }
// ----------------------------------------------------------

    .global FullWordAccess
    .thumb_func
    .align
FullWordAccess:
    .rept       100
    LDR         R1,[R0]
    .endr
    BX          LR

// ----------------------------------------------------------
// void __attribute__((weak)) AddressDependency(uint32_t *src) { tbd[2] = 1 ; }
// ----------------------------------------------------------

    .global AddressDependency
    .thumb_func
    .align
AddressDependency:
    .rept       100
    LDR         R1,[R0]
    LDR         R0,[R1]
    .endr
    BX          LR

// ----------------------------------------------------------
// void __attribute__((weak)) NoAddressDependency(uint32_t *src) {tbd[3] = 1 ; }
// ----------------------------------------------------------

    .global NoAddressDependency
    .thumb_func
    .align
NoAddressDependency:
    .rept       100
    LDR         R1,[R0]
    LDR         R2,[R0]
    .endr
    BX          LR

// ----------------------------------------------------------
// void __attribute__((weak)) DataDependency(float f1) { tbd[4] = 1 ; }
// ----------------------------------------------------------

    .global DataDependency
    .thumb_func
    .align
DataDependency:
    .rept       100
    VADD.F32    S1,S0,S0
    VADD.F32    S0,S1,S1
    .endr
    VMOV        S1,S0
    BX          LR


// ----------------------------------------------------------
// void __attribute__((weak)) NoDataDependency(float f1) { tbd[5] = 1 ; }
// ----------------------------------------------------------

    .global NoDataDependency
    .thumb_func
    .align
NoDataDependency:
    .rept       100
    VADD.F32    S1,S0,S0
    VADD.F32    S2,S0,S0
    .endr
    VMOV        S1,S0
    BX          LR


// ----------------------------------------------------------
// void __attribute__((weak)) VDIVOverlap(float dividend, float divisor) { tbd[6] = 1 ; }
// ----------------------------------------------------------

    .global VDIVOverlap
    .thumb_func
    .align
VDIVOverlap:
    VDIV.F32    S2,S1,S0
    .rept       14
    NOP
    .endr
    VMOV        S3,S2
    BX          LR
