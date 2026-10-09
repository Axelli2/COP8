;
; This file predeclares I/O amd control registers
; frequently used by the COP888GW programmer.
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
        PORTFD  =   094:BYTE         ; Port F data
        PORTFC  =   095:BYTE         ; Port F configuration
        PORTFP  =   096:BYTE         ; Port F pin
;
        PORTED  =   090:BYTE         ; Port E data
        PORTEC  =   091:BYTE         ; Port E configuration
        PORTEP  =   092:BYTE         ; Port E pin
;

        PORTD   =   0DC:BYTE         ; Port D
        PORTI   =   0D7:BYTE         ; Port I
;
        SIOR    =   0E9:BYTE         ; SIO shift register
        SIO     =   0E9:BYTE         ; SIO shift register
        S       =   0FF:BYTE         ; Segment register
;
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
        CNTRL   =   0EE:BYTE         ; Control register
        PSW     =   0EF:BYTE         ; PSW register
        WKEDG   =   0C8:BYTE         ; MIWU edge select register
        WKEN    =   0C9:BYTE         ; MIWU enable register
        WKPND   =   0CA:BYTE         ; MIWU pending register
        ICNTRL  =   0E8:BYTE         ; ICNTRL register
;
        TBUF    =   0B8:BYTE         ; UART transmit buffer
        RBUF    =   0B9:BYTE         ; UART receive buffer
        ENU     =   0BA:BYTE         ; UART control and status register
        ENUR    =   0BB:BYTE         ; UART receive control and status reg.
        ENUI    =   0BC:BYTE         ; UART interrupt and clock source reg.
        BAUD    =   0BD:BYTE         ; BAUD register
        PSR     =   0BE:BYTE         ; UART prescaler select register
;
        MDR1    =   098:BYTE         ; Dividend or Result byte
        MDR2    =   099:BYTE         ; Dividend/Multiplier or Result byte
        MDR3    =   09A:BYTE         ; Dividend/Result byte
        MDR4    =   09B:BYTE         ; Divisor/Multiplicand or Result byte
        MDR5    =   09C:BYTE         ; Divisor or Multiplicand byte
        MDCR    =   09D:BYTE         ; Multiply/Divide control register
;
        CCR1    =   09E:BYTE         ; Counter Control 1 register
        CCR2    =   09F:BYTE         ; Counter Control 2 register
        C1PRL   =   0A0:BYTE         ; Counter 1 prescaler lower byte
        C1PRH   =   0A1:BYTE         ; Counter 1 prescaler upper byte
        C1CTL   =   0A2:BYTE         ; Counter 1 count register lower byte
        C1CTH   =   0A3:BYTE         ; Counter 1 count register upper byte
;
        C2PRL   =   0A4:BYTE         ; Counter 2 prescaler lower byte
        C2PRH   =   0A5:BYTE         ; Counter 2 prescaler upper byte
        C2CTL   =   0A6:BYTE         ; Counter 2 count register lower byte
        C2CTH   =   0A7:BYTE         ; Counter 2 count register upper byte
;
        C3PRL   =   0A8:BYTE         ; Counter 3 prescaler lower byte
        C3PRH   =   0A9:BYTE         ; Counter 3 prescaler upper byte
        C3CTL   =   0AA:BYTE         ; Counter 3 count register lower byte
        C3CTH   =   0AB:BYTE         ; Counter 3 count register upper byte
;
        C4PRL   =   0AC:BYTE         ; Counter 4 prescaler lower byte
        C4PRH   =   0AD:BYTE         ; Counter 4 prescaler upper byte
        C4CTL   =   0AE:BYTE         ; Counter 4 count register lower byte
        C4CTH   =   0AF:BYTE         ; Counter 4 count register upper byte
;
        CM1PSC  =   0B0:BYTE         ; Capture Timer 1 prescaler register
        CM1CRL  =   0B1:BYTE         ; Capture Timer 1 lower byte
        CM1CRH  =   0B2:BYTE         ; Capture Timer 1 upper byte
;
        CM2PSC  =   0B3:BYTE         ; Capture Timer 2 prescaler register
        CM2CRL  =   0B4:BYTE         ; Capture Timer 2 lower byte
        CM2CRH  =   0B5:BYTE         ; Capture Timer 2 upper byte
