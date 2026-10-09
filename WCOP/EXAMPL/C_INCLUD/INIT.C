/**************************************************************************/
/* File: INIT.C								  */
/* Date: April 96							  */
/* This include file contains the initial settings and			  */
/* initialisation routines                                      	  */
/**************************************************************************/



void init_var_ports()
{
     /* 			  Configuring the ports 		*/
     PORTD = 0; 		/*Output low				*/
     PORTLD = 0xFF;		/*PortL Input, weak pull up		      */
     PORTLC = 0;
     PORTGD.0 = 1;		/* Input weak pull up G0		*/
     PORTGD.1 = 0;		/* Output G2,G3,G4,G5			*/
     PORTGD.2 = 1;		/* Input G6(SI), G7(CKO)=>Tristate	*/
     PORTGD.3 = 1;		/* Output G1(WDOUT)	=>Open Drain	*/
     PORTGD.4 = 1;
     PORTGD.5 = 1;
     PORTGD.6 = 0;
     PORTGD.7 = 0;
     PORTGC.0 = 0;
     PORTGC.1 = 0;
     PORTGC.2 = 1;
     PORTGC.3 = 1;
     PORTGC.4 = 1;
     PORTGC.5 = 1;
     PORTGC.6 = 0;
     PORTGC.7 = 0;
     PORTCD = 0;		/*All pins => Output push pull low	*/
     PORTCC = 0xFF;
}


/* sets the timer T1 (pwm mode) to ton = 25 us, toff = 80 us		  */

void init_t2_pwm()
{
     PORTLC.4 = 1;		/* configure L4 as output		  */
     TMR2 = 99; 		/* Both ways are possible as long var.	  */
/*   TMR2LO = 99;		/* or as short var.			  */
     TMR2HI = 0;   */
     T2RALO = 49;		/* 50 us on time			  */
     T2RAHI = 0;
     T2RBLO = 99;		/* 100 us off time			   */
     T2RBHI = 0;
     T2CNTRL.T2C1 = 1;		/* Timer2 in PWM mode, toggle L4	   */
     T2CNTRL.T2C2 = 0;
     T2CNTRL.T2C3 = 1;
     T2CNTRL.T2C0 = 1;		/* start Timer2 			  */
}


void init_control_r()
{
     PSW.GIE = 1;       /* global interrupt enable                        */
     CNTRL.IEDG = 0;    /* External interrupt edge polarity (0 = rising)  */
     PSW.EXPND = 0;     /* Clear external interrupt pending flag          */
     PSW.EXEN = 1;      /* Enable external interrupt on PortG ZeroX       */
     T2CNTRL.T2ENB = 1; /* Enable T2B underflow interr. 		  */
     T2CNTRL.T2ENA = 1; /* Enable T2A underflow interr. 		  */

}


void init_idle_timer()
{
     ICNTRL.T0PND = 0;              /* !Always clear pending flags first */
     ICNTRL.T0EN = 1;               /* enable interrupts from T0     */
}

void init_function()
{
  init_var_ports();		    /* Init Ports			 */
  init_idle_timer();		    /* Init Idle Timer			 */
  init_control_r();		    /* Init control register		 */
  init_t2_pwm();		    /* Init Timer T2 as pwm Timer	 */
}
