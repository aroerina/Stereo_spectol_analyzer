//InをBit Reverse するだけ
/* Portlist
BitReverse #(.bw_fftp()) br
(.In(),.Out());
*/

module BitReverse
////////////////////////////////////////////////////
// Parameters
#(
	parameter bw_fftp = 4
)
////////////////////////////////////////////////////
// Ports
(
	input [bw_fftp-1:0]	In,
	output [bw_fftp-1:0] Out
);
	////////////////////////////////////////////////////
	// Net
	wire [bw_fftp-1:0] wBR;
	assign Out = wBR;
	
	//ビットリバースワイヤ
	genvar j;
	generate
		for( j=0 ; j<bw_fftp ; j=j+1) begin :brev
			assign wBR [j] = In [bw_fftp-(1+j)];
		end
	endgenerate	
endmodule 