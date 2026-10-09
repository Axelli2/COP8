
; This file predeclares I/O and control registers
; frequently used by the COP888BC programmer.
; 08/22/94  Bob Moeckel

        PSCAL   =   0A0:BYTE         ; PWM timer Prescale Register
        RLON    =   0A1:BYTE         ; PWM timer On-Time Register
        PWMCON  =   0A2:BYTE         ; PWM Control Register
                PWEN0   =  0            ; Enable PWM0 I/O function on I/O Port
                PWEN1   =  1            ; Enable PWM1 I/O function on I/O Port
                PWON    =  2            ; PWM Start Bit
                                        ;   '1' to start PWM
                                        ;   '0' to stop PWM
                PWMD    =  3            ; PWM Mode bit
                                        ;   '1' for PWM Mode
                                        ;   '0' for Capture Mode
                PWIE    =  4            ; PWM Interrupt Enable Bit
                PWPND   =  5            ; PWM Interrupt Pending bit
                ESEL    =  6            ; Capture Mode Edge Select bit
                                        ;   '1' for falling edge
                                        ;   '0' for rising edge

        TXD1    =   0B0:BYTE         ; CAN Transmit Data byte 1
        TXD2    =   0B1:BYTE         ; CAN Transmit Data byte 2
        TDLC    =   0B2:BYTE         ; Transmit Data Length Code and ID Low
                TDLC0   =  0            ; Bit 0 transmit data length code
                TDLC1   =  1            ; Bit 1 transmit data length code
                TDLC2   =  2            ; Bit 2 TDLC
                TDLC3   =  3            ; Bit 3 TDLC
                TID0    =  4            ; Bit 0 Transmit Identifier
                TID1    =  5            ; Bit 1 TID
                TID2    =  6            ; Bit 2 TID
                TID3    =  7            ; Bit 3 TID

        TID     =   0B3:BYTE         ; Transmit Identifier High
                TID4    =  0            ;Bit 4 TID
                TID5    =  1            ;Bit 5 TID
                TID6    =  2            ;Bit 6 TID
                TID7    =  3            ;Bit 7 TID
                TID8    =  4            ;Bit 8 TID
                TID9    =  5            ;Bit 9 TID
                TID10   =  6            ;Bit 10 TID
                TRTR    =  7            ;Transmit remote frame

        RXD1    =   0B4:BYTE         ; CAN Receive Data byte 1
        RXD2    =   0B5:BYTE         ; CAN Receive Data byte 2
        RIDL    =   0B6:BYTE         ; Receive Data Length Code
                                     ; and Identifier Low
                RDLC0   =  0            ;Bit 0 receive data length code
                RDLC1   =  1            ;Bit 1 receive data length code
                RDLC2   =  2            ;Bit 2 receive data length code
                RDLC3   =  3            ;Bit 3 receive data length code
                RID0    =  4            ;Bit 0 Receive Identifier
                RID1    =  5            ;Bit 1 Receive Identifier
                RID2    =  6            ;Bit 3 Receive Identifier
                RID3    =  7            ;Bit 4 Receive Identifier

        RID     =   0B7:BYTE         ; Receive Identifier High
                RID4    =  0            ;Bit 4 Receive Identifier
                RID5    =  1            ;Bit 5 Receive Identifier
                RID6    =  2            ;Bit 6 Receive Identifier
                RID7    =  3            ;Bit 7 Receive Identifier
                RID8    =  4            ;Bit 8 Receive Identifier
                RID9    =  5            ;Bit 9 Receive Identifier
                RID10   =  6            ;Bit 10 Receive Identifier

        CSCAL   =   0B8:BYTE         ; CAN Prescaler register

        CTIM    =   0B9:BYTE         ; CAN Bus Timing register
                SJ0     =  0            ;Syncronization Jump Width bit 0
                SJ1     =  1            ;Syncronization Jump Width bit 1
                                        ;SJ1  SJ0   Syncronization Jump Width
                                        ; 0    0    1 tcan
                                        ; 0    1    2 tcan
                                        ; 1    0    3 tcan
                                        ; 1    1    4 tcan
                PS0     =  2            ;Phase Segment 1&2 bit 0
                PS1     =  3            ;Phase Segment 1&2 bit 1
                PS2     =  4            ;Phase Segment 1&2 bit 2
                                        ;PS2 PS1 PS0  Length of Phase Segment
                                        ; 0   0   0   1 tcan
                                        ; 0   0   1   2 tcan, etc. until
                                        ; 1   1   1   8 tcan
                PPS0    =  5            ;Propagation Segment bit 0
                PPS1    =  6            ;Propagation Segment bit 1
                PPS2    =  7            ;Propagation Segment bit 3
                                        ;PPS2 PPS1 PPS0  Length of Prop. Seg.
                                        ; 0    0    0    1 tcan
                                        ; 0    0    1    2 tcan, etc. until
                                        ; 1    1    1    8 tcan


        CBUS    =   0BA:BYTE         ; CAN Bus Control register
                FMOD    =  0            ;Fault Confinement Mode Select
                                        ;0= standard mode (error active after
                                        ;   128*11 recessive bits)
                                        ;1= enhanced mode (128 "good" messages)
                RXREF0  =  2            ;1= apply reference voltage to pin RX0
                RXREF1  =  3            ;1= apply reference voltage to pin RX1
                TXEN0   =  4            ;output driver enable bit 0
                TXEN1   =  5            ;output driver enable bit 1
                                        ;TXEN1 TXEN0    Output
                                        ; 0      0      TX0,TX1 tristated
                                        ; 0      1      TX0 enabled
                                        ; 1      0      TX1 enabled
                                        ; 1      1      TX0,TX1 enabled
                RIAF    =  6            ;Receive Identifier Acceptance Filter
                                        ;1= accept all messages regardless of
                                        ;   identifier
                                        ;0= compare bits 4 to 10 of received
                                        ;   identifier with mask bits of RID
                                        ;   register


        TCNTL   =   0BB:BYTE         ; Transmit Control/Status register
                TXSS    =  0            ;Transmission Start/Stop 1=start
                RIE     =  1            ;1= Receive Interrupt enable
                TIE     =  2            ;1= Transmit Interrupt enable
                CEIE    =  3            ;1= CAN error interrupt enable
                                        ;   (transmit/ receive error)
                RERR    =  4            ;1= Receive error pending
                TERR    =  5            ;1= Transmit error pending
                NS0     =  6            ;Node Status bit 0
                NS1     =  7            ;Node Status bit 1
                                        ;NS1 NS0  outputs
                                        ; 0   0   error active
                                        ; 0   1   error passive
                                        ; 1   0   bus off
                                        ; 1   1   bus off

        RTSTAT  =   0BC:BYTE         ; Receive/Transmit Status register
                                     ; READ ONLY
                RBF     =  0            ;1= Receive buffer full (receive
                                        ;   interrupt pending)
                RCV     =  1            ;RECEIVE MODE
                                        ;1= DEVICE IS RECEIVING A MESSAGE
                                        ;THAT PASSED ACCEPTANCE FILTERING
                RFV     =  2            ;1= received frame valid
                RORN    =  3            ;1= receiver overrun
                ROLD    =  4            ;1= received overload frame
                RRTR    =  5            ;1= received remote transmission
                                        ;request
                TXPND   =  6            ;1= Transmission pending
                TBE     =  7            ;1= Transmit buffer empty (transmit
                                        ;   interrupt pending)

        TEC     =   0BD:BYTE         ; Transmit Error Counter
        REC     =   0BE:BYTE         ; Receive Error Counter

        WKEDG   =   0C8:BYTE         ; MIWU edge select register
        WKEN    =   0C9:BYTE         ; MIWU enable register
        WKPND   =   0CA:BYTE         ; MIWU pending register

        PORTLD  =   0D0:BYTE         ; Port L data
        PORTLC  =   0D1:BYTE         ; Port L configuration
        PORTLP  =   0D2:BYTE         ; Port L pin

        CMPSL   =   0D3:BYTE         ; Comparator Control register
              CMP1EN  =   1          ; Comparator 1 enable
              CMP1RD  =   2          ; Comparator result (read only)
              CMP10E  =   3          ; Select COMP1OUT as output
              CMP2EN  =   4          ; Comparator 2 enable
              CMP2RD  =   5          ; Comparator 2 result (read only)
              CMP20E  =   6          ; Select COMP2OUT as output
	      CMP2SEL =   7	     ; Select L3 or L5 as Comparator 2 Input

        PORTGD  =   0D4:BYTE         ; Port G data
        PORTGC  =   0D5:BYTE         ; Port G configuration
        PORTGP  =   0D6:BYTE         ; Port G pin

        PORTD   =   0DC:BYTE         ; Port D

        T1RBLO  =   0E6:BYTE         ; Timer 1 RB register low byte
        T1RBHI  =   0E7:BYTE         ; Timer 1 RB register high byte

        ICNTRL  =   0E8:BYTE         ; ICNTRL register
              T1ENB   =   0           ; Timer T1B interr. enable
              T1PNDB  =   1           ; Timer T1B interr. pending flag
              WEN     =   2           ; Microwire interr. enable
              WPND    =   3           ; Microwire interr. pending
              T0EN    =   4           ; Timer T0 interr. enable
              T0PND   =   5           ; Timer T0 interr. pending
              LPEN    =   6           ; L-Port interr. enable

        SIOR    =   0E9:BYTE         ; SIO shift register
        SIO     =   0E9:BYTE         ; SIO shift register

        TMR1LO  =   0EA:BYTE         ; Timer 1 low byte
        TMR1HI  =   0EB:BYTE         ; Timer 1 high byte
        T1RALO  =   0EC:BYTE         ; Timer 1 RA register low byte
        T1RAHI  =   0ED:BYTE         ; Timer 1 RA register high byte


