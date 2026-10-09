.incld cop880.inc
;*****************************************************                                                                             ;*****************************************************
;*       NATIONAL SEMICONDUCTOR CORPORATION          *
;*        MICROCONTROLLER APPLICATION LAB            *
;*        FUERSTENFELDBRUCK, WEST GERMANY            *
;*                                                   *
;*         COP800  MICROCONTROLLER FAMILY            *
;*                                                   *
;* PROGRAMM NAME: EEPROM1.ASM                        *
;* SOURCE FILE  : EEPROM1.ASM                        *
;*                                                   *
;* OPERATION    : SERIEL COMUNICATION VIA MICROWIRE  *
;*                                                   *            
;*						     *                
;*                                                   *
;*                                                   *
;* PROGRAMMER   : ROBERT WEISS                       *
;* DATE         : 30/06/94                           *
;*                                                   *
;*****************************************************
;****************************************************************************
;
;Handle the serial communication via MICROWIRE of NM93C06/NM93C46 and COP8
;The source code includes all routines for the EEPROM communication
;
;****************************************************************************
;ERASEee:       Erase cell
;EWENee:	Erase write enable
;EWDSee:	Erase write disable
;ERALee:	Erase all cells
;WRALee:	Write into all cells
;WRITEee:	Write into cell
;READee:	Read data from cell
;uwinit:	MICROWIRE init.
;uwire: 	Activate MICROWIRE shifting
;busytest:	Check time it take to write date into the EEPROM
;****************************************************************************

EESIZE = 03F;				;checks address range of NM93C46
.sect basepage,BASE
writelow:	.dsb 1			;load byte from RAM and write it
writehigh:	.dsb 1			;into EEPROM
readlow:	.dsb 1			;Read byte from EEPROM and write it
readhigh:	.dsb 1			;into RAM
address:	.dsb 1			;EEPROM Address

.sect ram,RAM
status: 	.dsb 1			;Error register

.sect reg,REG
count1: 	.dsb 1
;***************************Only for test purpose****************************
.sect code,ROM
eeprom:
	LD	SP,#06F
	JSR	uwinit			;init. uwire interface
	LD	X,#writehigh		;pointed on high byte
	LD	address,#0
main:
	JSR	EWENee			;erase write enable
	LD	A,address
	JSR	WRITEee 		;write data into cell
	LD	A,address
	LD	X,#readhigh		;pointed on high byte
	JSR	READee			;read data from cell
	JSR	EWDSee			;erase write disable
wait:	JP	wait

;****************************************************************************
uwinit: 				;enable uwire interface,
	LD     B,#PORTGC
	SBIT   3,[B]			;configure G3 as Chip select
	SBIT   4,[B]			;configure G4 as output (SO)
	SBIT   5,[B]			;configure G5 as output (SK)
	LD     B,#CNTRL
	SBIT   3,[B]			;enable uwire, SK cycle time = 2tc
	RBIT   0,[B]
	RBIT   1,[B]
	RET

;****************************************************************************

uwire:					;activate uwire interface
	SBIT	3,PORTGD		;EEPROM select
uwire_1:LD	B,#PSW
	SBIT	BUSY,[B]		;start shifting
poll:	IFBIT	BUSY,[B]		;shifting active?
	JP	poll			;yes
	LD	B,#SIO
	RET				;no =>return
;****************************************************************************
EWENee: 				; enables erase and write commands

        ;EWEN has to presed erase and write commands
	LD	SIO,#001		; SIO loaded with "ewen hi"
	JSR	uwire
	LD	[B],#030		; SIO loaded with "ewen lo"
	JSR	uwire_1
	RBIT	3,PORTGD		; unselect esquare
   RET
;****************************************************************************
EWDSee: 				; disables erase and write commands
	LD	SIO,#001		; SIO loaded with "EWDS hi"
	JSR	uwire
	LD	[B],#000		; SIO loaded with "EWDS lo"
	JSR	uwire_1
	RBIT	3,PORTGD		; unselect esquare
   RET
;****************************************************************************
WRITEee:				; writes 2 bytes in esquare
	; Akku A content the address of the write location
	; Datahigh byte/datalow byte is in RAM
	; The content of the Akku A will be changed, the content of the
	; X-pointer stays the same

	LD	SIO,#001		; SIO loaded with "start bit"
	IFGT	A,#EESIZE		; if addr. is to high e.g 03F
	JMP	wrerror 		; Address error
	JSR	uwire			; shift start bit

	OR	A,#040			; modify akku->add opcode
	X	A,[B]			; SIO loaded with "write and addr."
	JSR	uwire_1 		; shift write+addr.

	LD	A,[X-]			; A loaded with data {hibyte}
	X	A,[B]			; SIO loaded with data {hibyte}
	JSR	uwire_1 		; shift data highbyte

	LD	A,[X+]			; A loaded with data {lobyte}
	X	A,[B]			; SIO loaded with data {lobyte}
	JSR	uwire_1 		; shift data lowbyte

	RBIT	3,PORTGD		; chip select disable
	JP	wriend			; goto write end {end of write subroutine}
   wrerror:				; label write error
	SBIT   0,status 		; set error flag
	RET
   wriend:				; end of write subroutine
	JSR    busytest
   RET
