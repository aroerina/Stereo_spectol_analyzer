
`ifdef N64	//要素数64
	`define BW_FFTPOINT 6
	`define BW_DATA		9
	`define BW_FFTDATA	9

`else		//要素数2048
	`define BW_FFTPOINT 11
	`define BW_DATA		16
	`define BW_FFTDATA	16
`endif

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
	
	`ifndef NO_DAI
	//For DAI
	input BCK,LRCK,SData,
	`endif
	
	//For SRAM
	output nWE,nOE,
	inout	[14:0]	SRAMIO,
	output	[17:0]	SRAMAddr,
	 
	//For LCDs
	output	DotClock,VS,HS,
	output 	[14:0]	L_RGB, R_RGB
	
	//Debug Pin
	`ifndef SIM
	,
	output	[1:0]	LED
	`endif

);

	////////////////////////////////////////////////////
	// Instansiation
	
	localparam bw_data		= `BW_DATA;		//DAI出力ビット幅
	localparam bw_fftdata	= `BW_FFTDATA;	//FFT入力ビット幅
	localparam bw_fftp		= `BW_FFTPOINT;	//FFT要素数 2^x
	localparam bw_dpram		= `BW_FFTPOINT+1;

	`ifdef SIM
			pdo_PLL pll(.Clock(PLLClock),.Reset(Reset));
	`else	//Synthesys
			PLL pll (.CLK(IN_PLLClock), .CLKOP(PLLClock) ,.CLKOS(Clock));
			LED_Flicker #(.bw_cntr(26)) cntr0(PLLClock,Reset,LED[0]);
			LED_Flicker #(.bw_cntr(24)) cntr1(IN_PLLClock,Reset,LED[1]);
	`endif

	// 1/4 Clock Divider
	CLKDIVB clock_div (.RST(Reset),.CLKI(IN_PLLClock),.RELEASE(1'b1), 
	.CDIV4(DotClock));
	
	//CLKOP = 64MHz
	//CLOKOS = IN_PLLClock スルー
	
	`ifdef NO_DAI
		pdo_Cacher #(
			.bw_dpram(bw_dpram),
			.bw_data(bw_data))
		pdo_cacher	(
			.Clock(PLLClock),
			.Reset(Reset),
			.DPRAMAddr(DPRAMAddr),
			.RAM_Q(RAM_Q)
		);
	`else
	//波形保存
	Cacher #(
		.bw_dpram(bw_dpram),
		.bw_data(bw_data)) 
	cacher	(
		.Clock(PLLClock),
		.Reset(Reset),
		.BCK(BCK),
		.LRCK(LRCK),
		.SData(SData),
		.DPRAMAddr(DPRAMAddr),
		.RAM_Q(RAM_Q)
	);
	`endif
	
	wire [bw_fftp:0] DPRAMAddr;
	wire [bw_data-1:0] RAM_Q;
	
	//スペクトル化
	Spectolizer2 #(
		.bw_fftp(bw_fftp),
		.bw_data(bw_data),
		.bw_fftdata(bw_fftdata))
	top_sl (
		.Clock(PLLClock),		//i
		.Reset(Reset),			//i
		
		//For Cacher
		.RAM_Q(RAM_Q),				//i
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
		
		//For Spectol Writer
		.Screen(Screen),
		.WrAdr_X(X),			//i
		.WrAdr_Y(Y),			//i
		.WriteData(Color),		//i	
		.SWClockEn(SWClockEn),	//o
		
		//For SRAM
		.nWE(nWE),				//o
		.nOE(nOE),				//o
		.Address(SRAMAddr),		//o
		.IO(SRAMIO),			//io
		.R_RGB(R_RGB) ,			//o
		.L_RGB(L_RGB),			//o
		.VS(VS),				//o
		.HS(HS),				//o
		.StartLoader(StartLoader)	//o
	);
	defparam vramcont.hs_offset_minus = 1;
endmodule 