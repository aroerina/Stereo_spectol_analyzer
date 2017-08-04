//FFTCの出力を最適化する
//処理の状況を提供する

/* Portlist
	FFTResOptimize spc
	(
		.Clock(),	//i
		.Reset(),	//i
		.Start(),	//i
		.Busy(),	//o
		.Re(),		//i:18
		.Im(),		//i:18
		.Spectol(),	//i:7
		.Busy()		//o
	);
*/

module FFTResOptimize
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,Start,AudioInputSel,
	input [17:0] Re,Im,
	
	output [6:0] Spectol,
	output End,
	output reg Busy
);
	
	////////////////////////////////////////////////////
	// Registers
	reg [1:0] r_SqrtStart;
	wire wSqrtStart	= r_SqrtStart[1];

	////////////////////////////////////////////////////
	// Net
	wire [36:0]	Res_MULTADD;	//MULTADD Output wire
	
	wire LogbarEnd;
	assign End = LogbarEnd;
	////////////////////////////////////////////////////
	// Instantiations
	
	//MULTADD Re^2 + Im^2
	//CE　なし	Input reg なし　Pipeline reg あり Output reg あり
	//Delay:2
	MULTADD18 mult(
		.CLK0(Clock),
		.RST0(Reset),
		.A0(Re), 
		.A1(Im), 
		.B0(Re), 
		.B1(Im), 
		.SUM(Res_MULTADD)
	);
	
	wire [35:0] Sin = Res_MULTADD[35:0];
	wire [17:0]	Res_Sqrt;		//平方根演算器出力
	//平方根演算器
	Sqrt #(.bw_in(36),.bw_step(5))
	sqr(
		.Clock(Clock),
		.Reset(Reset),
		.Start(wSqrtStart),
		.Sin(Sin),
		.Sout(Res_Sqrt),
		.Busy(SqrtBusy),
		.End(LogbarStart)
	);
	
	// Line input の時のノイズをカットする
	// (AudioInputSel == 1'b1) = LINE
	localparam val_suppress = 64;
	wire [17:0]	LineNoizeReduction	= (Res_Sqrt<val_suppress)	?	18'd0				:	Res_Sqrt-val_suppress;
	wire [17:0]	Logbar_in 			= (AudioInputSel)			? 	LineNoizeReduction	:	Res_Sqrt ;
	
	reg rLogbarStart;
	reg [17:0]	rLogbar_in;
	always @ (posedge Clock or posedge Reset) begin
		if(Reset)begin
			{rLogbarStart,rLogbar_in}	<= 1'b0;
		end else begin
			rLogbarStart	<= LogbarStart;
			rLogbar_in		<= Logbar_in;
		end
	end
	

	//最大振幅の正弦波入力で出力：32770
	//対数スケール化　＋　ノーマライズ 　＋　飽和判定
	FFTLogbar3 fftlogbar (
		.Clock(Clock),
		.Reset(Reset),
		.Start(rLogbarStart),
		.In(rLogbar_in),
		.Out(Spectol),
		.Busy(LogBarBusy),
		.End(LogbarEnd)
	);

	always @ (posedge Clock or posedge Reset)
		if(Reset)begin
			Busy	<= 1'b0;
			r_SqrtStart	<= 1'b0;
		end else begin
			r_SqrtStart[1:0]	<= {r_SqrtStart[0],Start};
			
			if ( Start )
				Busy	<= 1'b1;
			else if ( LogbarEnd) 
				Busy	<= 1'b0;
				
		end

endmodule 