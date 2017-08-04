`timescale	1ns/10ps
`define		ONE_CYCLE 22.7	//BCK 1サイクル/メインクロック 1サイクル
//シミュレーション用DAI
//矩形波出力

/* Portlist
pdo_DAI #(.num_fft_element()) pdo_dai
(.BCK(),.LRCK(),.SData());
*/
/* memo
メインクロック (64MHz) = 15.6 [ns]

BCK 周波数		= サンプルレート * 64 = 2.82 [MHz]
1 Cycle 		= 22.6 [us]

LRCK			= サンプルレート * 2	= 88.2 [KHz]

Right Justified Format
*/

module pdo_DAI
#(
	parameter bw_fftp = 4	//FFT要素数
)
(
	////////////////////////////////////////////////////
	// Ports
	output reg BCK,SData,
	output LRCK
);
	
	time t_1c	= `ONE_CYCLE;
	time t_half_cycle = t_1c/2;
	
	initial begin
		BCK		= 1'b0;
		SData	= 1'b0;
		
		fork
			forever begin
				#t_half_cycle	BCK	= ~BCK;
			end
		join
		
	end
	
	////////////////////////////////////////////////////
	// Registers
	wire PulsePhase = LRCKCount <= (1<<(bw_fftp-1));
	reg [bw_fftp-1:0] LRCKCount = 0;
	
	reg [5:0] BCKCount = 0;
	assign LRCK = ~BCKCount[5];
	
	always@(negedge BCK) begin
		BCKCount = BCKCount + 1;
	end

	wire [4:0] BCKCountLow = BCKCount[4:0];
	always@(negedge BCK) begin
	
		if		(BCKCountLow>=24|BCKCountLow<=7)
			SData	<= 1'b0;
		else if (!PulsePhase && (BCKCountLow==8)) //Phase LOW
			SData	<= 1'b1;
		else if (PulsePhase && (BCKCountLow>=9)) //Phase HI
			SData	<= 1'b1;
		else 
			SData	<= 1'b0;
			
	end	
	
	always@(posedge LRCK) begin
			LRCKCount = LRCKCount + 1;
	end

endmodule 