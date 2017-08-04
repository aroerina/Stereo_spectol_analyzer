#include "mylm8.h"
// ext_dout output Strove
#define STARTLDR		0x01
#define ADR_START_SC	0x02
#define F_ROMADDR 		0x04
#define FFTCADDR		0x08
#define SC_X			0x10
#define ADR_SC_THRU		0x20
#define ADR_START_RO	0x40
#define ADR_START_SW	0x80

// Set SC Thru mode
#define SC_THRU_ON		OUT(ADR_SC_THRU,1)
#define SC_THRU_OFF		OUT(ADR_SC_THRU,0)

// Start Strove
#define START_RO	OUT(ADR_START_RO,0)
#define START_SC 	OUT(ADR_START_SC,0)
#define START_SW	OUT(ADR_START_SW,0)

// ext_addr input Strove
#define MOD_STATUS	0x01
#define F_ROMQ		0x02
#define SC_H		0x04

// Module Status
#define STARTSEQ	IN(MOD_STATUS) & 0x01
#define FFTEND		IN(MOD_STATUS) & 0x02
#define READY_SW	IN(MOD_STATUS) & 0x04
#define READY_RO	IN(MOD_STATUS) & 0x08
#define BAR0ISBIG	IN(MOD_STATUS) & 0x10

#define F_ROM_DEPTH 304-1
#define H_ROM_DEPTH 49

uint fftcaddr;
void out_x(byte x){
	OUT(SC_X,x);
	_until( READY_SW);
	START_SW;
}

void fftcadd(){
	fftcaddr = fftcaddr + IN(F_ROMQ);	//FFTCアドレス加算
	OUT(FFTCADDR,fftcaddr);				//FFTCAddr出力
	/*
	__asm__ volatile(
		"import		r0,0x02		\n\t"
		"add		%A0,r0		\n\t"
		"addic		%B0,0		\n\t"
		"mov		r13,%B0		\n\t"
		"movi		r0,0x08		\n\t"
		"exporti 	r0,%A0		\n\t"
		: "=&r"(fftcaddr) : "0"(fftcaddr) : "r0","r13"
	);*/
}

int main(){
	ITR_OFF;	// 割り込みOFF
	fftcaddr	= 0;
	uint f_romaddr	= 0;
	byte h,x;
	for(;;){
		_until( STARTSEQ );			//Wait StartSeq
		
		OUT(STARTLDR|F_ROMADDR,0);	// Start FFTLoader &  ROM Addr Reset
		SC_THRU_ON;
		
		_until( FFTEND );			//Wait FFTEnd
		
		fftcadd();
			
		START_RO;
		f_romaddr++;
		OUT(F_ROMADDR,f_romaddr);
		
		_until( READY_RO );
		START_SC;
		SC_THRU_OFF;
		
		fftcadd();
		
		f_romaddr++;
		// 補完を必要とする区間
		while(f_romaddr < H_ROM_DEPTH){
			START_RO;
			fftcadd();
			OUT(F_ROMADDR,f_romaddr);
			
			h = IN(SC_H);
			_until( READY_RO );
			START_SC;
			
			if(BAR0ISBIG)
				for(x = 0;x < h;x++) out_x(x);
			else
				for(x = h;x > 0;x--) out_x(x);
			f_romaddr++;
		}
		
		SC_THRU_ON;
		
		//補完が必要ない区間
		while(f_romaddr <= F_ROM_DEPTH){
			//_until( READY_SW ); 				// SW空きを待つ
			//OUT((ADR_START_SW|ADR_START_RO),0);	//START SW & RO
			__asm__ volatile(
				// SW空きを待つ
				"import r0,0x01	\n\t"
				"testi	r0,0x04	\n\t"
				"bz		-2		\n\t"
				"movi	r0,192	\n\t"
				"export r0,0	\n\t"	//START SW & RO
				:::"r0"
			);
			
			fftcadd();
			
			f_romaddr++;						//周波数ROMアドレス加算
			OUT(F_ROMADDR,f_romaddr);			//ROMアドレス出力
		}
		
		f_romaddr	= 0;
		fftcaddr	= 0;
	}
}