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

module Spectolizer
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
		.DPRAMAddr(DPRAMAddr),
		.ibstart(ibstart),
		.ibend(ibend),
		.rfib(rfib)
	);

	
	//シーケンサ
	FFTSequenser #(.bw_fftp(bw_fftp))		seq
	(
		.Clock(Clock),
		.Reset(Reset),
		.obstart(obstart),
		.outvalid(outvalid), 
		.Busy_SW(Busy_SW),
		.Busy_SL(Busy_SL),
		.CGate(Gate),
		.Start_SL(Start_SL),
		.Start_SW(Start_SW)
	);
	
	//Clock Gate
	ClockGate cgate
	(
		.InClock(Clock),
		.Gate(Gate),
		.OutClock(GatedClock)
	);

	wire [bw_data-1:0] dire = RAM_Q;
	//FFTComiler
	`ifdef N64
	FFTC64	fftc
	(
		.clk(GatedClock),			// system clock
		.rstn(~Reset),				// system reset
		.ibstart(ibstart),			// input block start indicator
		.dire(dire),				// real part of input data
		.diim(0),					// imaginary part of input data

		.except(except),			// exception signal
		.rfib(rfib),				// ready for input block
		.ibend(ibend),				// input block end
		.obstart(obstart),			// output block start
		.outvalid(outvalid),		// output outvalid
		.dore(dore),				// real part of output data
		.doim(doim)					// imaginary part of output data
	);
	`else
	FFTC2048_16	fftc
	(
		.clk(GatedClock),			// system clock
		.rstn(~Reset),				// system reset
		.ibstart(ibstart),			// input block start indicator
		.dire(dire),			// real part of input data
		.diim(0),					// imaginary part of input data
	
		.except(except),			// exception signal
		.rfib(rfib),				// ready for input block
		.ibend(ibend),				// input block end
		.obstart(obstart),			// output block start
		.outvalid(outvalid),		// output outvalid
		.dore(dore),				// real part of output data
		.doim(doim)					// imaginary part of output data
	);
	`endif

	wire [bw_fftdata-1:0] dore,doim;
	
	//スペクトル化
	FFTSpectolizer #(
		.bw_data(bw_fftdata))
	fft_spec (
		.Clock(Clock),
		.Reset(Reset),
		.Start(Start_SL),
		.Re(dore),
		.Im(doim),
		.Spectol(Spectol),
		.Busy(Busy_SL)
	);
	wire [6:0] Spectol;
	
	//スペクトル描画
	wire LRChange = obstart;
	FFT_SpectolWriter sw
	(
		.Clock(Clock),
		.ClockEn(SWClockEn),
		.Reset(Reset),
		.End(End_SW),
		.Busy(Busy_SW),
		.Start(Start_SW),
		.LRChange(LRChange),		//LRChange = obstart
		.Bar(Spectol),
		.Screen(Screen),
		.X(X),
		.Y(Y),
		.Color(Color)
	);


endmodule 