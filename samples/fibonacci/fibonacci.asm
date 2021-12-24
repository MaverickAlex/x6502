aNum              = $00 ; 16 bytes
bNum              = $10 ; 16 bytes
xNum              = $20 ; 16 bytes

value             = $40 ; 2 bytes
mod10             = $42 ; 2 bytes
numString         = $44 ; 6 bytes
numbersInString   = $4a ; 1 byte

PORTB             = $6000
PORTA             = $6001
DDRB              = $6002
DDRA              = $6003

E  = %10000000
RW = %01000000
RS = %00100000

  .org $8000
start:
  lda #$00    
  ldx #$ff 
  txs
  ldx #$0f 
  ldx #$2
zeroMemory:
  lda #0
  sta xNum,x
  sta aNum,x
  sta bNum,x
  dex
  txa
  bne zeroMemory
  sta xNum,x
  sta aNum,x
  sta bNum,x   

init_lcd:
  lda #%11111111 ; Set all pins on port B to output
  sta DDRB
  lda #%11100000 ; Set top 3 pins on port A to output
  sta DDRA
  lda #%00111000 ; Set 8-bit mode; 2-line display; 5x8 font
  jsr lcd_instruction
  lda #%00001110 ; Display on; cursor on; blink off
  jsr lcd_instruction
  lda #%00000110 ; Increment and shift cursor; don't shift display
  jsr lcd_instruction
  lda #$00000001 ; Clear display
  jsr lcd_instruction

start_fib:
  lda #0
  sta aNum
  lda #1
  sta bNum
add_fib:
  lda aNum      ; load a
  adc bNum      ; add b
  bcs end_prog  ; if carry bit is set we need to expand to two byte numbers for now quit    
  sta xNum      ; store in x
  jsr printStep
  lda bNum      ; load b
  sta aNum      ; store b in a
  lda xNum      ; load x
  sta bNum      ; store in b
  jmp add_fib   ; next interation

printStep:
  lda lcd_commands + 3 ; Clear display
  jsr lcd_instruction
  lda lcd_commands + 4 ; return home
  jsr lcd_instruction
  
  ; Initialize a to be the number to convert
  lda aNum
  sta value
  lda aNum + 1
  sta value + 1
  ;jmp to convert & print number
  jsr print_num
  
  lda #"+"
  jsr print_char
  ; convert b
  lda bNum
  sta value
  lda bNum + 1
  sta value + 1
  jsr print_num
  lda #"="
  jsr print_char
  ; convert b
  lda xNum
  sta value
  lda xNum + 1
  sta value + 1
  jsr print_num
  
  rts

end_prog:
  jmp end_prog   ;stop here in inifinte loop

print_num:
    lda #0
    sta numString
    sta numString + 1
    sta numString + 2
    sta numString + 3
    ;sta numString + 4
    ;sta numString + 5  ; this could be simple loop with x regiseter
    sta numbersInString;
print_num_loop:
    ; Initialize the remainder to zero
    lda #0
    sta mod10
    sta mod10 + 1
    clc
    ldx #16
divloop:
    ; Rotate value and remainder
    rol value
    rol value + 1
    rol mod10
    rol mod10 + 1

    ; A + Y = dividend - divisor
    sec
    lda mod10
    sbc #10
    tay ; Save low byte
    lda mod10 + 1
    sbc #0
    bcc ignore_result
    sty mod10
    sta mod10 + 1

ignore_result:
    dex
    bne divloop
    rol value
    rol value + 1
    lda mod10
    clc
    adc #"0"
    ldx numbersInString
    sta numString, x
    inc numbersInString
    ; If value < 0 continue dividing
    lda value
    ora value + 1
    bne print_num_loop 
    ldx numbersInString
output_num:
    dex
    lda numString,x
    jsr print_char
    cpx #0
    beq finished_output_num
    jmp output_num
finished_output_num:
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
  jsr lcd_wait
  sta PORTB
  lda #0         ; Clear RS/RW/E bits
  sta PORTA
  lda #E         ; Set E bit to send instruction
  sta PORTA
  lda #0         ; Clear RS/RW/E bits
  sta PORTA
  rts

print_char:
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


  lcd_commands:
    byte %00111100
    byte %00001100
    byte %00000110
    byte %00000001 ;3 - clear 
    byte %00000010 ;4 - return home 
    byte %00000000

  .org $fffc
  .word start
  .word $0000





