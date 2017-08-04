//
//		
//	
/* Portlist
MessageROM mrom(
		.Clock(Clock),			// i
		.Reset(Reset),			// i
		.Start(Start),			// i
		.FWEnd(FWEnd),			// i
		.MessageNumber(MessageNumber),		// i:7
		.FWStart(FWStart),		// o
		.Busy(Busy),			// o
		.CharNumber(CharNumber)	// o:6
	);
*/

`define FILENAME_ADDR_ROM	"message_top_addr_rom_25d8b.mem"
`define DEPTH_ADDRROM		25
`define BW_ADDRROM_Q		8
`define BW_ADDRROM_ADDR		5

`define FILENAME_MROM		"message_rom_235d6b.mem"
`define DEPTH_MROM			235



module MessageROM
(
	input Clock,Reset,Start,
	input FWEnd,
	input Color,
	input Char,	//文字コードをそのまま出力
	input [5:0] MessageNumber,
	output reg FWColor,
	output reg FWStart,Busy,
	output reg [5:0] CharNumber
);

	reg [5:0] rMessageNumber;
	localparam bw_addrrom_q		= `BW_ADDRROM_Q;
	localparam depth_addrrom	= `DEPTH_ADDRROM;
	localparam bw_addrrom_addr	= `BW_ADDRROM_ADDR;
	wire [bw_addrrom_addr-1:0] wAddrROMAddr = rMessageNumber[bw_addrrom_addr-1:0] ;
	


	wire [bw_addrrom_q-1:0] wAddrROMQ;
	
	pmi_distributed_rom #(
		.pmi_addr_depth(depth_addrrom),
		.pmi_addr_width(bw_addrrom_addr),
		.pmi_data_width(bw_addrrom_q),
		.pmi_regmode("reg"),
		.pmi_init_file(`FILENAME_ADDR_ROM),
		.pmi_init_file_format("hex"),
		.pmi_family("XP2"),
		.module_type("pmi_distributed_rom")
	) addr_rom  (
		.Address(wAddrROMAddr),
		.OutClock(Clock),
		.OutClockEn(1'b1),
		.Reset(Reset),
		.Q(wAddrROMQ)
	);
	
	reg [3:0]rStart;
	localparam bw_mrom_addr	= 8;
	reg [bw_mrom_addr-1:0] rMROMAddr;
	wire wEndChar = wMROMQ == 6'b111111;	// 区切り文字
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{FWStart,rMessageNumber,rMROMAddr,rStart,Busy,FWColor}	<= 1'b0;
		end else begin
			rStart	<= {rStart[3:0],Start};
			
			FWStart	<= rStart[3] | (FWEnd & (~Char) & (~wEndChar));
			
			if(Start)
				FWColor	<= Color;
			
			if(Start)
				rMessageNumber	<= MessageNumber;
			
			if(Start)
				Busy	<= 1'b1;
			else if(FWEnd && (Char || (wEndChar&&!Char)))
				Busy	<= 1'b0;
				
			if(rStart[1])
				rMROMAddr	<= wAddrROMQ;
			else if(FWEnd|rStart[2])
				rMROMAddr	<= rMROMAddr + 1'b1;
			
		end
	end
	
	wire [5:0] wMROMQ;
	pmi_distributed_rom #(
		.pmi_addr_depth(`DEPTH_MROM),
		.pmi_addr_width(bw_mrom_addr),
		.pmi_data_width(6),
		.pmi_regmode("reg"),
		.pmi_init_file(`FILENAME_MROM),
		.pmi_init_file_format("hex"),
		.pmi_family("XP2"),
		.module_type("pmi_distributed_rom")
	) message_rom  (
		.Address(rMROMAddr),
		.OutClock(Clock),
		.OutClockEn(1'b1),
		.Reset(Reset),
		.Q(wMROMQ)
	);
	
	
	
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{CharNumber}	<= 1'b0;
		end else begin
			CharNumber	<= (Char) ? rMessageNumber : wMROMQ;
		end
	end

endmodule 