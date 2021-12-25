numA = $00    ;10 digits 5 bytes
numB = $10    ;10 digits 5 bytes
sum  = $20    ;storage for sum
output = $30  ;output string

xcnt = 1
ycnt = 1

PORTB             = $6000
PORTA             = $6001
DDRB              = $6002
DDRA              = $6003

E  = %10000000
RW = %01000000
RS = %00100000


  .org $8000
init:
  cld             ;clear decimal mode
  clc             ;clear carry bit
  lda #$00    
  ldx #$ff 
  txs
  ldx #0
start:
  jsr init_lcd
  LDA #$00
  LDX #15
zero_mem:
  STA numA,x
  STA numB,x
  STA sum,x
  STA output,x
  DEX
  bne zero_mem
  STA numA,x
  STA numB,x
  STA sum,x
  STA output,x
  
  SED      
  LDA #$00
  STA numA
  lda #$01
  STA numB

add_number:
  ldx #0 
add_loop:
  SED
  lda numA,x
  adc numB,x
  sta sum ,x
  inx
  BCS add_loop
  cpx #16
  bne add_loop


  lda lcd_commands + 5 ; Clear display
  jsr lcd_instruction
  lda lcd_commands + 6 ; return home
  jsr lcd_instruction
  ldx #7
printSum:
  lda sum , x 
  jsr print_decimal_byte
  dex
  bne printSum
  lda sum , x 
  jsr print_decimal_byte
  ldx #15
move_sum_to_numA:
  lda sum,x
  sta numA,x
  dex
  bne move_sum_to_numA
  lda sum,x
  sta numA,x
  jsr start_delay
  jmp add_number

print_decimal_byte
  PHA 
  and #%11110000  
  CLD
  clc
  ror 
  ror
  ror
  ror
  adc #"0"
  jsr print_char
  PLA
  and #%00001111
  CLD
  clc
  adc #"0"
  jsr print_char
  rts

init_lcd:
  ;rts             ;skip
  pha
  lda #%11111111 ; Set all pins on port B to output
  sta DDRB
  lda #%11100000 ; Set top 3 pins on port A to output
  sta DDRA
  lda lcd_commands ; Set 8-bit mode; 2-line display; 5x8 font
  jsr lcd_instruction
  lda lcd_commands + 1 ; Display on; cursor on; blink off
  jsr lcd_instruction
  lda lcd_commands + 4 ; Increment and shift cursor; don't shift display
  jsr lcd_instruction
  lda lcd_commands + 5 ; Clear display
  jsr lcd_instruction
  pla
  rts

lcd_wait:
  pha
  lda #%00000000  ; Port B is input
  sta DDRB
lcdbusy:
  lda #RW
  sta PORTA
  lda #(RW | E)
  sta PORTA
  lda PORTB
  and #%10000000
  bne lcdbusy
  lda #RW
  sta PORTA
  lda #%11111111  ; Port B is output
  sta DDRB
  pla
  rts
lcd_instruction:
  ;rts             ;skip
  jsr lcd_wait
  sta PORTB
  lda #0         ; Clear RS/RW/E bits
  sta PORTA
  lda #E         ; Set E bit to send instruction
  sta PORTA
  lda #0         ; Clear RS/RW/E bits
  sta PORTA
  rts
print_char:     ; prints character on a register
  ;rts           ;skip
  pha
  jsr lcd_wait
  sta PORTB
  lda #RS         ; Set RS; Clear RW/E bits
  sta PORTA
  lda #(RS | E)   ; Set E bit to send instruction
  sta PORTA
  lda #RS         ; Clear E bits
  sta PORTA
  pla
  rts


start_delay:
  ;rts         ;skip
  ldy  #ycnt   ; (2 cycles)
  ldx  #xcnt   ; (2 cycles)
delay:  
  dex          ; (2 cycles)
  bne  delay   ; (3 cycles in loop, 2 cycles at end)
  dey          ; (2 cycles)
  bne  delay   ; (3 cycles in loop, 2 cycles at end)
  rts

exit:
  jmp exit   ;stop here in inifinte loop

lcd_commands:
  byte %00111000 ;0 Set 8-bit mode; 2-line display; 5x8 font
  byte %00001110 ;1 Display on; cursor on; blink off
  byte %00111100 ;2
  byte %00001100 ;3
  byte %00000110 ;4 Increment and shift cursor; don't shift display
  byte %00000001 ;5 clear 
  byte %00000010 ;6 return home 
  byte %00000000 ;7 

  .org $fffc
  .word init
  .word $0000





