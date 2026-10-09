;File:  C8A1INC.INC

; Bit Definitions
outbit   =     0                  ;Bit #0 in PORTD
outmsk   =     X'01               ;Mask for Bit #0 in PORTD

; Register Definitions
PORTD    =     X'DC               ;standard PORTD register

; Register Variable Definitions
         .SECT    reg_variables,REG,COMMON
r0:      .dsb     1                 ;=     X'F0               ;R0
tmpcnt:  .dsb     1                 ;=     X'F1               ;R1
trpcnt:  .dsb     1                 ;=     X'F2               ;R2
         .ENDSECT
