//FFT順序 R ⇒　L
/* Portlist
	FFTSequenser2 #(.bw_fftp(bw_fftp)) fftseq2(
		.Clock(Clock),						// i
		.Reset(Reset),						// i
		.Busy(),							// o
		.StartFFT(StartFFT),				// i
		
		// For FFTLoader
		.StartFFTLoader(StartFFTLoader),	// o
		
		// For FFTC
		.FFTEnd(FFTEnd),						// i
		.FFTCReadAddrValid(FFTCReadAddrValid),	// i
		.FFTCReadAddr(wFFTCReadAddr),			// o
		
		// For Spetolizer ResOptimize
		.StartRO(StartRO),					// o
		.BusyRO(BusyRO),					// o
		.EndRO(EndRO),						// i
		
		// For SpectolWriter
		.StartSW(StartSW),					// o
		.X(X),								// o:9
		.BusySW(BusySW),					// i
		.EndSW(EndSW)						// i
	);
*/

module FFTSequenser2
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_fftp = 12
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,
	input StartFFT,
	input FFTEnd,	// = FFTEnd 
	input FFTCReadAddrValid,
	output reg [bw_fftp-1:0] FFTCReadAddr,
	output reg Busy,
	
	// For FFTLoader
	output reg StartFFTLoader,
	
	// For Spetolizer
	output	reg StartRO,
	input	BusyRO,EndRO,
	
	// For SpectolWriter
	output	reg StartSW,
	output	reg [8:0] X,
	input	BusySW,EndSW
);
	localparam bw_romq		= 5;
	
	////////////////////////////////////////////////////
	// Registers
	reg rDownEn,rWaitSWFree,rCEX;
	reg [4:0] rSRStart;
	reg [1:0] rAddSubCE;
	reg rUDCounterCE;	
	
	////////////////////////////////////////////////////
	// Net
	wire wNotStartSeq	= ~|rSRStart;
	wire [bw_romq-1:0] wROMQ;
	wire [8:0]  wROMAddr;
		
	//最後の要素
	wire wLastElmR = (FFTCReadAddr[11] & ~rDownEn);
	wire wLastElmL = ((X == 9'd1) & rDownEn);
	wire wLastElm =  wLastElmR | wLastElmL;
	wire wPreUDCounterCE	= StartSW | (rSRStart[0]& !rDownEn);
	wire wUDCounterCE = wPreUDCounterCE & ~wLastElm & Busy;
	wire wAddSubCE	= rAddSubCE | (wLastElm&StartRO);
	
	////////////////////////////////////////////////////
	// Instantiations
	UDCounter #(.width(9)) 
	udcounter (
		.Clock(Clock),
		.Reset(Reset),
		.ClockEn(rUDCounterCE),
		.AClear(1'b0),
		.DownEn(rDownEn),
		.Count(wROMAddr)
	);
	
	//選択周波数リストROM
	DiffFreqList_for_N4096_400d5b distrom_freq_list(
		.Address(wROMAddr),
		.OutClock(Clock), 
		.OutClockEn(1'b1),
		.Reset(Reset),
		.Q(wROMQ)
	);
	
	/*
	localparam bw_fill = bw_fftp - bw_romq;
	AddSub #(.width(bw_fftp)) as(
		.Clock(Clock),
		.ClockEn(wAddSubCE),
		.Reset(Reset),
		.SubEn(rDownEn),
		.A(FFTCReadAddr),
		.B({{bw_fill{1'b0}},wROMQ}),
		.S(FFTCReadAddr)
	);
	*/
	// StartFFTLoader 生成用
	PosedgePulse ppulse(
		.Clock(Clock),	// i
		.Reset(Reset),	// i
		.InPulse(wLastElmR),		// i
		.OutPulse(wLastElmRPulse)	// o
	);
	
	reg [1:0] rCountFFTEnd;	// FFTEndパルスの数を数える FFTEndが三回目に来たときは無視
	wire wEnableFFTEnd = (rCountFFTEnd < 2'b10 && FFTEnd);
	
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{
				StartRO,StartSW,X,rAddSubCE,
				rUDCounterCE,StartFFTLoader,
				Busy,rDownEn,rWaitSWFree,rCEX,
				rSRStart,rCountFFTEnd,FFTCReadAddr
			}	
				<= 1'b0;
			rDownEn			<= 1'b1;	// Preset
		end else begin
			rUDCounterCE	<= wUDCounterCE;
			rAddSubCE		<= rUDCounterCE;
			rSRStart		<= {rSRStart[3:0],FFTEnd};
			
			StartFFTLoader	<= wLastElmRPulse | StartFFT;
			
			if(wAddSubCE & Busy)
				FFTCReadAddr	<= wROMQ + FFTCReadAddr;
			else if(FFTEnd)
				FFTCReadAddr[bw_fftp-1]	<= 1'b0;
			
			if(wEnableFFTEnd)			//1,2回目
				rCountFFTEnd <= rCountFFTEnd + 1'b1;
			else if(FFTEnd)	
				rCountFFTEnd <= 2'b0;	//3回目でリセット
			
			if(wEnableFFTEnd)
				Busy		<= 1'b1;
			else if(wLastElm&& EndSW)
				Busy		<= 1'b0;
			
			if(wEnableFFTEnd)
				rDownEn		<= ~rDownEn;	//LR の切り替えのたび反転
			
			rCEX			<= wPreUDCounterCE;
			
			if(rCEX)
				X			<= wROMAddr;
				
			if(StartSW)
				rWaitSWFree		<= 1'b0;
			else if(EndRO && BusySW)
				rWaitSWFree		<= 1'b1;	
			
			StartRO			<= ~BusySW & Busy & ~BusyRO & wNotStartSeq & ~StartRO;
				
			StartSW			<= (rWaitSWFree | EndRO) & ~BusySW & ~StartSW;
		end
	end
endmodule 