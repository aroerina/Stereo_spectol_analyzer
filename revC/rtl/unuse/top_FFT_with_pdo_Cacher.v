//`define		SIM
//Cacher無し

/*Port list
 
top_FFT top
(
	.Clock(Clock),
	.Reset(Reset),
	
	//For SRAM
	.nWE(nWE),
	.SRAMIO(SRAMIO),
	.SRAMAddr(SRAMAddr),
	
	//For LCDs
	.VS(VS),
	.HS(HS),
	.L_RGB(L_RGB),
	.R_RGB(R_RGB)
);
*/ 


module top_FFT_with_pdo_Cacher
(
	input IN_PLLClock,Reset,
	
	//For SRAM
	output nWE,nOE,
	inout [14:0]	SRAMIO,
	output [17:0]	SRAMAddr,
	 
	//For LCDs
	output DotClock,VS,HS,
	output [14:0]	L_RGB, R_RGB
	
`ifndef SIM
	//Debug Pin
	,
	output [1:0]	LED
`endif

);
	// 動作クロック：ドットクロック 16:1
	////////////////////////////////////////////////////
	// Instansiation
	
	//GSR gsr(Reset);
	
	`ifdef SIM
			pdo_PLL pll(Reset,PLLClock);
	`else	//Synthesys
			PLL pll (.CLK(IN_PLLClock), .CLKOP(PLLClock) ,.CLKOS(Clock));
			LED_Flicker #(.bw_cntr(26)) cntr0(PLLClock,Reset,LED[0]);
			LED_Flicker #(.bw_cntr(24)) cntr1(IN_PLLClock,Reset,LED[1]);
	`endif
	
	// 1/4 Clock Divider
	CLKDIVB clock_diva (.RST(Reset),.CLKI(IN_PLLClock),.RELEASE(1'b1), 
	.CDIV4(DotClock)
	);

	
	//CLKOP = 64MHz
	//CLOKOS = IN_PLLClock スルー
	
	parameter bw_romaddr = 11;
	parameter bw_data = 16;
	
	//波形保存
	pdo_Cacher_2048
	pdo_cacher	(
		.Clock(PLLClock),
		.Reset(Reset),
		.DPRAMAddr(DPRAMAddr),
		.DataL(DataL),
		.DataR(DataR)
	);
	wire [bw_romaddr-1:0] DPRAMAddr;
	wire [bw_data-1:0] DataL,DataR;
	
	//スペクトル化
	Spectolizer #(
		.bw_romaddr(bw_romaddr),
		.bw_data(bw_data))
	top_sl (
		.Clock(PLLClock),		//i
		.Reset(Reset),			//i
		
		//For Cacher
		.DataR(DataR),				//i
		.DataL(DataL),				//i
		.DPRAMAddr(DPRAMAddr),		//i
		
		//For VRAMControl
		.SWClockEn(SWClockEn),		//i
		.StartLoader(StartLoader),	//i
		.Color(Color),				//o
		.Screen(Screen),			//o
		.X(X),						//o
		.Y(Y)						//o
	);
	
	wire [8:0] 	X;
	wire [6:0]	Y;
	wire [14:0]	Color;
	
	
	//VRAM Control
	VRAMCtrl vramcont
	(
		.Clock(PLLClock), 
		.Reset(Reset),
		.DotClock(DotClock),
		//Write Address
		.Screen(Screen),
		.WrAdr_X(X),
		.WrAdr_Y(Y),
		//Write Data
		.WriteData(Color),
		
		.SWClockEn(SWClockEn),
		.nWE(nWE),
		.nOE(nOE),
		.Address(SRAMAddr),
		.IO(SRAMIO),
		.R_RGB(R_RGB) ,
		.L_RGB(L_RGB),
		.VS(VS),
		.HS(HS),
		.StartLoader(StartLoader)
	);

	
endmodule 