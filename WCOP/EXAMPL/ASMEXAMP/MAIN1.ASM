
;      *** ---------------------------------- ***
;      ***      COP884EK Testprogram for      ***
;      ***        PWM-Control and A/D         ***
;      ***       Timing and Processing        ***
;      ***            Main Program            ***
;      ***                                    ***
;      ***    ----------------------------    ***
;      ***    Vers.:       1.0                ***
;      ***    Date:        Nov. 1996          ***
;      ***    Author:      Siegfried Rueth    ***
;      *** ---------------------------------- ***

; ** The following program is dedicated to test   ***
; ** PWM Control techniques and A/D processing    ***
; ** in COP884EK                                  *** 


                .INCLD  COP888EK.INC
		      .INCLD	GENCH.INC
; ** Declaration of constants used in main program **

; Flag1 word BITs:

         VCC2   =       0    ; Flag to indicate, that
                             ; Vcc/2 Ref. is measured
         T16    =       1    ; Flag-bit to indicate that
                             ; Time-cycle counter has
                             ; passed 16                    

;  **** The following Flags are only used for ****
;  **** 	  EE  -  Routines	      ****

; *** Declaration of RAMs and Variables ***

        .PUBLIC FLAG,LDAT,GDAT,DDAT,IREG,PWMCONT
        .PUBLIC TEMP1,TEMP2,TEMP3

        .PUBLIC ADVOLTL,ADVOLTH,ADVPREL,ADVPREH
        .PUBLIC ADCURRL,ADCURRH,ADCPREL,ADCPREH
        .PUBLIC ADTEMPL,ADTEMPH,ADTPREL,ADTPREH
        .PUBLIC ADVCC2L,ADVCC2H,AD2PREL,AD2PREH
        .PUBLIC CONT17
        
        .EXTRN PWGEN,PWHI,PWLO              ; in Module "PWM1"
        .EXTRN DOATOD,PROCAD,ENDAD,ADVCC2   ; in Module "AD1"
	.EXTRN EETASK,ADRESS		         ; in Mod. NM93C06
	.EXTRN WDATL,WDATH,RDATL,RDATH	    ; in Mod. NM93C06

        .SECT   KEYVAR,BASE,ABS=008

KEYX:   .DSB    8

        FLAG    =  KEYX:BYTE   ;General purpose Flag-Byte
        LDAT    =  FLAG+1      ;holds Ldata-reg.Bits
        GDAT    =  FLAG+2      ;holds Gdata-reg.Bits
        DDAT    =  FLAG+3      ;holds Ddata-reg.Bits
        IREG    =  FLAG+4      ;holds I-input Bits
        PWMCONT =  FLAG+5      ;Holds the pointer for table-
                               ;lookup (PWM Hi-Low Bytes)

        .SECT   ADC,RAM,ABS=020

ATOD:   .DSB    16

        ADVOLTH  =  ATOD:BYTE  ; Hi -Byte of V - AD
        ADVOLTL  =  ATOD+1     ; Low-Byte of V - AD
        ADVPREH  =  ATOD+2     ; Previous Hi- Byte V
        ADVPREL  =  ATOD+3     ; Previous Low-Byte V
        ADCURRH  =  ATOD+4     ; Hi -Byte of I - AD
        ADCURRL  =  ATOD+5     ; Low Byte  of I - AD
        ADCPREH  =  ATOD+6     ; Previous Hi- Byte I
        ADCPREL  =  ATOD+7     ; Previous Low Byte I
        ADTEMPH  =  ATOD+8     ; Hi-Byte of T - AD
        ADTEMPL  =  ATOD+9     ; Low-Byte of T - AD
        ADTPREH  =  ATOD+10    ; Previous Hi- Byte T
        ADTPREL  =  ATOD+11    ; Previous Low-Byte T
        ADVCC2H  =  ATOD+12    ; Hi -Byte of Vcc/2-AD
        ADVCC2L  =  ATOD+13    ; Low-Byte of Vcc/2-AD
        AD2PREH  =  ATOD+14    ; Prev. Hi -Byte Vcc/2
        AD2PREL  =  ATOD+15    ; Prev. Low-Byte Vcc/2


        .SECT   GPREG,REG,ABS=0F0

GPCONT: .DSB    4

        
        TEMP1    =  GPCONT+2    ; Temporary usage Regs
        TEMP2    =  GPCONT+3
        TEMP3    =  GPCONT+4
        CONT17   =  GPCONT+5    ; Time base cycle counter


        .ENDSECT
                .FORM

        .PUBLIC RESET
        .SECT   RESET,ROM,ABS=000 ; Main program

; *** First part of the main program is ***
; *** ------ INITIALIZATION ----------- ***

RESET:
        LD      SP,#06F         ; Load stack-pointer

        LD      B,#000          ; B-points first RAM
        LD      TEMP1,#06F      ; Load loop counter
