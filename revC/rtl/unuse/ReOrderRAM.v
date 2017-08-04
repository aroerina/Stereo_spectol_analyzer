//Bit Reverse　制御Module
/* Portlist
ReOrderRAM _ #(.bw_fftp())
(.Clock(),.ClockEn(),.Reset(),.WE(),.RdAddress(),.WrAddress());
*/

module ReOrderRAM
////////////////////////////////////////////////////
// Parameters
#(
parameter bw_fftp = 9
)
////////////////////////////////////////////////////
// Ports
(
input Clock,ClockEn,Reset,
//output reg WE,
output reg [bw_fftp-1:0] RdAddress,WrAddress
);

	////////////////////////////////////////////////////
	// Registers
	reg [bw_fftp-1:0] rCount;

	////////////////////////////////////////////////////
	// Net
	wire [bw_fftp-1:0] wBR;
	
	//ビットリバースワイヤ
	genvar j;
	generate
		for( j=0 ; j<bw_fftp ; j=j+1) begin :brev
			assign wBR [j] = rCount[bw_fftp-1-j];
		end
	endgenerate	
	
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			rCount <=	0;
			RdAddress	<=	0;
			WrAddress	<=	0;
		end else if(ClockEn)begin
			rCount		<=	rCount + 1;
			RdAddress	<=	rCount;
			WrAddress	<=	wBR;
		end
	end
	
/* 	//negative edge sensitive
	always@(negedge Clock or posedge Reset) begin
		if(Reset)begin
			WE	<= 1'b1;
		end else if(ClockEn)begin
			if(RdAddress<WrAddress)
				WE <= 1'b1;
			else
				WE <= 1'b0;
		end
	end */
endmodule 