/* Port list

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
`define SIMULATION

module top_FFT
(
	input Clock,Reset,
	
	//For DAI
	input BCK,LRCK,SData,
	
	//For SRAM
	output nWE,
	inout [14:0]	SRAMIO,
	output [17:0]	SRAMAddr,
	
	//For LCDs
	output DotClock,VS,HS,
	output [14:0]	L_RGB, R_RGB
);
	
	////////////////////////////////////////////////////
	// Instansiation
	
	// 1/4 Clock Divider
	CLKDIVB clock_div (.RST(Reset),.CLKI(Clock),.RELEASE(1'b1), 
	.CDIV4(DotClock));
	
	//PLL
	`ifdef `SIMULATION
	pdo_PLL pll(PLLClock);
	`else
	PLL pll (.CLK(Clock), .CLKOP(PLLClock), .LOCK());
	`endif
	
	
	
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
		.Clock(PLLClock),	//i
		.Reset(Reset),	//i
		
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
		.DotClock(DotClock),
		.Reset(Reset),
		.X(X),
		.Y(Y),
		.WriteData(Color),
		.SWClockEn(SWClockEn),
		.nWE(nWE),
		.Address(SRAMAddr),
		.IO(SRAMIO),
		.R_RGB(R_RGB) ,
		.L_RGB(L_RGB),
		.VS(VS),
		.HS(HS),
		.StartLoader(StartLoader)
	);

	
endmodule 