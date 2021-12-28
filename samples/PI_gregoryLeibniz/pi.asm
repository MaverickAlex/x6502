; π = (4/1) - (4/3) + (4/5) - (4/7) + (4/9) - (4/11) + (4/13) - (4/15) ...
; Take 4 and subtract 4 divided by 3. 
; Then add 4 divided by 5. 
; Then subtract 4 divided by 7. 
; Continue alternating between adding and subtracting fractions with a numerator of 4 
; and a denominator of each subsequent odd number. The more times you do this, 
; the closer you will get to pi.
pi      =  $00  ; 3 bytes bc
factor  =  $03  ; one byte to hold 
  .incdir "../common"
  .org $8000
start:
  cld             ;clear decimal mode
  clc             ;clear carry bit
  lda #$00    
  ldx #$ff 
  txs
  ldx #0
  jsr div24_init
  jsr add24_init
  lda #1
  sta pi
  lda #0
  sta pi + 1
  sta pi + 2
  sta pi + 3
  ; jsr init_lcd
  
  lda #$ff
  sta addX
  sta addY
  jsr add24;
  
  
  lda #1
  sta dividend 
  lda #3
  sta divisor 
  jsr div24
  lda dividend
  sta pi
  BEQ  


exit:
  jmp exit

  .include "lcd.asm"
  .include "24bit_division.asm"
  .include "24bit_add.asm"

  .org $fffc
  .word start
  .word $0000