CLLOOP:
        CLR     A               ; Clear all
        X       A,[B+]          ; RAM
        DRSZ    TEMP1
        JP      CLLOOP          ; loop until done
        X       A,[B]

        LD      PORTGC,#03F     ; INIT G-Port
        LD      PORTGD,#000     ; G0/G1/G2=W.-pup
        LD      PORTLC,#0FF     ; INIT L-Port
        LD      PORTLD,#000
        LD      PORTCC,#0FF     ; INIT C-Port
        LD      PORTCD,#000
        LD      PORTD,#000      ; Set D-pins high
                                ; > all LEDs = Off

        LD      CNTRL,#0A9      ; Init Control Reg.
        

; *** ------------------------------------------- ***
; *** Following bits are initially set in "CNTRL" ***
; *** Register:                                   ***
; ***          1 0 1  0  1  0  0 1                ***
; ***          -----  -  -  -  ---
; ***  these combination does the following:      ***
; ***                                             ***
; ***   - sets timer to TIMER W/Auto-Load Reg.    ***
; ***     toggling T1A on each underflow of T1.   ***
; ***     =========>    PWM                       ***
; ***   - Timer = STOP                            ***
; ***   - Microwire enabled                       ***
; ***   - (external interrupt edge 'rising')      ***
; ***   - uWire SK cycle = 4 x Tc                 ***
; *** ------------------------------------------- ***
                .FORM
        LD      PSW,#000      ; Init Processor Status

; *** ------------------------------------------- ***
; *** Following bits are initially set in " PSW " ***
; *** Register:                                   ***
; ***          0 0 0 1 0 0 0 0                    ***
; ***          - - - - - - - -                    ***
; ***  this combination does the following:       ***
; ***                                             ***
; ***   - Carry/Half-carry = 0                    ***
; ***   - timer int. pending = 0                  ***
; ***   - timer int. disabled                     ***
; ***   - external int. pending = 0               ***
; ***   - uWire shifting disabled                 ***
; ***   - external int. = disabled                ***
; ***   - Global int. = disabled                  ***
; *** ------------------------------------------- ***

	LD	B,#0FB	      ; Clear registers
REGLOP:
	CLR	A	      ;  0F0
	X	A,[B-]	      ; through
	IFBNE	#0F	      ;  0FB
        JP      REGLOP
        
	Ld	ADRESS,#005
	SBIT	CEWEN,FLAG    ; Go and ERASE/WRITE
	JSR	EETASK	      ; enable the EEPROM

	SBIT	CERASE,FLAG   ; Go and erase register 5
	JSR	EETASK


	SBIT	CWRITE,FLAG   ; Set Flag to write into EE
	Ld	WDATL,#0CD    ; load the low byte with AB
	Ld	WDATH,#0AB    ; load the hi Byte with CD
	JSR	EETASK	      ; Go and write to register 5
;LOPTES:
	SBIT	CREAD,FLAG    ; Set READ Flag
	JSR	EETASK

; when returning from EEPROM Tasks the RAM-Location
; "RDATL" should contain "AB" and the RAM-Location
; "RDATH" should contain "CD".


;***************************************************
;	 JP	 LOPTES 	; Make Breakpoint
		 ; here to check, if EEPROM data
		 ; properly programmed and read!!!
		 ; Before, remove colon on the label
		 ; LOPTES and on the instruction:
		 ; JP	LOPTES.
;***************************************************


        Ld      PWMCONT,#01     ; Initialize PWM-Counter
        LD      CONT17,#17      ; Init Basic Loop-
                                ; Counter
        JSR     INTIM3          ; Init time base counter
                                ; Timer T3 autoreload
                                ; Registers              

        LD      T3CNTRL,#0A4    ; Timer 3 selected as
                                ; Time base counter
                                ; mode: PWM with
                                ; toggling T3A ( to test
                                ; time base)

        SBIT    T3C0,T3CNTRL    ; START Timer T3
        SBIT    GIE,PSW         ; Set Global Int.-
                                ; Enable
        Ld      PWMCONT,#0
        
        
; *** End of initialization ***

;               .FORM


;                M   A   I   N
;                =============


; *** Below is the Main-Loop of this test-software  ***
; *** The T3 TIME-BASE COUNTER INTERRUPT is enabled ***
; *** and the time from one interrupt to the next   ***
; *** is about 33msec long. Upon occurence of a T3  ***
; *** Timer interrupt A/D conversions are done on   ***
; *** the 3 A/D Channels I0,I2 and I3. At the very  ***
; *** first cycle the Vcc/2 reference is measured   *** 
; *** as well.

MAIN:
        NOP                     ; This is the main loop.
        IFBIT   T16,FLAG        ; It is checked whether
        JSR     ALGORIT         ; the time-cycle counter
        JP      MAIN            ; has passed 0 (16 A/D
                                ; events have taken place)
