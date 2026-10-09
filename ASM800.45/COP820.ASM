	.incld cop820.inc
;external data variables
	.extrn ba:base
	.extrn da:ram
	.extrn top_of_stack:ram
	.extrn ra:reg
.ifdef SPECIAL		;only if special chip 
	.extrn ea:eeram
	.extrn sa:seg
	.extrn sb:segb
.endif
;external label
	.extrn label:rom
;start of code at address zero
	.sect start,rom
start:
	ld sp,#top_of_stack
	ld a,ba
	jsr label	;two byte jsr for SMALL model, else three bytes
	jp .
;relocatable code section with public labels
	.sect t,rom
	.public labela,labelb
labela:
	ld a,da
	ret
labelb:
	ld a,ra
.ifdef SPECIAL		;only if special chip 
	add a,ea
	ld 0xff,#h(sa) ;set segment on
	add a,sa
	add a,sb
.endif
	ret
	.end start