;
        CNTRL   =   0EE:BYTE         ; Control register
              S0      =   0           ; Microwire clock divide select
              S1      =   1           ; Microwire clock divide select
              IEDG    =   2           ; Selects external interr. edge polarity
              MSEL    =   3           ; Enable Microwire
              T1C0    =   4           ; Start/Stop timer in modes 1 and 2
                                      ; Underflow interrupt pending in mode 3
              TRUN    =   T1C0        ; COP880/840/820 control signal name
              T1C1    =   5           ; Timer 1 mode control
              TC3     =   T1C1        ; COP880/840/820 control signal name
              T1C2    =   6           ; Timer 1 mode control
              TC2     =   T1C2        ; COP880/840/820 control signal name
              T1C3    =   7           ; Timer 1 mode control
              TC1     =   T1C3        ; COP880/840/820 control signal name

        PSW     =   0EF:BYTE         ; PSW register
              GIE     =   0           ; Global interr. enable
              ENI     =   1           ; External interr. enable
              EXEN    =   ENI
              BUSY    =   2           ; Microwire busy shifting
              IPND    =   3           ; External interr. pending
              EXPND   =   IPND
              ENTI    =   4           ; Timer interr. enable
              T1ENA   =   ENTI
              TPND    =   5           ; Timer interr. pending
              T1PNDA  =   TPND
              C       =   6           ; Carry flag
              HC      =   7           ; Half carry flag


;
;
; CONSTANT DECLARE
;       Alternate function bit definitions on port G
        INT     =   0           ; External Interrupt input
        INTR    =   0           ; External Interrupt input
        T1B     =   2           ; Timer T1B output
        T1A     =   3           ; Timer T1A output
        SO      =   4           ; Serial output
        SK      =   5           ; Serial clock
        SI      =   6           ; Serial input

;       Alternate function bit definitions on port L
        CMP1INP =   0           ;comparator 1 positive input
	CMP1WAKE =  0		;comparator 1 wakeup input
        CMP1INN =   1           ;comparator 1 negative input
        CMP1OUT =   2           ;comparator 1 output
        CMP2INN2 =  3           ;comparator 2 negative input 2
        CMP2INP =   4           ;comparator 2 positive input
	CMP2WAKE =  4		;comparator 2 wakeup input
        CMP2INN1 =  5           ;comparator 2 negative input 1
        CMP2OUT =   6           ;comparator 2 output

       .CHIP 888BC              ; specifies max. ROM address 0x7FF
