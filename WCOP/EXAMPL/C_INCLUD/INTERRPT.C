/**************************************************************************/
/* File: INTERRPT.C							  */
/* Date: April 96							  */
/* This include file contains the software for interrupt		  */
/* definition and handling						  */
/**************************************************************************/

/************************ Interrupt entry point ***************************/
/* generate code starting at 0xff                                         */
/**************************************************************************/

#pragma memory ROM [40] @ 0x00ff;

/**************************************************************************/
/* Context switching for interrupt entry point                            */
/**************************************************************************/
#asm
     PUSH    A      ; store Accumulator
     LD      A,B    ;
     PUSH    A      ; store B register
     LD      A,X    ;
     PUSH    A      ; store X register
     VIS            ; vector to interrupt service routine
#endasm

#asm
INT_EXIT
    POP      A      ; Restore X register
    X        A,X    ;
    POP      A      ; Restore B register
    X        A,B    ;
    POP      A      ; Restore accumulator
    RETI
#endasm

/**************************************************************************/
/* set up the interrupt vectors  in a vector table                        */
/**************************************************************************/

#pragma memory ROM [32] @ 0x1E0;

#asm
    .addrw    Trap      ;  VIS without any interrupts
    .addrw    Trap      ;  Port L edge (MIWU)
    .addrw    Trap      ;  Timer T3B
    .addrw    Trap      ;  Timer T3A/underflow
    .addrw    TimerT2B	;  Timer T2B
    .addrw    TimerT2A	;  Timer T2A/underflow
    .addrw    Trap      ;  UART - Send
    .addrw    Trap      ;  UART - Receive
    .addrw    Trap      ;  Reserved
    .addrw    Trap      ;  Microwire Plus - BUSY goes low
    .addrw    Trap	;  Timer T1B
    .addrw    Trap	;  Timer T1A/underflow
    .addrw    IdleTimer ;  Idle Timer T0 bit 12 toggling
    .addrw    Ext_int	;  Pin G0 edge
    .addrw    Trap      ;  Reserved
    .addrw    Trap      ;  INTR instruction
#endasm

/**************************************************************************/
/* Interupt routines                                                      */
/**************************************************************************/

#pragma memory ROM [0x1fff-0x200] @ 0x200;

/* To trap unused interrupts to reset the COP8 the following 		  */
/* code is included in the application code                  		  */

void Trap(void)
{
#asm
     RPND         ;    Clear Software Interrupt pending bit
     JMPL    00000;    execute reset routine
#endasm
}

void Ext_int(void)
{
	PSW.EXPND = 0;		/* Reset external interr. pending flag	    */
	dummy_f();
	goto INT_EXIT;
}


void TimerT2B(void)
{
	T2CNTRL.T2PNDB = 0;	/* Reset Timer pending flag		    */
	dummy_f();
	goto INT_EXIT;
}

void TimerT2A(void)
{
	T2CNTRL.T2PNDA = 0;	/* Reset Timer pending flag		    */
	dummy_f();
	goto INT_EXIT;
}


void IdleTimer(void)
{
     /* Interrupt from the Idle Timer (T0). Every 4096 cycles this	    */
     /* service routine is entered.					    */
     ICNTRL.T0PND = 0; /* Reset the Idle timer interrupt pending flag	    */
     dummy_f();
     goto INT_EXIT;
}

/***************************** End Interrupts *****************************/
