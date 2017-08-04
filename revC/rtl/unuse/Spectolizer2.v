//スペクトル化
/* Portlist
Spectolizer #(.bw_fftp())
	top_sl
	(
	.Clock(Clock),			//i
	.Reset(Reset),			//i
	
	//For Cacher
	.DataR(DataR),			//i
	.DataL(DataL),			//i
	.DPRAMAddr(DPRAMAddr),	//o
	
	//For VRAMControl
	.SWClockEn(SWClockEn),
	.StartLoader(StartLoader),
	.Color(Color),
	.Screen(Screen),
	.X(X),
	.Y(Y)
	);
*/

module Spectolizer2
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_fftp = 11,
	parameter bw_dpram = 12,
	parameter bw_fftdata = 16,
	parameter bw_data = 16
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,
	
	//For Cacher
	input [bw_data-1:0] RAM_Q,
	output [bw_dpram-1:0] DPRAMAddr,
	
	//For VRAMControl
	input			SWClockEn,
	input			StartLoader,
	output [14:0]	Color,
	output 			Screen,
	output [8:0] 	X,
	output [6:0]	Y

);
	
	////////////////////////////////////////////////////
	// Instantiations

	//波形読み込み
	FFTSeq_Loader #(
		.bw_dpram(bw_dpram),
		.bw_data(bw_data)) loader
	(
		.Clock(Clock),
		.Reset(Reset),
		.Start(StartLoader),
		.OutRAMAddr(DPRAMAddr),
		.ibstart(InputValid),
		.ibend(InputEnd),
		.rfib(rfib)
	);

	wire [bw_data-1:0] dire = RAM_Q;
	
	//FFTComiler
	MyFFTCompilerR2 #(
		.bw_fftp(bw_fftp),
		.bw_data(bw_data))
	myfftc
	(
		.Clock(Clock),
		.Reset(Reset),
		.Start(ibstart),
		.CEInput(1'b1),
		.InData(RAM_Q),
		.InputValid(InputValid),
		.InputEnd(InputEnd),
		.ReadAddr(),
		.FFTEnd(FFTEnd),
		.ReadOK(),
		.ReadQValid(),
		.Q_Re(Q_Re),
		.Q_Im(Q_Im)
	);


	wire [bw_fftdata-1:0] dore,doim;
	
	//スペクトル化
	FFTSpectolizer #(
		.bw_data(bw_fftdata))
	fft_spec (
		.Clock(Clock),
		.Reset(Reset),
		.Start(Start_SL),
		.Re(Q_Re),
		.Im(Q_Im),
		.Spectol(Spectol),
		.Busy(Busy_SL),
		.End(End_SL)
	);
	wire [6:0] Spectol;
	
	//スペクトル描画
	wire LRChange = FFTEnd;
	FFT_SpectolWriter sw
	(
		.Clock(Clock),
		.ClockEn(SWClockEn),
		.Reset(Reset),
		.Start(Start_SW),
		.LRChange(LRChange),		//LRChange = obstart
		.Bar(Spectol),
		//Output Port
		.End(End_SW),
		.Busy(Busy_SW),
		//For VRAMCtrl
		.Screen(Screen),
		.X(X),
		.Y(Y),
		.Color(Color)
	);


endmodule 