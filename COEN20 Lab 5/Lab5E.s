//Grace Tantra
//COEN20 Lab 5E
//April 27, 2021

    .syntax unified
    .cpu    cortex-m4
    .text

// ----------------------------------------------------------
// void __attribute__((weak)) Log2Phys(uint32_t lba, uint32_t heads, uint32_t sectors, CHS *phy) {
// phy->cylinder   = lba / (heads * sectors) ;
// phy->head       = (lba / sectors) % heads ;
// phy->sector     = (lba % sectors) + 1 ; }
// ----------------------------------------------------------

    .global Log2Phys
    .thumb_func
    .align
Log2Phys:
    PUSH    {R11, R12}
    //phy->cylinder   = lba / (heads * sectors)
    MUL     R12,R1,R2
    UDIV    R12,R0,R12
    STRH    R12,[R3]        //phy->cylinder

    //phy->head       = (lba / sectors) % heads
    UDIV    R12,R0,R2
    UDIV    R11,R12,R1      //used with below for %
    MLS     R12,R1,R11,R12
    STRB    R12,[R3,2]      //phy->head

    //phy->sector     = (lba % sectors) + 1
    UDIV    R12,R0,R2       //used with below for %
    MLS     R12,R2,R12,R0
    ADD     R12,1
    STRB    R12,[R3,3]
    POP     {R11, R12}      //phy->sector

    BX      LR
    
    
