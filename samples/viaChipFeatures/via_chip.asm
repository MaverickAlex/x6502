LATCH_COUNT = $00 ;4 bytes
SHIFT_COUNT = $04 ;4 bytes
TICKS       = $08 ;4 bytes
TOGGLE_TIME = $12 ;1 byte

  .incdir "../common"
  .org $8000
  .include "startup.asm"
  jsr init_lcd
  jsr btd_reset

;reset memory locations to zero
  lda #0
  sta TICKS
  sta TICKS + 1
  sta TICKS + 2
  sta TICKS + 3
  sta TOGGLE_TIME
  sta LATCH_COUNT
  sta LATCH_COUNT + 1
  sta LATCH_COUNT + 2
  sta LATCH_COUNT + 3
  sta SHIFT_COUNT 
  sta SHIFT_COUNT + 1
  sta SHIFT_COUNT + 2
  sta SHIFT_COUNT + 3  
  sta AUXCONTROL            
  lda #TIMER1_CONTINUOUS     
  sta AUXCONTROL              
  
  lda #(IRQ_SET | IRQ_TIMER1);  | IRQ_SHIFT | IRQ_CA1)  ; enable the shift IRQ and ca1 pin interrupt
  sta IRQ_ENABLE_REG
  cli
  lda #$0e
  sta T1CL
  lda #$27
  sta T1CH
  jsr print_status

loop:
  jsr update_status
  jmp loop

update_status:
  sec
  lda TICKS
  sbc TOGGLE_TIME
  cmp #100
  bcc exit_update_status
  jsr print_status
  lda TICKS
  sta TOGGLE_TIME
exit_update_status:
  rts


print_status
  lda LATCH_COUNT
  sta BTD_VALUE
  lda LATCH_COUNT + 1
  sta BTD_VALUE + 1
  lda LATCH_COUNT + 2
  sta BTD_VALUE + 2
  lda LATCH_COUNT + 3
  sta BTD_VALUE + 3
  jsr btd_start
  ldx #0
getLatchNumber:
  jsr bts_getNextChar
  cmp #$ff
  beq finishLatchNumber
  sta LCD_LINE ,x
  inx
  jmp getLatchNumber
finishLatchNumber:

  lda SHIFT_COUNT
  sta BTD_VALUE
  lda SHIFT_COUNT + 1
  sta BTD_VALUE + 1
  lda SHIFT_COUNT + 2
  sta BTD_VALUE + 2
  lda SHIFT_COUNT + 3
  sta BTD_VALUE + 3
  jsr btd_start
  ldx #16
getShiftNumber:
  jsr bts_getNextChar
  cmp #$ff
  beq finishShiftNumber
  sta LCD_LINE , x
  inx
  jmp getShiftNumber
finishShiftNumber:
  jsr lcd_updateScreen
  rts

irq:
  pha
  phy
  phx
  lda #(IRQ_CA1)  
  bit IRQ_FLAG    ;; compare this with irq_flag register, will be zero if from shift register
  bvs timer1_irq
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
shift_irq_work
  lda #%10101010
  sta SHIFTREG
  jmp exit_irq
timer1_irq:
  lda T1CL
  inc TICKS
  bne exit_irq
  inc TICKS + 1
  bne exit_irq
  inc TICKS + 2
  bne exit_irq
  inc TICKS + 3
exit_irq:
  pla
  ply
  plx
  rti

  .include "lcd.asm"
  .include "32bit_binary_to_decimal.asm"

  .org $fffc
  .word program_start
  .word irq





