;
; This file predeclares I/O and control registers
; frequently used by the COP888CS programmer.
;
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
        CNTRL   =   0EE:BYTE         ; control register
        PSW     =   0EF:BYTE         ; PSW register
        WDSVR   =   0C7:BYTE         ; Watch dop service register
        WKEDG   =   0C8:BYTE         ; MIWU edge select register
        WKEN    =   0C9:BYTE         ; MIWU enable register
        WKPND   =   0CA:BYTE         ; MIWU pending register
        ICNTRL  =   0E8:BYTE         ; ICNTRL register
;
        CMPSL   =   0B7:BYTE         ; Comparator select register
        TBUF    =   0B8:BYTE         ; UART transmit buffer
        RBUF    =   0B9:BYTE         ; UART receive buffer
        ENU     =   0BA:BYTE         ; UART control and status register
        ENUR    =   0BB:BYTE         ; UART receive control and status reg.
        ENUI    =   0BC:BYTE         ; UART interrupt and clock source reg.
        BAUD    =   0BD:BYTE         ; BAUD register
        PSR     =   0BE:BYTE         ; UART prescaler select register
;
; CONSTANT DECLARE
;       Alternate function bit definitions on port G
        INT     =   0           ; Interrupt input
        INTR    =   0           ; Interrupt input
        WDOUT   =   1           ; Watchdog output
        T1B     =   2           ; Timer T1B output
        T1A     =   3           ; Timer T1A output
        SO      =   4           ; Seriell output
        SK      =   5           ; Seriell clock
        SI      =   6           ; Seriell input
        CKO     =   7           ; Halt,restart input
;
;       Alternate function bit definitions on port L
        CKX     =   1           ; ext. clock I/O-pin/UART
        TDX     =   2           ; transmit data/UART
        RDX     =   3           ; receive data/UART
;
;      Alternate function bit definitions on port I
       CMP1INN  =   1             ; Comparator - input
       CMP1INP  =   2             ; Comparator + input
       CMP1OUT  =   3             ; Comparator output


;       Bit definitions CNTRL register
        T1C3    =   7           ; Timer 1 mode control
        TC1     =   T1C3        ; COP880/840/820 control signal name
        T1C2    =   6           ; Timer 1 mode control
        TC2     =   T1C2        ; COP880/840/820 control signal name
        T1C1    =   5           ; Timer 1 mode control
        TC3     =   T1C1        ; COP880/840/820 control signal name
        T1C0    =   4           ; Start/Stop timer in modes 1 and 2
                                ; Underflow interrupt pending in mode 3
        TRUN    =   T1C0        ; COP880/840/820 control signal name
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
;       Bit definitions ICNTRL register
        LPEN    =   6           ; L-Port interr. enable
        T0PND   =   5           ; Timer T0 interr. pending
        T0EN    =   4           ; Timer T0 interr. enable
        WPND    =   3           ; Microwire interr. pending
        WEN     =   2           ; Microwire interr. enable
        T1PNDB  =   1           ; Timer T1B interr. pending flag
        T1ENB   =   0           ; Timer T1B interr. enable
;
;       Bit definitions CMPSL register
        CMP10E  =   3           ; Select COMP1OUT as output
        CMP1RD  =   2           ; Comparator result (read only)
        CMP1EN  =   1           ; Comparator 1 enable
;
;       Bit definitions ENU register
        PEN     =   7           ; Parity enable
        PSEL1   =   6           ; Parity select
        PSEL0   =   5           ; Parity select
        XBIT9   =   5           ; 9th transmission bit in 9bit data mode
        CHL1    =   4           ; Select character frame format
        CHLO    =   3           ; Select character frame format
        ERR     =   2           ; Error flag
        RBFL    =   1           ; Received character
        TBMT    =   0           ; Transmited character
;
;       Bit definitions ENUR register
        DOE     =   7           ; Data overrun error
        FE      =   6           ; Framing error
        PE      =   5           ; Parity error
        RBIT9   =   3           ; Contains the ninth bit (nine bit frame!)
        ATTN    =   2           ; Attention mode
        XMTG    =   1           ; indicate transmitting mode
        RCVG    =   0           ; indicate framing error
;
;       Bit definition ENUI register
        STP2    =   7           ; Select number of stop bits
        STP78   =   6           ; Select the last stop bit
        ETDX    =   5           ; Select transmit-pin l2
        SSEL    =   4           ; Select UART-mode
        XRCLK   =   3           ; Select clock source for the receiver
        XTCLK   =   2           ; Select clock source for the transmitter
        ERI     =   1           ; Enable interr. from the receiver
        ETI     =   0           ; enable interr. from the transmitter
;
       .CHIP 888CS              ; specifies max. ROM address 0FFF
