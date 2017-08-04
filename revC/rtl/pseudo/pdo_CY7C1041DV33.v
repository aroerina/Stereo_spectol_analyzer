`timescale 1ns/100ps

//1サイクル = 1/64,000,000 = 15.6 [ns]
//CY7C1041DV33　モデル化
/* Portlist
pdo_CY7C1041DV33 sram (
		.Address(Address),	// i:18
		.nWE(nWE),			// i
		.nOE(nOE),			// i
		.IO(IO),			// io:16
		.dump_scr(dump_scr)
	);
*/

module pdo_CY7C1041DV33
////////////////////////////////////////////////////
// Ports
#(
	parameter fname_r = "mem_r_disp.txt",
	parameter fname_l = "mem_l_disp.txt",
	parameter dump_func = 0		// dump機能の有無
)
(
	input [17:0] Address,
	input nWE,nOE,
	
	inout [15:0] IO,
	input dump_scr		// dump_scr screen
);
	//メモリ配列本体
	reg [15:0] MEM [0:(2**18)-1];
	
	assign #0.3 IO = ( nWE==1'b1 && nOE==1'b0) ? MEM[Address] : 16'bz ;
	
	always@(Address) begin
		if(!nWE) #0.3 MEM[Address] <= IO;
	end

	generate if(dump_func) begin
		// screen dump_scr
		reg [8:0] x = 9'b0;
		reg [6:0] y = 7'b0;
		reg scr = 1'b0;
		wire [14:0] wPix_L = MEM[{scr,1'b0,y,x}][14:0];
		wire [14:0] wPix_R = MEM[{scr,1'b1,y,x}][14:0];
		always@(posedge dump_scr) begin
			repeat(2)begin
				y = 0;
				while(y<96) begin
					$fwriteh(fname_l,wPix_L);
					$fwriteh(fname_r,wPix_R);
					x = x + 1;
					if(400<x)begin
						x = 0;
						y = y + 1;
					end
				end
				scr = ~scr;
			end
		end
	end endgenerate
endmodule 