#include "mylm8.h"

// ext_dout output Strove address

#define ADR_START		0
// Start module select data
#define SW 				0x01
#define RO				0x02
#define LOADER			0x04
#define EE				0x08
#define HROM_ADDRRESET	0x10
#define	EVOL			0x20

#define ADR_SETREGS		1
//SettingRegs select data
#define SC_THRU			0x01
#define BWMUX			0x02
#define AUDIO_SEL		0x04	//1=ADC 0=DAI
#define GRADATION		0x08
#define AVR_OUT			0x10

#define ADR_MESSAGE		2
#define ADR_FW_POSX		3
#define ADR_FW_POSY		4
#define ADR_EEDATA		5
#define ADR_FALLSPEED	6
#define ADR_BARCOLOR	7
#define ADR_FONTCOLOR	8
#define ADR_EVOL_CH		9
#define ADR_EVOL_VOL	10

// Set SC Thru mode
#define SC_THRU_ON		setreg_out(SC_THRU)
#define SC_THRU_OFF		clrreg_out(SC_THRU)

// ext_din input Strove address
#define MOD_STATUS		0
#define F_ROMQ			1
#define SC_H			2
#define ADR_TACT		3
#define ADR_EEQ_H		4
#define ADR_EEQ_L		5
#define ADR_OVERFLOW	6

// Module Status
#define STARTSEQ	IN(MOD_STATUS) & 0x01
#define FFTEND		IN(MOD_STATUS) & 0x02
#define READY_SW	IN(MOD_STATUS) & 0x04
#define READY_RO	IN(MOD_STATUS) & 0x08
#define READY_FW	IN(MOD_STATUS) & 0x10
#define READY_EE	IN(MOD_STATUS) & 0x20
#define READY_AVR	IN(MOD_STATUS) & 0x40
#define READY_EVOL	IN(MOD_STATUS) & 0x80

#define F_ROM_DEPTH 		321
#define H_ROM_DEPTH 		73

#define H_ROM_DEPTH_OFFSET	2

#define EEOPC_WRITE_EN	0
#define EEOPC_WRITE		1
#define EEOPC_READ		2

// Tact swich
#define PUSH_ENTER		(tact&0x01)
#define PUSH_LEFT		(tact&0x02)
#define PUSH_RIGHT		(tact&0x04)
#define PUSH_UP			(tact&0x08)
#define PUSH_DOWN		(tact&0x10)
#define PUSH_CANCEL		(tact&0x20)	

#define F_CHAR		0x40

#define NORMAL_MENU		1
#define LOAD_PRESET		2

// font color
#define FC_NORMAL		0
#define FC_REVERSE		1

// input
#define DAI				0
#define ADC				1

//Message
/*
 0: COLOR
 1: FALL SPEED
 2: DISPLAY MODE
 3: INPUT SELECT
 4: SAVE PRESET
 5: INPUT VOLUME
 6: SPECTOL COLOR
 7: TOP COLOR
 8: R:
 9: G:
10: B:
11: / 7
12: GRADATION:
13: COMPLEMENT:
14: TOP DISPLAY:
15: ON
16: OFF
17: PRESET SAVE DONE
18: LOAD PRESET:
19: / 9
20: S/PDIF
21: LINE
22: LINE ATTENUATION: -
23: DB
24: INPUT SATURATION!
*/



inline void wait_sw() {
	__asm__ volatile(
			// SW空きを待つ
			"import r0,0x00	\n\t"
			"testi	r0,0x04	\n\t"
			"bz		-2		\n\t"
			:::"r0"
		);
	}

#define	setreg(x)		BS(setr,x)
#define clrreg(x)		BC(setr,x)
#define setreg_out(x)	BS(setr,x);OUT(setr,ADR_SETREGS);
#define clrreg_out(x)	BC(setr,x);OUT(setr,ADR_SETREGS);


// EEPROM Read
// EEPROM Shift Register 	Data_HI <= Data_LO <= ADDRESS <= OPCODE


void out_message(byte msg,byte x,byte color){
	OUT(x,ADR_FW_POSX);
	OUT(color,ADR_FONTCOLOR);
	OUT(msg,ADR_MESSAGE);
	_until(READY_FW);
}

