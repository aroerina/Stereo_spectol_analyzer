//基数２FFT用回転子出力
//Real 		= Cosine
//Imagine	= nSine
//
//Clock Delay : 3

/* Portlist
Rdx2Twiddle twiddle
	(.Clock(),.ClockEn(),.Reset(),.Theta(),.Re(),.Im());
*/

`ifdef N4096
`define NAME_TWIDDLE_ROM_NAME	TDPRAM_NSINE17b1024d
`endif

`ifdef N64
`define NAME_TWIDDLE_ROM_NAME	TDPRAM_NSINE17b16d	
`endif

`ifdef N2048
`define NAME_TWIDDLE_ROM_NAME	TDPRAM_NSINE17b512d	
`endif

`ifdef N16B9
`define NAME_TWIDDLE_ROM_NAME	TDPRAM_NSINE8b4d
`endif
//ビット幅はtwiddle factorのビット幅-1

module Rdx2Twiddle
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter b_fftp	= 12,
	parameter b_twd		= 18	//Twiddle Factor bit width
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,ClockEn,Reset,
	input [b_fftp-2:0] Theta,
	output reg signed [b_twd-1:0] Re,Im
);
	localparam b_theta = b_fftp-1;

	localparam b_raddr = b_fftp-2;
	localparam b_rdata = b_twd -1;
	
	////////////////////////////////////////////////////
	// Registers
	reg [b_raddr-1:0] rAddrRe,rAddrIm;
	reg [2:0] rArea;
	reg [2:0] rBegin0,rBegin1;
	
	////////////////////////////////////////////////////
	// Net
	wire wArea	= Theta[b_theta-1];
	wire wBegin0	= ~(Theta == 0);	//波形の切り替えポイント 論理反転しているので注意
	wire wBegin1	= (Theta == (1<<b_raddr));
	wire [b_raddr-1:0] wPreAddr		= Theta[b_raddr-1:0];
	wire [b_raddr-1:0] wPreAddrComp	= -wPreAddr;
	wire signed [b_rdata-1:0] wQA,wQB;
	wire signed [b_twd-1:0] wNQA = -wQA;
	
	////////////////////////////////////////////////////
	// Instantiations
	
	//True Dual Port RAMをROMとして使う
	// -Sin波の1/4だけ使用	波形の継ぎ目を先頭に持ってくる
	// A = Real : B = Imagine
	`NAME_TWIDDLE_ROM_NAME tdpram_rom (
		.DataInA(17'b0), .DataInB(17'b0),
		.AddressA(rAddrRe), .AddressB(rAddrIm), 
		.ClockA(Clock), .ClockB(Clock), .ClockEnA(ClockEn), 
		.ClockEnB(ClockEn), .WrA(1'b0), .WrB(1'b0), 
		.ResetA(Reset), .ResetB(Reset), .QA(wQA), .QB(wQB)
		);
	
	always@(posedge Reset or posedge Clock)
		if(Reset)begin
			{
				Re,Im,rArea,rBegin0,rBegin1,
				rAddrRe,rAddrIm
			}	
				<= 1'b0;
		end else if(ClockEn) begin
			rArea	<=	{rArea[1:0],wArea};
			rBegin0	<=	{rBegin0[1:0],wBegin0};
			rBegin1	<=	{rBegin1[1:0],wBegin1};
			
			//アドレス変換
			if(wArea) begin		// 1/2π ~ π
				rAddrRe	<= wPreAddr;
				rAddrIm	<= wPreAddrComp;
			end else begin		// 0 ~ 1/2π
				rAddrRe	<= wPreAddrComp;
				rAddrIm	<= wPreAddr;
			end
			
			// Imagine	出力変換
			Im[b_rdata-2:0] <= wQB[b_rdata-2:0];
			if(!rBegin0[2])		//波形のつなぎ目の処理
				Im[b_twd-1:b_twd-2]		<= 2'b0;
			else
				Im[b_twd-1:b_twd-2]		<= 2'b11;

			// Real	出力変換
			if(rArea[2]) 			// 1/2π ~ π
				Re[b_rdata-1:0]		<= wQA[b_rdata-2:0];
			else 					// 0 ~ 1/2π
				Re[b_rdata-1:0]		<= wNQA[b_rdata-2:0];	//正負変換
			
			if(!rBegin0[2])
				Re[b_twd-1:b_twd-2]  <= 2'b01;
			else if(rBegin1[2] || !rArea[2])
				Re[b_twd-1:b_twd-2]  <= 2'b00;
			else
				Re[b_twd-1:b_twd-2]  <= 2'b11;
		end
endmodule 