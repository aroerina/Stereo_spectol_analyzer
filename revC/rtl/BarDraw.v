//
/* Portlist
BarDraw bardraw (
		.Clock(Clock),					// i
		.Reset(Reset),					// i

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

module BarDraw
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,LRChange,
	
	input [1:0] ActiveScreen,
	
	// For FFTSequenser
	input Start,
	input DrawTop,
	input [14:0]	BarColor,TopColor,BGColor,
	input [6:0] Bar,			//描画するバーの高さ 0~96
	input [6:0] Top,			//トップの位置 0~96
	output reg 	End,Busy,
	
	// For SRAMCtrl
	input AddrValid,
	output ReqBurstWrite,
	output reg [8:0] X,				//描画するバーの位置
	output [17:0] WrAddress,
	output [15:0] WrData
);
	////////////////////////////////////////////////////
	// Registers
	reg [14:0] rColor;
	reg rChannel;
	reg [6:0] rBarTop,rY,rY2;
	reg [8:0] rX;
	////////////////////////////////////////////////////
	// Net

	assign ReqBurstWrite	= Busy;
	assign WrData			= rColor;	//MSB  R54321,G54321,B54321  LSB
	assign WrAddress		= {ActiveScreen,rY2,rX};
	
	
	wire wY_EqualBarBottom	= (rY == 7'd96) && AddrValid;
	
	wire [8:0] wX;
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			rChannel 	<= 1'b1;
			X	<= 1'b0;
		end else begin
			if(LRChange)
				rChannel		<= ~rChannel;
			
			if(LRChange) begin
				if(rChannel)
					X	<= 9'd0;
				else
					X	<= 9'd399;
			end else if(Start) begin
				X	<= wX;
			end
				
		end
	end
	// Increment and Decrementer
	IncDec #(.width(9)) incdec(.DecEn(rChannel),.A(X),.S(wX));
	
	reg [6:0] rTopPos;
	wire wDrawTopPos		= (rTopPos == rY);
	wire wDrawBar			= (rBarTop <= rY);
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			{
				End,Busy,rBarTop,
				rColor,rY,rY2,rX,rTopPos
			}
				<= 1'b0;
		end else begin
		
			if(Start)
				rX	<= X;
			
			if(Start)
				Busy 	<= 1'b1;
			else if(wY_EqualBarBottom)
				Busy	<= 1'b0;
				
			if(Start)
				rTopPos	<= 7'd96 - Top;
			
			if(End)
				rBarTop	<= 7'd0;
			if(Start)
				rBarTop <= 7'd96 - Bar;
			
			if(End) begin
				rY		<= 7'b0;
				rY2		<= 7'b0;
			end else if(Busy && AddrValid) begin
				rY		<= rY + 1'b1;
				rY2		<= rY;
			end
	
			if(AddrValid) begin
				if(DrawTop && wDrawTopPos)
					rColor	<= TopColor;
				else if(wDrawBar)
					rColor	<= BarColor;
				else
					rColor	<= BGColor;
			end
			
			if(End)
				End		<= 1'b0;
			else if(wY_EqualBarBottom)
				End		<= 1'b1;
		end
	end
endmodule 