int main(){

	/* Initialize Start */

	byte h,i,ch,cursor_color,temp,setr=0,menu_sel=0,menu2_sel=0,fallspeed=0,save_preset_sel=0,disp_save_done=0;
	byte frame_count=0,tact,load_preset_sel=0,att,input_sel=0,disp_overflow=0;
	bool menu_disp=FALSE,menu_forcus=FALSE,gradation,complement,top_disp,preset_save_flag=FALSE,preset_load_flag=TRUE;
	byte color[6];	//[0]:R [1]:G [2]:B [3]:TopR [4]:TopG [5]:TopB
	
	const byte first_menu_posx[5] = {2,27,70,115,160};	// 最初のメニューのメッセージ位置
	
	//EEPROM WRITE ENABLE
	OUT(0b110000,ADR_EEDATA);
	OUT(EEOPC_WRITE_EN,ADR_EEDATA);
	OUT(EE,ADR_START);
	

	
	/* Initilize end */
	
	for(;;){
		_until( STARTSEQ );		//Wait StartSeq
		
		/* FFT START  */
		for(ch=0;ch<2;ch++){
			
			OUT(LOADER,ADR_START);	// Start FFTLoader &  ROM Addr Reset
			
			_until( FFTEND );		//Wait FFTEnd
				
			if(complement){
			// 最初のスペクトルをセットする
				OUT(RO,ADR_START);
				_until( READY_RO );
				SC_THRU_OFF;
				OUT(RO,ADR_START);
				_until( READY_RO );
				OUT(HROM_ADDRRESET,ADR_START);	// HROM Address Reset
			}
		
			// 補完を必要とする区間
			for(i=0;i< (H_ROM_DEPTH-H_ROM_DEPTH_OFFSET);i++){
				h = IN(SC_H);
				OUT(RO,ADR_START);	//START SC & RO & INC ROMADDR
				for(;0<h;h--){
					_until( READY_RO );
					wait_sw();
					OUT(SW,ADR_START);
				}
			}
			

			if(complement){
				wait_sw();
				OUT(SW,ADR_START);	//START SW
				h = (F_ROM_DEPTH-H_ROM_DEPTH);// loop num
			} else {
				OUT(RO,ADR_START);
				h = (F_ROM_DEPTH-H_ROM_DEPTH)+1;
			}
				
			SC_THRU_ON;
			
			//補完が必要ない区間
			for(i=0;i <= h;i++){
				__asm__ volatile(
					// SW空きを待つ
					"import r0,0x00	\n\t"
					"testi	r0,0x04	\n\t"
					"bz		-2		\n\t"
					"movi	r0,3	\n\t"
					"export r0,0x00	\n\t"	//START SW & RO  INC ROMADDR
					:::"r0"
				);
			}
			
			wait_sw();		
			
		}

		
		setreg_out(BWMUX);
		

		
		// FFT END  //
			
		// READ EEPROM
		// EEPROM SAVE FORMAT 
		// ADRn {{2'b0,complement,gradation},R,G,B}	ADRn+1 {{1'b0,fallspeed},TopR,TopG,TopB}
		// EEPROM Shift Register 	Data_HI <= Data_LO <= ADDRESS <= OPCODE
		h = 0;
		i = 0;
		if(preset_load_flag){
			preset_load_flag	= FALSE;
			ch = (load_preset_sel<<1);
			do{
				// EEREAD START
				OUT(ch+i,ADR_EEDATA);	// Address set
				OUT(EEOPC_READ,ADR_EEDATA);
				OUT(EE,ADR_START);
				_until(READY_EE);
				// EEREAD END
				
				temp = IN(ADR_EEQ_H);
				fallspeed	= (temp>>4)|(fallspeed<<4);	// データ退避
				color[h]	= temp&0x0f;
				temp = IN(ADR_EEQ_L);
				color[h+1]	= temp>>4;
				color[h+2]	= temp&0x0f;
				h = 3;
				i++;
			} while (i<2);
			
			gradation	= (fallspeed>>4)&0x01;
			complement	= (fallspeed>>5)&0x01;
			fallspeed	= fallspeed & 0b0111;
		}
		
		if(IN(ADR_OVERFLOW)){	// ADC input Over flow
			disp_overflow=8;
		}		
		
		if(fallspeed==0)
			fallspeed=1;
		
		// カーソルの色決定
		frame_count++;
		if(frame_count&0x20)
			cursor_color = 1;
		else
			cursor_color = 0;

		tact = IN(ADR_TACT);
		
		if(menu_disp==0 && tact) { 
			if(PUSH_ENTER)
				menu_disp = 1;	// normal menu
			else {
				menu_disp = 2;	// load preset
				preset_save_flag = TRUE;
				save_preset_sel = 0;
			}
			tact = 0;
		}
			
		if((menu_forcus==0) && PUSH_CANCEL)
			menu_disp = 0;
		
		OUT(4,ADR_FW_POSY);
		

		
		
		if(menu_disp==1){
			
			// menu line 1 write start
			if(menu_forcus == 0 ){
				if(PUSH_LEFT && (menu_sel!=0))
					menu_sel -= 1;
				else if(PUSH_RIGHT && (menu_sel<4))
					menu_sel += 1;
			}
			

			for(i=0;i<5;i++){
				out_message(i,first_menu_posx[i],(menu_sel == i) && (cursor_color || menu_forcus));	// menu 1 draw
			}
			
			OUT(24,ADR_FW_POSY);
			
			// menu line 2 write start
			if(menu_forcus){
				switch(menu_sel){	// フォーカスがある
				
					//Display Color  R: G: B:
					case 0:		
						
						if( PUSH_LEFT && (menu2_sel>0))
							menu2_sel--;
						else if( PUSH_RIGHT && (menu2_sel<5))
							menu2_sel++;
						else if( PUSH_UP && color[menu2_sel]<15)
							color[menu2_sel]++;
						else if( PUSH_DOWN && color[menu2_sel]>0 )
							color[menu2_sel]--;
					
						out_message(6,4,FC_NORMAL);	//disp "SPECTOL COLOR"
					
						temp = 50;
						h=8;
						for(i=0;i<6;i++){
							_until(READY_FW);
							OUT(0,ADR_FONTCOLOR);
							OUT(temp,ADR_FW_POSX);	
							OUT(h,ADR_MESSAGE);		// disp R: G: B:
							
							_until(READY_FW);		// wait
							
							OUT(((menu2_sel == i) && cursor_color),ADR_FONTCOLOR);// disp select
							
							OUT((color[i]|F_CHAR),ADR_MESSAGE);
							temp += 13;
						
							h++;
							if(i==2){
								h = 8;
								_until(READY_FW);
								OUT(95,ADR_FW_POSX);
								OUT(0,ADR_FONTCOLOR);
								OUT(7,ADR_MESSAGE);	//disp "TOP COLOR"
								temp += 40;
							}
						}
						
					break;
						
					// Display fallspeed value
					case 1:
						
						if(PUSH_UP && fallspeed<7)
							fallspeed++;
						else if(PUSH_DOWN && fallspeed > 1)
							fallspeed--;
					
						out_message(fallspeed|F_CHAR,34,cursor_color);	// disp fallspeed
						out_message(11,40,FC_NORMAL);					// disp "/7"
					
					break;
						
					// Display DISPLAY MODE "GRADATION ON OFF" "COMPLEMENT ON OFF"
					case 2:
					
						if(menu_forcus==1){
							if(PUSH_LEFT)
								complement = TRUE;
							else if(PUSH_RIGHT)
								complement = FALSE;
							else if(PUSH_DOWN)
								menu_forcus = 2;
						} else if(menu_forcus==2){	// forcus == 2
							if(PUSH_LEFT){
								gradation = TRUE;
							} else if(PUSH_RIGHT){
								gradation = FALSE;
							} else if(PUSH_UP)
								menu_forcus = 1;
						}
						
						out_message(13,57,FC_NORMAL);				// disp "COMPLEMENT:"
						temp = (cursor_color||menu_forcus!=1);
						out_message(15,95,complement && temp);		// ON
						out_message(16,105,!complement && temp);	// OFF					

						OUT(38,ADR_FW_POSY);
						out_message(12,60,FC_NORMAL);				// disp "GRADATION:"
						temp = (cursor_color||menu_forcus!=2);
						out_message(15,95,gradation && temp);		// ON
						out_message(16,105,!gradation && temp);		// OFF
					
					break;
					
					// INPUT SELECT
					case 3:
						
						if(PUSH_RIGHT)
							input_sel = ADC;
						else if(PUSH_LEFT)
							input_sel = DAI;
						
						
						out_message(20,115,!input_sel);				// disp "S/PDIF"
						out_message(21,139,input_sel);				// disp "LINE"
						
					break;
					
					
					// SAVE PRESET
					case 4:
						if(save_preset_sel==0)
							save_preset_sel = 1;
					
						if(menu_forcus){
							if(PUSH_UP && (30>save_preset_sel))
								save_preset_sel++;
							else if(PUSH_DOWN && (0<save_preset_sel))
								save_preset_sel--;
							else if(PUSH_ENTER){
								preset_save_flag = TRUE;
								disp_save_done =64;		// 1秒ぐらい表示
							}
						}
						
						out_message(save_preset_sel|F_CHAR,166,menu_forcus && cursor_color);
						//out_message(19,170,FC_NORMAL);	// dips " / 9"
					break;
						
					default:
						break;
				}	// switch end
			}
			
			// menu forcus
			if((menu_forcus==0) && PUSH_ENTER)
				menu_forcus = 1;
			else if(PUSH_CANCEL) {	// menu clear1
				menu_forcus	= 0;
				menu2_sel 	= 0;
			}
			
		} else if(menu_disp==2){	// LOAD PRESET
			if(PUSH_DOWN && (0 < load_preset_sel)){
				load_preset_sel--;
				preset_load_flag = TRUE;
			}
			else if(PUSH_UP && (30 > load_preset_sel)){
				load_preset_sel++;
				preset_load_flag = TRUE;
			}
			else if(PUSH_CANCEL)
				menu_disp=0;
			
			out_message(18,8,FC_NORMAL);	// disp "LOAD PRESET"
			
			out_message(load_preset_sel|F_CHAR,47,cursor_color);
			
			//out_message(19,54,FC_NORMAL);	// disp "/ 9"
			
			save_preset_sel	= load_preset_sel;
		}	
		
		// menu disp end
		
		if(disp_save_done){
			OUT(44,ADR_FW_POSY);			// Pos Y set
			out_message(17,76,FC_REVERSE);	//disp "SAVE DONE"
			disp_save_done--;
		}
		
		if(disp_overflow){
			OUT(2,ADR_FW_POSY);				// Pos Y set
			out_message(42|F_CHAR,196,0);	// dips "□"
			disp_overflow--;
		}
		

		for(i=0;i<6;i++){
			OUT(color[i],ADR_BARCOLOR);
		}
		
		OUT(fallspeed,ADR_FALLSPEED);
		
		if(gradation){
			setreg(GRADATION);
		} else {
			clrreg(GRADATION);
		}
		
		bool end_state=FALSE;
		if(READY_AVR){
			preset_save_flag	= TRUE;
			save_preset_sel	= 0;
			end_state = TRUE;
		}
		
		if(preset_save_flag){
			preset_save_flag	= FALSE;									// Flag clear
			temp	= save_preset_sel<<1;									// EEPROM Address
			OUT((complement<<5)|(gradation<<4)|color[0],ADR_EEDATA);		// data hi set
			OUT((color[1]<<4)|color[2],ADR_EEDATA);							// data lo set
			OUT(temp,ADR_EEDATA);											// address set
			OUT(EEOPC_WRITE,ADR_EEDATA);									// opcode set
			// 4回データセットすると　EE Send
			_until(READY_EE);
			
			OUT((fallspeed<<4)|color[3],ADR_EEDATA);						// data hi set
			OUT((color[4]<<4)|color[5],ADR_EEDATA);							// data lo set
			OUT(temp+1,ADR_EEDATA);											// address set
			OUT(EEOPC_WRITE,ADR_EEDATA);									// opcode set
			// EE Send
			_until(READY_EE);			
		}
		
		if(end_state){
			setreg(AVR_OUT);	//電源ON -> 電源OFF
		}
		
		if(input_sel)
			setreg(AUDIO_SEL);	// ADC
		else
			clrreg(AUDIO_SEL);	// DAI
		
	
		OUT(0,ADR_EVOL_CH);		//ch
		_until(READY_EVOL);
		OUT(0,ADR_EVOL_VOL);	//volume
		OUT(1,ADR_EVOL_CH);		//ch
		_until(READY_EVOL);
		
		clrreg_out(BWMUX);
	}
}