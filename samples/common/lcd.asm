;this module uses 32 bytes of zero page to allow for faster drawing of lcd.
LCD_LINE  = $e0   ; $00e0 -> $00ff  stack starts in $0100  
  
  
  .include "io.asm"

E  =  %10000000                    ;E
RW =  %01000000                    ;RW
RS =  %00100000                    ;RS

init_lcd:
  lda #" "
  ldx #32
zero_LCD_LINE:
  sta LCD_LINE,x
  dex 
  bne zero_LCD_LINE
  sta LCD_LINE,x
  lda #%11111111 ; Set all pins on port B to output
  sta DDRB
  lda #%11100000 ; Set top 3 pins on port A to output
  sta DDRA
  lda lcd_commands ; Set 8-bit mode; 2-line display; 5x8 font
  jsr lcd_instruction
  lda lcd_commands + 1 ; Display on; cursor on; blink off
  jsr lcd_instruction
  lda lcd_commands + 5 ; Clear display
  jsr lcd_instruction
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
  pha
  jsr lcd_wait
  sta PORTB
  lda #0         ; Clear RS/RW/E bits
  sta PORTA
  lda #E         ; Set E bit to send instruction
  sta PORTA
  lda #0         ; Clear RS/RW/E bits
  sta PORTA
  pla
  rts



lcd_updateScreen:
  jsr lcd_returnHome
  ldx #0
lcd_updateScreenFirst16:
  lda LCD_LINE,x
  jsr print_char
  inx
  cpx #16
  bne lcd_updateScreenFirst16
  ldx #0
lcd_updateScreen_blanks
  lda lcd_commands + 4
  jsr lcd_instruction
  inx
  cpx #24
  bne lcd_updateScreen_blanks
  ldx #16
lcd_updateScreenLast16
  lda LCD_LINE,x
  jsr print_char
  inx
  cpx #32
  bne lcd_updateScreenLast16
  rts


lcd_returnHome:
  lda lcd_commands + 6
  jsr lcd_instruction
  rts



print_char:     ; prints character on a register
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


  
lcd_commands:
  byte %00111000 ;0 Set 8-bit mode; 2-line display; 5x8 font
  byte %00001110 ;1 Display on; cursor on; blink off
  byte %00111100 ;2
  byte %00001100 ;3
  byte %00010100 ;4 shift cursor right
  byte %00000001 ;5 clear 
  byte %00000010 ;6 return home 
  byte %00000000 ;7 