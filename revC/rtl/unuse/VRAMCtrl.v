//VRAMコントロールモジュール
//x 0-512
//y 0-128
/* Portlist
VRAMCtrl vc
(.Clock(), .Reset(), .Screen(), .WrAdr_X(), .WrAdr_Y(), .WriteData(),
	.SWClockEn(), .nWE(), .StartLoader() ,.Address(), .IO(),
	.DotClock(), .R_RGB() , .L_RGB() , .VS(), .HS());
*/
/*	memo

Screen配置
Address 
[17] 0:1st	1:2nd
[16] 0:R	1:L
[17:16]
 01 00	1st
 11 10	2nd
 L  R

 SRAMAddr = [17:16]:Screen , [15:10] : Y , [8:0] : X
 
 SRAM IO サイクル		ドットクロックから90度ずれる
 
				|			16 Clock				|
				| Write * 12 | Read * 2 | Blank *1	|
 
|			1 Dot Clock			|			1 Dot Clock				|
*/


module VRAMCtrl
(
	////////////////////////////////////////////////////
	// Ports
	
	//For Inner Module
	input			Clock,Reset,	//Clock = 64MHz
	input	[8:0]	WrAdr_X,
	input	[6:0]	WrAdr_Y,
	input			Screen,			//0:R	1:L
	input	[14:0]	WriteData,
	output			SWClockEn,		//Spectol Writer Clock Enable
	output	reg 	StartLoader,	//フレームの始まり。65536サイクルごとに出力
	//書き込みモジュール制御用ClockEn

	//For SRAM
	output	nWE,nOE,
	output	reg [17:0]	Address,
	inout		[14:0] 	IO,
	
	//For LCDs
	input				DotClock,		// = 4MHz
	output reg [14:0]	R_RGB,L_RGB,
	output reg			VS,HS

);
	parameter	 hs_offset_minus = 0;
	localparam pos_hs	= 405 - hs_offset_minus;
	localparam pos_vs	= pos_hs - 153;
	localparam line_vs	= 112;//111;

	////////////////////////////////////////////////////
	// Registers
	reg r_nOE,r_SWClockEn;
	reg [1:0]	rDotClock;				//DotClockの状態を採取
	reg [11:0]	rSR_SqSigs,rSR_PE;		//LSB->MSBシフトレジスタ
	reg [14:0]	rWriteData [0:1];
	reg [16:0]	r_Count;
	reg [17:0]	r_RdAddr,r_WrAddr;
	
	////////////////////////////////////////////////////
	// Net
	wire [8:0] wReadX	= r_Count[8:0];
	wire [6:0] wReadY	= r_Count[15:9];
	
	wire [17:0] w_WrSRAMAddr 	= {~r_Count[16],Screen,{WrAdr_Y,WrAdr_X}};
	wire [17:0] w_RdSRAMAddr	= {r_Count[16],rSR_PE[7],r_Count[15:0]};
	wire wSRAMAddrSW			= |rSR_PE[8:7];
	
	wire w_IOSW				= rSR_SqSigs[6];
	wire w_PosEdge			= {rDotClock[1],rDotClock[0]} == 2'b01 ;	//DotClockの立上がりエッジ検出
	
	assign nWE				= rSR_SqSigs[6];
	assign nOE				= r_nOE;
	assign IO				= (w_IOSW) ?	15'bz : rWriteData[1]	;		//IO Switch :0 == Hi-Z
	assign SWClockEn		= r_SWClockEn;
	
	
	////////////////////////////////////////////////////
	//SRAM Control
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			{r_nOE,r_SWClockEn} <= 0;
			rDotClock	<= 2'b0;
			rSR_PE		<= 0;
			rSR_SqSigs 	<= 0;
			Address		<= 0;
		end else begin
			rDotClock[0]		<= DotClock;
			rDotClock[1]		<= rDotClock[0];
			
			//DotClock下降エッジをパルスに変換LSB->MSBシフトレジスタ
			rSR_PE		 <= {rSR_PE[10:0],w_PosEdge};
			//4Cycle分Low期間を作る
			rSR_SqSigs	<= {rSR_SqSigs[10:0],|rSR_PE[3:0]};
			
			r_SWClockEn	<= ~|rSR_PE[6:3];
			r_nOE		<= ~|rSR_PE[8:7];
			r_RdAddr	<= w_RdSRAMAddr;
			r_WrAddr	<= w_WrSRAMAddr;
			Address		<= (wSRAMAddrSW)	? r_RdAddr : r_WrAddr	;
			
			rWriteData[0]	<= WriteData;
			rWriteData[1]	<= rWriteData[0];
			
		end
	end
	
	////////////////////////////////////////////////////
	//LCD Control
	//最初に右画面の色データ読み出し、次は左
	wire wHS	= ~(wReadX == pos_hs);
	wire wVS	= ~(wReadY == line_vs);
	wire w_SampleR_RGB	= rSR_PE[8];
	wire w_SampleL_RGB	= rSR_PE[9];
	reg r_Count15;
	
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			L_RGB		<= 0;
			R_RGB		<= 0;
			r_Count15	<= 1'b0;
			StartLoader <= 1'b0;
		end else begin	//Clock
			if ( w_PosEdge ) begin
				r_Count15	<= r_Count[15];
				//r_Countの15ビット目の立下りエッジを検出
				StartLoader <= ({r_Count[15],r_Count15} == 2'b01) ;
			end	else begin
				StartLoader <= 1'b0;
			end
			
			if ( w_SampleR_RGB )	R_RGB	<= IO;
			if ( w_SampleL_RGB )	L_RGB	<= IO;
			
		end
	end
	
	always@(negedge DotClock or posedge Reset) begin
		if(Reset) begin
			r_Count	<= 0;
		end else begin
			//StartLoaderパルス生成
			r_Count	<= r_Count + 1'b1;
		end
	end
	
	always@(negedge DotClock or posedge Reset) begin
		if(Reset) begin
			HS		<= 1'b0;
			VS		<= 1'b0;
		end else begin
			HS		<= wHS;
			VS		<= wVS;
		end
	end
	
endmodule 