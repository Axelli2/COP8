;
; This file predeclares items frequently used by the
; COP820 programmer.
;
; This includes registers and flags.
;
;
        PORTLD  =   0D0:BYTE         ; Port L data
        PORTLC  =   0D1:BYTE         ; Port L configuration
        PORTLP  =   0D2:BYTE         ; Port L pin
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
        TMRLO   =   0EA:BYTE         ; Timer low bytes
        TMRHI   =   0EB:BYTE         ; Timer high bytes
        TAULO   =   0EC:BYTE         ; Timer register low byte
        TAUHI   =   0ED:BYTE         ; Timer register high byte
;
        CNTRL   =   0EE:BYTE         ; Control register
        PSW     =   0EF:BYTE         ; PSW register
;
; CONSTANT DECLARE
;       Alternate function bit definitions on port G
        INT     =   0           ; Interrupt input
        INTR    =   0           ; Interrupt input
        TIO     =   3           ; Timer output
        SO      =   4           ; Seriell output
        SK      =   5           ; Seriell clock
        SI      =   6           ; Seriell input
        CKO     =   7           ; Halt,restart input
;
;       Bit definitions CNTRL register
        TC1     =   7           ; Selects timer mode
        T1C3    =   TC1         ; COP888
        TC2     =   6           ; Selects capture mode
        T1C2    =   TC2         ; COP888
        TC3     =   5           ; Selects Timer input edge polarity
        T1C1    =   TC3         ; COP888
        TRUN    =   4           ; Start/stop Timer, Counter
        T1C0    =   TRUN        ; COP888
        MSEL    =   3           ; Enable Microwire
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
        .CHIP   820             ; specifies max. ROM address 03FF

