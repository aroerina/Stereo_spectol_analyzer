//
//		
//	
/* Portlist
SpectrumComplementer speccompl (
		.Clock(Clock),		// i
		.Reset(Reset),		// i
		.Thru(),			// i
		.Start(),			// i
		.InBar(),			// i: 7
		.H(),				// i: 3
		.X(),				// i: 3
		.Bar0IsBig(),		// o
		.OutBar(),			// o: 7
		.SWStart(),			// o
		.Busy()				// o
	);
*/

module SpectrumComplementer
(
	input Clock,Reset,
	input Start,	// Level Trigger  0 -> 1
	input Thru, 	// Bar Thru
	input [6:0] InBar,
	input [2:0] H,X,
	output reg Bar0IsBig,
	output reg Busy,End,
	output reg [6:0] OutBar
);
	reg rStart;
	reg [5:0] rH2;
	reg [6:0] rBar0,rBar1;
	reg [6:0] rBig,rA,rY;
	localparam bw_state = 3;
	reg [bw_state-1:0] rState;
	wire wStart	= {rStart,Start} == 2'b01;
	wire wStartNotThru = wStart & !Thru;
	
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{rStart,rY,rBar0,rBar1,rH2,rBig,rA,Bar0IsBig}
			<= 1'b0;
		end else begin
			rStart <= Start;
			rState	<= {rState[bw_state-2:0],wStartNotThru};
			
			if(wStart) begin
				rBar0	<= InBar;
				rBar1	<= rBar0;
				rH2		<= H**2;
				Bar0IsBig	<= (InBar>rBar0);
			end
			
			// rState[0]
			rBig	<= (Bar0IsBig)	? rBar0	: rBar1;
			rA		<= (Bar0IsBig)	? rBar1	: rBar0;
			
			// rState[1]
			rY			<= rBig	- rA;
			
		end
	end
	
	localparam cp = 6; //固定小数点拡張ビット拡張
	wire [7+cp-1:0] wB;
	wire wDivEnd;
	
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
		
	reg [5:0]	rX2;
	reg rEnd;
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{rEnd,Busy,End,rX2} <= 1'b0;
		end else begin
			rEnd	<= wDivEnd;
			End		<= rEnd;
		
		if(wStartNotThru)
			Busy	<= 1'b1;
		else if(rEnd)
			Busy	<= 1'b0;
		
		rX2		<= X**2;
			
		end
	end

	reg [7:0]	rPreOutBar;
	wire [18:0]	wX2B = rX2 * wB;
	wire [7:0]	wPreOut = rPreOutBar + 1'b1;	//丸め
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{OutBar,rPreOutBar} <= 1'b0;
		end else begin
			rPreOutBar	<= wX2B[cp+6:cp-1];
			OutBar		<= (Thru) ?  InBar : wPreOut[7:1] + rA;
		end
	end
endmodule 