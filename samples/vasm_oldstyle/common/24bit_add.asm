addX        .equ $0210  ; 3 bytes
addY        .equ $0213  ; 3 bytes
addResult 	.equ $0216	; 3 bytes

add24_init:
  lda #0
  sta addX 
  sta addX + 1
  sta addX + 2
  sta addY 
  sta addY + 1
  sta addY + 2
  sta addResult
  sta addResult + 1
  sta addResult + 2
  rts

add24:
  ldx #0
add24_loop:
  lda addX,x
  adc addY,x
  sta addResult,x
  inx
  bcs add24_loop
  cpx #3
  bne add24_loop 
  rts
