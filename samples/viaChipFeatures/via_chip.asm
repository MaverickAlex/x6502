  .incdir "../common"
  .org $8000
  .include "startup.asm"

  jsr init_lcd;
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
  beq clock_irq
ca1_irq:
  lda PORTA
  lda #"L"
  jsr print_char
  jmp exit_irq
clock_irq:
  lda #"C"
  jsr print_char
  lda #%10101010
  sta SHIFTREG
  jmp exit_irq
exit_irq:
  rti

  .include "lcd.asm"

  .org $fffc
  .word program_start
  .word irq





