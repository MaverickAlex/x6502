;Converting binary to decimal

PortB = $6000
PortA = $6001
DDRB = $6002
DDRA = $6003

value = $0200 ; 2 bytes
mod10 = $0202 ; 2 bytes


E = %10000000
RW = %01000000
RS = %00100000

    .org $8000

reset:

    lda #%11111111 ;Set all pins on port B to output
    sta DDRB

    lda #%11100000 ;Set first 3 pins on port A to output
    sta DDRA

    lda #%00111000 ;Set 8-bit mode ;Two line display ;5x8 Font
    jsr lcd_instruction
    lda #%00000001 ;Reset LCD
    jsr lcd_instruction
    lda #%00001110 ; Display on ;Cursor on ;Blinking off
    jsr lcd_instruction
    lda #%00000110 ;Increment and shift cursor ;Don't shift display
    jsr lcd_instruction


    ; Initialize value to be the number to convert
    lda number
    sta value + 1
    lda number + 1
    sta value 

divide:
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
    jsr print_char
    ; If value < 0 continue dividing
    lda value
    ora value + 1
    bne divide 

loop:
    jmp loop


number: 
  byte $ff
  byte $00

lcd_wait:
    pha
    lda #%00000000
    sta DDRB
lcd_busy
    lda #RW
    sta PortA
    lda #(RW | E)
    sta PortA
    lda PortB
    and #%10000000
    bne lcd_busy

    lda #RW
    sta PortA
    lda #%11111111
    sta DDRB
    pla
    rts

lcd_instruction:
    jsr lcd_wait
    sta PortB
    lda #%0        ;Reset port A
    sta PortA
    lda #E         ;Set E bit to send instructions
    sta PortA
    lda #%0        ;Reset port A
    sta PortA
    rts 

print_char:
    jsr lcd_wait
    sta PortB
    lda #RS        ;Reset port A
    sta PortA
    lda #(RS | E)  ;Set E bit to send instructions
    sta PortA
    lda #RS        ;Reset port A
    sta PortA
    rts


    .org $fffc

    .word reset
    .word $0000