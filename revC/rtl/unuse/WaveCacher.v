//Right Justified フォーマットのデータをEBRRAMに保存
/* Portlist
WaveCacher #(.bw_dpram().,bw_data()) wc
	(.Clock,.BCK(),.LRCK(),.Reset(),.SData().
	,.Address(),.OutData()); 
*/

module WaveCacher
	////////////////////////////////////////////////////
	// Parameters
#(
	parameter bw_dpram = 12,
	parameter bw_data = 16
)
	////////////////////////////////////////////////////
	// Ports
(
	input Clock,BCK,LRCK,Reset,SData,
	output [bw_dpram-1:0] Address, //EBRRAM Address
	output reg [bw_data-1:0] OutData
);
	
	////////////////////////////////////////////////////
	// Registers
	reg [23:0] r_Sreg;
	reg [bw_dpram-2:0] rAddress;
	
	//Shift Register
	always@ (posedge BCK or posedge Reset) begin	//Bit Clock
		if(Reset) begin
			r_Sreg	<= 1'b0 << bw_data-1;
		end else begin
			r_Sreg	<= {r_Sreg[22:0],SData};
		end
	end
	
	assign Address[bw_dpram-1] = LRCK;
	assign Address[bw_dpram-2:0] = rAddress;
	always@	(negedge LRCK or posedge Reset) begin	//LRClock
		if(Reset) begin
			rAddress	<= 0;
		end else begin
			rAddress <= rAddress + 1;
		end
	end
	
endmodule 