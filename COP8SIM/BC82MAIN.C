/* File:  bc82main.c */

/* C Language Demo Program 'BC82MAIN.COD',
** for use with the Byte Craft COP8 C Cross-compiler,
** Version 1.00 or later.
** Version actually used here:     Compiler:  Alpha V0.16
**
** This program replicates, as closely as possible (except for actual timing),
** the functionality of the assembly language demo program 'demo_c8.asm'.
**
** Modules (Files) in BC82MAIN.COD:
**   bc82main.c -- C, main program (function 'main()')
**   bc82innr.c -- C, function 'InnerLoop( repeat_cnt )'
**   bc82wast.c -- C, function 'WasteTime()'
**   bc82prag.h -- include file
*/

#include "bc82prag.h"

/* external function prototypes (interface specifications) */
/*extern*/ static void	InnerLoop	(char);	/* prototype */
/*extern*/ static void	WasteTime	(void);	/* prototype */

/*#include <stdio.h>*/

#define	TRUE	1
#define	FALSE	0

bits		PORTD	@0xDC;	/* standard PORTD register */
#define	OUTBIT	0		/* Bit #0 in PORTD */
#define	OUTMSK	0x01	/* mask for Bit #0 in PORTD */

char	trip_count;	/* dummy counter (rolls over at 256) */

void main(void)
{
	/* Allow program to run in any COP8 processor --
	** (load a valid value into the Stack Pointer).
	*/
#asm
	LD	SP,#47		; 0x2F == 47 decimal
#endasm

	trip_count = 255;
	while (TRUE) {
		PORTD.OUTBIT = 0;	/* Set bit #0 in PORTD low at start */
		InnerLoop( 10 );	/* Generate 5 pulses */
		trip_count--;
		WasteTime();		/* Call 'wastetime' twice to generate   */
		WasteTime();		/* blank pulse between sets of 5 pulses */
		} /* while TRUE */

} /* end of function:  'main()' */

#include "bc82innr.c"
#include "bc82wast.c"
