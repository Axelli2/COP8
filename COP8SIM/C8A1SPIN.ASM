#crossref
#noformfeed
#noheadings
         .TITLE  c8a1spin,'Simple Multi-Module COP8 Assembler Demo Program'
         .LIST   X'FF             ;complete listing
         .CONTRL 0                ;disable all code alteration
         .CHIP   840              ;(doesn't really matter which)
;        .MAXROM X'0FFF
;==============================================================
; Output a pulse pattern on bit/pin 0 of PORTD
;==============================================================
         .INCLD C8A1INC.INC       ;Equates, Variables
;============================================================================
         .SECT   spin_code,ROM
         .PUBLIC spin

;=================================;
spin:    LD    r0,#X'04           ;
spinlp:  DRSZ  r0                 ;
         JP    spinlp             ;
         RET                      ;
;=================================;

; Test other section types:

         .SECT    unused_sect_1,BASE
us1_b_1: .dsb     1 
         .ENDSECT

         .SECT    unused_sect_2,RAM
us2_b_1: .dsb     1 
         .ENDSECT

;Warning 251 on the follwing is OK (harmless)
         .SECT    unused_sect_3,EERAM
us3_b_1: .dsb     1 
         .ENDSECT

;Warning 251 on the follwing is OK (harmless)
         .SECT    unused_sect_4,SEG
us4_b_1: .dsb     1 
         .ENDSECT

         .END




