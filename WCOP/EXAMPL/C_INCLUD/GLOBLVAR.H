/**************************************************************************/
/* File: GLOBLVAR.H						          */
/* Date: Oct 1995						       */
/* This include file contains the declaration of global		          */
/* variables.							          */
/**************************************************************************/



/* min max limit declaration */
struct limits {
	     int Min;
	     int Max;
};

struct limits freq_one, freq_two;

/* variables declaration */
/* bits is a predefined var to access bitwise */

bits control_flag;

register unsigned int *p_ointer;

char pointer;

int  Buffer_short;
long Buffer_long;
long TMR2 @0xC0;

/* Stack definition  */
#pragma stack [8] @ 0x6f;



