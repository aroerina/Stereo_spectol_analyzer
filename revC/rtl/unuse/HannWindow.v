//
/* Portlist
HannWindow hw
	(.Clock(Clock),.Reset(Reset),.Start(),.X(),
	,.InData(),.Out(),.Busy(),.End());
*/

module HannWindow
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_x		= 11,
	parameter bw_data	= 16
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,Start,
	input [bw_x-1:0] X,
	input [bw_data-1:0] InData,
	output [bw_data-1:0] Out,
	output reg Busy,End
);
	localparam bw_res_han	= bw_data+1;
	localparam bw_codic_theta	= bw_x-2;
	
	////////////////////////////////////////////////////
	// Registers
	reg rEnd;
	reg [1:0] rArea;
	reg signed [bw_data-1:0] 	rInData;
	reg signed [bw_res_han-1:0] rResHan;
	
	////////////////////////////////////////////////////
	// Net
	wire [1:0] wArea = X[bw_x-1:bw_x-2];
	wire [bw_data-1:0] wSinOut,wCosOut;
	wire [bw_codic_theta-1:0] wCODICTheta = X[bw_codic_theta-1:0];

	////////////////////////////////////////////////////
	// Instantiations
	CORDIC_SC cordic
	(.Clock(Clock),.Reset(Reset),.Start(Start),.Theta(wCODICTheta),
	.SinOut(wSinOut),.CosOut(wCosOut),.Busy(wCBusy),.End(wCEnd));
	
	//A:Signed 16bit	B:Unsigned 17bit	P:Signed 33bit
	//Output Register
	wire [32:0] wMULTP;
	MULT_HANW mult_han (
		.CLK0(Clock), .RST0(Reset), .A(rInData), .B(rResHan), .P(wMULTP) ,.CE0(rEnd));
	
	assign Out	= wMULTP[31:bw_data];

	parameter val_center = 16'h8000;
	////////////////////////////////////////////////////
	// Register Transfer
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			Busy	<=	0;
			End		<=	0;
			rEnd	<=	0;
			rArea	<=	0;
			rResHan	<=	0;
			rInData	<=	0;
		end else
		if(Clock)begin
			if(Start)
				Busy	<= 1'b1;
			else if (rEnd)
				Busy	<= 1'b0;
				
			if(Start)
				rArea	<= wArea;
				
			if(Start)
				rInData	<= InData;
				
			if(wCEnd) begin
				case (rArea)
					2'd0 :	rResHan	<= val_center - wCosOut;
					2'd1 :	rResHan <= {(2'b1+wSinOut[bw_data-1]),wSinOut[bw_data-2:0]};
					2'd2 :	rResHan	<= {(2'b1+wCosOut[bw_data-1]),wCosOut[bw_data-2:0]};
					2'd3 :	rResHan	<= val_center - wSinOut;
					default	:	rResHan	<= 0;
				endcase
			end
			
			rEnd	<= wCEnd;
			End		<= rEnd;
		end
	end

endmodule 