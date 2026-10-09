;***************************************************************************
;National Semiconductor Corporation
;Microcontroller Application Lab, FFB Germany
;Programmer: Siggi Rueth/Robert Weiss
;Last Revision: 09/17/93
;****************************************************************************
;*									    *
;*	       Software UART						    *
;*									    *
;****************************************************************************
;UART features: 9600 Baud(COP cycle time 2us), 1 start bit, 8 Daten bit,
;even parity, 1 stop bit.
;****************************************************************************
;All time-critical routines are written for 2us cycle time. If other clock
;rates are used the routines must be changed!
;****************************************************************************
;
;
;       ************************************
;       *                                  *
;	*	REGISTER-Definition	   *
;	*			           *
;	************************************
;
;			
	COUNT  = 0F0		; General purp. counter
	COUNT1 = 0F1		; One bit counter
	COUNT2 = 0F2		; Counter for delay
;
	PARI1  = 0F3		; Control flag for parity test
	PARI2  = 0F4		; Parity flag
;
	ERROR  = 0FA		; Error flag for parity testing
;
	INSER1 = 000		; Register for recieved byte
	OUTSER = 001		; Transmit Register
;
	ZW     = 002		; Temp. memory
	ZWI    = 003		; Temp. memory
	ZW2    = 004		; Temp. memory
;
;
	STACK  = 02F		; Top of stack
;
	ANZ    = 8		; Counter for loop
;
;****************************************************************************
.incld cop820.inc
.sect code,ROM,abs=0
POWRUP:
	LD	SP,#STACK	; STACKPOINTER INIT.
;****************************************************************************
;	       Init Receive routine
;****************************************************************************
	LD	ERROR,#0	; CLEAR ERROR FLAG
	LD	B,#PORTGC
	LD	[B-],#010	; Conf. Portg0 as input with Pull up
	LD	[B],#001	; Conf. Portg4 as push pull zero output
	LD	B,#CNTRL
	LD	[B+],#004	; External interr. falling edge
	LD	[B],#003	; Enable external interr at G0
;****************************************************************************
;Send byte via software uart: Byte -> OUTSER, JSR SENDUA
;Receive Byte via software uart: Interr. controlled -> ext. interr.
;***************************************************************************
WAIT:   JP      WAIT
;
;**************************** Begin Send Routine ***************************
SENDUA: 			; Transmit routine
	LD	B,#OUTSER	;
	LD	A,[B]		;

	JSR	PARITY		; Subroutine for Parity handling

	X	A,PARI1 	; Store Parity bit
;
	JSR	SEROUT		; SEND BYTE
	RET
;
;*********************************
;
; ====	Transmit Routine     ====
;
;*********************************
;
;
SEROUT:
	LD	COUNT,#ANZ	; ANZ = 8
	LD	X,#PORTGD	; G OUTPUT PORT
	RBIT 	#4,PORTGD	; STARTBIT ...
	LD	COUNT2,#3
	JSR	DEL		; ... Transmit
	NOP
;
	LD	A,[B]		; Load Transmit Byte
	LD	COUNT2,#3	;
NEXTO:
	JSR	OUTBIT		; Transmit
	LD	COUNT2,#3
	DRSZ	COUNT		; 8 BITS transmitted ?
	JP	NEXTO		; No
;
	LD	COUNT2,#5	;Yes
	LD	A,PARI1 	;
	JSR	OUTBIT		; Send Parity bit
;
	LD	COUNT2,#7
	LD	A,#1		; 1 STOP BIT transmit
	JSR	DEL1		; DUMMY, Delay
	NOP
	NOP
	NOP
	NOP	
	.FORM
;
;---------------------------------------------
;
;	1 BIT Transmit Routine (PORTGP4)
;
;---------------------------------------------
;
OUTBIT:
	RRCA			; Rotate bit -> Carry
	IFC
	JP	SETBIT		; PORT BIT G4 -> HIGH
	JP	RESBIT		; PORT BIT G4 -> LOW
