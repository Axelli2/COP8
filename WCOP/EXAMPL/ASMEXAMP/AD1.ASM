
                .Title ATOD,'Analog/Digital Conversions on I0/I2/I3'
                .INCLD COP888EK.INC
                
                
                .PUBLIC DOATOD,PROCAD,ENDAD,ADVCC2
                
                .EXTRN ADVOLTL,ADVOLTH,ADVPREL,ADVPREH
                .EXTRN ADCURRL,ADCURRH,ADCPREL,ADCPREH
                .EXTRN ADTEMPL,ADTEMPH,ADTPREL,ADTPREH
                .EXTRN ADVCC2L,ADVCC2H,AD2PREL,AD2PREH
                
		.EXTRN CONT17:REG:BYTE
		.EXTRN FLAG:BASE:BYTE
 
 
 ;                  A    to    D
 ;                  ============
 ;              Measurement - Cycles
 
 
 ; *** In this module, all A/D measurements will be done.  ***
 ; *** All Channels I0, I2 and I3 will be converted when   ***
 ; *** this subroutine is being called.                    ***
 ; ***  During the very first 16 cycles also the Vcc/2     ***
 ; *** (internal channel) will be measured and the results ***
 ; *** will be accumulated.                                ***
 ; ***  Finally the results will be processed in the way,  ***
 ; *** that the average of the 16 measurements is being    ***
 ; *** built and the results will be stored.               ***
 
        
;       
        
        VCC2    =       0
        
        .SECT ADCON,ROM

DOATOD:

        
        
        LD    CMPSL,#0BB     ; Select T2B input to
                             ; be driven directly
                             ; from the compout,
; select I0. w/ comp.- output on I7,enable
; comp.- output, disable constant current source,
; enable comparator and discharge capacitor.

;      CMPSL  =  1   0 1 1    1  0  1  1

        NOP                    ; give time to
        NOP                    ; discharge

        SBIT     CSEN,CMPSL    ; enable constant
                               ; current source
                                
;      CMPSL  =  1   0 1 1    1  1  1  1

        JSR     ADLOP          ; Execute A/D

        LD      B,#ADVOLTL     ; Point Low byte of
        JSR     SAFEAD         ; I0 (VOLT) storage
                               ; of 2nd convers.
                               ; and save                


        LD    CMPSL,#09B     ; Select T2B input to
                             ; be driven directly
                             ; from the compout,
; select Channel I2 w/ comp.- output on I7,enable
; comp.- output, disable constant current source,
; enable comparator and discharge capacitor.

;  CMPSL  =  1   0 0 1    1  0  1  1   

        NOP                     ; give time to
        NOP                     ; discharge cap.

        SBIT     CSEN,CMPSL    ; enable constant
                               ; current source
                                
;      CMPSL  =  1   0 0 1    1  1  1  1



        JSR     ADLOP           ; Execute A/D

        LD      B,#ADCURRL      ; Point Low Byte
        JSR     SAFEAD          ; of I2(CURRENT) storage
                                ; of first convers.
                                ; and save 
                                
        LD    CMPSL,#0AB     ; Select T2B input to
                             ; be driven directly
                             ; from the compout,
; select Channel I3 w/ comp.- output on I7,enable
; comp.- output, disable constant current source,
; enable comparator and discharge capacitor.

;  CMPSL  =  1   0 1 0    1  0  1  1


        NOP                     ; give time to
        NOP                     ; discharge cap.

        SBIT     CSEN,CMPSL    ; enable constant
                               ; current source
                                
;      CMPSL  =  1   0 1 0    1  1  1  1



        JSR     ADLOP           ; Execute A/D

        LD      B,#ADTEMPL      ; Point Low Byte
        JSR     SAFEAD          ; of I3 storage
                                ; of first convers.
                                ; and save
        IFBIT   VCC2,FLAG
        RET

ADVCC2:

        LD    CMPSL,#0FB     ; Select T2B input to
                             ; be driven directly
                             ; from the compout,
; select Vcc/2 Ref. w/ comp.- output on I7,enable
; comp.- output, disable constant current source,
; enable comparator and discharge capacitor.

;      CMPSL  =  1   1 1 1    1  0  1  1

        NOP                    ; give time to
        NOP                    ; discharge

        SBIT     CSEN,CMPSL    ; enable constant
                               ; current source
                                
;      CMPSL  =  1   1 1 1    1  1  1  1

        JSR     ADLOP          ; Execute A/D

        Ld      B,#ADVCC2L     ; Point Low byte of
        JMP     SAFEAD         ; Vref/2 storage
                               ; of first convers.
                               ; and save 


 
 ; ***       S  B  R  O  U  T  I  N  E  S       ***


ADLOP:
        LD      TMR2LO,#0FF     ; Init Timer 2
        LD      TMR2HI,#0FF

        LD      T2CNTRL,#0E0    ; Init timer mode

        RBIT    0,CMPSL         ; Start constant
LOPC:                           ; current source

        IFBIT   1,T2CNTRL       ; Check if value
        JP      OUT             ; captured.
        JP      LOPC            ; Loop until
        NOP                     ; value of Vcc/2
                                ; Ref. in capture
                                ; register.
OUT:    RBIT    CMPEN,CMPSL
        RET

; *** Here the end of the A/D conversion is ***
; *** indicated from the timer pending flag.***
; *** A more convenient method is to in-    ***
; *** dicate the end of a conversion cycle  ***
; *** via timer 2 interrupt source.         ***


; *** The foloowing saves the A/D results   ***
; *** (16-Bit) in the above mentioned RAMs. ***
        
