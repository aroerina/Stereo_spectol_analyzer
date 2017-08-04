//FFTC出力を最適化する
/* Portlist
FFTLogbar fftlogbar
	(.Clock(Clock),.Reset(Reset),.Start(Start),
	.In(In),.Out(Out),.Busy(Busy),.End(End)
	);
*/

module FFTLinearbar
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_input = 17
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,Start,
	input [bw_input-1:0] In,
	output reg [6:0] Out,
	output reg Busy,End
);

	localparam bw_sat		= 6;	//飽和条件判定ビット幅
	localparam bw_lowwer	= bw_input-bw_sat;	//下位ビット Dividerで割られる数
	localparam nval			= 85;	//ノーマライズ値

	
	////////////////////////////////////////////////////
	// Net
	wire wSat				= In[bw_input-1:bw_lowwer] > 1;	//飽和条件判定 in<8192
	wire wDividerEnd;
	wire wEnd				= wDividerEnd | wSat;
	wire [bw_lowwer-1:0] wDividerQuo;

	////////////////////////////////////////////////////
	// Instantiations
	
	Divider #(.bw_Dsor(7),.bw_Dend(bw_lowwer),.bw_i(4)) div
	(.Clock(Clock),  .Reset(Reset), .Start(Start), .Dsor(nval), .Dend(In[bw_lowwer-1:0]), 
	.Quo(wDividerQuo), .End(wDividerEnd) ,.Busy());

	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			Out				<= 0;
			End				<= 0;
			Busy			<= 0;
		end else
		if(Clock)begin
			
			if(Start) begin
				Busy	<= 1'b1;
			end else if (wEnd) begin
				Busy	<= 1'b0;
			end
				
			if(wEnd) begin
				if(wSat)
					Out	<= 7'd96;
				else
					Out	<= wDividerQuo;
			end
				
			if(End)
				End	<= 1'b0;
			else if (Busy)
				End	<= wEnd;
		end
	end

endmodule 