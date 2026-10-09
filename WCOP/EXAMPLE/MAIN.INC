; This file predeclares some I/O amd control registers
; frequently used by the COP888EG programmer.
        PORTGD  =   0D4:BYTE         ; Port G data
        PORTGC  =   0D5:BYTE         ; Port G conf
        PORTD   =   0DC:BYTE         ; Port D
        TMR1LO  =   0EA:BYTE         ; Timer low
        TMR1HI  =   0EB:BYTE         ; Timer high
        T1RALO  =   0EC:BYTE         ; Timer RA reg low
        T1RAHI  =   0ED:BYTE         ; Timer RA reg high
        T1RBLO  =   0E6:BYTE         ; Timer RB reg low
        T1RBHI  =   0E7:BYTE         ; Timer RB reg high
        CNTRL   =   0EE:BYTE         ; Control reg
        PSW     =   0EF:BYTE         ; PSW reg
  