SAFEAD:
        LD      A,T2RBLO      ; Load low byte of
        XOR     A,#0FF        ; capture timer,build
        X       A,[B-]        ; 1's complement,save
                              ; and dec. B-pointer.

        LD      A,T2RBHI      ; same as above on
        XOR     A,#0FF        ; high byte
        X       A,[B]

        LD      T2CNTRL,#0
        SBIT    0,CMPSL        ; disable comparator


        RET
        
             
                       
PROCAD:
        Ld      A,CONT17       ; Check if 1st 
        Ifeq    A,#16          ; time through
        Jp      SAV            ; If so, simply save!
        Ld      B,#ADTPREL     ; Accumulate events on
        Ld      A,ADTEMPL      ; Temperature measurement
        RC                     ; Reset Carry Flag
        ADC     A,[B]          ; Add Low-Bytes
        X       A,[B-]         ; Point High byte
        Ld      A,ADTEMPH      ; Add Hi -Bytes
        ADC     A,[B]          ; and save
        X       A,[B]
        RC
        
        Ld      B,#ADCPREL     ; Accumulate events on
        Ld      A,ADCURRL      ; Current measurement
        RC                     ; Reset Carry Flag
        ADC     A,[B]          ; Add Low-Bytes
        X       A,[B-]         ; Point High byte
        Ld      A,ADCURRH      ; Add Hi -Bytes
        ADC     A,[B]          ; and save
        X       A,[B]
        RC
        
        Ld      B,#ADVPREL     ; Accumulate events on
        Ld      A,ADVOLTL      ; Voltage measurement
        RC                     ; Reset Carry Flag
        ADC     A,[B]          ; Add Low-Bytes
        X       A,[B-]         ; Point High byte
        Ld      A,ADTEMPH      ; Add Hi -Bytes
        ADC     A,[B]          ; and save
        X       A,[B]
        
        IFBIT   VCC2,FLAG      ; Check if Vcc/2 measurement
        RET                    ; already done? If so,return.
ACCVCC2:
        Ld      B,#AD2PREL     ; Accumulate events on
        Ld      A,ADVCC2L      ; Voltage measurement
        RC                     ; Reset Carry Flag
        ADC     A,[B]          ; Add Low-Bytes
        X       A,[B-]         ; Point High byte
        Ld      A,ADVCC2H      ; Add Hi -Bytes
        ADC     A,[B]          ; and save
        X       A,[B]
        RET
SAV:
        Ld      B,#ADTPREL     ; Transfer 1st measured
        Ld      A,ADTEMPL      ; values of Temp. meas.
        X       A,[B-]         ; into RAM locations to
        Ld      A,ADTEMPH      ; accumulate results.
        X       A,[B]
        
        Ld      B,#ADCPREL     ; Transfer 1st measured
        Ld      A,ADCURRL      ; values of Curr. meas.
        X       A,[B-]         ; into RAM locations to
        Ld      A,ADCURRH      ; accumulate results.
        X       A,[B]
        
        Ld      B,#ADVPREL     ; Transfer 1st measured
        Ld      A,ADVOLTL      ; values of Temp. meas.
        X       A,[B-]         ; into RAM locations to
        Ld      A,ADVOLTH      ; accumulate results.
        X       A,[B]
        
        
        IFBIT   VCC2,FLAG      ; Check if Vcc/2 measurement
        RET                    ; already done? If so,return.
        
        
     
SAV1:
        Ld      B,#AD2PREL     ; Transfer 1st measured
        Ld      A,ADVCC2L      ; values of VCC/2. meas.
        X       A,[B-]         ; into RAM locations to
        Ld      A,ADVCC2H      ; accumulate results.
        X       A,[B]                  
        RET
        
        
ENDAD:
        LD      B,#ADTPREL      ; Point RAM with
        JSR     DIV16           ; accumulated TEMP.
        LD      B,#ADCPREL      ; Point RAM with
        JSR     DIV16           ; accumulated Curr.
        LD      B,#ADVPREL      ; Point RAM with
        JSR     DIV16           ; accumulated Volt.
        
        IFBIT   VCC2,FLAG      ; Check if Vcc/2 measurement
        RET                    ; already done? If so,return.
        
ENDVCC2:
        LD      B,#AD2PREL
;        JSR     DIV16          ; Can be left out if
;        RET                    ; Subroutine stays in
                                ; below place.
DIV16:                          
        RC                      ; Reset Carry Flag

        LD      A,[B]           ; Load Low-Byte value
        AND     A,#00F          ; mask out low-nibble
        IFGT    A,#007          ; Check if > 7 and set
        SC                      ; carry for rounding.
        LD      A,[B]           ; Load low-Byte value
        SWAP    A               ; again and swap.
                                ; (shift 4 times to
        AND     A,#00F          ; the right)
        X       A,[B-]          ; save in RAM and
        LD      A,[B+]          ; point High-Byte
        SWAP    A               ; swap to mask out
        AND     A,#0F0          ; lower nibble of
        ADD     A,[B]           ; high byte and add
                                ; to low-byte.
        X       A,[B-]          ; Save it!

        LD      A,[B]           ; Now shift high-Byte
        SWAP    A               ; 4 bits to the right
        AND     A,#00F          ; ===> equal to div16.
        X       A,[B+]          ; Save it!

        CLR     A               ; Finally add carry
        ADC     A,[B]           ; if set. The carry
        X       A,[B-]          ; flag is set if the
        CLR     A               ; LS-nibble was > 7
        ADC     A,[B]           ; in the majority
        X       A,[B]           ; of measurements.
        RET