;
        CCMR1   =   0B6:BYTE         ; Capture Timer 1 control register
        CCMR2   =   0B7:BYTE         ; Capture Timer 2 control register
;
; CONSTANT DECLARE
;       Bit definitions CCMR1 register
        CM1RUN  =   0           ; CM1 start/stop
        CM1IEN  =   1           ; CM1 interrupt enable
        CM1IP1  =   2           ; CM1 interrupt pending underflow
        CM1IP2  =   3           ; CM1 interrupt pending capture
        CM1EC   =   4           ; CM1 edge capture select
        CM1TM   =   7           ; CM1 test mode control bit
;
;       Bit definitions CCMR2 register
        CM2RUN  =   0           ; CM2 start/stop
        CM2IEN  =   1           ; CM2 interrupt enable
        CM2IP1  =   2           ; CM2 interrupt pending underflow
        CM2IP2  =   3           ; CM2 interrupt pending capture
        CM2EC   =   4           ; CM2 edge capture select
        CM2TM   =   7           ; CM2 test mode control bit
;
;       Bit definitions CCR1 register
        C1RUN   =   0           ; Counter 1 start/stop
        C1IEN   =   1           ; Counter 1 interrupt enable
        C1IPND  =   2           ; Counter 1 interrupt pending    
        C1TM    =   3           ; Counter 1 test mode control bit  
        C2RUN   =   4           ; Counter 2 start/stop
        C2IEN   =   5           ; Counter 2 interrupt enable
        C2IPND  =   6           ; Counter 2 interrupt pending    
        C2TM    =   7           ; Counter 2 test mode control bit  
;
;       Bit definitions CCR2 register
        C3RUN   =   0           ; Counter 3 start/stop
        C3IEN   =   1           ; Counter 3 interrupt enable
        C3IPND  =   2           ; Counter 3 interrupt pending    
        C3TM    =   3           ; Counter 3 test mode control bit  
        C4RUN   =   4           ; Counter 4 start/stop
        C4IEN   =   5           ; Counter 4 interrupt enable
        C4IPND  =   6           ; Counter 4 interrupt pending    
        C4TM    =   7           ; Counter 4 test mode control bit  
;
;       Bit definitions MDCR register
        MULT    =   0           ; Start multiplication operation
        DIV     =   1           ; Start division operation
        DIVOVF  =   2           ; Division overflow  
;
;       Alternate function bit definitions on port g
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
        T2A     =   4           ; Timer T2A output
        T2B     =   5           ; Timer T2B output
        T3A     =   6           ; Timer T3A output
        T3B     =   7           ; Timer T3B output
;
;       Alternate function bit definitions on port I
        CMP1INN =   1           ; Comparator 1 negative input
        CMP1INP =   2           ; Comparator 1 positive input
        CMP1OUT =   3           ; Comparator 1 output
        CMP2INN =   4           ; Comparator 2 negative input
        CMP2INP =   5           ; Comparator 2 positive input
        CMP2OUT =   6           ; Comparator 2 output
;
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
;       Bit definitions T2CNTRL register
        T2C3    =   7           ; Timer T2 mode control
        T2C2    =   6           ; Timer T2 mode control
        T2C1    =   5           ; Timer T2 mode control
        T2CO    =   4           ; Timer T2A start/stop
        T2PNDA  =   3           ; Timer T2A interr. pending flag
        T2ENA   =   2           ; Timer T2A interr. enable
        T2PNDB  =   1           ; Timer T2B interr. pending flag
        T2ENB   =   0           ; Timer T2B interr. enable
;
;       Bit definitions CMPSL register
        CMP20E  =   6           ; Select COMP2OUT as output
        CMP2RD  =   5           ; Comparator 2 result (read only)
        CMP2EN  =   4           ; Comparator 2 enable
        CMP10E  =   3           ; Select COMP1OUT as output
        CMP1RD  =   2           ; Comparator result (read only)
        CMP1EN  =   1           ; Comparator 1 enable
;
;       Bit definitions ENU register
        PEN     =   7           ; Parity enable
        PSEL1   =   6           ; Parity select Bit 1
        PSEL0   =   5           ; Parity select Bit 0
        XBIT9   =   5           ; 9th transmission bit in 9 bit data mode
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
        .CHIP 888GW             ; specifies max. ROM address 3FFF
