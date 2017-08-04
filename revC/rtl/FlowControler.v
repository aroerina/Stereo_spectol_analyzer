//FFT順序 R ⇒　L
/* Portlist
	FlowControler #(.bw_fftp(bw_fftp)) fftseq2(
		.Clock(Clock),						// i
		.Reset(Reset),						// i
		.Busy(),							// o
		.StartSeq(StartSeq),				// i
		
		// For FFTLoader
		.StartFFTLoader(StartFFTLoader),	// o
		
		// For FFTC
		.FFTCEnd(FFTCEnd),						// i
		.FFTCReadAddrValid(FFTCReadAddrValid),	// i
		.FFTCReadAddr(wFFTCReadAddr),			// o
		
		// For Spetolizer ResOptimize
		.StartRO(StartRO),					// o
		.BusyRO(BusyRO),					// o
		.EndRO(EndRO),						// i
		
		// For SpectolWriter
		.StartSC(StartSC),					// o
		.BusySW(BusySW),					// i
		.EndSW(EndSW)						// i
	);
*/
`define H_ROM_NAME	"Compl_h_71d3b.mem"
`define H_ROM_DEPTH	71
`define H_ROM_ADDRW 7

`define F_ROM_NAME	"DiffFreqList_321d5b.mem"
`define F_ROM_DEPTH 321

module FlowControler
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
	input StartSeq,
	input FFTCEnd,	// = FFTCEnd 
	output reg [bw_fftp-1:0] FFTCReadAddr,
	
	input [num_tact-1:0] Tact,
	
	// For FFTLoader
	output reg StartFFTLoader,
	
	// For Spetolizer
	output	reg StartRO,
	input	BusyRO,
	
	// For SpectolComplementer
	output StartSC,
	output SCThru,
	output [2:0] H,
	
	output RBWMUXSel,	//　バースト書き込みモジュールを選択
	
	// For SpectolWriter
	input	BusySW,
	output reg StartSW,
	output [14:0] TopColor,
	output [14:0] BarColor,
	output reg [2:0] FallSpeed,
	output GradationEn,
	output TopDispEn,
	
	// For MessageROM
	input	BusyMROM,
	output	reg StartMROM,
	output	reg MROMChar,
	output	reg [5:0] MessageNumber,
	
	// For FontWriter
	output	reg FWInitPosX,
	output	FWColor,
	output	[8:0] FWPosX,
	output	reg [6:0] FWPosY,
	
	// For AT93C46_Tranceiver
	output	reg		EEStart,
	output	[1:0]	EEOpcode,
	output	[5:0]	EEAddress,
	output	[15:0]	EEData,
	input	[15:0]	EEQ,
	input 			EEBusy,
	
	output			AudioInputSel,
	input			ADCOverflow,
	
	// For EVSPI Transmitter
	input	EVTranBusy,
	output	reg [15:0]	EVTranData,
	output	reg			EVTranSend,
	
	// For AVR
	input		AVR_IN,
	output		AVR_OUT
);
	localparam bw_romq		= 5;
	parameter bw_addr		= 8;

	
	localparam bw_sp_addr = 8;
	wire [bw_addr-1:0] ext_addr;
	
	wire [7:0] ext_io_din,ext_dout,ext_mem_din; 
	// ScratchPad Memory
	pmi_distributed_spram #(
		.pmi_addr_depth(2**bw_sp_addr),
		.pmi_addr_width(bw_sp_addr),
		.pmi_data_width(8),
		.pmi_regmode("noreg"),
		.pmi_init_file("none"),
		.pmi_init_file_format("scratchpad_init.mem"),
		.pmi_family("XP2")
	) scratch_pad(
		.Address(ext_addr[bw_sp_addr-1:0]),
		.Data	(ext_dout),
		.Clock	(Clock),
		.ClockEn(1'b1),
		.WE		(ext_mem_wr),
		.Reset	(Reset),
		.Q		(ext_mem_din)
	);
	
	
	// 読んだら消すレジスタ	
	reg rStartSeq,rFFTCEnd;
	reg rADCOverflow;
	reg [num_tact-1:0] rTact;
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{rStartSeq,rFFTCEnd,rTact,rADCOverflow}	<= 1'b0;
		end else begin
		
			if(StartSeq)
				rStartSeq	<= 1'b1;
			else if( StartFFTLoader )
				rStartSeq	<= 1'b0;
				
			if(FFTCEnd)
				rFFTCEnd	<= 1'b1;
			else if( StartRO )
				rFFTCEnd	<= 1'b0;

			if((ext_addr==3'd3) && ext_io_rd)	//読んだら消す
				rTact		<= 1'b0;
			else
				rTact		<= rTact | Tact;
				
			if((ext_addr==3'd6) && ext_io_rd)
				rADCOverflow	<= 1'b0;
			else
				rADCOverflow	<= rADCOverflow | ADCOverflow;
				
		end
	end
	
	// IO Read
	// ext_io_din 前置mux
	wire [7:0] wModStat;
	assign wModStat[0] = rStartSeq;
	assign wModStat[1] = rFFTCEnd;
	assign wModStat[2] = ~BusySW;	// Busy -> Ready
	assign wModStat[3] = ~BusyRO;
	assign wModStat[4] = ~BusyMROM;
	assign wModStat[5] = ~EEBusy;
	assign wModStat[6] = AVR_IN;
	assign wModStat[7] = ~EVTranBusy;
	reg [7:0] r_io_mux;
	
	localparam bw_istrove = 3;
	
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			r_io_mux	<= 1'b0;
		end else begin
		
			case (ext_addr[bw_istrove-1:0])
				3'd0:	r_io_mux	<= wModStat;
				3'd1:	r_io_mux	<= wFROMQ;
				3'd2:	r_io_mux	<= wH_ROMQ;
				3'd3:	r_io_mux	<= rTact;
				3'd4:	r_io_mux	<= EEQ[15:8];
				3'd5:	r_io_mux	<= EEQ[7:0];
				3'd6:	r_io_mux	<= rADCOverflow;
				default: r_io_mux	<= r_io_mux;
			endcase
			
		end
	end
	assign ext_io_din = {3'b0,r_io_mux};
	
	localparam bw_prom_addr = 12;	// 2048
	// LatticeMico8
	my_lm8_core_mixrom
	//my_lm8_core
	#(
		.FAMILY_NAME("XP2"),
		.PROM_FILE("prom_init.mem"),
		.PORT_AW(8),
		.EXT_AW(8),
		.PROM_AW(bw_prom_addr),
		.PROM_AD(2**bw_prom_addr),
		.REGISTERS_16(0),
		.PGM_STACK_AW(4),
		.PGM_STACK_AD(16),
		.PROM_MODE("block"))
	//	.PROM_MODE("distribute"))
	mico8 (
		//input
		.clk(Clock),
		.rst_n(~Reset),
		.ext_mem_din(ext_mem_din),	//w:8
		.ext_mem_ready(1'b1),
		.ext_io_din(ext_io_din),	//w:8
		.intr(1'b0),
		//output
		.ext_addr(ext_addr),			//w:EXT_AW
		.ext_addr_cyc(ext_addr_cyc),
		.ext_dout(ext_dout),			//w:8
		.ext_mem_wr(ext_mem_wr),
		.ext_mem_rd(ext_mem_rd),
		.ext_io_wr(ext_io_wr),
		.ext_io_rd(ext_io_rd),
		.intr_ack()
	);
	
	wire [4:0] wFROMQ;
	//選択周波数リストROM
	pmi_distributed_rom #(
		.pmi_addr_depth(`F_ROM_DEPTH),
		.pmi_addr_width(9),
		.pmi_data_width(5),
		.pmi_regmode("reg"),
		.pmi_init_file(`F_ROM_NAME),
		.pmi_init_file_format("hex"),
		.pmi_family("XP2"),
		.module_type("pmi_distributed_rom")
	) freq_rom  (
		.Address(rFROMAddr),
		.OutClock(Clock),
		.OutClockEn(1'b1),
		.Reset(Reset),
		.Q(wFROMQ)
   );

	// H ROM
	wire [2:0] wH_ROMQ;
	localparam bw_hrom_addr = `H_ROM_ADDRW;
	reg [bw_hrom_addr-1:0] rHROMAddr;
	assign H = wH_ROMQ;
	pmi_distributed_rom #(
		.pmi_addr_depth(`H_ROM_DEPTH),
		.pmi_addr_width(bw_hrom_addr),
		.pmi_data_width(3),
		.pmi_regmode("reg"),
		.pmi_init_file(`H_ROM_NAME),
		.pmi_init_file_format("hex"),
		.pmi_family("XP2"),
		.module_type("pmi_distributed_rom")
	) h_rom  (
		.Address(rHROMAddr),
		.OutClock(Clock),
		.OutClockEn(1'b1),
		.Reset(Reset),
		.Q(wH_ROMQ)
   );
   
   //IO Write
   
	localparam bw_settingregs = 5;
	reg [bw_settingregs-1:0] SettingRegs;
	assign SCThru			= SettingRegs[0];
	assign RBWMUXSel		= SettingRegs[1];
	assign AudioInputSel	= SettingRegs[2];
	assign GradationEn		= SettingRegs[3];
	assign AVR_OUT			= SettingRegs[4];
	
	assign FWColor		= rFontColor;
	assign TopDispEn	= 1'b1;
	
	wire wStrvPulse	= ext_io_wr & ext_addr_cyc;

	wire wStrvStart			= (ext_addr[3:0] == 4'd0) & wStrvPulse;	
	wire wStrvSWStart		= wStrvStart & ext_dout[0];
	wire wStrvROStart		= wStrvStart & ext_dout[1];
	wire wStrvLoaderStart	= wStrvStart & ext_dout[2];
	wire wStrvEESend		= wStrvStart & ext_dout[3];
	wire wStrvHROMAddrReset	= wStrvStart & ext_dout[4];
//	wire wStrvEVTranSend	= wStrvStart & ext_dout[5];
	
	wire wStrvSettingRegs	= wStrvPulse & ext_addr[3:0] == 4'd1;	
	wire wStrvMessage		= wStrvPulse & ext_addr[3:0] == 4'd2;
	wire wStrvFWPosX		= wStrvPulse & ext_addr[3:0] == 4'd3;
	wire wStrvFWPosY		= wStrvPulse & ext_addr[3:0] == 4'd4;
	wire wStrvEEData		= wStrvPulse & ext_addr[3:0] == 4'd5;
	wire wStrvFallSpeed		= wStrvPulse & ext_addr[3:0] == 4'd6;
	wire wStrvBarColor		= wStrvPulse & ext_addr[3:0] == 4'd7;
	wire wStrvFontColor		= wStrvPulse & ext_addr[3:0] == 4'd8;
	wire wStrvEVTranDataCh	= wStrvPulse & ext_addr[3:0] == 4'd9;
	wire wStrvEVTranDataVol	= wStrvPulse & ext_addr[3:0] == 4'd10;
	
	wire wStrvROMAddr		= wStrvROStart;
	reg rStrvFFTCROMAddr,rStartFFTLoader,rFontColor;
	reg [2:0] rCountStrvEEData;
	reg [3:0] TopR,TopG,TopB,BarR,BarG,BarB;
	assign BarColor = {{BarR,1'b1},{BarG,1'b1},{BarB,1'b1}};
	assign TopColor = {{TopR,1'b1},{TopG,1'b1},{TopB,1'b1}};
	reg [8:0] rFROMAddr;	
	reg [7:0] rFWPosX;
	assign FWPosX = {rFWPosX,1'b0};
	reg [7:0] rEEDataSR [0:3];
	assign EEData		= {rEEDataSR[3],rEEDataSR[2]};
	assign EEAddress	= rEEDataSR[1][5:0];
	assign EEOpcode		= rEEDataSR[0][1:0];
	assign StartSC = StartRO;
	wire wCountStrvEEDataReset	=	rCountStrvEEData==3'd4;
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin{
			rFROMAddr,StartSW,rStartFFTLoader,
			FFTCReadAddr,StartRO,rStrvFFTCROMAddr,MessageNumber,
			rFWPosX,FWPosY,FWInitPosX,rEEDataSR[0],
			rEEDataSR[1],rEEDataSR[2],rEEDataSR[3],EEStart,StartMROM,
			FallSpeed,SettingRegs,MROMChar,rHROMAddr,rFontColor,
			EVTranData,EVTranSend,rCountStrvEEData
			}<= 1'b0;
		end else begin
			
			StartFFTLoader	<= wStrvLoaderStart;
			StartRO			<= wStrvROStart;
			StartSW			<= wStrvSWStart;
			
			
			if(wStrvSettingRegs)
				SettingRegs	<= ext_dout[bw_settingregs-1:0];
			
			if(StartFFTLoader)
				rFROMAddr	<= 1'b0;
			else if( wStrvROMAddr )
				rFROMAddr	<= rFROMAddr+1'b1;
				
			
			if(StartFFTLoader | wStrvHROMAddrReset)
				rHROMAddr	<= 1'b0;
			else if( wStrvROMAddr )
				rHROMAddr	<= rHROMAddr+1'b1;
			
			rStartFFTLoader		<= StartFFTLoader;
			rStrvFFTCROMAddr	<= wStrvROMAddr | rStartFFTLoader;
				
			if(StartFFTLoader)
				FFTCReadAddr	<= 1'b0;
			else if(rStrvFFTCROMAddr)
				FFTCReadAddr	<= FFTCReadAddr + wFROMQ;
				
			FWInitPosX		<= wStrvFWPosX;
			StartMROM		<= wStrvMessage;
			
			//	For Font Writer
			if(wStrvMessage)
				{MROMChar,MessageNumber}	<= ext_dout[6:0];
				
			if(wStrvFWPosX)
				rFWPosX			<= ext_dout;
				
			if(wStrvFWPosY)
				FWPosY		<= ext_dout[6:0];
				
			if(wStrvFontColor)
				rFontColor	<= ~ext_dout[0];
				
			// For SpectolWriter
			if(wStrvBarColor)	// Shift Reg
				{BarR,BarG,BarB,TopR,TopG,TopB}	<= {BarG,BarB,TopR,TopG,TopB,ext_dout[3:0]};
				
			if(wStrvFallSpeed)
				FallSpeed	<= ext_dout[2:0];
				
			// For EEPROM
			EEStart 		<= wStrvEESend | wCountStrvEEDataReset;
			
			if(wStrvEEData) begin
				rEEDataSR[0]	<= ext_dout;
				rEEDataSR[1]	<= rEEDataSR[0];
				rEEDataSR[2]	<= rEEDataSR[1];
				rEEDataSR[3]	<= rEEDataSR[2];
			end
			
			if(wCountStrvEEDataReset | StartSeq)
				rCountStrvEEData	<= 1'b0;
			else if(wStrvEEData)
				rCountStrvEEData	<= rCountStrvEEData+1'b1;
			
			// For	EV Transmitter
			EVTranSend			<= wStrvEVTranDataCh;
			if(wStrvEVTranDataVol)
				EVTranData[7:0]		<= ext_dout;
				
			if(wStrvEVTranDataCh)
				EVTranData[15:8]	<= ext_dout;
			
		end
	end
	
endmodule 

/*
always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{}	<= 1'b0;
		end else begin
			
		end
	end
*/