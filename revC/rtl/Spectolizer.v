//スペクトル化
/* Portlist
Spectolizer #(.bw_fftp())
	top_sl
	(
		.Clock(Clock),		// i
		.Reset(Reset),		// i
		
		//For Cacher
		.LastWriteAddr(),	// i:13
		
		//For SRAMControl
		.Start(),			// i
		.AddrValidLoader(),	// i
		.AddrValidSW(),		// i
		.SRAMQ)(),			// i:16
		.ReqBurstWrite(),	// o
		.WrData(),			// o:16
		.WrSRAMAddress(),	// o:18
		.RdSRAMAddress(),	// o:18
	);
	*/

module Spectolizer
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_fftp = 12,
	parameter num_tact = 6
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,
	input [num_tact-1:0] Tact,
	
	//For SRAMControl
	input			Start,DAI_Rerr,
	input			AddrValidLoader,AddrValidSW,
	input	[12:0]	LastWriteAddr,
	input	[15:0]	SRAMQ,
	output			ReqBurstWrite,
	output	[17:0] 	WrSRAMAddress,RdSRAMAddress,
	output	[15:0]	WrData,
	
	//For Top
	input	SPI_MISO,
	output	SPI_MOSI,
	output	SPI_CLK,
	output	SPI_CS,
	
	output	EVSPInCS,
	output	EVSPIClock,
	output	EVSPIData,
	
	//For Top
	input	AVR_IN,
	output	AVR_OUT,
	
	output	AudioInputSel,
	input	ADCOverflow
);
	localparam bw_data = 16;

	//波形読み込み
	wire StartFFTLoader;
	wire [1:0] ActiveScreen;
	FFTLoader  #(.bw_fftp(12))
	fftloader (
		.Clock(Clock),
		.Reset(Reset),
		.Start(StartFFTLoader),
		.LastWriteAddr(LastWriteAddr),
		.FFTCStart(FFTCStart),
		.FFTCInputEnable(FFTCInputEnable),
		.OutData(FFTCInData),
		.ActiveScreen(ActiveScreen),
		.AddrValid(AddrValidLoader),
		.SRAMQ(SRAMQ),
		.RdAddress(RdSRAMAddress)
	);
	wire [bw_data-1:0] FFTCInData;
	wire FFTCEnd;
	wire FFTCStart;
	//FFT演算
	MyFFTCompiler #(
		.bw_fftp(bw_fftp))
	myfftc (
		.Clock(Clock),
		.Reset(Reset),
		.Start(FFTCStart),
		.CEInput(FFTCInputEnable),
		.InData(FFTCInData),
		.InputValid(InputValid),
		.InputEnd(InputEnd),
		.ReadAddr(wFFTCReadAddr),
		.ReadAddrValid(),
		.FFTEnd(FFTCEnd),
		.Q_Re(Q_Re),
		.Q_Im(Q_Im)
	);
	
	wire [1:0]	EEOpcode;
	wire [5:0]	EEAddress;
	wire [15:0]	EEData,EEQ;
	AT93C46_Tranceiver eeprom_tran(
		.Clock(Clock),
		.Reset(Reset),
		
		// For LM8
		.Send(EEStart),			// i	Start Send
		.Opcode(EEOpcode),		// i:2
		.Address(EEAddress),	// i:6
		.Data(EEData),			// i:15	Write Data
		.Q(EEQ),				// o:15
		.Busy(EEBusy),			// o
		
		// For AT93C46
		.SClock(SPI_CLK),		// o	= Clock/64
		.MOSI(SPI_MOSI),		// o
		.MISO(SPI_MISO),		// i
		.CS(SPI_CS)				// o
	);
	
	wire [15:0] EVTranData;
	SPI_Transmitter spi_trans(
		.Clock(Clock),
		.Reset(Reset),
		
		// For LM8
		.Send(EVTranSend),		// i	Start Send
		.Data(EVTranData),		// i:15	Write Data
		.Busy(EVTranBusy),		// o
		
		.nCS(EVSPInCS),			// o
		.SClock(EVSPIClock),	// o	= Clock/64
		.MOSI(EVSPIData)		// o
	);
	
	wire [2:0] FallSpeed;
	wire [bw_fftp-1:0] wFFTCReadAddr;
	wire [5:0] MessageNumber;

	wire [6:0] FWPosY;
	wire [8:0] FWPosX;
	wire [14:0] TopColor,BarColor;
	FlowControler fc(
		.Clock(Clock),						// i
		.Reset(Reset),						// i
		.StartSeq(Start),					// i

		.Tact(Tact),
		
		// For FFTLoader
		.StartFFTLoader(StartFFTLoader),	// o
		
		// For FFTC
		.FFTCEnd(FFTCEnd),				// i
		.FFTCReadAddr(wFFTCReadAddr),	// o
		
		// For Spetolizer ResOptimize
		.StartRO(StartRO),				// o
		.BusyRO(BusyRO),				// o
		
		.RBWMUXSel(RBWMUXSel),
		.TopColor(TopColor),			// o:15
		.BarColor(BarColor),			// o:15
		
		// For SpectolCompl
		.SCThru(SCThru),
		.StartSC(StartSC),				// o
		.H(H),
		
		// For Spectol Writer
		.BusySW(BusySW),				// i
		.StartSW(StartSW),
		.FallSpeed(FallSpeed),
		.GradationEn(GradationEn),
		.TopDispEn(TopDispEn),
		
		// For Message ROM
		.BusyMROM(BusyMROM),
		.MROMChar(MROMChar),
		.StartMROM(StartMROM),
		.MessageNumber(MessageNumber),		// o:6
		.FWColor(MessageColor),
		
		// For FontWriter
		.FWInitPosX(SetInitPosX),
		.FWPosX(FWPosX),				// o:9
		.FWPosY(FWPosY),				// o:7
		
		.AudioInputSel(AudioInputSel),
		.ADCOverflow(ADCOverflow),
		

		// For EEPROM Tranceiver
		.EEStart(EEStart),
		.EEOpcode(EEOpcode),
		.EEAddress(EEAddress),
		.EEData(EEData),
		.EEQ(EEQ),
		.EEBusy(EEBusy),
		
		// For EV
		.EVTranData(EVTranData),		// o:16
		.EVTranSend(EVTranSend),		// o
		.EVTranBusy(EVTranBusy),		// i
		
		// For AVR
		.AVR_IN(AVR_IN),
		.AVR_OUT(AVR_OUT)
	);
	wire [2:0] H;
	wire [17:0] Q_Re,Q_Im;
	
	//スペクトル化
	wire [6:0] InBar,OutBar,Spectol;
	FFTResOptimize
	fft_resopt (
		.Clock(Clock),
		.Reset(Reset),
		.Start(StartRO),
		.Re(Q_Re),
		.Im(Q_Im),
		.AudioInputSel(AudioInputSel),
		.Spectol(Spectol),
		.Busy(BusyRO),
		.End(EndRO)
	);
	assign InBar = (DAI_Rerr & (AudioInputSel==1'b0)) ? 7'b0 : Spectol ;
	//assign InBar = Spectol ;
	SCompLinear speccompl (
		.Clock(Clock),		// i
		.Reset(Reset),		// i
		.Thru(SCThru),		// i
		.Start(StartSC),	// i
		.SWStart(StartSW),	// i
		.InBar(InBar),		// i: 7
		.H(H),				// i: 3
		.OutBar(OutBar),	// o: 7
		.Busy(Busy)			// o
	);
	
	wire [17:0] wSWAddr;
	wire [15:0] wSWData;
	wire wSWRBW;
	//スペクトル描画
	FFTSpectolWriter	sw(
		.Clock(Clock),			//i
		.Reset(Reset),			//i
		.NewFrame(Start),		//i
		.DrawTop(TopDispEn),	//i
		.End(EndSW),			//o
		.Busy(BusySW),			//o
		.Start(StartSW),		//i
		.ActiveScreen(ActiveScreen),	//i:2
		.LRChange(StartFFTLoader),		//i
		.Bar(OutBar),					//i:7
		.AddrValid(AddrValidSW),		//i
		.ReqBurstWrite(wSWRBW),			//o
		.WrAddress(wSWAddr),			//o:18
		.WrData(wSWData),				//o:16
		
		// For FlowControler
		.BarColor(BarColor),			//i:15
		.TopColor(TopColor),			//i:15
		.FallSpeed(FallSpeed),			//i:3
		.GradationEn(GradationEn)		//i
	);
	
	wire [5:0] CharNumber;
	MessageROM mrom(
		.Clock(Clock),			// i
		.Reset(Reset),			// i
		.Start(StartMROM),		// i
		.FWEnd(FWEnd),			// i
		.Color(MessageColor),
		.MessageNumber(MessageNumber),		// i:6
		.Char(MROMChar),
		.FWColor(CharColor),	// o
		.FWStart(StartFW),		// o
		.Busy(BusyMROM),		// o
		.CharNumber(CharNumber)	// o:6
	);
	
	wire [17:0] wFWAddr;
	wire [15:0] wFWData;
	wire wFWRBW;
	FontWriter fw(
		.Clock(Clock),					//i
		.Reset(Reset),					//i
		.Start(StartFW),				//i
		.AddrValid(AddrValidSW),		//i
		.SetInitPosX(SetInitPosX),			//i
		.ActiveScreen(ActiveScreen),	//i:2
		.CharNumber(CharNumber),		//i:6
		.CharColor(CharColor),			//i:15
		.InitScr(1'b1),					//i
		.InitPosX(FWPosX),				//i:9
		.InitPosY(FWPosY),				//i:7
		.Busy(),					//o
		.End(FWEnd),						//o
		.ReqBurstWrite(wFWRBW),			//o
		.WrAddress(wFWAddr),			//o:18
		.WrData(wFWData)				//o:16
	);
	
	reg [17:0] rWrSRAMAddress;
	reg [15:0] rWrData;
	reg rRBW;
	assign ReqBurstWrite = rRBW;
	assign WrData		= rWrData;
	assign WrSRAMAddress = rWrSRAMAddress;
	always@(posedge Clock or posedge Reset)begin
		if(Reset) begin
			{rWrData,rWrSRAMAddress,rRBW} <= 1'b0;
		end else begin
			rRBW			<= (RBWMUXSel) ? wFWRBW		: wSWRBW;
			rWrData			<= (RBWMUXSel) ? wFWData	: wSWData;
			rWrSRAMAddress	<= (RBWMUXSel) ? wFWAddr	: wSWAddr;
		end
	end

endmodule 