//ROMを使ったコサイン波、反転サイン波テーブル
//クロック遅延 4
//Theta は半分だけ

/* Portlist
SCTable_Half #(.bw_fftp(4)) sct	
(.Clock(),.ClockEn(),.Reset(),.Theta(),.Cosine(),.nSine());
*/
`define SCTROM_NAME sctrom4		//ROM module name
`define BW_ROM_WDTH 18			//出力ビット幅

module SCTableHalf #(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_fftp = 4,
	parameter bw_data = `BW_ROM_WDTH
)
(
	input Clock,ClockEn,Reset,
	input [bw_fftp-1:0] Theta,
	output reg [bw_data-1:0] Cosine,nSine
);
	localparam bw_theta		= bw_fftp -1;
	localparam half			= 2**(bw_theta-1);	// Theta/2

	////////////////////////////////////////////////////
	// Registers
	reg [bw_theta-2:0] rAddress;
	reg [bw_theta-1:0] rTheta;
	reg rFturn;

	////////////////////////////////////////////////////
	// Net
	wire [bw_data-1:0] w_Cosine,w_nSine;
	wire [1:0] wArea = Area(Theta);
	wire wFjoint,wFpnCos;

	//ROMの出力値を-するか、０にするか判断するフラグ
	//0bit:RAMアドレス折り返し方法負値に変換 Cos
	//1bit:ROM出力レジスタを0にする

	function [1:0] Area
		(input [bw_theta-1:0] Theta);
		if(Theta == half) begin //波形連結ポイントθ＝π/2
			Area = 2'b10;
		end else if(Theta < half ) begin
			Area = 2'b00;
		end else begin
			Area = 2'd01;
		end
	endfunction

	////////////////////////////////////////////////////
	// Instansiation
	`SCTROM_NAME sct (.Address(rAddress ), .OutClock(Clock ), .OutClockEn(ClockEn ),
	.Reset(Reset ), .Q({w_Cosine,w_nSine}));

	DelayUnit fd (.Clock(Clock),.ClockEn(ClockEn),.Reset(Reset),.i_DATA(wArea),.o_DATA({wFjoint,wFpnCos}));
	defparam fd.w_data = 2;
	defparam fd.delay = 3;
	/*
	θ入力⇒フラグ出力⇒アドレス生成⇒ROM出力⇒
	⇒フラグを確認して出力を負値にする or そのまま or 0にする
	*/
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			rAddress	<= 0;
			rTheta		<= 0;
			rFturn		<= 0;
			Cosine		<= 0;
			nSine		<= 0;
		end else if(ClockEn)begin
			rFturn	<= wArea[0];
			rTheta	<= Theta;

			//ROMアドレス折り返し
			if(rFturn)
				rAddress <= half - rTheta[bw_theta-2:0];
			else
				rAddress <= rTheta[bw_theta-2:0];

			//Cosine
			if(wFjoint)
				Cosine	<= 0;
			else if(wFpnCos)
				Cosine	<= -w_Cosine;
			else
				Cosine	<= w_Cosine;

			//nSine
			if(wFjoint)
				nSine	<= 2'b11<<(bw_data-2);	// 出力波形の最大値
			else
				nSine	<= w_nSine;
		end
	end
endmodule 