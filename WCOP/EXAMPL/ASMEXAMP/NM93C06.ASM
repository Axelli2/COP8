;**********************************************************************
;THIS PROGRAM PROVIDES IN THE FORM OF SUBROUTINES,THE ABILITY TO ERASE,
;Erase/Write enable, READ AND WRITE TO THE NM93C06 EEPROM.
;**********************************************************************
;
; EDITTED MAY 11, 1994 - REVISED FOR NEW ASSEMBLER (ASMCOP v4.2)
;
; Adapted to COP888(EK), or any other member of COP888xy feature
; family of Microcontrollers (ASMCOP V4.6)

	.TITLE	EE1,'Handling serial EEPROM with COP888 uC'
	.INCLD COP888EK.INC
	.INCLD GENCH.INC
	.PUBLIC EETASK
	.PUBLIC SNDBUF,RDATL,RDATH,WDATL,WDATH,ADRESS,EEFLAGS
	.PUBLIC DLYH,DLYL

	.EXTRN FLAG:BASE:BYTE


	.SECT  EE,RAM

EE1:	.DSB	8
	SNDBUF	=	EE1:BYTE; Contains EE-instruction
				; and EEPROM address,
				; (Command Byte)
	RDATH	=	EE1+1	; Stores Low-Byte read
				; from EE-Cell
	RDATL	=	EE1+2	; Stores Hi-Byte read
				; from EE-Cell
	ADRESS	=	EE1+3	; lower 4 bits contain
				; the EE-Adress
	WDATH	=	EE1+4	; Stores Hi-Byte to be
				; written into EE-Cell
	WDATL	=	EE1+5	; Stores Lo-Byte to be
				; written into EE-Cell
	EEFLAGS =	EE1+6	; Stores flags to control
				; proper handling of the
				; different instructions
				; from COP to EE.

	.SECT  EER,REG

EER1:	.DSB	2

	DLYL	=	EER1:BYTE ; Low Byte register and
	DLYH	=	EER1+1	  ; High Byte register to
	; run security timing.

     ;FLAG VALUE          ACTION
     ; 00                 ERASE,ENABLE,DISABLE,ERASE ALL
	; 01		  READ CONTENTS OF NMC9306 REG.
	; 02		  WRITE TO NMC9306 REGISTER
     ; OTHERS             ILLEGAL COMBINATION



;
;THE INTERFACE BETWEEN THE COP888EK AND THE NM93C06 (256-BIT EEPROM)
;CONSISTS OF FOUR LINES.THE G2(CHIP SELECT LINE),G4(SERIAL OUT SO),
;G5(SERIAL CLOCK SK )AND G6 (SERIAL IN SI ).
;########################################################################
;
	.SECT	EEINT,ROM
EETASK:
	LD	A,PORTGC	;Load current values form
				;PORTG Configuration register
	OR	A,#034		;Ensure G2,G4 and G5 Configu-
				;ration bits are set (Outputs)
	X	A,PORTGC	;Enable new values in Configu-
				;rayion register.
	Ld	A,PORTGD
	AND	A,00B		; make G2,G4 and G5 pins low
	X	A,PORTGD	; and maintain other register
				; settings.
	LD	A,CNTRL 	;ENABLE MSEL,SELECT
				;Micro Wire RATE OF 8TC
	OR	A,#00B		;and leave other CNTRL bits
	X	A,CNTRL 	;the same.

	LD	B,#PSW		; B-Pointer to PSW
	LD	X,#SIOR 	; X-Pointer to SIO Register
;
	IFBIT	CEWEN,FLAG
	JMP	EWEN		; Go and do Erase/Write en.
	IFBIT	CEWDS,FLAG
	JMP	EWDS		; Go and do Erase/Write dis.
	IFBIT	CERAL,FLAG
	JMP	ERAL		; Go and erase all registers
	IFBIT	CERASE,FLAG
	JMP	ERASE		; Go and perform an Erase
				; Cycle on one EE-Cell of
				; 16 Bits.
	IFBIT	CWRITE,FLAG
	JMP	WRITE		; Go and Perform a Write
				; Cycle into one 16-Bit
				; EE-Cell.
	IFBIT	CREAD,FLAG
	JMP	READ		; Go and perform a Read-
	RET			; Cycle from one 16-Bit
				; EE-Cell and save results.
;THIS RUOTINE ERASES THE MEMORY LOCATION POINTED TO BY THE ADRESS
;CONTAINED IN THE LOCATION ADRESS.THE LOWER NIBBLE OF THE "ADRESS"
;CONTAINS THE NMC9306 REGISTER ADDRESS. THE UPPRE NIBLE SHOULD BE
;SET ZERO.
;
;

