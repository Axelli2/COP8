#pragma option v;   /* symbol table information is added to the bin. code */
#pragma option s1;  /* symbol file is generated */
#pragma option K;
/* **************************************************************************
 ; *									    *
 ; *			     COP888EG					    *
 ; *									    *
 ; **************************************************************************
 ;
 ; THIS FILE PREDECLARES ITEMS FREQUENTLY USED BY THE
 ; COP8 PROGRAMMER.
 ; REGISTER NAMES, CONTROL BITS, ETC. ARE NAMED THE SAME WAY
 ; AS IN THE DATA-SHEETS.
 ;
 ; ************************************************
 ; * PORT- , CONFIGURATION- AND CONTROL REGISTERS *
 ; ************************************************
 */
#pragma memory ROM [0x01FFF] @ 0;  /* ROM Range from 0-01FFF COP888EG */
#pragma memory RAM [0x70] @ 0;	  /* RAM Range from 0-6F	 */
#pragma memory RAM [12] @ 0x0F0;  /* REG Range from f0-FB        */
#pragma memory RAM [0x80] @ 0x100;/* RAM Range from 0100-017F	 */
#pragma has 888;		  /* Instruction set is COP888	 */
#pragma has SREG;
/* define all interrupt vectors using VIS instruction */
#pragma vector VIS_only  @ 0x1E0;   /* VIS without any inter. */
#pragma vector PORTL     @ 0x1E2;   /* Portl edge */
#pragma vector T3B       @ 0x1E4;   /* Timer3B Interrupt */			
#pragma vector T3A       @ 0x1E6;   /* Timer3A Interrupt */
#pragma vector T2B	 @ 0x1E8;   /* Timer2B */
#pragma vector T2A	 @ 0x1EA;   /* Timer2A/Underflow */
#pragma vector UARTTR    @ 0x1EC;   /* UART-Transmit */
#pragma vector UARTRE    @ 0x1EE;   /* UART-Recieve */
#pragma vector RES1      @ 0x1F0;   /* Reserved */
#pragma vector MWIRE     @ 0x1F2;   /* UWIRE Busy goes low */
#pragma vector T1B	 @ 0x1F4;   /* Timer1B */
#pragma vector T1A	 @ 0x1F6;   /* Timer1A/underflow */
#pragma vector T0	 @ 0x1F8;   /* Timer0 underflow */
#pragma vector EXTERNAL  @ 0x1FA;   /* External Interr. G0 Pin */
#pragma vector RES2      @ 0x1FC;   /* Reserved */
#pragma vector SWTRAP    @ 0x1FE;   /* Software interr. */

#pragma portrw PORTLD   @ 0xD0 ; /* PORT L DATA */
#pragma portrw PORTLC 	@ 0xD1 ; /* PORT L CONFIGURATION */
#pragma portrw PORTLP 	@ 0xD2 ; /* PORT L PIN */

#pragma portrw PORTGD 	@ 0xD4 ; /* PORT G DATA */
#pragma portrw PORTGC 	@ 0xD5 ; /* PORT G CONFIGURATION */
#pragma portrw PORTGP 	@ 0xD6 ; /* PORT G PIN */

#pragma portrw PORTCD 	@ 0xD8 ;
#pragma portrw PORTCC 	@ 0xD9 ;
#pragma portrw PORTCP 	@ 0xDA ;

#pragma portrw PORTD 	@ 0xDC ; /* PORT D */
#pragma portrw PORTI 	@ 0xD7 ; /* PORT I */

#pragma portrw SIOR 	@ 0xE9 ; /* SIO SHIFT REGISTER */
#pragma portrw S 	@ 0xFF ; /* SEGMENT REGISTER 		*/

#pragma portrw TMR1LO 	@ 0xEA ; /* TIMER 1 LOW BYTE */
#pragma portrw TMR1HI 	@ 0xEB ; /* TIMER 1 HIGH BYTE */
#pragma portrw T1RALO 	@ 0xEC ; /* TIMER 1 RA REGISTER LOW BYTE */
#pragma portrw T1RAHI 	@ 0xED ; /* TIMER 1 RA REGISTER HIGH BYTE */
#pragma portrw T1RBLO 	@ 0xE6 ; /* TIMER 1 RB REGISTER LOW BYTE */
#pragma portrw T1RBHI 	@ 0xE7 ; /* TIMER 1 RB REGISTER HIGH BYTE */

#pragma portrw TMR2LO 	@ 0xC0 ; /* TIMER 2 LOW BYTE */
#pragma portrw TMR2HI 	@ 0xC1 ; /* TIMER 2 HIGH BYTE */
#pragma portrw T2RALO 	@ 0xC2 ; /* TIMER 2 RA REGISTER LOW BYTE */
#pragma portrw T2RAHI 	@ 0xC3 ; /* TIMER 2 RA REGISTER HIGH BYTE */
#pragma portrw T2RBLO 	@ 0xC4 ; /* TIMER 2 RB REGISTER LOW BYTE */
#pragma portrw T2RBHI 	@ 0xC5 ; /* TIMER 2 RB REGISTER HIGH BYTE */
#pragma portrw T2CNTRL 	@ 0xC6 ; /* TIMER 2 CONTROL REGISTER */

