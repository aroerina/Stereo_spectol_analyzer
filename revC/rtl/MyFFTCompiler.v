//
/* Portlist
MyFFTCompiler #(.bw_fftp(),.bw_data()) myfftc
	(.Clock(),.Reset(),.Start(),.CEInput(),
	.ReadAddr(),.InData(),.InputValid(),.InputEnd(),
	.FFTEnd(),.ReadAddrValid(),.ReadQValid(),.Q_Re(),.Q_Im());
*/

/*	memo
	n=2048で矩形波を入れると出力20000程度
	n=4096で28000程度
*/
`define N4096

`ifdef N4096
`define NAME_FFTC_DPRAM RAM_DP_18b4096d
`endif

`ifdef N64 
`define NAME_FFTC_DPRAM DPRAM_18b64d
`endif

`ifdef N2048
`define NAME_FFTC_DPRAM DPRAM_18b2048d
`endif

`ifdef N16B9
`define NAME_FFTC_DPRAM DPRAM9b16d
`endif


module MyFFTCompiler
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_fftp	= 12,
	parameter bw_stage	= 4
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,Start,CEInput,
	input signed [15:0] InData,
	input [bw_fftp-1:0] ReadAddr,
	output InputValid,InputEnd,FFTEnd,
	output reg ReadAddrValid,
	output signed [17:0] Q_Re,Q_Im	//Address - Q 遅延：3クロック
);
	localparam bw_indata = 16;
	localparam bw_data	= 18;

	////////////////////////////////////////////////////
	// Registers
	reg [bw_fftp-1:0] rWrRAMAddr,rRdRAMAddr;
	reg signed [bw_data-1:0] rData_Re,rData_Im;
	reg rMUXSW,rHWWE,rWE;
	reg rFFTCStart;

	////////////////////////////////////////////////////
	// Net
	wire [bw_data-1:0] wOutDataHW;
	wire [bw_fftp-1:0] wWrRAMAddrHW,wWrAddrFFTCore,wRdAddrFFTCore;
	wire [bw_data-1:0] wFFTCIn_Re,wFFTCIn_Im,wFFTCOut_Re,wFFTCOut_Im,wQ_Im,wQ_Re;
	assign wFFTCIn_Re = wQ_Re;
	assign wFFTCIn_Im = wQ_Im;
	assign Q_Re = wQ_Re;
	assign Q_Im = wQ_Im;
	assign FFTEnd	= wFFTCEnd;
	
	////////////////////////////////////////////////////
	// Instantiations
	wire wClockEnHW 	= CEInput;
 	HannWindowROM #(
		.b_fftp(bw_fftp),
		.b_outdata(bw_data),
		.b_indata(bw_indata)
	) 
	hw(
		.Clock(Clock),
		.ClockEn(CEInput),
		.Reset(Reset),
		.Start(Start),
		.InData(InData),
		.OutData(wOutDataHW),
		.WrRAMAddr(wWrRAMAddrHW),
		.InputValid(InputValid),
		.OutValid(wHWOutValid),
		.End(InputEnd)
	); 
	
	//Dual Port RAM 
	//Output Delay: 2
	`NAME_FFTC_DPRAM  ram_re (
//	DPRAM9b16d_SQW ram_sqw_real(
		.WrAddress(rWrRAMAddr), 
		.RdAddress(rRdRAMAddr), 
		.Data( rData_Re), 
		.WE( rWE), 
		.RdClock(Clock), 
		.RdClockEn(1'b1), 
		.Reset(Reset), 
		.WrClock(Clock), 
		.WrClockEn(1'b1), 
		.Q(wQ_Re)
	);
	
	`NAME_FFTC_DPRAM ram_im (
		.WrAddress(rWrRAMAddr), 
		.RdAddress(rRdRAMAddr), 
		.Data( rData_Im), 
		.WE( rWE), 
		.RdClock(Clock), 
		.RdClockEn(1'b1), 
		.Reset(Reset), 
		.WrClock(Clock), 
		.WrClockEn(1'b1), 
		.Q(wQ_Im)
	);
	
	wire wWE = wFFTCoreWE|rHWWE;
	FFTCore #(.bw_fftp(bw_fftp),.bw_data(bw_data),.bw_stage(bw_stage)) 
		fcore(
		.Clock(Clock),
		.Reset(Reset),
		.Start(rFFTCStart),
		.In_Re(wFFTCIn_Re),
		.In_Im(wFFTCIn_Im),
		.WrRAMAddr(wWrAddrFFTCore),
		.RdRAMAddr(wRdAddrFFTCore),
		.Out_Re(wFFTCOut_Re),
		.Out_Im(wFFTCOut_Im),
		.WE(wFFTCoreWE),
		.End(wFFTCEnd)
	);
	wire [bw_fftp-1:0] wBRAddr;
	BitReverse #(.bw_fftp(bw_fftp)) br
	(.In(ReadAddr),.Out(wBRAddr));

	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{
				rHWWE,rFFTCStart,
				ReadAddrValid,rMUXSW,rWrRAMAddr,
				rRdRAMAddr,rData_Re,rData_Im
			}
				<= 1'b0;
		end else begin
			if(Start)
				rHWWE	<= 1'b1;
			else if(InputEnd)
				rHWWE	<= 1'b0;
			
			if(rFFTCStart)
				rMUXSW	<= 1'b1;
			else if(wFFTCEnd)
				rMUXSW	<= 1'b0;
				
			rFFTCStart	<= InputEnd;
				
			rWE			<= wFFTCoreWE|rHWWE;
			
			rWrRAMAddr	<= (rMUXSW)? wWrAddrFFTCore	: wWrRAMAddrHW ;
			rRdRAMAddr	<= (rMUXSW)? wRdAddrFFTCore	: wBRAddr ;
			
			rData_Re	<= (rMUXSW)? wFFTCOut_Re	: wOutDataHW;
			rData_Im	<= (rMUXSW)? wFFTCOut_Im	: 18'b0 ;
			
			if(Start)
				ReadAddrValid	<= 1'b0;
			else if(wFFTCEnd)
				ReadAddrValid	<= 1'b1;
		end
	end

endmodule 