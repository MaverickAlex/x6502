;Converting binary to decimal does up to 32 bit number,call btd_reset, input into BTD_VALUE, call btd_start, retrive output 
; from BTD_DECIMAL_NUM

BTD_VALUE  = $c0            ; $00c0 -> $00c3  
BTD_MOD10  = $c4            ; $00c4 -> $00c7
BTD_DECIMAL_NUM = $c8       ; $00c8 -> $00d2 10 bytes, one per character max 4294 9672 95
BTD_INDEX   = $d3           ; $00d3 -> $00d4 1 byte, output index
BTD_TEMP = $d4              ; $00d4 -> $00d5 1 byte, temp for swap

btd_reset:
  lda #0
  sta BTD_INDEX
  sta BTD_VALUE 
  sta BTD_VALUE + 1
  sta BTD_VALUE + 2
  sta BTD_VALUE + 3
  sta BTD_MOD10 
  sta BTD_MOD10 + 1
  sta BTD_MOD10 + 2
  sta BTD_MOD10 + 3
  lda #" "
  sta BTD_DECIMAL_NUM  
  sta BTD_DECIMAL_NUM  + 1
  sta BTD_DECIMAL_NUM  + 2
  sta BTD_DECIMAL_NUM  + 3
  sta BTD_DECIMAL_NUM  + 4
  sta BTD_DECIMAL_NUM  + 5
  sta BTD_DECIMAL_NUM  + 6
  sta BTD_DECIMAL_NUM  + 7
  sta BTD_DECIMAL_NUM  + 8
  sta BTD_DECIMAL_NUM  + 9
  rts  

btd_start:
  ldy #0
btd_divide:
  ; Initialize the remainder to zero
  lda #0
  sta BTD_MOD10
  sta BTD_MOD10 + 1
  sta BTD_MOD10 + 2
  sta BTD_MOD10 + 3
  clc
  ldx #32

btd_divloop:
  ; Rotate value and remainder
  rol BTD_VALUE
  rol BTD_VALUE + 1
  rol BTD_VALUE + 2
  rol BTD_VALUE + 3
  rol BTD_MOD10
  rol BTD_MOD10 + 1
  rol BTD_MOD10 + 2
  rol BTD_MOD10 + 3
  ; A + Y = dividend - divisor
  sec
  lda BTD_MOD10
  sbc #10
  tay ; Save low byte
  lda BTD_MOD10 + 1
  sbc #0
  bcc btd_ignore_result
  sty BTD_MOD10
  sta BTD_MOD10 + 1

btd_ignore_result:
  dex
  bne btd_divloop
  rol BTD_VALUE
  rol BTD_VALUE + 1
  rol BTD_VALUE + 2
  rol BTD_VALUE + 3
  lda BTD_MOD10
  clc
  adc #"0"
  ldy BTD_INDEX
  sta BTD_DECIMAL_NUM,y  ;; this is probably wrong order
  inc BTD_INDEX
  ; If value < 0 continue dividing
  lda BTD_VALUE
  ora BTD_VALUE + 1
  bne btd_divide 
  ;; might have to continute this pattern
  jmp bts_done
  ;; need to swap number order
  ldx #0
  ldy BTD_INDEX
btd_swap:
  lda BTD_DECIMAL_NUM , x
  sta BTD_TEMP
  lda BTD_DECIMAL_NUM , y
  sta BTD_DECIMAL_NUM , x
  inx
  dey
  dec BTD_INDEX
  bne btd_swap
  lda BTD_DECIMAL_NUM , x
  sta BTD_TEMP
  lda BTD_DECIMAL_NUM , y
  sta BTD_DECIMAL_NUM , x

bts_done:
  rts



