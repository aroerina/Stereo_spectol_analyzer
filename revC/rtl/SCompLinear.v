//
//		
//	
/* Portlist
SpectrumComplementer speccompl (
		.Clock(Clock),		// i
		.Reset(Reset),		// i
		.Thru(),			// i
		.Start(),			// i
		.SWStart(),			// i
		.InBar(),			// i: 7
		.H(),				// i: 3
		.OutBar(),			// o: 7
		.Busy()				// o
	);
*/

module SCompLinear
(
	input Clock,Reset,
	input Start,SWStart,	// Level Trigger  0 -> 1
	input Thru, 	// Bar Thru
	input [6:0] InBar,
	input [2:0] H,
	output reg Busy,
	output reg [6:0] OutBar
);
	reg rStartNotThru,rStart;
	reg [2:0] rH;
	reg [6:0] rBar0,rBar1;
	reg signed [7:0] rY;
	wire wStart	= {rStart,Start} == 2'b01;
	wire wStartNotThru = wStart & !Thru;
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{rStartNotThru,rY,rH,rBar0,rBar1,rStart}
			<= 1'b0;
		end else begin
			rStart	<= Start;
			if(wStart) begin
				rBar0	<= InBar;
				rBar1	<= rBar0;
				rY		<= InBar - rBar0;
				rH		<= H;
			end
			
			rStartNotThru <= wStartNotThru;
		end
	end
	
	localparam cp = 4; //固定小数点拡張ビット拡張
	localparam bw_b = 8+cp;
	wire signed [bw_b-1:0] wB;
	SDivider #(.bw_Dsor(3),.bw_Dend(bw_b),.bw_i(4))
		divider (
		.Clock(Clock),
		.Reset(Reset),
		.Start(rStartNotThru),
		.Dsor(rH), 
		.Dend({rY,{cp{1'b0}}}), 
		.Quo(wB), 
		.Busy(wDivBusy)
	);
	
	reg [2:0]	rX;
	reg rEnd;
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{rEnd,Busy,rX} <= 1'b0;
		end else begin

			Busy	<= wDivBusy|rStartNotThru;
			
			if(wStart)
				rX	<= 3'b0;
			else if(SWStart)
				rX		<= rX+1'b1;
				
		end
	end
	
	// Signed mult
	localparam bw_preout = bw_b+4;
	wire signed [bw_preout-1:0] wMultOut;
	pmi_mult #(
		.pmi_dataa_width(bw_b),
		.pmi_datab_width(4),
		.module_type("pmi_mult"),
		.pmi_sign("on"),
		.pmi_additional_pipeline(0),
		.pmi_input_reg("off"),
		.pmi_output_reg("on"),
		.pmi_family("XP2"),
		.pmi_implementation("DSP")) 
		smult (
		.Clock(Clock),		//i
		.ClkEn(1'b1),		//i
		.Aclr(Reset),		//i
		.DataA(wB),			//o
		.DataB({1'b0,rX}),		//o
		.Result(wMultOut)		//o
	);
	
	wire [7:0]	wPreOut1 = {wMultOut[bw_preout-1],wMultOut[9:3]} + 1'b1;	//丸�
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{OutBar} <= 1'b0;
		end else begin
			OutBar		<= (Thru) ?  InBar : rBar1 + wPreOut1[7:1];
		end
	end
endmodule 