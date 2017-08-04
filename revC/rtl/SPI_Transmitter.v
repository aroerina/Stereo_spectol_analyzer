//
//	
//	
/* Portlist
SPI_Transmitter spi_trans(
		.Clock(Clock),
		.Reset(Reset),
		
		// For LM8
		.Send(Send),		// i	Start Send
		.Data(Data),		// i:15	Write Data
		.Busy(Busy)			// o
		
		.SClock(SClock),	// o	= Clock/64
		.MOSI(MOSI),		// o
		.nCS(nCS)			// o
	);
*/

module SPI_Transmitter
#(
	parameter bw_clock_divider = 5,
	parameter bw_data = 16
)
(
	input Clock,Reset,
	
	input Send,
	input [bw_data-1:0] Data,
	
	output	MOSI,		// For DI
	output	reg nCS,
	output	SClock,
	
	output reg Busy
);
	
	reg [bw_clock_divider-1:0] ClockGenCounter;	// メインクロックを６４分周してSClockにする
	assign	SClock	= ClockGenCounter[bw_clock_divider-1];
	//	同期化
	reg [1:0] rSClock;
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{rSClock,ClockGenCounter}
				<= 1'b0;
		end else begin
			ClockGenCounter	<= ClockGenCounter+1'b1;
		
			rSClock	<= {rSClock[0],SClock};
		end
	end
	
	wire wNegEdge	= rSClock == 2'b10;
	reg [bw_data-1:0] rOutSR;
	reg [4:0] rNEdgeCount;
	reg rEnd;
	assign MOSI	= rOutSR[bw_data-1];
	wire wCS = rNEdgeCount>=bw_data;
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{rOutSR,rNEdgeCount,Busy,rEnd}
				<= 1'b0;
				
			nCS	<= 1'b1;
		end else begin
		
			if(Send)
				rEnd	<= 1'b0;
			else if(wNegEdge)
				rEnd	<= wCS;
				
				
			if(Send)
				Busy	<= 1'b1;
			else if(rEnd)
				Busy	<= 1'b0;
						
			if(Send) begin
				rOutSR[bw_data-1:0] <= Data;
			end else if(wNegEdge && !nCS)
				rOutSR	<= {rOutSR[bw_data-2:0],1'b0};

			if(wNegEdge)begin
				if(wCS)
					nCS		<= 1'b1;
				else
					nCS		<= ~Busy;
			end
				
			if(Send)
				rNEdgeCount	<= 5'b0;
			else if(wNegEdge && Busy)
				rNEdgeCount	<= rNEdgeCount + 1'b1;
			
		end
	end
		
endmodule 