.chip COP888EG
.incld main.inc
.sect REGISTER,REG
COUNT1: 	.dsb 1
.endsect
	.EXTRN Subroutine		;Subr. from ext. module

.sect code1,rom
init:
	JSR	Subroutine		;Call subr from ext. module
	LD	CNTRL,#B'10100000	;PWM Mode, T1A Toggle
	LD	TMR1LO,#L(1000)	;1ms, tc =1us
	LD	TMR1HI,#H(1000)
	LD	T1RALO,#L(500)		;0.5ms
	LD	T1RAHI,#H(500)
	LD	T1RBLO,#L(1000)
	LD	T1RBHI,#H(1000)
	RBIT	3,PORTGD
	SBIT	3,PORTGC
	LD	PSW,#B'00010001	;Enable GIE,T1ENA
	SBIT	4,CNTRL			;Start Timer T1
WAIT:	JSR	DELAY
	JSR	TOGGLE
	JP	WAIT
.endsect
;
;******Interrupt handler*******
.sect intr,rom,abs=0xff
	RBIT	5,PSW			;Reset Timer T1A pending flag
	LD	A,PORTD
	XOR	A,#001			;Toggle Port D0, 1.5ms
	X	A,PORTD
	RETI
.endsect
;******************************
.sect delay,rom
DELAY:	LD	COUNT1,#0FF
LABEL1: DRSZ	COUNT1
	JP	LABEL1
	RET
.endsect
;*******************************
.sect toggle,rom,abs=0x200
TOGGLE: LD	A,PORTD
	XOR	A,#002
	X	A,PORTD
	JSR	DELAY
	RET
.endsect
;******************************
.end init
