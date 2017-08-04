//
/* Portlist
CORDIC_SC cordic
(.Clock(Clock),.Reset(Reset),.Start(),.Theta(),
	.SinOut(),.CosOut(),.Busy(),.End());
*/

module CORDIC_SC
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_theta = 9,
	parameter bw_out = 16
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,Start,
	input [bw_theta-1:0] Theta,
	output reg [bw_out-1:0] CosOut,SinOut,
	output reg Busy,End
);
	localparam fxp = 4;						//小数点位置
	localparam convert_vector	= 19898;	//変換ベクトル
	localparam bw_tromaddr	= 4;
	localparam bw_tromq		= 13;

	////////////////////////////////////////////////////
	// Registers
	reg signed [bw_out:0] 		rX,rY;		//符号付
	reg [bw_theta-1:0]			rInTheta;	//入力Thetaを格納するだけ
	reg signed [bw_tromq+1:0]	rTheta;		//Thetaを計算した結果を格納する
	reg [bw_tromaddr-1:0]		rTROMAddr;	//Startを遅延させる
	reg rDStart;
	
	////////////////////////////////////////////////////
	// Net
	wire signed [bw_out:0] wResAsX,wResAsY;	//AddSubの結果を出力
	wire signed [bw_out:0] wSX,wSY;			//X,Yをシフトした数値
	assign wSX[bw_out] = wSX[bw_out-1];
	assign wSY[bw_out] = wSY[bw_out-1];
	
	wire signed [bw_tromq+1:0] wResAsTheta;
	wire [bw_tromq+1:0] wTROMQ;
	assign wTROMQ[bw_tromq+1:bw_tromq] = 2'b0;
	
	wire [fxp-1:0] wFxp = 1'b0<<fxp;
	wire signed [bw_tromq+2:0] wInTheta = {2'b0,rInTheta,wFxp};
	
	
	wire wSeqEn		= (rTROMAddr < bw_tromq) && Busy;
	wire wEnd		= Busy && !wSeqEn;
	
	////////////////////////////////////////////////////
	// Instantiations
	
	//Address Depth:13	Q BitWidth:13	4bit FixPoint
	DISTROM_CORDIC_THETA theta_rom (.Address(rTROMAddr), .OutClock(Clock), 
    .OutClockEn(1'b1), .Reset(Reset), .Q(wTROMQ[bw_tromq-1:0]));
	
	wire wRSEnd;
	//算術右シフトレジスタ
	wire wRSStart = rDStart | wRSEnd;
	SRightShifter2 #(.bw_in(bw_out)) rs2(
		.Clock(Clock),
		.Reset(Reset|Start),	//Startでリセット
		.Start(wRSStart),
		.IN1(wResAsX[bw_out:1]),
		.IN2(wResAsY[bw_out:1]),
		.Amount(rTROMAddr),
		.OUT1(wSX[bw_out-1:0]),
		.OUT2(wSY[bw_out-1:0]),
		.Busy(wRSBusy),
		.End(wRSEnd)
	);
	
	wire wCompRes	= rTheta > wInTheta;	//Thetaを比較計算したθが大きければ１
	
	wire [2:0] wDmy; //ワーニング抑制用
	AddSub #(.width(bw_out+1)) asX(
		.SubEn(~wCompRes),
		.A(rX),
		.B(wSY),
		.S({wDmy[0],wResAsX})
	);
	AddSub #(.width(bw_out+1)) asY(
		.SubEn(wCompRes),
		.A(rY),
		.B(wSX),
		.S({wDmy[1],wResAsY})
	);
	AddSub #(.width(bw_tromq+2)) asT(
		.SubEn(wCompRes),
		.A(rTheta),
		.B(wTROMQ),
		.S({wDmy[2],wResAsTheta})
	);
	
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			rX			<=	0;
			rY			<=	0;
			CosOut		<=	0;
			SinOut		<=	0;
			Busy		<=	0;
			End			<=	0;
			rTheta		<=	0;
			rInTheta	<= 0;
			rTROMAddr	<= 0;
			rDStart		<= 0;
		end else begin
			rDStart	<= Start;
			if(Start) begin
				rX			<= convert_vector;
				rY			<= convert_vector;
			end else if (wRSEnd) begin
				rX		<= wResAsX;
				rY		<= wResAsY;
			end
			
			if(Start) begin
				rTheta		<= wTROMQ;	
			end else if (wRSEnd) begin
				rTheta		<= wResAsTheta;			
			end
			
			if(Start) begin
				rInTheta	<= Theta;
				Busy		<= 1'b1;
			end else if (wEnd) begin
				CosOut		<= wResAsX[bw_out-1:0];
				SinOut		<= wResAsY[bw_out-1:0];
				Busy		<= 1'b0;
			end
			
			if((Busy || rDStart) && !wRSBusy)
				rTROMAddr	<= rTROMAddr + 1;
			else if (wEnd)
				rTROMAddr	<= 0;
				
			if(End)
				End	<= 1'b0;
			else if (wEnd)
				End	<= 1'b1;

		end
	end
endmodule 