//
/* Portlist
FFTCore #(.bw_fftp(),.bw_data(),.bw_stage()) fftcore	
(.Clock(),.Reset(),.Start(),.In_Re(),.In_Im(),
	.WrRAMAddr(),.RdRAMAddr(),.Out_Re(),.Out_Im(),.WE(),.End());
*/

`ifdef N16B9
	`define NAME_FFTB_MODULE FFTB_R2_DIT9
`else
	`define NAME_FFTB_MODULE FFTB_R2_DIT18
`endif

module FFTCore
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_fftp	= 12,
	parameter bw_data	= 18,
	parameter bw_stage	= 4,	//bw_fftpが収まるビット幅
	parameter ram_delay = 3		// Address - Q delay
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,Start,
	input signed [bw_data-1:0] In_Re,In_Im,
	output [bw_fftp-1:0] RdRAMAddr,WrRAMAddr,
	output signed [bw_data-1:0] Out_Re,Out_Im,
	output reg WE,Busy,End
);
	localparam index_delay = ram_delay+4;
	localparam bw_theta = bw_fftp-1;
	localparam bw_fftb = bw_data*2;
	localparam b_twd = bw_data;

	////////////////////////////////////////////////////
	// Register(s)
	
	reg rCEFFTB;
	reg [bw_data-1:0] rFFTCDataA_Re,rFFTCDataA_Im;
	
	localparam bw_rstart = 11;
	reg [bw_rstart-1:0] rStart;
	
	localparam bw_rend = 5;
	reg [bw_rend-1:0] rEnd;

	////////////////////////////////////////////////////
	// Net
	wire [bw_theta-1:0] wTheta;
	wire [bw_stage-1:0] wStage;
	wire [b_twd-1:0]	wTwiddle_Re,wTwiddle_Im;
	wire [bw_fftb-1:0] wResultA_Re,wResultB_Re,wResultA_Im,wResultB_Im;
	
	////////////////////////////////////////////////////
	// Instantiations
	
	//Indexer
	FFTIndexer_R2 #(.bw_fftp(bw_fftp),.bw_stage(bw_stage)) 
	indexer(
		.Clock(Clock),
		.Start(rStart[3]),
		.Stage(wStage),
		.Busy(),
		.End(wIndexerEnd),
		.Reset(Reset),
		.Index(RdRAMAddr)
	);
	
	//Pipe Register with index delay
	PipeReg #(.b_width(bw_fftp),.depth(index_delay)) preg
	(.Clock(Clock),.Reset(Reset),.ClockEn(1'b1),.In(RdRAMAddr),.Out(WrRAMAddr));
	
	//Generate Theta
	FFTTheta_R2 #(.bw_fftp(bw_fftp),.bw_stage(bw_stage)) theta
	(.Clock(Clock),.Start(Start),.Busy(),.End(),.Reset(Reset),.Theta(wTheta));
	
	//Generate Twiddle factor	latency:3
	Rdx2Twiddle #(.b_fftp(bw_fftp),.b_twd(b_twd)) twiddle
	(.Clock(Clock),.ClockEn(1'b1),.Reset(Reset),
	.Theta(wTheta),.Re(wTwiddle_Re),.Im(wTwiddle_Im));
	
	//FFT Buttefly	latency:2
	`NAME_FFTB_MODULE fftb (
		.Clock(Clock), .ClkEn(rCEFFTB), .Reset(Reset), 
		.Twiddle_Re(wTwiddle_Re), 
		.Twiddle_Im(wTwiddle_Im),
		.DataA_Re(rFFTCDataA_Re),
		.DataA_Im(rFFTCDataA_Im),
		.DataB_Re( In_Re), 
		.DataB_Im( In_Im), 
		.ResultA_Re(wResultA_Re),
		.ResultA_Im(wResultA_Im), 
		.ResultB_Re(wResultB_Re), 
		.ResultB_Im(wResultB_Im)
	);
	
	wire signed [bw_data-1:0] wOutA_Re,wOutB_Re,wOutA_Im,wOutB_Im;
	//bit shift save signed bit
	localparam sft = 2;
	assign wOutA_Re = {{2{wResultA_Re[bw_fftb-1]}},wResultA_Re[bw_fftb-sft-2:bw_data-sft+1]};	
	assign wOutA_Im = {{2{wResultA_Im[bw_fftb-1]}},wResultA_Im[bw_fftb-sft-2:bw_data-sft+1]};
	assign wOutB_Re = {{2{wResultB_Re[bw_fftb-1]}},wResultB_Re[bw_fftb-sft-2:bw_data-sft+1]};
	assign wOutB_Im = {{2{wResultB_Im[bw_fftb-1]}},wResultB_Im[bw_fftb-sft-2:bw_data-sft+1]};
	
	
	assign Out_Re = (rCEFFTB)? wOutB_Re : wOutA_Re ;
	assign Out_Im = (rCEFFTB)? wOutB_Im : wOutA_Im ;
	
	
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			End				<= 1'b0;
			Busy			<= 1'b0;
			WE				<= 1'b0;
			rEnd			<= 1'b0;
			rStart			<= 1'b0;
			rFFTCDataA_Re	<= 1'b0;
			rFFTCDataA_Im	<= 1'b0;
			rCEFFTB			<= 1'b0;
		end else begin
			if(Start)
				Busy <= 1'b1;
			else if (rEnd[bw_rend-1])
				Busy <= 1'b0;
				
			
			rStart	<= {rStart[bw_rstart-2:0],Start};
			rEnd	<= {rEnd[bw_rend-2:0],wIndexerEnd};
			End		<= rEnd[bw_rend-1];
			
			if(rStart[7+ram_delay])
				WE	<= 1'b1;
			else if(rEnd[bw_rend-1])
				WE	<= 1'b0;
				
			if(rStart[3-ram_delay] || !Busy)
				rCEFFTB <= 1'b0;
			else if(Busy)
				rCEFFTB <= ~rCEFFTB;
			
			rFFTCDataA_Re	<= In_Re;
			rFFTCDataA_Im	<= In_Im;
		end
	end

endmodule 