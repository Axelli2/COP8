/**************************************************************************/
/* File: VAR_FUNC.C							 */
/* Date: April 96							  */
/* This include file contains variable functions for different            */
/* purposes                                                     	  */
/**************************************************************************/
long Swap(long Swap_Var)		 /* Exchange Hi and Low byte	   */
{
	#asm
	  LD A,Swap_Var
	  X  A,Swap_Var+1
	  X  A,Swap_Var
	#endasm
	return(Swap_Var);
}
/**********************Simple-Pointer-Routine********************************/
int *pointer1;
void init_PORTL(void)
{
        pointer1 = &PORTLD;       // Configure PORTL as push/pull low
        *pointer1++ = 0;          // Output
        *pointer1   = 0xFF;
}
/**********************Dummy-Routine*****************************************/
void dummy_f(void)
{
NOP();
}
/****************************************************************************/
void fetch_rom_table()
{
	pointer = 0;
	Buffer_short = INTEGER_TABLE[pointer];
	pointer++;
	Buffer_long = LONG_INTER_TABLE[pointer];
}
/****************************************************************************/
/* Fill RAM from 06D to 000 with 0  */
void clear()
{	p_ointer = 0x6d;
        do
        {
	*p_ointer = 0;
        }
	while(p_ointer--); /* post dec. */
}
/****************************************************************************/
