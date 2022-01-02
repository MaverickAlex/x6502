;
; File generated by cc65 v 2.18 - Ubuntu 2.18-1
;
	.fopt		compiler,"cc65 v 2.18 - Ubuntu 2.18-1"
	.setcpu		"65C02"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.export		_lcd_clearScreen
	.export		_lcd_isBusy
	.export		_print_str
	.export		_print
	.export		_init_lcd
	.export		_lcd_instruction
	.export		_lcd_portb_buffer

.segment	"DATA"

_lcd_portb_buffer:
	.byte	$00

; ---------------------------------------------------------------
; void __near__ lcd_clearScreen (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_lcd_clearScreen: near

.segment	"CODE"

	ldx     #$00
	lda     #$01
	jsr     _lcd_instruction
	ldx     #$00
	lda     #$02
	jmp     _lcd_instruction

.endproc

; ---------------------------------------------------------------
; unsigned char __near__ lcd_isBusy (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_lcd_isBusy: near

.segment	"CODE"

	stz     $6002
	lda     #$40
	sta     $6001
	lda     #$C0
	sta     $6001
	lda     $6000
	sta     _lcd_portb_buffer
	lda     #$40
	sta     $6001
	lda     _lcd_portb_buffer
	and     #$80
	ldx     #$00
	rts

.endproc

; ---------------------------------------------------------------
; void __near__ print_str (__near__ unsigned char *)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_print_str: near

.segment	"CODE"

	jsr     pushax
	jsr     decsp2
	ldy     #$03
	jsr     ldaxysp
	jsr     stax0sp
L006D:	jsr     ldax0sp
	sta     ptr1
	stx     ptr1+1
	lda     (ptr1)
	beq     L006E
	jsr     ldax0sp
	sta     ptr1
	stx     ptr1+1
	lda     (ptr1)
	jsr     _print
	ldx     #$00
	lda     #$01
	jsr     addeq0sp
	bra     L006D
L006E:	jmp     incsp4

.endproc

; ---------------------------------------------------------------
; void __near__ print (unsigned char)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_print: near

.segment	"CODE"

	jsr     pusha
L004F:	jsr     _lcd_isBusy
	tax
	bne     L004F
	dea
	sta     $6002
	lda     (sp)
	sta     $6000
	lda     #$20
	sta     $6001
	lda     #$A0
	sta     $6001
	lda     #$20
	sta     $6001
	jmp     incsp1

.endproc

; ---------------------------------------------------------------
; void __near__ init_lcd (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_init_lcd: near

.segment	"CODE"

	lda     #$FF
	sta     $6002
	sta     $6003
	ldx     #$00
	lda     #$38
	jsr     _lcd_instruction
	ldx     #$00
	lda     #$0E
	jmp     _lcd_instruction

.endproc

; ---------------------------------------------------------------
; void __near__ lcd_instruction (signed short)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_lcd_instruction: near

.segment	"CODE"

	jsr     pushax
L0022:	jsr     _lcd_isBusy
	tax
	bne     L0022
	dea
	sta     $6002
	lda     (sp)
	sta     $6000
	stz     $6001
	lda     #$80
	sta     $6001
	stz     $6001
	jmp     incsp2

.endproc

