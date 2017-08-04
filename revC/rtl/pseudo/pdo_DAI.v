`timescale	10ns/10ps
`define		ONE_CYCLE 22.7	//BCK 1サイクル/メインクロック 1サイクル
//シミュレーション用DAI
//矩形波出力
//MSB First 左詰めフォーマット

/* Portlist
pdo_DAI pdo_dai(
		.BCK(BCK), 		// o
		.LRCK(LRCK),	// o
		.SData(SData)	// o
	);
*/
/* memo
メインクロック (64MHz) = 10 [ns] = 1GHz

BCK 周波数		= サンプルレート * 64 = 2.82 [MHz]

LRCK			= サンプルレート * 2	= 88.2 [KHz]
*/

module pdo_DAI
#(
	parameter bw_fftp = 12	//FFT要素数
)
(
	////////////////////////////////////////////////////
	// Ports
	output BCK,LRCK,
	output SData
);
	reg [5:0] BCKCount = 32;
	
	//クロック生成
	time t_hc = `ONE_CYCLE/2;	// Half Cycle
	always #t_hc	BCKCount = BCKCount + 1'b1;
	assign BCK = BCKCount[0];
	assign LRCK = ~BCKCount[5];
	
	reg [15:0] rData = 0;
	
	//　元波形生成　FFTPoint / 16 の矩形波生成
	reg [11:0] Counter = 12'b0;

	always@(posedge LRCK) begin
		Counter <= Counter + 1'b1;
	end
	
	parameter half_phase = 4096 / 32;
	parameter phase = half_phase*2;
	assign SData = rData[15];
	
	always@(negedge BCK) begin
		if(BCKCount[4:0] == 5'd0 )
			if((Counter % phase)<half_phase)
					rData	<= 10000;
				else
					rData	<= -10000;
		else
			rData	<= rData << 1;
	end

endmodule 