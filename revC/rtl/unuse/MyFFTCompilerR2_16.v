//
/* Portlist
_ #() _	
();
*/

module MyFFTCompilerR2
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_fftp	= 4,
	parameter bw_data	= 18
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,Start,
	input CEInput,	//ClockEnable
	input [bw_fftp-1:0] RAMReadAddr,
	input [bw_data-1:0] InData,
	output reg StatInput,StatFFT,StatRAMReadOK,
	output [bw_data-1:0] OutData
);
	localparam bw_stage = 2;
	localparam bw_theta = bw_fftp-1;
	////////////////////////////////////////////////////
	// Register(s)
	
	reg rClockEnHW,rWrAddrSW;
	reg [bw_data-1:0] rInData,rDataA_Re,rData_Im;

	////////////////////////////////////////////////////
	// Net
	wire [bw_theta-1:0] wTheta;
	wire [bw_fftp-1:0]	wIndex,wDIndex,wWrAddress,wWrRAMAddrHW;
	wire [bw_data-1:0]	wTwiddle_Re,wTwiddle_Im,
						wWrData_Re,wWrData_Im,wQ_Re,wQ_Im,
						wOutDataHW;
						
	wire [bw_data*2-1:0] wResultA_Re,wResultB_Re,wResultA_Im,wResultB_Im;
	
	assign wWrAddress = ?(wHWOutValid) wWrRAMAddrHW	: wDIndex ;
	assign wWrData_Re = ?(wHWOutValid) wOutDataHW	: rFFTBResult_Re;
	assign wWrData_Im = ?(wHWOutValid) 18'b0 		: rFFTBResult_Im;
	////////////////////////////////////////////////////
	// Instantiations
	
	//窓関数
	wire wClockEnHW 	= StatInput&CEInput;
	HannWindowROM hw
	(.Clock(Clock),.ClockEn(rClockEnHW),Reset(Reset),.Start(Start),
	.InData(rInData),.OutData(wOutDataHW),.WrRAMAddr(wWrRAMAddrHW)
	.InputValid(),.OutValid(wHWOutValid),.End());
	
	//Dual Port RAM 
	//Output Delay: 2
	DPRAM16d_36b dpram16 (
		.WrAddress(wWrAddress), 
		.RdAddress(wDIndex), 
		.Data({wWrData_Re,wWrData_Im}), 
		.WE(1'b1), 
		.RdClock(Clock), 
		.RdClockEn(ClockEn), 
		.Reset(Reset), 
		.WrClock(Clock), 
		.WrClockEn(ClockEn), 
		.Q({wQ_Re,wQ_Im})
	);
	
	//Indexer
	FFTIndexer_R2 #(.bw_idx(bw_fftp	),.bw_stage(bw_stage)) 
	indexer(.Clock(Clock),.Start(),.Busy(),.End(),.Reset(Reset),.Index(wIndex));
	
	//Indexを遅延するPipe Register
	PipeReg #(.b_width(bw_fftp),.depth(3)) preg
	(.Clock(Clock),.Reset(Reset),.ClockEn(ClockEn),.In(wIndex),.Out(wDIndex));
	
	//theta出力
	FFTTheta_R2 #(.bw_fftp(bw_fftp),.bw_stage(bw_stage)) theta
	(.Clock(Clock),.Start(),.Busy(),.End(),.Reset(Reset),.Theta(wTheta));
	
	//回転子出力	Delay:3
	Rdx2Twiddle #(.b_fftp(bw_fftp)) twiddle
	(.Clock(Clock),.ClockEn(ClockEn),.Reset(Reset),
	.Theta(wTheta),.Re(wTwiddle_Re),.Im(wTwiddle_Im));
	
	//FFT Buttefly	Delay:2
	FFTB_R2_DIT18 fftb (
		.Clock(Clock), .ClkEn(ClockEn), .Reset(Reset), 
		.Twiddle_Re(wTwiddle_Re), 
		.Twiddle_Im(wTwiddle_Im),
		.DataA_Re(rDataA_Re),
		.DataA_Im(rDataA_Im),
		.DataB_Re(wQ_Re), 
		.DataB_Im(wQ_Im}), 
		.ResultA_Re(wResultA_Re),
		.ResultA_Im(wResultA_Im), 
		.ResultB_Re(wResultB_Re), 
		.ResultB_Im(wResultB_Im)
	);
	
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			StatInput	<= 1'b0;
			rInData		<= 0;
			StatFFT		<= 0;
			rDataA_Re	<= 0;
			rDataA_Im	<= 0;
		end else begin
			rClockEnHW	<= wClockEnHW;
			
			if(Start)
				StatInput	<= 1'b1;
			else if (wPreX0)
				StatInput	<= 1'b0;
				
			if(CEInput)
				rInData		<= InData;
				
			if(wPreX0)
				StatFFT		<= 1'b1;
			
			rDataA_Re	<= wQ_Re;
			rDataA_Im	<= wQ_Im;
		end
	end

endmodule 