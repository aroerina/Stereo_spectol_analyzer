/*
接続
PB0: FPGA IO OUTPUT =>INPUT
PB1: FPGA IO INPUT	=>OUTPUT
PB2: No Connect
PB3: KB
PB4: MOS-FET Control Tr Base

*/
#define F_CPU	1200000UL			//クロック指定 1.2MHz = 9.6MHz/8

#include <avr/io.h>
#include <util/delay.h>
#include <bit.h>
#define TACT_MASK 0x08

int main(){
	DDRB	= 0x12;
	PORTB	= 0x08;	//KB Pullup
	
	byte after_tac,before_tac;
	byte push_count=0;
	bool push_done=FALSE;
	
	bool power = FALSE;
	_delay_ms(500);
	for(;;){
		before_tac = PINB & TACT_MASK;
		_delay_ms(1);
		
		after_tac = PINB & TACT_MASK;

		if(before_tac > after_tac){
			push_count=0;
			while((PINB & TACT_MASK)==0){
				_delay_ms(1);
				push_count++;
				if(push_count>16){
					push_done=TRUE;
					break;
				}
			}
		}

		if(push_done){
			push_done=FALSE;
			if(power){		// ON  -> OFF
				sbi(PORTB,PB1);
				while(!( PINB & 0x01 ));	//FPGAの応答を待つ
				PORTB = 0x08;
				power = FALSE;
			} else {		// OFF ->  ON
				sbi(PORTB,PB4);
				power = TRUE;
			}
		}
	}
}
