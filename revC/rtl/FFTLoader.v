//SRAMからデータを読み込んでFFTCに渡す
/*
   Start       End
L: 18'h0C000 ~ 18'h0DFFF
R: 18'h1C000 ~ 18'h1DFFF
 Portlist
FFTLoader  #(.bw_fftp(12)) fftloader
(.Clock(),.Reset(),.Start(),
.LastWriteAddr(),
.FFTCStart(),.FFTCInputEnable(),.OutData(),
.ActiveScreen(),
.AddrValid(),.SRAMQ(),.RdAddress());
*/

module FFTLoader
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_fftp = 12
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,Start,
	
	// For Cacher
	input [12:0] LastWriteAddr,
	
	//For FFTC
	output FFTCStart,
	output reg FFTCInputEnable,
	output [15:0] OutData,
	
	// For Spectol Writer
	output reg [1:0] ActiveScreen,
	
	//For SRAM
	input AddrValid,
	input [15:0] SRAMQ,
	output [17:0] RdAddress
);

	////////////////////////////////////////////////////
	// Registers
	reg rCounterBusy;
	reg rStateSR;
	reg [12:0]	rAddrReadStart,rAddr;
	
	////////////////////////////////////////////////////
	// Net
	wire wLR	= ActiveScreen[0];
	assign FFTCStart	= Start;
	assign OutData		= SRAMQ;
	assign RdAddress	= {1'b0,wLR,3'b111,rAddr};
	////////////////////////////////////////////////////
	// Instantiations
	wire [bw_fftp-1:0] wCount;
	wire wCounterEnd,wCounterBusy;
	
	StartCounter #(.width(bw_fftp))
		scounter(
		.Clock(Clock),
		.Reset(Reset),
		.CountEn(AddrValid),
		.Start(Start),
		.Count(wCount),
		.End(wCounterEnd),
		.Busy(wCounterBusy)
	);

	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{	//Reset
				rAddr,rAddrReadStart,rCounterBusy,
				rStateSR,FFTCInputEnable
			}
				<= 1'b0;
			// Preset
			ActiveScreen	<= 2'b00;	//最初に二番目のスクリーンRから書き込む
		end else begin
			if(Start) 
				ActiveScreen 	<= ActiveScreen - 1'b1;	//Down counter
				
			//同時刻のサンプルを読み込むために
			//LRとも最後に書き込んだアドレスを同じにする			
			if(Start && !ActiveScreen[0]) begin	// ActiveScreen == 2'b00 , 2'b10
				// LastWriteAddr - 4096
				rAddrReadStart	<=	{~LastWriteAddr[12],LastWriteAddr[11:0]};
			end
				
			if(AddrValid)
				rAddr	<= wCount + rAddrReadStart;
			
			if(AddrValid)
				rCounterBusy		<= wCounterBusy;	//タイミング調節のため遅延
			
			//FFTCInputEn生成 2Cycleディレイ
			{FFTCInputEnable,rStateSR}	<= {rStateSR,(rCounterBusy && AddrValid)};
			
		end
	end
endmodule 