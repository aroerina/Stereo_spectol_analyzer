/*Port list
 
top_FFT top
(
	.Clock(Clock),
	.Reset(Reset),
	
	//For DAI
	.BCK(BCK),
	.LRCK(LRCK),
	.SData(SData),
	
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
 
module top_FFT
(
	input IN_PLLClock,Reset,
	
	//For DAI
	input BCK,LRCK,SData,
	
	//For SRAM
	output nWE,
	inout [14:0]	SRAMIO,
	output [17:0]	SRAMAddr,
	
	//For LCDs
	output DotClock,VS,HS,
	output [14:0]	L_RGB, R_RGB,
	//LED
	output [1:0]	LED
);

	////////////////////////////////////////////////////
	// Instansiation

//	GSR gsr(Reset);
	
	PLL pll (.CLK(IN_PLLClock), .CLKOP(PLLClock) ,.CLKOS(Clock));
	
	CLKDIVB clock_div (.RST(Reset),.CLKI(Clock),.RELEASE(1'b1), 
	.CDIV4(DotClock) ,.CDIV8());
	
	assign LED[0] = Reset;
	
//	CNTR cntr0(PLLClock,Reset,LED[0]);
//	defparam cntr0.bw_cntr = 26;
	
	CNTR cntr1(DotClock,Reset,LED[1]);
	defparam cntr1.bw_cntr = 23;
	localparam bw_romaddr = 6;
	
	//波形保存
	Cacher #(.bw_romaddr(bw_romaddr)) 
	cacher	(
		.Clock(PLLClock),
		.Reset(Reset),
		.BCK(BCK),
		.LRCK(LRCK),
		.SData(SData),
		.DPRAMAddr(DPRAMAddr),
		.DataL(DataL),
		.DataR(DataR)
	);
	wire [bw_romaddr-1:0] DPRAMAddr;
	wire [8:0] DataL,DataR;
	
	//スペクトル化
	Spectolizer #(.bw_romaddr(bw_romaddr))
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