;****************************************************************************
readee: 				; read from esquare
	; Akku A content the address of the read location
	; Datahigh byte/datalow byte is in RAM
	; The content of the Akku A will be changed, the content of the
	; X-pointer stays the same
 
	LD	SIO,#003		; SIO loaded with startbit+1bit opc.
        IFGT    A,#EESIZE       	; if addr. to high
        JMP     reaerr                 	; goto read error
	JSR	uwire			; shift start code
	RC				; reset carry
	ADC	A,address		; rotate left, create dummy zero
	X	A,[B]			; write addr. into SIO
	JSR	uwire_1 		; shift opcode+adrress
	JSR	uwire_1 		; recieve highbyte
	X	A,[B]			; A loaded with data highbyte
	X	A,[X-]			; register loaded with data highbyte
	jsr	uwire_1 		; recieve lowbyte
	X	A,[B]			; A loaded with data lowbyte
	X	A,[X+]			; register loaded with data lowbyte
        RBIT    3,PORTGD        	; unselect esquare
	JP	reaend			; goto reaend {end of read subroutine}
   reaerr:				; label read error
	SBIT   0,status 		; set error flag
    reaend:				; end of read subroutine
   RET
;***************************************************************************

ERASEee:				; erase addr. content in esquare

	;Write address (which shall be erased) into register A
        
	LD	  SIO,#001		; SIO loaded with start bit
        IFGT    A,#EESIZE       	; if addr. is to high
        JMP     eraerr                 	; goto erase error
	JSR	uwire			; shift startbit
	OR	 A,#0C0 		; modify A (erase lo + addr.)
	X	   A,[B]		; SIO loaded with "erase lo + addr.)
	JSR	uwire_1 		; shift opcode+address
	RBIT	3,PORTGD		; unselect esquare
	JP	  eraend		; goto erase end {end of erase subroutine}
   eraerr:				; label erase error
	SBIT	0,status		; erase error
	RET
	JSR  busytest
   RET
;****************************************************************************
ERALee:                              	; erase all registers in esquare

	LD	SIO,#001		; SIO loaded with "erase all hibyte"
	JSR	uwire
	LD	[B],#020		; SIO loaded with "erase all lobyte"
	JSR	uwire_1
        RBIT    3,PORTGD        	; esquare unselected
	JSR	busytest
   RET
;****************************************************************************

  WRALee:                          	; write all registers in esquare

        ;Write the data hibyte in a ram register and the data lobyte
        ;(16 Bit data, which shall be written into the esquare) into 
	;the ram register below. The address of the ram register
	;storing the hibyte has to be written into the X register.
	;The content of the X pointer is not changed.

	LD	SIO,#001		; SIO loaded with "write all hi"
        IFGT    A,#EESIZE         	; if addr. is to high
	JMP	wraerr			; goto write all error
	JSR	uwire
	LD	[B],#010		; SIO loaded with "write all lo"
	JSR	uwire_1
	LD	A,[X-]			; A loaded with data {hibyte}
	X	A,[B]			; SIO loaded with data {hibyte}
	JSR	uwire_1
	LD	A,[X+]			; A loaded with data {lobyte}
	X	A,[B]			; SIO loaded with data {lobyte}
	JSR	uwire_1
        RBIT    3,PORTGD        	; unselect esquare
	JP	wraend			; goto write end {end of wral subroutine}
   wraerr:				; label write all error
	SBIT	0,status
   wraend:
   RET

;****************************************************************************
busytest:
	;check the time it takes for writing data into the EEPROM
	;max time is 10ms
	LD	count1,#0FF
	LD	B,#PORTGD
	SBIT	3,[B]
busy_1: IFBIT	6,PORTGP
	JP	ok
	JSR	watch			;avoid endless loop if EEPROM
	JP	busy_1			;is broken
ok:	RBIT   3,[B]
	RET
;****************************************************************************
watch:
	drsz	count1
	RET
	SBIT	1,status	;set error flag => EEPROM is broken
	RETSK
;***************************************************************************
.end  eeprom
