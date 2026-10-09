.TITLE FLOAT800
.CHIP 820
; revised by Volker Soffel
; March 05, 1993
; fixed bug in divide routine that caused faulty result for
; some 32 bit divisions
;
; DATE: APRIL 11,1988
; WRITTEN BY: JERRY LEVENTER
;
; THE FOLLOWING ROUTINES PERFORM MULTI-BYTE, BINARY
; ADD, SUBTRACT, MULTIPLY, AND DIVIDE.  ALL ROUTINES
; ARE FLOATING POINT AND ASSUME AN N-BYTE OPERAND,
; A BINARY POINT, AND A SIGN BIT.  THE BINARY POINT
; INDICATES THE POSITION AFTER WHICH THE OPERAND
; BITS REPRESENT FRACTIONAL ELEMENTS. FOR INSTANCE, A
; BINARY POINT OF ZERO INDICATES THAT NO BITS ARE FRAC-
; TIONAL.  A BINARY POINT OF ONE INDICATES THAT THE
; LEAST SIGNIFICANT BIT OF THE OPERAND IS FRACTIONAL.
; A BINARY POINT OF N*8 INDICATES THAT THE ENTIRE
; OPERAND IS FRACTIONAL. (N = 2 OR 4).
;
; THESE ROUTINES WILL RUN ON ALL COP 800 DEVICES WHICH
; INCLUDE THE COP820C/840C, THE COP888CF, THE COP888CG,
; AND THE COP888CL.
;
; THE OPERANDS MUST BE TWO (OR FOUR) BYTES IN LENGTH FOR
; 16 BIT (OR 32 BIT) OPERATIONS. TO CHANGE FROM 32 BIT
; OPERATIONS TO 16 BIT OPERATIONS, SIMPLY REASSIGN THE
; VARIABLE "BYTES" TO A VALUE OF TWO INSTEAD OF FOUR.
;
; FOR FURTHER INFORMATION REGARDING THE BINARY POINT
; REGISTERS, SIGN BIT REGISTER, OPERATION SELECTION FLAG
; REGISTERS, OPERAND MEMORY LOCATIONS AND OVERFLOW, REFER
; TO THE COMMENTS IN THE FOLLOWING SECTIONS.


        ; FLOAT800.MAC
        ; REGISTER ASSIGNMENTS

        CNTR    =0F0            ; COUNTER REGISTER
        BYTES   =4              ; OPERAND LENGTH

        ; DIVISION REGISTERS

        DVMSB   =01             ; DIVISOR LSB
        DVLSB   =DVMSB+BYTES-1  ; DIVISOR MSB

        DDMSB   =DVLSB+BYTES+1  ; DIVIDEND MSB
        DDLSB   =DDMSB+BYTES-1  ; DIVIDEND LSB

        QMSB    =DDMSB          ; QUOTIENT MSB
        QLSB    =DDLSB+BYTES    ; QUOTIENT LSB

        DDBP    =QLSB+2         ; DIVIDEND BIN POINT REG
        DVBP    =DDBP-1         ; DIVISOR BIN POINT REG
        QBP     =DDBP           ; QUOTIENT BIN POINT

        SIGNREG =DDBP+1         ; SIGN STATUS REGISTER
        OPFLAG  =SIGNREG+1      ; OPERATION FLAG REG
        ADDFLG  =SIGNREG+2      ; ADD OR SUB FLAG REG

        MLTSIGN =SIGNREG        ; MULTIPLY SIGN REGISTER
        DIVSIGN =SIGNREG        ; DIVISION SIGN REGISTER
        ADSIGN  =SIGNREG        ; ADD/SUB SIGN REGISTER

        BPXT    =DDLSB+1        ; FRACTIONAL EXTENSION

        ; CONSTANTS

        DIVCOUNT=BYTES*16       ; DIVIDE SHIFT COUNT

        DDSN    =1              ; DIVIDEND SIGN BIT
        DVSN    =0              ; DIVISOR SIGN BIT
        QSN     =DDSN           ; QUOTIENT SIGN BIT

        ; MULTIPLICATION REGISTERS

        MCMSB   =01             ; MULTIPLICAND MSB
        MCLSB   =MCMSB+BYTES-1  ; MULTIPLICAND MSB

        PMSB    =MCLSB+1        ; PRODUCT MSB
        PLSB    =PMSB+BYTES*2-1 ; PRODUCT LSB
        PCLR    =PMSB+BYTES-1   ; UPPER HALF, PRODUCT

        MPMSB   =PCLR+1         ; MULTIPLIYER MSB
        MPLSB   =MPMSB+BYTES-1  ; MULTIPLIER LSB

        MCBP    =DDBP           ; MULTIPLICAND BINARY POINT
        MPBP    =DVBP           ; MULTIPLIER BINARY POINT
        PBP     =MCBP           ; PRODUCT BINARY POINT


        ; CONSTANTS

        COUNTM  =(BYTES*8)+1    ; MULTIPLY SHIFT COUNT

        MCSN    =DDSN           ; MULTIPLICAND SIGN BIT
        MPSN    =DVSN           ; MULTIPLIER SIGN BIT
        PSN     =MCSN           ; PRODUCT SIGN BIT

        ; ADDITION/SUBTRACTION ASSIGNMENTS

        XMSB    =01             ; MSB OF X
        XLSB    =XMSB+BYTES-1   ; LSB OF X
        RSLT    =XLSB           ; RESULT FOR ADD OR SUB

        YMSB    =XLSB+1         ; MSB OF Y
        YLSB    =YMSB+BYTES-1   ; LSB OF Y

        BPX     =YLSB+1         ; BINARY POINT FOR X
        BPY     =BPX+1          ; BINARY POINT FOR Y
        RBP     =BPX            ; RESULT BINARY POINT

        ; CONSTANTS

        XMSBIT  =07             ; UPPER BIT OF OPERAND
        YMSBIT  =07

        XSN     =DDSN           ; X SIGN BIT
        YSN     =DVSN           ; Y SIGN BIT
        RSN     =XSN            ; RESULT SIGN BIT

        ADSUB   =0
        ADD     =0              ; FLAG BITS
        SUB     =1
        MULT    =1

        .FORM

