//
//		
//	
/* Portlist
Reseter rstr(
		.Clock(Clock),		//i
		.Reset(Reset),		//i
		.Frame(Frame),		//i
		.OutReset(OutReset)	//o
	);
*/

module Reseter
(
	input Clock,Reset,Frame,
	output OutReset
);
	reg [6:0] rFrameCount;
	assign OutReset	= rFrameCount[6];	// 64Frame目でリセット
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			rFrameCount	<= 1'b0;
		end else begin
			if(Frame && !rFrameCount[6])
				rFrameCount	<= rFrameCount + 1'b1;
		end
	end

endmodule 