#pragma portrw TMR3LO 	@ 0xB0 ; /* TIMER 3 LOW BYTE */
#pragma portrw TMR3HI 	@ 0xB1 ; /* TIMER 3 HIGH BYTE */
#pragma portrw T3RALO 	@ 0xB2 ; /* TIMER 3 RA REGISTER LOW BYTE */
#pragma portrw T3RAHI 	@ 0xB3 ; /* TIMER 3 RA REGISTER HIGH BYTE */
#pragma portrw T3RBLO 	@ 0xB4 ; /* TIMER 3 RB REGISTER LOW BYTE */
#pragma portrw T3RBHI 	@ 0xB5 ; /* TIMER 3 RB REGISTER HIGH BYTE */
#pragma portrw T3CNTRL 	@ 0xB6 ; /* TIMER 3 CONTROL REGISTER */

#pragma portrw CNTRL 	@ 0xEE ; /* CONTROL REGISTER */
#pragma portrw PSW	@ 0xEF ; /* PSW REGISTER */
#pragma portrw WDCNT	@ 0xC7 ; /* Watch Dog Service Register */
#pragma portrw WDEDG	@ 0xC8 ; /* MIWU Edge Select Register */
#pragma portrw WDEN	@ 0xC9 ; /* MIWU Enable Register */
#pragma portrw WKPND	@ 0xCA ; /* MIWU Pending Register */
#pragma portrw ICNTRL	@ 0xE8 ; /* ICNTRL Register */

#pragma portrw CMPSR	@ 0xB7 ; /* COMPARATOR Select Register */
#pragma portrw TBUF	@ 0xB8 ; /* UART TRANSMIT Register */
#pragma portrw RBUF	@ 0xB9 ; /* UART RECEIVE Register */
#pragma portrw ENU	@ 0xBA ; /* UART CONTROL and STATUS Register */
#pragma portrw ENUR	@ 0xBB ; /* UART REVEIVE CONTROL and STATUS Register */
#pragma portrw ENUI	@ 0xBC ; /* UART INTERRUPT and CLOCK SOURCE Register */
#pragma portrw BAUD 	@ 0xBD ; /* BAUD Register */
#pragma portrw PSR	@ 0xBE ; /* UART PRESCALER SELECT Register */

/*
 ********************
 * CONSTANT DECLARE *
 ********************/
/***** PSW register *****/
#define GIE              0    /* Global Interrupt Enable */
#define EXEN		 1    /* External Interrupt Enable */
#define BUSY             2    /* Microwire busy shifting flag */
#define EXPND		 3    /* External Interrupt Pending */
#define T1ENA            4    /* Timer T1A interrupt Enable */
#define T1PNDA           5    /* Timer T1A interrupt Pending */
#define CARRY            6    /* Carry Flag */

/***** CNTRL register *****/
#define SL0              0    /* Select Microwire clock divide */ 
#define SL1              1    /* see above */
#define IEDG             2    /* External Interrupt edge polarity 
                                 (0 = rising, 1 = falling ) */
#define MSEL             3    /* Selects ports G4, G5 as uwire SK and SO */
#define T1C0             4    /* Timer T1 start/stop Ctrl in mode 1 and 2 */
#define T1C1             5    /* Timer T1 Mode Control Bits */
#define T1C2             6
#define T1C3             7

/***** ICNTRL register *****/
#define T1ENB            0    /* Timer T1B interrupt Enable */
#define T1PNDB           1    /* Timer T1B interrupt Pending */
#define T0EN             4    /* idle Timer interrupt Enable */
#define T0PND            5    /* idle Timer interrupt Pending */

/***** T2CNTRL register *****/
#define T2ENB            0    /* Timer T2B interrupt Enable */
#define T2PNDB           1    /* Timer T2B interrupt Pending*/
#define T2ENA            2    /* Timer T2A interrupt Enable */
#define T2PNDA           3    /* Timer T2A interrupt Pending */
#define T2C0             4    /* Timer T2 Mode Control Bits */
#define T2C1             5
#define T2C2             6
#define T2C3             7

/***** T3CNTRL register *****/
#define T3ENB            0    /* Timer T3B interrupt Enable */
#define T3PNDB           1    /* Timer T3B interrupt Pending*/
#define T3ENA            2    /* Timer T3A interrupt Enable */
#define T3PNDA           3    /* Timer T3A interrupt Pending */
#define T3C0             4    /* Timer T3 Mode Control Bits */
#define T3C1             5
#define T3C2             6
#define T3C3             7

#define 0		 0
#define 1		 1
#define 2		 2
#define 3		 3
#define 4		 4
#define 5		 5
#define 6		 6
#define 7		 7





