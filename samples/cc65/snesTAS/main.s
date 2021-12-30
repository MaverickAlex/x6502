;
; File generated by cc65 v 2.18 - Ubuntu 2.18-1
;
	.fopt		compiler,"cc65 v 2.18 - Ubuntu 2.18-1"
	.setcpu		"65SC02"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.forceimport	__STARTUP__
	.export		_PORTB
	.export		_PORTA
	.export		_DDRB
	.export		_DDRA
	.export		_E_bit
	.export		_RW_bit
	.export		_RS_bit
	.export		_lcd_cmd_8BIT
	.export		_lcd_cmd_DisplayOn
	.export		_lcd_cmd_Clear
	.export		_lcd_cmd_Home
	.export		_lcd_isBusy
	.export		_execute_lcd_instruction
	.export		_init_lcd
	.export		_main

.segment	"DATA"

_PORTB:
	.word	$6000
_PORTA:
	.word	$6001
_DDRB:
	.word	$6002
_DDRA:
	.word	$6003
_E_bit:
	.word	$0080
_RW_bit:
	.word	$0040
_RS_bit:
	.word	$0020
_lcd_cmd_8BIT:
	.word	$0038
_lcd_cmd_DisplayOn:
	.word	$000E
_lcd_cmd_Clear:
	.word	$0001
_lcd_cmd_Home:
	.word	$0002

; ---------------------------------------------------------------
; int __near__ lcd_isBusy (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_lcd_isBusy: near

.segment	"CODE"

	lda     _DDRB+1
	sta     ptr1+1
	lda     _DDRB
	sta     ptr1
	lda     #$00
	sta     (ptr1)
	ldy     #$01
	sta     (ptr1),y
	lda     _PORTA+1
	sta     ptr1+1
	lda     _PORTA
	sta     ptr1
	lda     _RW_bit
	sta     (ptr1)
	ldy     #$01
	lda     _RW_bit+1
	sta     (ptr1),y
	lda     _PORTA+1
	sta     ptr1+1
	lda     _PORTA
	sta     ptr1
	lda     _E_bit
	ora     _RW_bit
	pha
	lda     _E_bit+1
	ora     _RW_bit+1
	tax
	pla
	sta     (ptr1)
	ldy     #$01
	txa
	sta     (ptr1),y
	lda     _PORTB+1
	sta     ptr1+1
	lda     _PORTB
	sta     ptr1
	lda     (ptr1)
	ldy     #$01
	ora     (ptr1),y
	beq     L0014
	ldx     #$00
	bra     L0030
L0014:	tax
	rts
L0030:	tya
	rts

.endproc

; ---------------------------------------------------------------
; void __near__ execute_lcd_instruction (int)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_execute_lcd_instruction: near

.segment	"CODE"

	jsr     pushax
L0017:	jsr     _lcd_isBusy
	stx     tmp1
	ora     tmp1
	bne     L0017
	lda     _PORTB+1
	sta     ptr1+1
	lda     _PORTB
	sta     ptr1
	jsr     ldax0sp
	sta     (ptr1)
	ldy     #$01
	txa
	sta     (ptr1),y
	lda     _PORTA+1
	sta     ptr1+1
	lda     _PORTA
	sta     ptr1
	lda     _E_bit
	sta     (ptr1)
	ldy     #$01
	lda     _E_bit+1
	sta     (ptr1),y
	lda     _PORTA+1
	sta     ptr1+1
	lda     _PORTA
	sta     ptr1
	lda     #$00
	sta     (ptr1)
	ldy     #$01
	sta     (ptr1),y
	jmp     incsp2

.endproc

; ---------------------------------------------------------------
; void __near__ init_lcd (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_init_lcd: near

.segment	"CODE"

	lda     _DDRB+1
	sta     ptr1+1
	lda     _DDRB
	sta     ptr1
	lda     #$FF
	sta     (ptr1)
	ldy     #$01
	ina
	sta     (ptr1),y
	lda     _DDRA+1
	sta     ptr1+1
	lda     _DDRA
	sta     ptr1
	lda     #$E0
	sta     (ptr1)
	ldy     #$01
	lda     #$00
	sta     (ptr1),y
	lda     _lcd_cmd_8BIT
	ldx     _lcd_cmd_8BIT+1
	jsr     _execute_lcd_instruction
	lda     _lcd_cmd_DisplayOn
	ldx     _lcd_cmd_DisplayOn+1
	jsr     _execute_lcd_instruction
	lda     _lcd_cmd_Clear
	ldx     _lcd_cmd_Clear+1
	jmp     _execute_lcd_instruction

.endproc

; ---------------------------------------------------------------
; int __near__ main (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_main: near

.segment	"CODE"

	jsr     _init_lcd
	ldx     #$00
	txa
	rts

.endproc

