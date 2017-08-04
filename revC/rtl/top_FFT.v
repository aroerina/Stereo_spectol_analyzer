`define N4096
`define BW_FFTPOINT 12
`define BW_DATA		16


//`define DEBUG

module top_FFT
(
	
	input PmiClock,//Reset,
	
	//For ATTiny13
	output 	AVRPB0,
	input 	AVRPB1,
	
	//For Key Board
	input [5:0] KB,		//Pull Up
	
	//For PCM1802
	input	ADC_BCK,ADC_LRCK,ADC_SData, /* SData should PULLDOWN */
	output	ADC_nPDWN,ADC_CLK,
	
	//For CS8416
	input	DAI_BCK,DAI_LRCK,DAI_SData,DAI_Rerr,DAI_96KHZ,
	output	DAI_Reset,
	
	//For LM1972
	output	EVSPInCS,EVSPIClock,EVSPIData,
	
	//For AT93C46A
	input	SPI_MISO,	//	PULLDOWN
	output	SPI_MOSI,
	output	SPI_CS,
	output	SPI_CLK,
	
	//For SRAM
	output nWE,nOE,
	inout	[15:0]	SRAMIO,
	output	[17:0]	SRAMAddr,
	 
	//For LCD Left
	output	LCDL_DCK,LCDL_VS,LCDL_HS,
	output 	[4:0]	LCDL_R,LCDL_G,LCDL_B,
	
	//For LCD Right
	output	LCDR_DCK,LCDR_VS,LCDR_HS,
	output 	[4:0]	LCDR_R,LCDR_G,LCDR_B
);
	localparam bw_fftp = 12;
	
	wire Clock;
	//CLK=22.6 *3-> Clock=67.8 /16->DCK=4.23MHz 
	//64.54FPS 1Frame = 15.49ms
	PLL pll(.CLK(PmiClock), .CLKOP(Clock), .CLKOK(LCDL_DCK), .LOCK(LOCK));
	wire Reset	= ~LOCK;
	assign DAI_Reset = LOCK;
	assign ADC_nPDWN = LOCK;
	assign ADC_CLK	= ~PmiClock;
	wire NewFrame;	//画面のフレーム開始パルス
	
	
	
	`ifdef DEBUG
	wire [17:0] debug;
	assign debug[15:0] = spl.FFTCInData;
	assign debug[16] = spl.InputEnd;
	assign debug[17] = spl.FFTCInputEnable;
	assign {LCDR_DCK,LCDR_HS,LCDR_VS,LCDR_R,LCDR_G,LCDR_B} = debug;
	`endif
	
	parameter num_tact = 6;
	wire [num_tact-1:0] Push;
	TactPulse #(
		.num_tact(num_tact)
	) tpulse (
		.Clock(Clock),		//i
		.Reset(Reset),		//i
		.Frame(NewFrame),	//i
		.Tact(KB[num_tact-1:0]),			//i:num_tact
		.Push(Push)			//o:num_tact
	);
	
	// Digital Audio Input Select
	wire AudioInputSel;		// 		1:ADC	 		0:DAI
	wire BCK	= (AudioInputSel)?	ADC_BCK 	:	DAI_BCK		;
	wire LRCK	= (AudioInputSel)?	ADC_LRCK	:	DAI_LRCK	;
	wire SData	= (AudioInputSel)?	ADC_SData	:	DAI_SData	;
	wire ADCOverflow	= (AudioInputSel==1'b1) & ((DataCacher==16'h7fff)||(DataCacher==16'h8000));

	wire [12:0] LastWriteAddr;
	Cacher cacher	(	
		.Clock(Clock),
		.Reset(Reset),	
		.BCK(BCK),
		.LRCK(LRCK),
		.SData(SData),
		.LastWriteAddr(LastWriteAddr),	//bw:12
		.WrAddress(WrAddrCacher),		//bw:18
		.OutData(DataCacher)			//bw:16
	);
	wire [17:0] RdAddrLCDCtrl,RdAddrLoader,WrAddrCacher,WrAddrSW;
	wire [15:0] DataCacher,DataBurstWrite,SRAMQ;
	
	wire SRAMDataFrameStart;
	SRAMCtrl srmctl(
		.Clock(Clock),			// i
		.Reset(Reset),			// i
		
		//For SRAM
		.nWE(nWE),				// o
		.nOE(nOE),				// o
		.Address(SRAMAddr),		// i:18
		.IO(SRAMIO),			// io:16
		
		//For Cacher
		.WrAddrCacher(WrAddrCacher),		// i:18
		.DataCacher(DataCacher),			// i:16
		
		//For Spectorlizer
		.ReqBurstWrite(ReqBurstWrite),		// i
		.RdAddrBRead(RdAddrLoader),			// i:18
		.WrAddrBWrite(WrAddrSW),			// i:18
		.DataBWrite(DataBurstWrite),		// i:16
		.AValidBWrite(AValidSW),			// o
		.AValidBRead(AValidLoader),			// o

		// For LCDCtrl
		.FrameStart(SRAMDataFrameStart),	// i
		.AValidLCDCtrl(AValidLCDCtrl),		// o
		.RdAddrLCDCtrl(RdAddrLCDCtrl),		// i:18

		// SRAMQ
		.Q(SRAMQ)							// o:16
	);
	

	Spectolizer #(.bw_fftp(bw_fftp))
	spl
	(
		.Clock(Clock),		// i
		.Reset(Reset),		// i
		.Tact(Push),
		.DAI_Rerr(DAI_Rerr),
		//For LCDCtrl
		.Start(NewFrame),	// i
		
		//For SRAMControl
		.AddrValidLoader(AValidLoader),	// i
		.AddrValidSW(AValidSW),			// i
		.LastWriteAddr(LastWriteAddr),	// i:12
		.SRAMQ(SRAMQ),					// i:16
		.ReqBurstWrite(ReqBurstWrite),	// o
		.WrData(DataBurstWrite),		// o:16
		.WrSRAMAddress(WrAddrSW),		// o:18
		.RdSRAMAddress(RdAddrLoader),	// o:18

		//For EEPROM
		.SPI_MOSI(SPI_MOSI),		//i
		.SPI_MISO(SPI_MISO),		//o
		.SPI_CLK(SPI_CLK),			//o
		.SPI_CS(SPI_CS),			//o
		
		//For Volume
		.EVSPInCS(EVSPInCS),			//o
		.EVSPIClock(EVSPIClock),			//o
		.EVSPIData(EVSPIData),				//o

		//For AVR
		.AVR_IN(AVRPB1),			//i
		.AVR_OUT(AVRPB0),			//o
		
		.AudioInputSel(AudioInputSel),
		.ADCOverflow(ADCOverflow)
	);
	
	LCDCtrl lcdc(
		.Clock(Clock),					//i
		.DotClock(LCDL_DCK),			//i
		.Reset(Reset),					//i
		.InSRAMQ(SRAMQ[14:0]),			//i
		.NewFrame(NewFrame),			//o
		.SRAMDataFrameStart(SRAMDataFrameStart),	//o
		.L_RGB({LCDL_R,LCDL_G,LCDL_B}),	//o
		`ifndef DEBUG
		.R_RGB({LCDR_R,LCDR_G,LCDR_B}),	//o
		`endif
		.VS(LCDL_VS),					//o
		.HS(LCDL_HS),					//o
		.RdSRAMAddr(RdAddrLCDCtrl)		//o
	);
	`ifndef DEBUG
	assign LCDR_VS	= LCDL_VS;
	assign LCDR_HS	= LCDL_HS;
	assign LCDR_DCK	= LCDL_DCK;
	`endif

endmodule 