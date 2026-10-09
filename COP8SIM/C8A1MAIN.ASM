#crossref
#noformfeed
#noheadings
         .TITLE  c8a1main,'Simple Multi-Module COP8 Assembler Demo Program'
         .LIST   X'FF             ;complete listing
         .CONTRL 0                ;disable all code alteration
         .CHIP   840              ;(doesn't really matter which)
;        .MAXROM X'0FFF
;==============================================================
; Output a pulse pattern on bit/pin 0 of PORTD
;==============================================================
         .INCLD C8A1INC.INC       ;Equates, Variables
;============================================================================
         .SECT  code,ROM         
         .EXTRN spin
reset:   LD    SP,#X'2F           ;(make it work on all COP8 parts)
start:   LD    trpcnt,#X'FF       ;
outer:     RBIT  outbit,PORTD     ;outbit <- 0  ----------------------- 
           LD    tmpcnt,#10       ;                         outer loop |
inner:       JSR   spin           ;--------------------------------    |
             LD    A,PORTD        ;Complement           inner loop |   |
             XOR   A,#outmsk      ;  bit #0                        |   |
             X     A,PORTD        ;  in PORTD                      |   |
             LD    B,#0           ;B register reflects             |   |
             IFBIT outbit,PORTD   ;  current state of              |   |
             LD    B,#1           ;  'outbit' in PORTD             |   |
             DRSZ  tmpcnt         ;                                |   |
             JP    inner          ;--------------------------------    |
           DRSZ  trpcnt           ;tripcnt--,                          |
           NOP                    ;  and nothing more                  |
           JSR   spin             ;                                    |
           JSR   spin             ;                                    |
           JP    outer            ;                                    |
endprg:  JMP   start              ;------------------------------------ 
;=================================;
         .END  reset              ;program starting address