ERASE:	LD	A,ADRESS	; Fetch EEPROM address,
	OR	A,#0C0		; fill in ERSAE-instruction
	X	A,SNDBUF	; and store in Send-buffer
	LD	EEFLAGS,#05	;DELAY BEFORE CS GOES LOW
     JSR     INIT

	JMP	ENDEE
;
;THIS ROUTINE ENABLS PROGRAMMING TO COP 494.PROGRAMMING MUST BE
;PRECEDED ONCE BY PROGRAMMING ENABLE (EWEN).
;
EWEN:	LD	SNDBUF,#030	; Put Command word into
			            	; SNDBUF
	LD	EEFLAGS,#00     	; and modify EEFLAG-word
     JSR     INIT
	JMP	ENDEE
;
;THIS ROUTINE DISABLES PROGRAMMING OF NMC9306.
;
EWDS:	LD	SNDBUF,#00	; Put Command word into
			            	; SNDBUF
	LD	EEFLAGS,#00     	; and modify EEFLAG-word
     JSR     INIT
	JMP	ENDEE
;
;THIS RUOTINE ERASES ALL REGISTERS OF NMC9306.
;
ERAL:	LD	SNDBUF,#020	; Put Command word into
			            	; SNDBUF
	LD	EEFLAGS,#05     	; and modify EEFLAG-word
     JSR     INIT
	JP     ENDEE
;
;THIS RUOTINE READS THE CONTENTS OF THE NMC9306 REGISTER.THE NMC9306
;ADDRESS IS SPECIFID IN THE LOWER NIBBLE OF LOCATION "ADDRESS".THE UPPER
;NIBBBLE SHOULD BE SET TO ZERO.THE 16-BIT CONTENTS OF NMC9306 REGISTER ARE
;STORED IN RDATL AND RDATH.
;
READ:
	LD	A,ADRESS	; Load EE-Address and
	OR	A,#080		; form Command word to
	X	A,SNDBUF	; be put into SNDBUF
	LD	EEFLAGS,#01	; set appropriate flag
	RBIT	SKSEL,PORTGC
	JSR	INIT		; and send/read.
	JP     ENDEE
;
;THIS WRITES A 16-BIT VALUE STORED IN WDATL AND WDADTH TO THE VOP 494
;REGISTER WHOSE ADDRESS IS CONTAINED IN THE LOWER NIBBLE OF THE
;LOCATION "ADRESS".THE UPPER NIBBLE OF THE ADDRES SHOULD BE SET TO ZERO.
;
WRITE:
	LD	A,ADRESS       ; Load EE-Address and
	OR	A,#040	     ; form Command word to
	X	A,SNDBUF       ; be put into SNDBUF
	LD	EEFLAGS,#03    ; set appropriate flag
	JSR	INIT	          ; and send/write.

ENDEE:
	LD	A,FLAG
	AND	A,#003	       ; Erase Action Flag
	X	A,FLAG	       ; and return
	RET
;
;THIS ROTINE SENDS OUT THE START BIT AND COMMAND BYTE.IT ALSO
;DECIPHERS THE CONTENTS OF THE ;FLAG LOCATION AND TAKES A DECISION
;REGARDING WRITE,READ OR RETURN TO THE CALLING RUOTINE.
;
INIT:
	LD	0F0,#0FF	; Load Counter to ensure,
				; that CPU not getting stucked
	SBIT	2,PORTGD	;SET CHIP SELECT HIGH(G2)
     LD      SIOR,#001       ;LOAD SIOR WHITH START BIT
     SBIT    BUSY,[B]        ;SEND OUT THE START BIT
				;Setting the BUSY-Flag causes
				;8 bits to be clocked from SIO-
				;Register


	JSR	PUNT1	      ; Go and test Busy Status,
	JP	CONT1	      ; proceed if ok,
	JMP	REINT	      ; Reinitialize if failing.
CONT1:
        LD      A,SNDBUF
        X       A,[X]         ; LOAD SIOR WITH COMMAND BYTE
        SBIT    BUSY,[B]      ; SEND OUT COMMAND BYTE

	JSR	PUNT1	      ; Go and test Busy Status,
	JP	CONT2	      ; proceed if ok,
	JMP	REINT	      ; Reinitialize if failing
CONT2:
	IFBIT	0,EEFLAGS	;ANY FURTHER PROCESSING ?
     JP      NOTDON      ;YES
	RBIT	2,PORTGD  	;NO, RESET CS AND RETURN
        RET
