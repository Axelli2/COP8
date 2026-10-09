	.incld cop820.inc
;declare public variables and label
	.public ba,da,ra,label,top_of_stack
;declare BASE data
	.sect b,base
ba: 	.dsb 1
;declare RAM  data
	.sect d,ram
da: 	.dsb 1
;declare stack
	.sect stack,ram
	.dsb 01f
top_of_stack: .dsb 1
;declare REG data
	.sect r,reg
ra: 	.dsb 1
.ifdef SPECIAL 		;only for special chip
	.public ea,sa,sb
;declare EERAM data
	.sect e,eeram
ea: 	.dsb 1
;declare SEG data
	.sect s,seg
sa: 	.dsb 1
;declare SEGB data
	.sect sb,segb
sb: 	.dsb 1
.endif
;declare jid table to be placed in a page
;external label
	.extrn labela:rom
	.sect i,rom,inpage
label:
	add a,#low(label)	;add 8 bit offset of start of start
	jid
	.addr la,lb
la: 	jmp labela		;two byte jmp only for SMALL model
lb: 	jmp sect_t_label	;two byte jmp only for SMALL model
;same relocatable section as in copxxx.asm
	.sect t,rom
;place extrn in section so ASMCOP know labelb in same section t
	.extrn labelb
sect_t_label: 
	jmp labelb		;two byte jmp for SMALL and MEDIUM
