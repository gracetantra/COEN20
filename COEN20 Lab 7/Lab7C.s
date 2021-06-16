//Grace Tantra
//COEN20 Lab 7C
//May 11, 2021

    .syntax unified
    .cpu    cortex-m4
    .text

// ----------------------------------------------------------
/* uint32_t __attribute__((weak)) GetNibble(void *nibbles, uint32_t which) {
        uint8_t byte ;

        byte = ((uint8_t *) nibbles)[which >> 1] ;
        if ((which & 1) == 1) byte >>= 4 ;
        return (uint32_t) (byte & 0b00001111) ;
    } */
// ----------------------------------------------------------

    .global GetNibble
    .thumb_func
    .align
GetNibble:
    LSR     R3,R1,1             //which >> 1
    LDRB    R0,[R0, R3]
    AND     R1,R1,1             //R1 = which & 1
    CMP     R1,1                //compares R1 with 1
    IT      EQ                  //If equal...
    LSREQ   R0,R0,4
    AND     R0,R0,0b00001111    //byte & 0b00001111
    BX      LR
  
    
// ----------------------------------------------------------
/* void __attribute__((weak)) PutNibble(void *nibbles, uint32_t which, uint32_t value) {
        uint8_t *pbyte ;
        pbyte = (uint8_t *) nibbles + (which >> 1) ;
        if ((which & 1) == 1) {
            *pbyte &= 0b00001111 ;
            *pbyte |= value << 4 ;
        } else {
            *pbyte &= 0b11110000 ;
            *pbyte |= value ;
        }
    } */
// ----------------------------------------------------------

.global PutNibble
.thumb_func
.align
PutNibble:
    LSR     R12,R1,1            //which >> 1
    LDRB    R3,[R0,R12]         //stores value in R3 (bc R0 pointer)
    AND     R1,R1,1             //R1 = which & 1
    CMP     R1,1                //compares R1 with 1

    ITTEE   EQ
    ANDEQ   R3,R3,0b00001111    //preserves lower
    ORREQ   R3,R3,R2,LSL4       //updates upper
    ANDNE   R3,R3,0b11110000    //preserves upper
    ORRNE   R3,R3,R2            //updates lower

    STRB    R3,[R0,R12]         //stores in R0, shifted by R12
    BX      LR
.end
