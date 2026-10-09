
                .Title  PWM1,'Control Testing I.'
                .INCLD  COP888EK.INC


;  ***                P   W   M              ***
;  ***          Table Looup - Data           ***
;  ***     and fetching of this data is      ***
;  ***     handled below.               

        .PUBLIC PWHI,PWLO,PWGEN
        
	.EXTRN PWMCONT:BASE:BYTE

        .SECT PWMGEN,RAM,ABS=010
        
PW1:    .DSB    10

        PWHI    =       PW1:BYTE     ; Hi  time of PWM
        PWLO    =       PW1+1        ; Low Time of PWM
        

        .SECT PWBASE,ROM        
PWGEN:
        Ld      A,PWMCONT       ; Get Table address
        
        ; The RAM Location PWMCONT contains the Low
        ; portion (8-bit = one ROM-Block of 256 consecutive
        ; Locations) of the ROMaddress where to find the
        ; high respectively low byte of the PWM.
             
        JSR     PW1FETCH        ; Fetch PWM Hi-Byte
        X       A,PWHI          ; and save in PWHI
        
        Ld      A,PWMCONT       ; Get back [Accu]
        JSR     PW2FETCH        ; for Low-Byte Fetch
        X       A,PWLO          ; and save in PWLO
        RET
        
        
        
        
        
        
        
        
        
        
; *** Following is the ROM Table to store the amount of ***
; *** Tc - Cycles for the On-Time of the PWM width.     ***
; *** The PWM-frequency is always                       ***
; *** at 23.5 kHz if a 10 Mhz clock is applied to Cki.  ***
        
         
        
        .SECT PWTAB1,ROM,INPAGE
        
PW1FETCH:

        LAID                    ; The accumulator must contain
        RET                     ; the address byte from the ROM
                                ; Block (data-block below) which
                                ; contains the information for
                                ; the "High-Time" of the PWM
                                ; Control Signal.
                                
        .Byte   01,01,01,01,01,01,02,02,02,02
        .Byte   02,02,03,03,03,03,03,03,04,04
        .Byte   04,04,04,04,05,05,05,05,05,05
        .Byte   06,06,06,06,06,06,07,07,07,07
        .Byte   07,07,08,08,08,08,08,08,09,09
        .Byte   09,09,09,09,10,10,10,10,10,10
        .Byte   11,11,11,11,11,11,12,12,12,12
        .Byte   12,12,13,13,13,13,13,13,14,14
        .Byte   14,14,14,14,15,15,15,15,15,15
        .Byte   16,16,16,16,16,16,17,17,17,17
        .Byte   17,17,18,18,18,18,18,18,19,19
        .Byte   19,19,19,19,20,20,20,20,20,20
        .Byte   21,21,21,21,21,21,22,22,22,22
        .Byte   22,22,23,23,23,23,23,23,24,24
        .Byte   24,24,24,24,25,25,25,25,25,25
        .Byte   26,26,26,26,26,26,27,27,27,27
        .Byte   27,27,28,28,28,28,28,28,29,29
        .Byte   29,29,29,29,30,30,30,30,30,30
        .Byte   31,31,31,31,31,31,32,32,32,32
        .Byte   32,32,33,33,33,33,33,33,34,34
        .Byte   34,34,34,34,35,35,35,35,35,35
        .Byte   36,36,36,36,36,36,37,37,37,37
        .Byte   37,37,38,38,38,38,38,38,39,39
        .Byte   39,39,39,39,40,40,40,40,40,40
        .Byte   41,41,41,41,41,41


                .Form        
        
; *** Following is the ROM Table to store the amount of ***
; *** Tc - Cycles for the Off-Time of the PWM width.    ***
; ***  The PWM-frequency is always                      ***
; *** at 23.5 kHz if a 10 Mhz clock is applied to Cki.  ***
        
        
        
        .SECT PWTAB2,ROM,INPAGE
        
PW2FETCH:

        LAID                    ; The accumulator must contain
        RET                     ; the address byte from the ROM
                                ; Block (data-block below) which
                                ; contains the information for
                                ; the "Low-Time" of the PWM
                                ; Control Signal.
                                
        .Byte   41,41,41,41,41,41,40,40,40,40
        .Byte   40,40,39,39,39,39,39,39,38,38
        .Byte   38,38,38,38,37,37,37,37,37,37
        .Byte   36,36,36,36,36,36,35,35,35,35
        .Byte   35,35,34,34,34,34,34,34,33,33
        .Byte   33,33,33,33,32,32,32,32,32,32
        .Byte   31,31,31,31,31,31,30,30,30,30
        .Byte   30,30,29,29,29,29,29,29,28,28
        .Byte   28,28,28,28,27,27,27,27,27,27
        .Byte   26,26,26,26,26,26,25,25,25,25
        .Byte   25,25,24,24,24,24,24,24,23,23
        .Byte   23,23,23,23,22,22,22,22,22,22
        .Byte   21,21,21,21,21,21,20,20,20,20
        .Byte   20,20,19,19,19,19,19,19,18,18
        .Byte   18,18,18,18,17,17,17,17,17,17
        .Byte   16,16,16,16,16,16,15,15,15,15
        .Byte   15,15,14,14,14,14,14,14,13,13
        .Byte   13,13,13,13,12,12,12,12,12,12
        .Byte   11,11,11,11,11,11,10,10,10,10
        .Byte   10,10,09,09,09,09,09,09,08,08
        .Byte   08,08,08,08,07,07,07,07,07,07
        .Byte   06,06,06,06,06,06,05,05,05,05
        .Byte   05,05,04,04,04,04,04,04,03,03
        .Byte   03,03,03,03,02,02,02,02,02,02
        .Byte   01,01,01,01,01,01
        
        
        
        .END   
                
                