;
;               DO EXTRA PROCESSING HERE:
;
NOTDON:
     IFBIT	1,EEFLAGS	;READ OR WRITE ?
     JP        WR494     ;JMP TO WRITE ROUTINE
	IFBIT	2,EEFLAGS	;ERASE DELAY NEEDED ?
	JMP	     PUNT6	;YES
	LD	     SIOR,#000	;NO, DO READ NM93C06
;	 SBIT	 BUSY,PSW	;DUMMY CLOCK TO READ ZERO
;	 RBIT	 BUSY,PSW
	SBIT	SKSEL,PORTGC	; Change to alternate Clock
			     	; mode of microwire shifting
     SBIT    BUSY,[B]

	JSR	PUNT1		; Go and test Busy Status
	JP	PUNT3		; proceed if ok;
	JMP	REINT		; Reinitialize if failing
PUNT3:
	X	A,[X]		; Load [SIOR] into ACCU
	X	A,RDATH 	; Save Read Hi-Byte in RAM
	SBIT	BUSY,[B]	; Set Busy bit in order to
				; start and shift Low-Byte.
	JSR	PUNT1		; Go and test Busy Status
	JP	PUNT4		; proceed if ok;
	JMP	REINT		; Reinitialize id failing
PUNT4:
	LD	A,[X]		; Load [SIOR] into ACCU
	X	A,RDATL 	; Save Read Lo-Byte in RAM

	RBIT	2,PORTGD	; Make Chip-Select Low
	RET			; and RETURN
;
WR494:	LD	A,WDATH 	; Load Hi-Byte of value to
				; save in EE Cell into ACCU
	X	A,[X]		; and transfer into SIOR.
	SBIT	BUSY,[B]	; Initilaize Busy Bit and
				; start shifting 8 Bits.
	JSR	PUNT1		; Go and test Busy Status;
	JP	PUNT5		; proceed if ok;
	JMP	REINT		; Reinitialize if failing.
PUNT5:
	LD	A,WDATL 	; Load Lo-Byte of value to
	X	A,[X]		; save in EE Cell into ACCU
				; and transfer into SIOR

	SBIT	BUSY,[B]	; Initialize Busy Bit and
				; start shifting 8 Bits.
	JSR	PUNT1		; Go and test Busy Status;
	JP	PUNT6		; proceed if ok;
	JMP	REINT		; Reinitialize if failing.
PUNT6:
	RBIT	2,PORTGD	; make Chip-select low
	LD	DLYH,#002	; set security counters
	LD	DLYL,#0FF	; DLYL and DLYH
	SBIT	2,PORTGD	; set Chip-select high in
				; order to activate on CHIP
				; DC-DC converter.
;	JMP	TOUT		; Go and check if
				; programming is done.
;
;ROUTINE TO Check if Programming is over
;***************************************
;
TOUT:
	IFBIT	SI,PORTGP	; Check if programming
				; is activated.
	JP	DECDLY		; If so, wait until done.
	JP	DLYLOP		; stay in loop until
				; activated.
DECDLY:
	DRSZ	DLYL		; decrement security counter
	JP	TOUT		; and stay in loop.
	JMP	EEFAIL		; STOP if failed.
DLYLOP:
	IFBIT	SI,PORTGP	; Programming is success-
	JP	TERMDLY 	; fully activated; so wait,
DLOP:
	DRSZ	DLYL		; until busy Status goes
	JP	DLYLOP		; high. This is indicated
	DRSZ	DLYH		; with logical high on "DO"
	JP	DLYLOP		; (SI on COPs).


	JMP	EEFAIL		; If Security counter runs
				; out, the programmin time
				; is to long --> Failing.
TERMDLY:
	RBIT	2,PORTGD	; Terminate programming by
	RET			; resetting Chip-select.

; *** The following small routine tests if ***
; *** 8 bits of data are shifted by the    ***
; *** Micro-Wire block. 		   ***

PUNT1:	IFBIT	BUSY,[B]	; Check, if 8 bits are clocked
	JP	DECR		;Decrement the 'Safety Counter'
	RET			; Continue if 8 Bits through
DECR:
	DRSZ	0F0		;Decrementing this safety
	JP	PUNT1		;counter ensures, that no
				;endless loop.
	RETSK			;Return and skip if Busy
				;status unchanged.


EEFAIL:
	NOP
	JP	EEFAIL


REINT:
	NOP
	JP	REINT
        .END
