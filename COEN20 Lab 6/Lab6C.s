//Grace Tantra
//COEN20 Lab 6C
//May 4, 2021

    .syntax unified
    .cpu    cortex-m4
    .text

// ----------------------------------------------------------
/* void __attribute__((weak)) CopyCell(uint32_t *dst, uint32_t *src)
    {
    uint32_t row, col ;

    for (row = 0; row < 60; row++)
        {
        for (col = 0; col < 60; col++)
            {
            dst[col] = src[col] ;
            }
        dst += 240 ; // Move down to
        src += 240 ; // the next row
        }
    } */
// ----------------------------------------------------------

    .global CopyCell
    .thumb_func
    .align
CopyCell:
            LDR     R2,=0   //row = 0

OutTop:     CMP     R2,60   //row < 60
            BHS     OutDone
            LDR     R3,=0   //col = 0

InTop:      CMP     R3,60   //col < 60
            BHS     InDone
            LDR     R12,[R1,R3,LSL 2]   //R12 = src[col]
            STR     R12,[R0,R3,LSL 2]   //dst[col] = src[col]
            ADD     R3,R3,1             //col++
            B       InTop

InDone:     ADD     R2,R2,1 //row++
            ADD     R0,R0,960           //dst += 240
            ADD     R1,R1,960           //src += 240
            B OutTop

OutDone:    BX LR

    
    
// ----------------------------------------------------------
/* void __attribute__((weak)) FillCell(uint32_t *dst, uint32_t pixel)
    {
    uint32_t row, col ;

    for (row = 0; row < 60; row++)
        {
        for (col = 0; col < 60; col++)
            {
            dst[col] = pixel ;
            }
        dst += 240 ; // Move to next row
        }
    } */
// ----------------------------------------------------------

.global FillCell
.thumb_func
.align
FillCell:
            LDR     R2,=0   //row = 0

OutT:       CMP     R2,60   //row < 60
            BHS     OutD
            LDR     R3,=0   //col = 0

InT:        CMP     R3,60   //col < 60
            BHS     InD
            STR     R1,[R0,R3,LSL 2]    //dst[col] = pixel
            ADD     R3,R3,1             //col++
            B       InT

InD:        ADD     R2,R2,1 //row++
            ADD     R0,R0,960           //dst += 240
            B OutT

OutD:       BX LR

.end
