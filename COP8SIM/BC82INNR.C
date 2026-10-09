/* File:  bc82innr.c */

char	state;		/* 'state' reflects value in B (in original demo_c8.asm) */
char	i;

static void InnerLoop( char repeat_cnt )
{
	for ( i = 0;  i < repeat_cnt;  i++ ) {
		WasteTime();
		PORTD.OUTBIT ^= OUTMSK;				/* complement PORTD.0 */
		state = (PORTD.OUTBIT) ? 1 : 0 ;
		} /* end of:  for 'i' */

} /* end of function:  'InnerLoop( repeat_cnt )' */
