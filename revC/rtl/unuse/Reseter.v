//
/* Portlist
_ #() _
();
*/

module Reseter
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Tact
	output reg Reset
);

	////////////////////////////////////////////////////
	// Registers
	reg [16:0] Count;
	reg	CountEnd,CountBegin;

	////////////////////////////////////////////////////
	// Net
	
	////////////////////////////////////////////////////
	// Instantiations

	always@(posedge Clock or posedge Tact) begin		
		if(!Count[16])begin
			Count = Count + 1;
		end else begin
			if(!CountEnd) begin
				Reset	<= 1'b1;
				CountEnd<= 1'b1;
			end else begin
				Reset	<= 1'b0;
			end
		end
	end

endmodule 