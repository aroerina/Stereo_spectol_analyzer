//
//	Tranceiver for AT93C46 Series
//	
/* Portlist
AT93C46_Tranceiver eeprom_tran(
		.Clock(Clock),
		.Reset(Reset),
		
		// For LM8
		.Send(Send),		// i	Start Send
		.Opcode(Opcode),	// i:2
		.Address(Address),	// i:6
		.Data(Data),		// i:15	Write Data
		.Q(Q),				// o:15
		.Busy(Busy)			// o
		
		// For AT93C46
		.SClock(SClock),	// o	= Clock/64
		.MOSI(MOSI),		// o
		.MISO(MISO)			// i
	);
*/

// define opcode
`define READ	2'b10
`define WRITE	2'b01
`define EWEN	2'b00

module AT93C46_Tranceiver
(
	input Clock,Reset,
	
	// For LatticeMico8
	input Send,
	input [1:0] Opcode,
	input [5:0] Address,
	input [15:0] Data,
	output reg [15:0] Q,
	
	// For AT93C46
	input	MISO,		// For DO !!PULLDOWN!!
	output	MOSI,		// For DI
	output	reg CS,
	output	SClock,
	
	output reg Busy
);
	
	reg [5:0] ClockGenCounter;	// メインクロックを６４分周してSClockにする
	assign	SClock	= ClockGenCounter[5];
	//	同期化
	reg [1:0] rSIN,rSClock;
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{rSIN,rSClock,ClockGenCounter}
				<= 1'b0;
		end else begin
			ClockGenCounter	<= ClockGenCounter+1'b1;
		
			rSIN	<= {rSIN[0],MISO};
			rSClock	<= {rSClock[0],SClock};
		end
	end
	
	wire wNegEdge	= rSClock == 2'b10;
	reg [25:0] rOutSR;
	reg [15:0] rInSR;
	reg [4:0] rNEdgeCount;
	reg [1:0] rOpcode;
	reg rNegEdge;
	assign MOSI	= rOutSR[25];
	wire wNEdgeCountEnd = (rNEdgeCount >= 5'd27);
	wire wEnd = (rNEdgeCount >= 5'd26);
	wire wSeqWrite = (rOpcode==`WRITE);	//WRITE Sequens
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{rOutSR,rNEdgeCount,rInSR,Q,Busy,CS,rNegEdge,rOpcode}
				<= 1'b0;
				
		end else begin
		
			if(Send)
				rOpcode	<= Opcode;
			
			if(Send) begin
				rOutSR[25:16]	<= {2'b01,Opcode,Address};
				rOutSR[15:0]	<= (Opcode==`WRITE)? Data : 15'b0;
			end else if(wNegEdge)
				rOutSR	<= {rOutSR[24:0],1'b0};
			
			if(Send)
				Busy	<= 1'b1;
			else if(wSeqWrite) begin
				if(wEnd&&rSIN[0])
					Busy	<= 1'b0;
			end else if(wEnd)
				Busy	<= 1'b0;
			
				
			if(wNegEdge)
				rInSR	<= {rInSR[14:0],rSIN[1]};
				
			if(wNegEdge)begin
				if(wSeqWrite&&(rNEdgeCount == 5'd25))
					CS		<= 1'b0;
				else
					CS		<= Busy;
			end
				
			rNegEdge 	<= wNegEdge;
			
			if(Busy & rNegEdge & wEnd)
				Q		<= rInSR;
				
			if(Send)
				rNEdgeCount	<= 5'b0;
			else if(Busy && wNegEdge && !wNEdgeCountEnd)
				rNEdgeCount	<= rNEdgeCount + 1'b1;
			
		end
	end
		
endmodule 