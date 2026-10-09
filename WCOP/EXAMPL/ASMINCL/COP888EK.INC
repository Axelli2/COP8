;
; This file predeclares I/O and control registers
; frequently used by the COP888EK programmer.
;
	.incld COP800.INC
	COPCHIP = COP888EK

        PORTLD  =   0D0:BYTE         ; Port L data
        PORTLC  =   0D1:BYTE         ; Port L configuration
        PORTLP  =   0D2:BYTE         ; Port L pin
;
        PORTCD  =   0D8:BYTE         ; Port C data
        PORTCC  =   0D9:BYTE         ; Port C configuration
        PORTCP  =   0DA:BYTE         ; Port C pin
;
        PORTGD  =   0D4:BYTE         ; Port G data
        PORTGC  =   0D5:BYTE         ; Port G configuration
        PORTGP  =   0D6:BYTE         ; Port G pin
;
        PORTD   =   0DC:BYTE         ; Port D
        PORTI   =   0D7:BYTE         ; Port I
;
        SIOR    =   0E9:BYTE         ; SIO shift register
        SIO     =   0E9:BYTE         ; SIO shift register
        S       =   0FF:BYTE         ; Segment register

        TMR1LO  =   0EA:BYTE         ; Timer 1 low byte
        TMR1HI  =   0EB:BYTE         ; Timer 1 high byte
        T1RALO  =   0EC:BYTE         ; Timer 1 RA register low byte
        T1RAHI  =   0ED:BYTE         ; Timer 1 RA register high byte
        T1RBLO  =   0E6:BYTE         ; Timer 1 RB register low byte
        T1RBHI  =   0E7:BYTE         ; Timer 1 RB register high byte
;
        TMR2LO  =   0C0:BYTE         ; Timer 2 low byte
        TMR2HI  =   0C1:BYTE         ; Timer 2 high byte
        T2RALO  =   0C2:BYTE         ; Timer 2 RA register low byte
        T2RAHI  =   0C3:BYTE         ; Timer 2 RA register high byte
        T2RBLO  =   0C4:BYTE         ; Timer 2 RB register low byte
        T2RBHI  =   0C5:BYTE         ; Timer 2 RB register high byte
        T2CNTRL =   0C6:BYTE         ; Timer 2 control register
;
        TMR3LO  =   0B0:BYTE         ; Timer 3 low byte
        TMR3HI  =   0B1:BYTE         ; Timer 3 high byte
        T3RALO  =   0B2:BYTE         ; Timer 3 RA register low byte
        T3RAHI  =   0B3:BYTE         ; Timer 3 RA register high byte
        T3RBLO  =   0B4:BYTE         ; Timer 3 RB register low byte
        T3RBHI  =   0B5:BYTE         ; Timer 3 RB register high byte
        T3CNTRL =   0B6:BYTE         ; Timer 3 control register
;
        CNTRL   =   0EE:BYTE         ; control register
        PSW     =   0EF:BYTE         ; PSW register
        WDSVR   =   0C7:BYTE         ; Watch dog service register
        WKEDG   =   0C8:BYTE         ; MIWU edge select register
        WKEN    =   0C9:BYTE         ; MIWU enable register
        WKPND   =   0CA:BYTE         ; MIWU pending register
        ICNTRL  =   0E8:BYTE         ; Interrupt control register
;
        CMPSL   =   0B7:BYTE         ; Comparator select register
;
; CONSTANT DECLARE
;       Alternate function bit definitions on port G
        INT     =   0           ; Interrupt input
        INTR    =   0           ; Interrupt input
        WDOUT   =   1           ; Watchdog output
        T1B     =   2           ; Timer T1B output
        T1A     =   3           ; Timer T1A output
        SO      =   4           ; Serial output
        SK      =   5           ; Serial clock
        SI      =   6           ; Serial input
        CKO     =   7           ; Halt,restart input
;
;       Alternate function bit definitions on port L
        T2A     =   4           ; Timer T2A output
        T2B     =   5           ; Timer T2B output
        T3A     =   6           ; Timer T3A output
        T3B     =   7           ; Timer T3B output
