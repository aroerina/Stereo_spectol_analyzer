//
/* Portlist
LTA042B010F #() _
();
*/

module LTA042B010F #(
	parameter filename = "disp.txt";
)
(
	////////////////////////////////////////////////////
	// Ports
	input nClock,HS,VS,
	input [14:0] RGB
);
	////////////////////////////////////////////////////
	// Registers
	reg rHS = 1'b0,rVS = 1'b0;
	reg [9:0] rX = 10'b0;
	reg [6:0] rHSCount = 7'b0;
	reg [7:0] rY = 8'b0;
	reg rStartHSSeq = 1'b0;
	
	integer f = $fopen(filename,"w");
	
	always@(negedge nClock) begin

		if(rX < 400 && rY < 96) begin
			$fwriteh(f,RGB);
		end
		
		rX	= rX + 1'b1;
				
		if ( (302 < rX) && ({rHS,HS} == 2'b10)) begin
			rStartHSCount	= 1'b1;
			rHSStartPos		= rX;
		end
		
		if( (rX == 98) && ({rVS,VS} == 2'b10)) begin
			rStartVSCount	= 1'b1;
			rVSStartPos		= rY;
		end		
		
		if(rStartHSCount) begin
			if (rHSCount < 106) begin
				rHSCount = rHSCount + 1'b1;
			end else begin
				rStartHSCount	= 1'b0;
				rHSCount		= 7'b0;
				rX				= 10'b0;
			end
		end
		
		rHS	= HS;
		rVS = VS;
	end

endmodule 