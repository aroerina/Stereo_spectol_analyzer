//
//		
//	
/* Portlist
BarColor bc (
		.Clock(Clock),				//i
		.Reset(Reset),				//i
		.Start(Start),				//i
		.InColor(InColor),			//i:15
		.Bar(Bar),					//i:7
		.GradationEn(GradationEn),	//i
		.OutColor(OutColor),		//o:15
		.Busy(Busy),				//o
		.End(End)					//o
	);
*/

module BarColor
(
	input Clock,Reset,Start,GradationEn,
	input [6:0] Bar,
	input [14:0] InColor,
	output [14:0] OutColor,
	output reg Busy,End
);
	
	wire [4:0] wInR = InColor[14:10];
	wire [4:0] wInG = InColor[9:5];
	wire [4:0] wInB = InColor[4:0];
	
	reg [4:0] R,G,B;
	assign OutColor = {R,G,B};
	wire [6:0] wQuo;
	
	Divider #(.bw_Dsor(2),.bw_Dend(7),.bw_i(3)) div
		(.Clock(Clock),  .Reset(Reset), .Start(Start), 
		.Dsor(2'd3), .Dend(Bar), .Quo(wQuo), .End(DivEnd) ,.Busy(DivBusy));
			
	wire [5:0] wGradation = wQuo[5:0];
	
	wire [4:0] wGradR,wGradG,wGradB;
	wire wSatR,wSatG,wSatB;	//飽和判定
	
	assign {wSatR,wGradR}	= wInR + wGradation;
	assign {wSatG,wGradG}	= wInG + wGradation;
	assign {wSatB,wGradB}	= wInB + wGradation;


	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{Busy,End,R,G,B}		<= 1'b0;
		end else begin
				
			if(GradationEn) begin
				R	<= (wSatR) ? 5'h1f : wGradR;
				G	<= (wSatG) ? 5'h1f : wGradG;
				B	<= (wSatB) ? 5'h1f : wGradB;
			end else begin
				{R,G,B}	<= InColor;
			end
			
			End	<= DivEnd;
			
			if(Start)
				Busy	<= 1'b1;
			else if(DivEnd)
				Busy	<= 1'b0;
		end
	end
	
endmodule 