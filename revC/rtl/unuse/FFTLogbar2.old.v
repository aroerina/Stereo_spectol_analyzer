//FFTC出力を最適化する
//x軸にオフセットを付けた対数関数
/* Portlist
FFTLogbar fftlogbar
	(
	.Clock(Clock),
	.Reset(Reset),
	.Start(Start),
	.In(In),
	.Out(Out),
	.Busy(Busy),
	.End(End)
	);
*/

module FFTLogbar2
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_input = 18
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,Start,
	input [bw_input-1:0] In,
	output reg [6:0] Out,
	output reg Busy,End
);

	localparam bw_sat		= 4;	//飽和条件判定に使うビット
	localparam bw_list		= 9;	//リスト処理に使う上位ビット
	localparam bw_lowwer	= bw_input - (bw_list + bw_sat);	//下位ビット Dividerで割られる数
	
	// Slope ROM Parameters
	localparam slope_rom_name = "LogbarSlopeList_16d5b.mem";
	localparam bw_sloperom_addr = 4;	//Slope ROM Address Bit Width
	localparam bw_sloperom_q	= 5;	//Slope ROM Q Bit Width
	localparam depth_sloperom	= 16;	//Slope ROM Address depth
	
	// Height ROM Parameters
	localparam height_rom_name = "LogbarHeightList_448d7b.mem";
	localparam bw_heightrom_addr 	= 9;
	localparam depth_heightrom		= 448;
	////////////////////////////////////////////////////
	// Registers
	reg [bw_input-1:0]	rIn;
	reg [2:0]			rSrStart;
	reg rStartDivider;
	
	////////////////////////////////////////////////////
	// Net
	wire [bw_list-1:0]		wAddrlist		= rIn [bw_list+bw_lowwer-1:bw_lowwer];
	wire [bw_sloperom_addr-1:0] wAddrSlope		= wAddrlist[bw_sloperom_addr-1:0];
	wire [bw_lowwer-1:0]	wQ_ROMSlope,wDividerQuo;
	wire [6:0]				wQ_ROMA;
	
	//上位ビットを評価してSlope ROMの範囲を超えるかどうか判定
	wire wOutOfSROMAddr		= wAddrlist > (depth_sloperom-1);
	wire wSat				= |rIn[bw_input-1:bw_input-bw_sat] || wOutOfSROMAddr;	//飽和条件判定
	
	//Slope ROMの範囲の超えない場合出力は : A + DividerQuo 
	//Slope ROMの範囲を超えた場合出力はAだけ
	wire [bw_list-1:0]	wPreOut = (wOutOfSROMAddr) ?  wQ_ROMA  :(wQ_ROMA + wDividerQuo);	//MUX
	wire wEnd				= (wOutOfSROMAddr & rSrStart[2]) | wDividerEnd | wSat;
	
	////////////////////////////////////////////////////
	// Instantiations
	
	//関数の傾きROM
	//Output Reg　あり　ROMの範囲を超えると０が出力される
	pmi_distributed_rom #(
		.pmi_addr_depth(depth_sloperom),
		.pmi_addr_width(bw_sloperom_addr),
		.pmi_data_width(bw_sloperom_q),
		.pmi_regmode("reg"),
		.pmi_init_file(slope_rom_name),
		.pmi_init_file_format("hex"),
		.pmi_family("XP2"),
		.module_type("pmi_distributed_rom"))
	rom_slope  (
		.Address(wAddrSlope),
		.OutClock(Clock),
		.OutClockEn(1'b1),
		.Reset(Reset),
		.Q(wQ_ROMSlope)
   );
	
	//区間の高さROM
	pmi_distributed_rom #(
		.pmi_addr_depth(depth_heightrom),
		.pmi_addr_width(bw_heightrom_addr),
		.pmi_data_width(7),
		.pmi_regmode("reg"),
		.pmi_init_file(height_rom_name),
		.pmi_init_file_format("hex"),
		.pmi_family("XP2"),
		.module_type("pmi_distributed_rom")) 
	rom_height  (
		.Address(wAddrlist),
		.OutClock(Clock),
		.OutClockEn(1'b1),
		.Reset(Reset),
		.Q(wQ_ROMA)
   );
	
	wire wDividerEnd;
	Divider #(
		.bw_Dsor(bw_lowwer),
		.bw_Dend(bw_lowwer),
		.bw_i(3)) 
	div	(
		.Clock(Clock), 
		.Reset(Reset),
		.Start(rStartDivider),
		.Dsor(wQ_ROMSlope),
		.Dend(rIn[bw_lowwer-1:0]), 
		.Quo(wDividerQuo),
		.End(wDividerEnd),
		.Busy()
	);

	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			{
				rIn,Out,rSrStart,
				rStartDivider,End,Busy
			}	<= 1'b0;
		end else
		if(Clock)begin
			rSrStart <= {rSrStart[1:0],Start};
			rStartDivider <= rSrStart[0] & ~wOutOfSROMAddr;
			
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