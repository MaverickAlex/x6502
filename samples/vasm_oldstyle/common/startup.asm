program_start:
  cld             ;clear decimal mode
  clc             ;clear carry bit
  ldx #$ff 
  txs             ;set up stack to ff
  ldx #0          ;set all registers to zero
  lda #0
  ldy #0