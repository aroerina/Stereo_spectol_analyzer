//
/* Portlist
FFTSpectolWriter sw (
		.Clock(Clock),					// i
		.Reset(Reset),					// i
		.ColorChange(ColorChange),		// i

		// For FFTLoader
		.ActiveScreen(ActiveScreen),	// i:2
		
		// For FlowControl
		.Start(StartSW),				// i
		.Bar(Bar),						// i:7
		.X(X),							// o:9
		.End(EndSW),					// o
		.Busy(BusySW),					// o
		
		// For SRAMCtrl
		.AddrValid(SWAddrValid),		// i
		.ReqBurstWrite(ReqBurstWrite),	// o
		.WrData(WrDataSW)				// o:16
		.WrAddress(WrAddressSW),		// o:18
	);
*/

module FFTSpectolWriter
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,LRChange,NewFrame,
	
	input [1:0] ActiveScreen,
	
	// For FFTSequenser
	input Start,
	input [6:0] Bar,
	input DrawTop,
	output End,
	output reg Busy,
	
	// For SRAMCtrl
	input AddrValid,
	output ReqBurstWrite,
	output [8:0] X,	
	output [17:0] WrAddress,
	output [15:0] WrData,
	
	// For FlowControler
	input [14:0] BarColor,
	input [14:0] TopColor,
	input [2:0]	FallSpeed,
	input GradationEn
);
	wire FallSpeedUp	= 1'b0;
	wire FallSpeedDown	= 1'b0;
	
	wire [14:0] OutBarColor;
	BarColor bc (
		.Clock(Clock),				//i
		.Reset(Reset),				//i
		.Start(Start),				//i
		.InColor(BarColor),			//i:15
		.Bar(Bar),					//i:7
		.GradationEn(GradationEn),	//i
		.OutColor(OutBarColor),	//o:15
		.Busy(),					//o
		.End(BCEnd)					//o
	);
	
	//wire FallSpeedDown = 1'b0;
	wire [6:0] Top;
	BarTop bt(
		.Clock(Clock),
		.Reset(Reset),
		.Start(Start),
		.NewFrame(NewFrame),
		.FallSpeed(FallSpeed),
		.Bar(Bar),
		.Top(Top)
	);
	
	reg [6:0] rBar;
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			rBar	<= 1'b0;
			Busy	<= 1'b0;
		end else begin
			if(Start)
				Busy	<= 1'b1;
			else if(BDEnd)
				Busy	<= 1'b0;
				
			//Start の時のバーの高さをを保持		
			if(Start) 
				rBar	<= Bar;			
		end
	end
	
	wire BDEnd,BDBusy;

	
	wire [14:0] BGColor		= 15'h0000;
	BarDraw bardraw (
		.Clock(Clock),					// i
		.Reset(Reset),					// i
		.BarColor(OutBarColor),
		.TopColor(TopColor),
		.BGColor(BGColor),
		.LRChange(LRChange),
		.DrawTop(DrawTop),
		// For FFTLoader
		.ActiveScreen(ActiveScreen),	// i:2
		
		// For FlowControl
		.Start(BCEnd),					// i
		.Bar(rBar),						// i:7
		.X(X),							// o:9
		.End(BDEnd),					// o
		.Busy(BDBusy),					// o
		.Top(Top),
		
		// For SRAMCtrl
		.AddrValid(AddrValid),			// i
		.ReqBurstWrite(ReqBurstWrite),	// o
		.WrData(WrData),					// o:16
		.WrAddress(WrAddress)			// o:18
	);
	assign End = BDEnd;
	

endmodule 