;
;       Alternate function bit definitions on port I
        CMPINP1 =   0           ; Comparator positive input 0
        CMP1INN =   1           ; Comparator 1 negative input
        CMPRD   =   1           ; Comparator output for internal use
        CMPINP0 =   2           ; Comparator positive input 1
        CMPINP2 =   3           ; Comparator positive input 2
        CMPINP3 =   4           ; Comparator positive input 3
        CMPINP4 =   5           ; Comparator positive input 4
        CMPINP5 =   6           ; Comparator positive input 5
        CMPOUT  =   7           ; Comparator output
     
    
   
  


;       Bit definitions CNTRL register
        T1C3    =   7           ; Timer 1 mode control
        TC1     =   T1C3        ; COP880/840/820 control signal name
        T1C2    =   6           ; Timer 1 mode control
        TC2     =   T1C2        ; COP880/840/820 control signal name
        T1C1    =   5           ; Timer 1 mode control
        TC3     =   T1C1        ; COP880/840/820 control signal name
        T1C0    =   4           ; Start/Stop timer in modes 1 and 2
                                ; Underflow interrupt pending in mode 3
	TRUN	=   T1C0	; COP880/840/820 control signal name
	SKSEL	=   6		; MicroWire SK Shift-Polarity
	MSEL	=   3		; Enable Microwire
        IEDG    =   2           ; Selects external interr. edge polarity
        S1      =   1           ; Microwire clock divide select
        S0      =   0           ; Microwire clock divide select
;
;       Bit definitions PSW register
        HC      =   7           ; Half carry flag
        C       =   6           ; Carry flag
        TPND    =   5           ; Timer interr. pending
        ENTI    =   4           ; Timer interr. enable
        IPND    =   3           ; External interr. pending
        BUSY    =   2           ; Microwire busy shifting
        ENI     =   1           ; External interr. enable
        GIE     =   0           ; Global interr. enable
;
;       Bit definitions ICNTRL register
;	FLAG1	=   7		; General purpose flag
        LPEN    =   6           ; L-Port interr. enable
        T0PND   =   5           ; Timer T0 interr. pending
        T0EN    =   4           ; Timer T0 interr. enable
        WPND    =   3           ; Microwire interr. pending
        WEN     =   2           ; Microwire interr. enable
        T1PNDB  =   1           ; Timer T1B interr. pending flag
        T1ENB   =   0           ; Timer T1B interr. enable
;
;       Bit definitions T2CNTRL register
        T2C3    =   7           ; Timer T2 mode control
        T2C2    =   6           ; Timer T2 mode control
        T2C1    =   5           ; Timer T2 mode control
        T2C0    =   4           ; Timer T2A start/stop
        T2PNDA  =   3           ; Timer T2A interr. pending flag
        T2ENA   =   2           ; Timer T2A interr. enable
        T2PNDB  =   1           ; Timer T2B interr. pending flag
        T2ENB   =   0           ; Timer T2B interr. enable
;
;       Bit definitions T3CNTRL register
        T3C3    =   7           ; Timer T3 mode control
        T3C2    =   6           ; Timer T3 mode control
        T3C1    =   5           ; Timer T3 mode control
        T3C0    =   4           ; Timer T3A start/stop
        T3PNDA  =   3           ; Timer T3A interr. pending flag
        T3ENA   =   2           ; Timer T3A interr. enable
        T3PNDB  =   1           ; Timer T3B interr. pending flag
        T3ENB   =   0           ; Timer T3B interr. enable
;
;       Bit definitions CMPSL register
        CMPT2B    =   7        ; COMPARATOR TO TIMER T2B 
        CMPISEL2  =   6        ; INPUT SELECT 2
        CMPISEL1  =   5        ; INPUT SELECT 1
        CMPISEL0  =   4        ; INPUT SELECT 0
        CMPOE  =   3           ; COMPARATOR OUTPUT ENABLE
        CSEN   =   2           ; CURRENT SOURCE ENABLE
        CMPEN  =   1           ; Comparator enable
        CMPNEG =   0           ; COMPARATOR DISCHARGE FOR CAP
;
       .CHIP 888EK             ; specifies max. ROM address 01FFF
