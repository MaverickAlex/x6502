  .incdir "../common"
  .org $8000
start:
  cld             ;clear decimal mode
  clc             ;clear carry bit
  lda #$00    
  ldx #$ff 
  txs
  ldx #0
  jsr init_lcd;
  lda #$99
  jsr print_decimal_byte
  lda #"A"
  jsr print_char

exit:
  jmp exit

  .include "lcd.asm"

  .org $fffc
  .word start
  .word $0000

