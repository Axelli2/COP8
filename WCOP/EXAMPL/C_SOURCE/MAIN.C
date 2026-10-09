/**************************************************************************/
/* File: MAIN.C 							  */
/* Date: April 96							  */
/* Ice Master Host software: 3.4 rev 14					  */
/* COP8C compiler: version 1.40				  */
/************************* Definitions ************************************/

#include <COP888.h>			  /* Declaration preprocessor dir.  */
					  /* Ports etc. 		    */
#include <globlvar.h>			  /* Global variables declaration   */
#include <table.h>			  /* The definition of tables	    */

/************************** Include "C" routines **************************/

#include <var_func.c>			/* various functions		  */
#include <interrpt.c>			/* Interrupt routines		  */
#include <init.c>			/* Initialising functions	  */

/***************************** MAIN FUNCTION ******************************/

void main()
{
 init_PORTL();
 clear();				/* Clear Memory 		   */
 init_function();			/* Init Ports, Timer, etc.	   */
 for(;;)
 {
	fetch_rom_table();		/* Handle lookup table		   */
 }
}

/******************************* END PROGRAM ******************************/
