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
	.forceimport	__STARTUP__
	.import		_lcd_clearScreen
	.import		_print_str
	.import		_init_lcd
	.export		_myInt
	.export		_numberString
	.export		_outputString
	.export		_size
	.export		_main

.segment	"DATA"

_myInt:
	.word	$FFFF

.segment	"RODATA"

L000A:
	.byte	$32,$00
L000E	:=	L000A+0
L0007:
	.byte	$31,$00

.segment	"BSS"

_numberString:
	.res	5,$00
_outputString:
	.res	40,$00
_size:
	.res	2,$00

; ---------------------------------------------------------------
; int __near__ main (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_main: near

.segment	"CODE"

	jsr     _init_lcd
	lda     #<(L0007)
	ldx     #>(L0007)
	jsr     _print_str
	lda     #<(L000A)
	ldx     #>(L000A)
	jsr     _print_str
	jsr     _lcd_clearScreen
	lda     #<(L000E)
	ldx     #>(L000E)
	jsr     _print_str
L0016:	bra     L0016

.endproc

