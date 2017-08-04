//
//		
//	
/* Portlist
SpectrumComplementer speccompl (
		.Clock(Clock),
		.Reset(Reset),
		.Start(),
		.InBar(),
		.H(),
		.SWStart(),
		.SWBusy(),
		.OutBar()
	);
*/

`define CH_L 1'b0
`define CH_R 1'b1
`define HIGH_LOW	1'b0
`define LOW_HIGH	1'b1

module SpectrumComplementer
(
	input Clock,Reset,
	input Start,	// Level Trigger  0 -> 1
	input Thru, 
	input SWBusy,
	input [6:0] InBar,
	input [2:0] H,
	output reg SWStart,
	output reg Busy,
	output reg [6:0] OutBar
);
	reg rStart;
	reg [2:0] rH;
	reg [5:0] rH2;
	reg [6:0] rBar0,rBar1;
	reg [6:0] rBig,rA,rY;
	localparam bw_state = 3;
	reg [bw_state-1:0] rState;

	wire wStart	= {rStart,Start} == 2'b01;
	
	reg rBar0IsBig;
	
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{rStart,rY,rBar0,rBar1,rH,rH2,rBig,rA}
			<= 1'b0;
		end else begin
			rStart <= Start;
			rState	<= {rState[bw_state-2:0],wStart & ~Thru};
			
			if(wStart) begin
				rBar0	<= InBar;
				rBar1	<= rBar0;
				rH		<= H+1'b1;
				rBar0IsBig	<= (InBar>rBar0);
			end
			
			// rState[0]
			rBig	<= (rBar0IsBig)	? rBar0	: rBar1;
			rA		<= (rBar0IsBig)	? rBar1	: rBar0;
			rH2		<= rH**2;
			
			// rState[1]
			rY			<= rBig	- rA;
			
		end
	end
	
	wire [7+cp-1:0] wB;
	wire wDivEnd;
	localparam cp = 6; //固定小数点拡張ビット幅
	Divider #(.bw_Dsor(6),.bw_Dend(7+cp),.bw_i(4))
		divider (
		.Clock(Clock),
		.Reset(Reset),
		.Start(rState[2]),
		.Dsor(rH2), 
		.Dend({rY,{cp{1'b0}}}), 
		.Quo(wB), 
		.End(wDivEnd),
		.Busy()
	);
	
	wire wDirection = rBar0IsBig; // 0:高→低  1:低→高
	reg [2:0] rX;
	reg [2:0] rState2;
	
	wire wSeqEnd  = (wDirection == `LOW_HIGH && rX == rH) | (wDirection == `HIGH_LOW && rX == 3'b0);
	reg [cp+9:0] rPreOutBar;
	wire [7:0] wOutBar = rPreOutBar[cp+9:cp+2] + 1'b1;	//丸め
	
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{OutBar	,Busy,rState2,SWStart,rX,rPreOutBar}
			<= 1'b0;
		end else begin
			
			if(wDivEnd)
				rState2	<= 1'b1;
			else if(wSeqEnd)
				rState2 <= 1'b0;
			
			if(Thru)
				Busy	<= SWBusy;
			else if(wStart)
				Busy	<= 1'b1;
			else if (wSeqEnd)
				Busy	<= 1'b0;
				
			if(Thru)
				SWStart	<= wStart;
			else if(SWStart)
				SWStart	<= 1'b0;
			else if(!SWBusy && rState2)
				SWStart	<= 1'b1;
		
			if(wDivEnd) begin
				if(wDirection == `LOW_HIGH)
					rX	<= 3'b1;
				else
					rX	<= rH-1'b1;
			end else if(!SWBusy && Busy) begin
				if(wDirection == `LOW_HIGH)
					rX	<= rX + 1'b1;
				else
					rX	<= rX - 1'b1;
			end
			
			rPreOutBar	<= rX * wB;
			OutBar		<= (Thru) ? InBar : wOutBar[7:1] + rA;
		
		end
	end
endmodule 