//SRAMからデータを拾ってLCDに出力
/* Portlist
LCDCtrl lcdc( 
		.Clock(Clock),	// i
		.DotClock(),	// i
		.Reset(Reset),	// i
		
		// Spectolizer
		.NewFrame(),	// o
		
		// For SRAMCtrl
		.AdrValid(),	// i
		.InSRAMQ(),		// i:16
		.SRAMDataFrameStart(),	// o
		.RdSRAMAddr()	// o:18
		
		// For LCD
		.L_RGB(),		// o:15
		.R_RGB(),		// o:15
		.VS(),			// o
		.HS(),			// o
	);
*/
/* memo
Screen配置
SRAM Address 
[17] 0:1st	1:2nd
[16] 0:L	1:R
[15:9] y 0-127
[ 8:0] x 0-511
*/
module LCDCtrl
(
	////////////////////////////////////////////////////
	// Ports
	
	//For inner module
	input Clock,DotClock,Reset,
	input [14:0] InSRAMQ,
	output NewFrame,
	output reg SRAMDataFrameStart,
	
	//For LCD
	output reg [14:0]	L_RGB,R_RGB,
	output reg			VS,HS,
	output reg [17:0]	RdSRAMAddr
);
	parameter	 hs_offset = 1;
	localparam pos_hs	= 405 + hs_offset;
	localparam pos_vs	= pos_hs - 153;
	localparam line_vs	= 112;//111;
	
	localparam bw_srne  = 3;
	localparam bw_srframe = 6;
	
	////////////////////////////////////////////////////
	// Registers
	reg rLR,rFS;
	reg [bw_srne-1:0] rSRNE;		//Shift register
	reg [bw_srframe-1:0] rSRFrame;	//Shift register
	reg [14:0]	rDotL0,rDotL1,rDotR0,rDotR1;
	reg [16:0]	rXYCount0,rXYCount1;	
	
	////////////////////////////////////////////////////
	// Net
	
	//最初に右画面の色データ読み出し、次は左
	wire [8:0] wReadX	= rXYCount1[8:0];
	wire [6:0] wReadY	= rXYCount1[15:9];
	wire wHS	= ~(wReadX == pos_hs);
	wire wVS	= ~(wReadY == line_vs);
	wire wDCK90	= rSRNE[2]; 
	
	PosedgePulse pp_negedge(
		.Clock(Clock),.Reset(Reset),
		.InPulse(~DotClock),.OutPulse(wDCKNegEdge)
		);
		
	wire wFFTStartLine = (wReadY == 7'd16);
	PosedgePulse pp_startfft		
		(.Clock(Clock),.Reset(Reset),
		.InPulse(wFFTStartLine),.OutPulse(NewFrame)
		);
	
	localparam pos = 2;	// First Sample Timing of rSRFrame	
	wire wFrameStart = rSRNE[1] & rFS;
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			{
				rXYCount0,rXYCount1,
				L_RGB,R_RGB,rLR,
				SRAMDataFrameStart,rSRNE,RdSRAMAddr,
				rFS,rDotL0,rDotL1,rDotR0,
				rDotR1,HS,VS
			}	<= 1'b0;
		end else begin
		
			rSRNE		<=	{rSRNE[bw_srne-2:0],wDCKNegEdge};
	
			if(rSRNE[0])
				rFS	<= ~rFS;
				
			SRAMDataFrameStart	<=	wFrameStart;	//rSReg[1]２回に１回にする
			rSRFrame	<= {rSRFrame[bw_srframe-2:0],SRAMDataFrameStart};
				
			if (rSRNE[0])
				rLR		<= 1'b1;
			else
				rLR		<=	~rLR;	//rSReg[1]から１クロックごとに反転
			
			if(rSRNE[0]) begin
				rXYCount0	<= rXYCount0 + 1'b1;
				rXYCount1	<= rXYCount0;
			end		
			//SRAM読み込みアドレス生成
			//1:SCREEN_L
			//2:SCREEN_R
			//3:ADRESS+1 SCREEN_L
			//4:ADRESS+1 SCREEN_R
			if(|{SRAMDataFrameStart,rSRFrame[0]})
				RdSRAMAddr	<= {rXYCount1[16],rLR,rXYCount1[15:0]};
			else if(|rSRFrame[2:1])
				RdSRAMAddr	<= {rXYCount0[16],rLR,rXYCount0[15:0]};
				
			if(wDCK90) begin
				L_RGB	<= rDotL1;
				R_RGB	<= rDotR1;
			end
			
			//Pixel Data Buffer
			if(wDCK90 || rSRFrame[pos] || rSRFrame[pos+2]) begin
				rDotL0	<= InSRAMQ[14:0];
				rDotL1	<= rDotL0;
			end
			
			if(wDCK90 || rSRFrame[pos+1] || rSRFrame[pos+3]) begin
				rDotR0	<= InSRAMQ[14:0];
				rDotR1	<= rDotR0;
			end
			
			if (wDCK90) begin
				HS		<= wHS;
				VS		<= wVS;
			end
			
		end
	end
endmodule 