; BEGIN PROGRAM HERE

        LD      SP,#02F         ; INITIALIZE SP
;---------------------------------------------------------
; OPERATION SELECTION
; TESTS THE OPERATION FLAG (OPFLAG) FOR ADD/SUB, MULT
; OR DIVIDE.
;
;
; OPFLAG: 16 BIT: M(C)    32 BIT: M(013)
;            _______________________________
;           |              |MLT/DIV| ADD/SUB|
;            -------------------------------
;            7      ...        1           0
;
; BIT 0 SET: BRANCHES TO ADDSUB (WHERE THE BIT ONE
;            IS TESTED.
; BIT 0 RESET: TESTS BIT 2 FOR MLT/DIV.
; BIT 2 SET/RSET: BRANCHES TO MULTIPLY/DIVIDE.
;
;
; ADDFLG: 16 BIT: M(D)    32 BIT: M(015)
;            _______________________________
;           |               |ADD/SUB|   X   |
;            -------------------------------
;            7       ...       1          0
;
;  BIT 1 SET: DO SUBTRACTION.
;        RESET: DO ADDITION.
;
;---------------------------------------------------------
SELECT: LD      B,#OPFLAG       ; TEST FOR ADD/SUB ?
        IFBIT   ADSUB,[B]
        JP      ALIGN           ; YES: DO ALIGNMENT
        IFBIT   MULT,[B]        ; NO: TEST FOR MULT ?
        JMP     MLTPLY          ; DO MULTIPLY
        JMP     DIVIDE          ; DO DIVIDE
;----------------------------------------------------------
; ALIGNMENT OF BINARY POINTS FOR ADD/SUB:
; MOST SIGNIFICANT BYTE (MSB) RESIDES AT THE LOW END IN
; RAM MEMORY.
; ADD/SUB RESULT RESIDES IN RESPECTIVE X LOCATIONS.
;
; RAM MAP FOR 16 X 16 ADD/SUB:
;
;    M(1)   M(2)   M(3)   M(4)   M(5)  M(6)    M(B)
;  ---------------------------------------------------
;    XMSB   XLSB   YMSB   XLSB   XBP   YBP   XSN/YSN
;   (RSLT) (RSLT)               (RBP)       (RSN/---)
;
; NOTE: XSN = BIT 1  ADSIGN
;       YSN = BIT 0  ADSIGN
;
;                ***********************
;
; RAM MAP FOR 32 X 32 BIT ADD/SUB:
;
;    M(1) ... M(4)   M(5) ... M(8)   M(9)  M(A)   M(13)
;   -----------------------------------------------------
;    XMSB     XLSB   YMSB     YLSB   XBP   YBP   XSN/YSN
;   (RSLT)   (RSLT)                 (RBP)       (RSN/---)
;
;----------------------------------------------------------
ALIGN:  LD      B,#BPY          ; TEST BINARY POINTERS
        LD      A,[B-]
        IFEQ    A,[B]           ; TEST IF BPX = BPY ?
        JMP     ADDSUB          ; YES: DO ADD/SUB
        IFGT    A,[B]           ; NO: IS BPY > BPX ?
        JP      BPYGTX          ; YES

BPXGTY: LD      B,#YMSB         ; TEST YMSB = 0 ?
        IFBIT   YMSBIT,[B]
        JP      YBNZ            ; NO: RIGHT SHIFT X
YBZ:    RC                      ; YES: LEFT SHIFT Y
        LD      B,#YLSB         ; POINT TO YLSB
LOOP1:  LD      A,[B]           ; LOAD YLSB
        ADC     A,[B]           ; LEFT SHIFT
        X       A,[B-]          ; POINT TO UPPER BYTE
        IFBNE   #YMSB-1         ; AND DO ALL BYTES
        JP      LOOP1
        LD      B,#BPY          ; INCREMENT BPY
BPT1:   LD      A,[B]
        INC     A
        X       A,[B]
        JP      ALIGN           ; TEST BP'S AGAIN

YBNZ:   LD      B,#XMSB         ; RIGHT SHIFT X
        RC
LOOP2:  LD      A,[B]
        RRC     A
        X       A,[B+]
        IFBNE   #XLSB+1         ; DO ALL BYTES
        JP      LOOP2
        LD      B,#BPX          ; DECREMENT BPX
BPT2:   LD      A,[B]
        ADD     A,#0FF
        X       A,[B]
        JMP     ALIGN           ; TEST BP'S AGAIN

BPYGTX: LD      B,#XMSB         ; TEST XMSB = 0 ?
        IFBIT   XMSBIT,[B]
        JP      XBNZ            ; NO: RIGHT SHIFT Y
XBZ:    RC                      ; YES: LEFT SHIFT X
        LD      B,#XLSB         ; POINT TO XLSB
LOOP3:  LD      A,[B]           ; LOAD XLSB
        ADC     A,[B]           ; ADD TO ITSELF
        X       A,[B-]          ; POINT TO UPPER BYTE
        IFBNE   #XMSB-1         ; DO ALL BYTES
        JP      LOOP3
        LD      B,#BPX          ; INCREMENT BPX
        JP      BPT1

XBNZ:   LD      B,#YMSB         ; RIGHT SHIFT Y
        RC
LOOP4:  LD      A,[B]
        RRC     A
        X       A,[B+]
        IFBNE   #YLSB+1         ; DO ALL BYTES
        JP      LOOP4
        LD      B,#BPY          ; DECREMENT BPY
        JP      BPT2

;------------------------------------------------------
; ADDITION OR SUBTRACTION FLAG TEST
; BIT 1 OF ADDFLG MUST BE SET TO PERFORM SUBTRACTION
; OR CLEARED TO PERFORM ADDITION.
;
;
; ADDFLAG:  16 BIT: M(D)    32 BIT: M(015)
;            ________________________
;           |        | ADD/SUB |  X  |
;            ------------------------
;            7    ...     1       0
;
;
; IN EVENT OF OVERFLOW:
; THE BINARY POINT OF THE RESULT IS TESTED AND IF NOT
; ZERO THE RESULT IS ROTATED RIGHT WITH CARRY.  IF RBP
; IS ZERO, AN ERROR MESSAGE IS GENERATED.
;
;------------------------------------------------------
ADDSUB: LD      B,#ADDFLG       ; POINT TO ADD/SUB FLAG
        IFBIT   SUB,[B]         ; TEST FOR SUBTRACT
        JMP     SUBSIGN         ; YES

;------------------------------------------------------
; BINARY ADD ROUTINE
; FIRST DETERMINES THE SIGNS OF THE OPERANDS. IF ONLY
; ONE IS NEGATIVE, DOES A SUBTRACTION AND ACCOUNTS FOR
; THE SIGN OF THE RESULT. THE SIGN REGISTER IS ADSIGN.
; BITS 1 AND 0 ARE X AND Y SIGN, RESPECTIVELY.
;
; ADSIGN: 16 BIT M(B)   32 BIT: M(013)
;             ____________________
;            |        | XSN | YSN |
;             --------------------
;             7  ...     1     0
;
;------------------------------------------------------
ADDSIGN:LD      B,#ADSIGN       ; TEST SIGN OF OPERANDS
        LD      A,[B]
        IFEQ    A,#02           ; X NEG, Y POS
        JMP     T4
        IFEQ    A,#01           ; X POS, Y NEG
        JMP     T3

BINADD: RC
        LD      X,#XLSB         ; POINT TO OPERANDS
        LD      B,#YLSB
BIN1:   LD      A,[X]           ; GET 1ST OPERAND
        ADC     A,[B]           ; ADD TO 2ND
        X       A,[X-]          ; STORE RESULT IN X
        LD      A,[B-]          ; POINT TO UPPER BYTE
        IFBNE   #YMSB-1         ; AND DO ALL BYTES
        JP      BIN1
        IFNC                    ; TEST FOR OVERFLOW ?
        JP      SETUP           ; NO: TEST ZERO RSLT

        LD      B,#BPX          ; YES: ADJUST FOR
        LD      A,[B]           ; OVERFLOW
        IFEQ    A,#000
        JP      ADERR           ; BP=ZERO: OVRFLW ERROR
        DEC     A
        X       A,[B]
        LD      B,#XMSB         ; BP OK: ROTATE RSLT
OVR:    LD      A,[B]
        RRC     A
        X       A,[B+]
        IFBNE   #XLSB+1
        JP      OVR
        ;RET
        JMP     END1            ; ****DEMO****************

SETUP:  LD      CNTR,#BYTES     ; PASS RESULT LENGTH AND
        LD      B,#XMSB         ; XMSB TO NEGZRO TEST
        JMP     NEGZRO

ADERR:  LD      B,#XLSB
        LD      A,#0E0          ; OVRFLW ERROR ROUTINE
        X       A,[B-]
        X       A,[B]
        ;RET
        JMP     END1            ; ******DEMO***************

;------------------------------------------------------
; BINARY SUBTRACT ROUTINE
; IF X IS NEG, Y POS: DOES ADDITION AND SETS
; RESULT SIGN BIT.
; IF X IS POS, Y NEG: DOES ADDITION
; AND RESETS SIGN BIT. RESULT RESIDES IN X LOCATIONS.
;------------------------------------------------------
SUBSIGN:LD      B,#ADSIGN       ; DETERMINE SIGNS
        LD      A,[B]
        IFEQ    A,#01           ; X POS, Y NEG
L2:     JMP     BINADD          ; DO ADDITION
        IFEQ    A,#02           ; X NEG, Y POS
        JP      L2              ; DO ADDITION
        IFEQ    A,#03           ; BOTH NEG ?
        JP      T4              ; YES

T3:     JSR     BINSUB          ; NO: BOTH POSITIVE
        IFC                     ; TEST X > Y ?
        ;RET                    ; YES: RETURN TO MAIN
        JMP     END1            ; *****DEMO*************

        LD      B,#ADSIGN       ; NO: SET SIGN BIT
        SBIT    XSN,[B]

COMP1:  LD      B,#XLSB         ; Y WAS GREATER
        SC                      ; DO 2'S COMPLIMENT
COMP2:  CLRA
        SUBC    A,[B]
        X       A,[B-]
        IFBNE   #XMSB-1         ; DO ALL BYTES
        JP      COMP2
        ;RET                    ; RETURN TO MAIN
        JMP     END1            ; ******DEMO**************

T4:     JSR     BINSUB          ; BOTH NEG
        IFC                     ; TEST X > Y ?
        JMP     SETUP           ; YES: DO NEG ZERO TEST
        LD      B,#ADSIGN       ; NO: RESET SIGN BIT
        RBIT    XSN,[B]
        JP      COMP1           ; AND DO 2'S COMP

BINSUB: SC
        LD      X,#XLSB         ; POINT TO OPERANDS
        LD      B,#YLSB
BIN2:   LD      A,[X]
        SUBC    A,[B]           ; DO SUBTRACTION
        X       A,[X-]          ; STORE RSLT IN X
        LD      A,[B-]          ; POINT TO UPPER BYTE
        IFBNE   #YMSB-1         ; DO ALL BYTES
        JP      BIN2
        RET                     ; RETURN TO 2'S COMP TEST
;--------------------------------------------------------
; MULTIPLY ROUTINE
; FOR 16[32] BIT MULTIPLY: PRODUCT RESIDES IN MPLSB (M6)
; [(MC)] THROUGH PMSB (M3)[(M5)].
;
;
;  RAM MAP: 16 X 16 BIT MULTIPLY
;
;  (M1)   (M2)   (M3)   (M4)   (M5)   (M6)
; -----------------------------------------
; MCMSB  MCLSB   - - - - - -   MPMSB  MPLSB
;                (PMSB..PCLR)        (PLSB)
;
;  (M7)   (M8)     (MB)
;  -----------------------
;  MPBP   MCBP   MCSN/MPSN
;        (PBP)   (PSN/---)
;
;
;
;  RAM MAP: 32 X 32 BIT MULTIPLY
;
;  (M1)...(M4)   (M5)...(M8)   (M9)...(MC)
; -----------------------------------------
; MCMSB..MCLSB   - - - - - -   MPMSB..MPLSB
;                (PMSB..PCLR)        (PLSB)
;
;  (M011)   (M012)    (M013)
;  --------------------------
;  MPBP      MCBP    MCSN/MPSN
;           (PBP)    (PSN/---)
;
;
;--------------------------------------------------------
MLTPLY: LD      CNTR,#COUNTM    ; COUNT = BYTES*8+1
        LD      B,#PCLR         ; CLEAR HICH BYTES OF
MCLR:   LD      [B-],#0         ; PRODUCT REG
        LD      [B-],#0
        IFBNE   #PMSB-1         ; DO ALL BYTES
        JP      MCLR
        RC
LUPM:   LD      B,#PMSB
LUPM1:  LD      A,[B]           ; [B] = PMSB
        RRC     A               ; ROTATE MULTIPLIER:
        X       A,[B+]
        LD      A,[B]
        RRC     A
        X       A,[B+]
        LD      A,[B]
        RRC     A
        X       A,[B+]
        LD      A,[B]
        RRC     A
        X       A,[B+]
        IFBNE   #MPLSB+1        ; 16/32 BIT OPERATION
        JP      LUPM1

        IFNC                    ; TEST MULTIPLIER BIT
        JP      TESTM           ; NOT SET: NO ADD
        RC                      ; SET: DO MULTIPLY
        LD      B,#PCLR
        LD      X,#MCLSB        ; PUT MULTIPLICAND IN [X]
LUPM2:  LD      A,[X-]
        ADC     A,[B]
        X       A,[B-]
        LD      A,[X-]
        ADC     A,[B]
        X       A,[B-]
        IFBNE   #PMSB-1         ; 16/32 BIT OPERATION
        JP      LUPM2
TESTM:  DRSZ    CNTR            ; TEST FOR FINAL ITERATION
        JP      LUPM

BPMLT:  LD      B,#MPBP         ; ADD BINARY POINTS:
        LD      A,[B+]
        ADD     A,[B]
        X       A,[B]           ; STORE BP IN PBP (=MCBP)

        JSR     DSIGN           ; STORE SIGN OF RESULT
        IFNC                    ; RESULT NEG ?
        ;RET                    ; NO: RET TO MAIN
        JMP     END1            ; *****DEMO****************
        LD      B,#PMSB         ; SEND PARAMETERS TO
        LD      CNTR,#BYTES*2   ; NEGZRO ROUTINE
        JMP     NEGZRO
;--------------------------------------------------------
; DIVIDE ROUTINE
; THIS ROUTINE ALLOWS FOR EXTRA FRACTIONAL BITS TO BE
; GENERATED AT THE LOW END OF THE QUOTIENT REGISTER.
; THE Q REGISTER IS THEREFORE 4[8] BYTES FOR
; A 16[32] BIT OPERATION. THE QUOTIENT RESIDES IN BPXT0
; (M8)[(M10)] THROUGH DDMSB (M5)[(M9)].
;
;
;  RAM MAP: 16 X 16 BIT DIVIDE
;
;
;   (M1)   (M2)   (M3)   (M4)   (M5)   (M6)   (M7)   (M8)
;  ---------------------------------------------------------
;  DVLSB  DVMSB    R1    R0    DDMSB  DDLSB  BPXT   BPXT0
;                             (QMSB)                (QLSB)
;
;   (M9)   (MA)      (MB)
;   -----------------------
;   DVBP   DDBP   DDSN/DVSN
;         (QBP)   (---/QSN)
;
;
;
;  RAM MAP: 32 X 32 BIT DIVIDE
;
;
;   (M1)...(M4)  (M5)...(M8)  (M9)...(MC)   (MD)...(M10)
;   ---------------------------------------------------
;   DVLSB..DVMSB   R3..R0    DDMSB..DDLSB   BPXT..BPXT0
;                            (QMSB)              (QLSB)
;
;   (M11)   (M12)    (M13)
;   ------------------------
;   DVBP     DDBP   DDSN/DVSN
;           (QBP)   (---/QSN)
;
;
;--------------------------------------------------------
DIVIDE: LD      B,#DVLSB        ; TEST FOR DIV BY ZERO ?
Z1:     LD      A,[B-]
        IFGT    A,#000
        JP      DIV             ; NO: DO DIVIDE
        IFBNE   #DVMSB-1        ; TEST ALL BYTES
        JP      Z1
        JMP     ZERR1           ; YES: DIV BY ZERO ERROR

DIV:    LD      CNTR,#DIVCOUNT
        LD      B,#DDMSB-BYTES  ; CLEAR HI BYTES OF
CLRD1:  LD      [B+],#000       ; OF SHIFT REG
        LD      [B+],#000
        IFBNE   #DDMSB
        JP      CLRD1
        LD      B,#BPXT+BYTES-1 ; CLEAR LO BYTES OF Q
CLRD2:  LD      [B-],#000
        LD      [B-],#000
        IFBNE   #DDLSB          ; 16/32 BIT OPERATION
        JP      CLRD2

LSHFT:  LD      B,#QLSB         ; LEFT SHIFT
        RC
LUP:    LD      A,[B]
        ADC     A,[B]
        X       A,[B-]
        IFBNE   #(DDMSB-BYTES-1); 16/32 BIT OPERATION
        JP      LUP
        IFC                     ; TEST FOR MSB=1
        JP      SUBT            ; YES: SKIP TEST SUBT

TSUBT:  LD      X,#DDMSB-1      ; POINT TO SHIFT REG
        LD      B,#DVLSB        ; TEST SUBTRACT:
        SC
TS1:    LD      A,[X-]
        SUBC    A,[B]
        LD      A,[B-]          ; DUMMY LD: DECREMENT B
        LD      A,[X-]
        SUBC    A,[B]
        LD      A,[B-]          ; DUMMY LD: DECREMENT B
        IFBNE   #DVMSB-1        ; 32 BIT OPERATION
        JP      TS1
        IFNC
        JP      TESTD           ; NO QUOTIENT BIT
SUBT:   LD      X,#DDMSB-1      ; POINT TO SHIFT REG
        LD      B,#DVLSB        ; SET QUOTIENT BIT AND
S1:     LD      A,[X]           ; STORE NEW DIVIDEND
        SUBC    A,[B]
        X       A,[X-]
        LD      A,[B-]          ; DUMMY LD: DECREMENT B
        LD      A,[X]
        SUBC    A,[B]
        X       A,[X-]
        LD      A,[B-]          ; DUMMY LD: DECREMENT B
        IFBNE   #DVMSB-1        ; 32 BIT OPERATION
        JP      S1
        LD      B,#QLSB
        SBIT    0,[B]           ; SET QUOTIENT BIT

TESTD:  DRSZ    CNTR            ; REPEAT
        JMP     LSHFT

BPDIV:  LD      B,#DDBP         ; SET BINARY POINT:
        LD      A,[B-]
        SC                      ; DDBP=DDBP-DVBP+COMP
        SUBC    A,[B]
        ADD     A,#BYTES*8      ; BP COMPENSATION
        LD      B,#DDBP         ; STORE QBP IN DDBP
        X       A,[B]

        JSR     DSIGN
        IFNC
        ;RET
        JMP     END1
        LD      CNTR,#BYTES*2
        LD      B,#QMSB
        JP      NEGZRO

DSIGN:  LD      B,#DIVSIGN      ; SET SIGN OF QUOTIENT:
        IFBIT   DVSN,[B]        ; DIVISOR NEGATIVE ?
        JP      D1              ; YES
        IFBIT   DDSN,[B]        ; NEG RSLT ?
        JP      D3              ; YES: TEST ZERO
        RC                      ; NO: RET TO MLT OR DIV
        RET

D1:     IFBIT   DDSN,[B]        ; BOTH NEG ?
        JP      D2              ; YES: = POS RSLT
        SBIT    DDSN,[B]        ; NO: NEGATIVE RESULT
        JP      D3

D2:     RBIT    DDSN,[B]        ; POSITIVE RESULT
        RC
        RET                     ; RETURN TO MLT OR DIV

D3:     SC                      ; SET FLAG
        RET                     ; RET TO MLT OR DIV

ZERR1:  LD      B,#QLSB
        LD      A,#0FF
        X       A,[B]
        ;RET                    ; RETURN TO MAIN
        JP      END1            ; ****DEMO****************
;--------------------------------------------------------
; NEGATIVE ZERO CORRECTION
; THIS ROUTINE IS BRANCHED TO FROM BINADD, MLTPLY AND
; DIVIDE. (BINSUB JUMPS TO THE BINADD BRANCH.)
;
; ALL ROUTINES MUST BE ASSIGNED THE SAME SIGN BIT AND
; SIGN REGISTER. (BIT 1: SIGNREG)
;
; IF THE RESULT IS A NEGATIVE ZERO, THE SIGN CORRECTION
; IS MADE AND CONTROL IS RETURNED TO THE MAIN CALLING
; ROUTINE.
;----------------------------------------------------------
NEGZRO: LD      A,[B+]          ; TEST NEGATIVE ZERO ?
        IFGT    A,#00
        JP      DONE            ; NO: NOT ZERO
        DRSZ    CNTR            ; (#BYTES IN RESULT)
        JP      NEGZRO
        RBIT    RSN,SIGNREG     ; YES: MAKE CORRECTION
DONE:   ;RET                    ; RET TO CALLING ROUTINE
        JP      END1            ; ****DEMO****************

END1:   NOP
        NOP
        NOP

        .END











Creation System Name : ESD Tech/Mark Info System

This system is : ESD Tech/Mark Info System
This user is : crwege        
topic no 57 Topic Name : COP8 Software
current date  Tue Nov 22 00:24:07 1994
Entry # : 273  prepared Sep 27 08:57:49 1993

Author : meeker        
Subject :Floating Point Math SFW, V3
Read by : burford       : at Tue Apr 26 16:02:07 1994
         crwege        : at Mon Nov 21 23:56:57 1994

Owning Topic : T=COP8 Software - 57 E= 273 Type = e

