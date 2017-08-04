//FFTC出力を最適化する
/* Portlist
FFTLogbar fftlogbar
	(.Clock(Clock),.Reset(Reset),.Start(Start),
	.In(In),.Out(Out),.Busy(Busy),.End(End)
	);
*/

module FFTLogbar
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_input = 17
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,Start,
	input [bw_input-1:0] In,
	output reg [6:0] Out,
	output reg Busy,End
);

	localparam bw_sat		= 5;	//飽和条件判定
	localparam bw_list		= 7;	//リスト処理に使う上位ビット
	localparam bw_lowwer	= 7;	//下位ビット Dividerで割られる数
	localparam bw_addrslope = 4;	//Slope ROM Address Bit Width
	localparam bw_a			= 7;	//"A" ROM Address bit width
	localparam rom_area_max	= 10;	//Slope ROM Address depth
	////////////////////////////////////////////////////
	// Registers
	reg [bw_input-1:0]	rIn;
	reg [2:0]			rSrStart;
	reg rStartDivider;
	
	////////////////////////////////////////////////////
	// Net
	wire [bw_list-1:0]		wAddrlist		= rIn [bw_list+bw_lowwer-1:bw_lowwer];
	wire [bw_addrslope-1:0] wAddrSlope		= wAddrlist[bw_addrslope-1:0];
	wire [bw_lowwer-1:0]	wQ_ROMSlope,wDividerQuo;
	wire [bw_a-1:0]			wQ_ROMA;
	
	//上位ビットを評価してSlope ROMの範囲を超えるかどうか判定
	wire wOutOfRomAddr		= wAddrlist > rom_area_max;
	wire wSat				= rIn[bw_input-1:bw_input-bw_sat] >= 3;	//飽和条件判定 h3000>IN
	
	//Slope ROMの範囲の場合内出力は : A + DividerQuo 
	//Slope ROMの範囲を超えた場合出力はAだけ
	wire [bw_a-1:0]	wPreOut = (wOutOfRomAddr) ?  wQ_ROMA  :(wQ_ROMA + wDividerQuo);	//MUX
	
	wire wDividerEnd;
	wire wEnd				= (wOutOfRomAddr & rSrStart[2]) | wDividerEnd | wSat;
	

	////////////////////////////////////////////////////
	// Instantiations
	
	//Output Reg　あり　ROMの範囲を超えると０が出力される
	DISTROM_LIST_SLOPE_7b10d rom_slope (.Address(wAddrSlope), .OutClock(Clock), .OutClockEn(1'b1), 
    .Reset(Reset), .Q(wQ_ROMSlope));
	
	DISTROM_LIST_A_7b128d rom_a (.Address(wAddrlist), .OutClock(Clock), .OutClockEn(1'b1), 
    .Reset(Reset), .Q(wQ_ROMA));
	
	Divider #(.bw_Dsor(bw_lowwer),.bw_Dend(bw_lowwer),.bw_i(4)) div
	(.Clock(Clock),  .Reset(Reset), .Start(rStartDivider), .Dsor(wQ_ROMSlope), .Dend(rIn[bw_lowwer-1:0]), 
	.Quo(wDividerQuo), .End(wDividerEnd) ,.Busy());

	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			rIn				<= 0;
			Out				<= 0;
			rSrStart		<= 0;
			rStartDivider	<= 0;
			End				<= 0;
			Busy			<= 0;
		end else
		if(Clock)begin
			rSrStart <= {rSrStart[1:0],Start};
			rStartDivider <= rSrStart[0] & ~wOutOfRomAddr;
			
			if(Start) begin
				rIn		<= In;
				Busy	<= 1'b1;
			end else if (wEnd) begin
				Busy	<= 1'b0;
			end
				
			if(wEnd) begin
				if(wSat)
					Out	<= 7'd96;
				else
					Out	<= wPreOut;
			end
				
			if(End)
				End	<= 1'b0;
			else if (Busy)
				End	<= wEnd;
		end
	end

endmodule 