ALGORIT:
        JSR     CALCALG         ; in the 17th cycle a new 
                                ; duty cycle will be 
                                ; calculated.
        JSR     PWF1            ; Go and fetch Hi-Low times.
                                ; Initialize Timer T3 regs
        RBIT    T16,FLAG        ; Reset Cycle counter Flag 
        RET
                


;         I   N   T   E   R   R   U   P   T  
;         =================================
;                     Service 



        .=X'0FF         ; Assign PC for Int.-Vector



        NOP
        IFBIT   T3PNDA,T3CNTRL  ; Test if timer T3 interrupt
        Jp      TIMCONTR        ; is pending
                                ; no other interrupts enabled
        NOP
        IFBIT   TPND,PSW        ; Test for T1 interrupt (not
        JP      REST1           ; enabled here).

        JMP     RESET           ; If S/W-Trap, Jump to reinit  
REST1:
        RBIT    TPND,PSW        ; do not procedd T1 interrupt
        NOP                     ; here
RTI:
        RETI                    ; Return from Int., 
                                ; reenable GIE
TIMCONTR:
        DRSZ    CONT17          ; decrement time base counter
        JP      DOATOD1         ; and do AtoD if not passed 16.
        LD      CONT17,#17      ; Reinit cycle counter
        JSR     ENDAD           ; Process A/D
        ;when returned from Subroutine, the accumulated A/D
        ;results have been processed and the average Hex values
        ; are residing now in RAM Locations:
        
        
;        ADVPREH  =  ATOD+2     ; High Byte V
;        ADVPREL  =  ATOD+3     ; Low Byte V
;        
;        ADCPREH  =  ATOD+6     ; High Byte I
;        ADCPREL  =  ATOD+7     ; Low Byte I
;        
;        ADTPREH  =  ATOD+10    ; High Byte T
;        ADTPREL  =  ATOD+11    ; Low Byte T
;        
;        AD2PREH  =  ATOD+14    ; High ByteVcc/2
;        AD2PREL  =  ATOD+15    ; Low Byte Vcc/2
         
        
        SBIT    VCC2,FLAG       ; Set Flag to indicate,
                                ; that Vcc/2 is measured
        SBIT    T16,FLAG        ; Set "16 Cycles Flag"
        RBIT    T3PNDA,T3CNTRL  ; Reset T3 interrupt 
        JP      RTI             ; pending flag
DOATOD1:
        JSR     DOATOD          ; Go and do AtoD

        JSR     PROCAD          ; Process results
        RBIT    T3PNDA,T3CNTRL  ; Reset T3 Interrupt
        JP      RTI             ; pending flag.



;  ****** S  U  B  R  O  U  T  I  N  E  S ******



        
PWF1:
       
        JSR     PWGEN           ; Go and get PWM
                                ; Values
        RBIT    T1C0,CNTRL      ; Stop Timer  
                              
        Ld      B,#T1RALO       ; Point T1 Autoreload Register
                                ; T1RALO with the B-Pointer
        Ld      X,#PWHI         ; Point the Location containing
                                ; the Low timer info with X.

        Ld      A,[X+]          ; Ld Hi-Value into accu
        X       A,[B+]          ; Store in low byte of Timer1
                                ; autoreload register T1RA (low)
        Ld      [B+],#0         ; Ensure high byte T1RA = 0
        
        Ld      B,#T1RBLO       ; Point T1 Autoreload Register
                                ; T1RBLO with the P-Pointer
        Ld      A,[X]           ; Ld Low-value into Accu



        X       A,TMR1LO        ; Store low time into
        CLR     A               ; Timer T1
        X       A,TMR1HI

        Ld      A,[X]           ; Ld low value again

        X       A,[B+]          ; Store in low-byte of Timer1
                                ; autoreload register T1RB (low)
        Ld      [B],#0          ; Ensure high byte T1RB = 0
        
        RBIT    3,PORTGD        ; Ensure T1RA controls high time
                                ; ***** VERY IMPORTANT !!!
        SBIT    T1C0,CNTRL      ; Start Timer
        RET                        

INTIM3:
        Ld      T3RALO,#047     ; Set Autoreload values
        Ld      T3RAHI,#040     ; in timer autoregisters
        Ld      T3RBLO,#047     ; of timer T3 (in order to
        Ld      T3RBHI,#040     ; generate 33msec cycles)
        RET
CALCALG:
        Ld      A,PWMCONT       ; Increase PWMCONT
        INC     A               ; By   1
        IFEQ    A,#247          ; (check if boundary)
        Ld      A,#0            ; each time passing through
        X       A,PWMCONT       ; here.
        RET                                         
        
                     .ENDSECT
                     .END  RESET