;
;----------------------------
;
;	SET G4 BIT
;
;----------------------------
;
SETBIT:
	NOP
	SBIT	#4,PORTGD	; PORT BIT G4 = HIGH
	JSR	DEL
	RET
;
;----------------------------------
;
;	RESET G4 BIT
;
;----------------------------------
;
RESBIT:
	RBIT	#4,PORTGD	; PORT BIT G4 = LOW
	JSR	DEL
	RET
;
;
;***********************************
;
; ====  EVEN PARITY ROUTINE  ====
;      ACCESS TIME : 288 YS
;
;***********************************
;
PARITY:	
	LD	COUNT1,#0	; ONE BITS COUNTER
	LD	COUNT,#ANZ	; ANZ = 8
PAR:
	RC			
	RRCA			; Rotate right -> Carry
	X	A,COUNT1
	IFC			; IF Bit set
	INCA			; T+1
	X	A,COUNT1
	DRSZ	COUNT		; 8 BITS ?
	JP PAR			; NO
	LD	A,COUNT1	; YES, ANZ. D. ONE BITS
	AND	A,#1		;
	RET
;******************************* End Send Routine ***************************
;
;
;
	.=X'0FF
;
;**********************************
;
; ****	INTERRUPT HANDLING  *******
;
; ****	 Recieve routine    *******
;
;**********************************
;
;	
SERIN:	
	X	A,ZW2		; Save accu
	LD	COUNT,#ANZ	; Counter for loops
	LD	X,#PORTGP	; Pointer for Port pin G0
	LD	B,#INSER1	; Pointer for input register
	LD	[B],#0		; CLEAR INSER1  
	LD	PARI2,#0	; CLEAR REGISTER
;
	IFBIT	#0,PORTGP	; Check if startbit ?
	JMP	RETURN		; No Startbit, go back
;
	NOP			; Delay
	NOP
	LD	COUNT2,#005
	JSR	DEL		; 1 BAUD TIME DELAY
NEXTB:
	LD	A,[X]		; Read portgp 0
	X	A,ZWI		; Store
	LD	A,ZWI		;
	RRCA			; Rotate through the carry
	CLRA
	RRCA			; INPUT BIT -> A7
	X	A,[B]		; NEW BIT->RAM,RAM->ACC
	X	A,ZW		; SAVE ACC
;
	LD	A,ZWI		; Build parity
	XOR	A,PARI2 	;
	X	A,PARI2		; SAVE IT
;
	LD	COUNT2,#001	; Delay
	JSR	DEL1		;
	LD	A,ZW		; Load old contents of INSER1
	RC			; Reset carry
	RRCA
	OR	A,[B]		; Add new bit
	X	A,[B]		; Store new contents in INSER1
;
	DRSZ	COUNT		; If 8 bit recieved?
	JP	NEXTB		; No
;
;---------------------------------------
;
;  ---	PARITY Checking  ---
;
;  ---	Receive Routine  ---
;
;---------------------------------------
;
	LD	A,[X]		; BIT #0 = PARITY BIT
;
	AND	A,#1		;
	X	A,PARI1		; PARITY -> RAM
;
	LD	A,PARI2 	; LOAD BUILD PARITY
	AND	A,#001		; SELECT PARITY BIT
	X	A,PARI2		; SAVE IT
;
	LD	A,PARI2
	XOR	A,PARI1 	; <A>=0 ?
;
	RRCA			; BIT -> CARRY
	X	A,ERROR 	; Store Error flag
	RRCA			; Move Carry in the Flag
	X	A,ERROR		; PARITY ERROR -> RAM
;
;
RETURN:
	LD	PSW,#002	;
	LD	A,ZW2		; Accu restore
        RETI
;
;
;
;***************************
;
; ====  DELAY ROUTINE  ====
;
; ====	  For both     ====
;
;***************************
;
; DELAY TIME[YS]=(6*COUNT2+5)*2+2*5
;
;
; DELV Time is 104ms
;
DELV:
	LD	COUNT2,#7
;
DEL:
	DRSZ	COUNT2		; COUNT DOWN
	JP	DEL
;
DEL1:
	RET
;

	.END POWRUP

  



