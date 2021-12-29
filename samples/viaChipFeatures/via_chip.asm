LATCH_COUNT = $00 ;32 bit numbers 4294967295
SHIFT_COUNT = $04

  .incdir "../common"
  .org $8000
  .include "startup.asm"
  jsr init_lcd
  jsr btd_reset
  lda #$ff
  sta BTD_VALUE
  sta BTD_VALUE + 1
  sta BTD_VALUE + 2
  sta BTD_VALUE + 3
  jsr btd_start
  ldx #0
getNumber:
  jsr bts_getNextChar
  cmp #0
  beq finishNumber
  sta LCD_LINE ,x
  inx
  cmp #0
  bne getNumber
finishNumber:


  jsr lcd_updateScreen

  jmp exit
  lda #0                
  sta AUXCONTROL         ;set all aux control bits to zero
  lda #SHIFT_OUT_CB1     ;set up shift reg direction  out on cb1 ext clock pulse
  sta AUXCONTROL        ;store to via chip autcontrol register
  
  lda #(IRQ_SET | IRQ_SHIFT | IRQ_CA1)  ; enable the shift IRQ and ca1 pin interrupt
  sta IRQ_ENABLE_REG
  lda #%10101010
  sta SHIFTREG
  cli

exit:
  jmp exit

irq:
  lda #(IRQ_CA1)  
  bit IRQ_FLAG    ;; compare this with irq_flag register, will be zero if from shift register
  bne ca1_irq
  beq shift_irq
ca1_irq:
  inc LATCH_COUNT
  bne ca1_irq_work
  inc LATCH_COUNT + 1
  bne ca1_irq_work
  inc LATCH_COUNT + 2
  bne ca1_irq_work
  inc LATCH_COUNT + 3
  bne ca1_irq_work
  inc LATCH_COUNT + 4
  bne ca1_irq_work 
ca1_irq_work:
  lda PORTA
  jmp exit_irq
shift_irq:
  inc SHIFT_COUNT
  bne shift_irq_work
  inc SHIFT_COUNT + 1
  bne shift_irq_work
  inc SHIFT_COUNT  + 2
  bne shift_irq_work
  inc SHIFT_COUNT + 3
  bne shift_irq_work
  inc SHIFT_COUNT + 4
  bne shift_irq_work 
shift_irq_work
  lda #%10101010
  sta SHIFTREG
  jmp exit_irq
exit_irq:
  rti

  .include "lcd.asm"
  .include "32bit_binary_to_decimal.asm"

  .org $fffc
  .word program_start
  .word irq





