//
/* Portlist
pdo_Cacher (.bw_dpram())
	pdo_cacher	(
		.Clock(Clock),
		.Reset(Reset),
		.DPRAMAddr(DPRAMAddr),
		.DataL(DataL),
		.DataR(DataR),
	);
*/

module pdo_Cacher
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_dpram = 12,
	parameter bw_data = 16
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,
	input [bw_dpram-1:0] DPRAMAddr,
	output [bw_data-1:0] RAM_Q
);

	////////////////////////////////////////////////////
	// Instantiations
	//波形ROM
	
	`ifdef N64
	ROM_SQWAVE64 rom_r (.Address(DPRAMAddr), .OutClock(Clock), 
	.OutClockEn(1'b1), .Reset(Reset), .Q(RAM_Q));
	`else
	ROM_SQWAVE_2048_16b pdo_dpram (.Address(DPRAMAddr[bw_dpram-2:0]), .OutClock(Clock), 
	.OutClockEn(1'b1), .Reset(Reset), .Q(RAM_Q));
	`endif


endmodule 