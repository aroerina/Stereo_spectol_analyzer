//SRAMCtrl
/*
Address - Q 間遅延 3

SRAM R/Wサイクル
FrameStartから
1~4:Read Pixel data
5:	Write Wave data
6~32: *Burst R/W
Normaly Burst Read mode
6の時ReqBurstReadがHighならWriteモード

 Portlist
	SRAMCtrl sramctrl(
		.Clock(Clock),			// i
		.Reset(Reset),			// i
		.FrameStart(),			// i
		.ReqBurstWrite(),		// i
		.RdAddrLCDCtrl(),		// i:18
		.RdAddrSpec(),		// i:18
		.WrAddrCacher(),		// i:18
		.WrAddrSpec(),			// i:18
		.AValidCacher(),		// o
		.AValidLCDCtrl(),		// o
		.AValidBurstRW(),			// o
		.DataCacher(),			// i:16
		.DataBWrite(),				// i:16
		.Q(),					// o:16
		//For SRAM
		.nWE(nWE),				// o
		.nOE(nOE),				// o
		.Address(SRAMAddr),		// o:18
		.IO(IO)					// io:16
	);
*/

module SRAMCtrl
(
	////////////////////////////////////////////////////
	// Ports
	
	//For inner modules
	input Clock,Reset,FrameStart,
	input ReqBurstWrite,	//Burst Write Request
	input [17:0] RdAddrLCDCtrl,RdAddrBRead,WrAddrCacher,WrAddrBWrite,
	output AValidBRead,AValidBWrite,
	output reg AValidLCDCtrl,		//Address Valid
	input [15:0] DataCacher,DataBWrite,		//Data
	output reg [15:0] Q,				//Q
	
	//For SRAM
	output reg	nWE,
	output 		nOE,
	output		[17:0]	Address,
	inout		[15:0] 	IO
);

	localparam bw_srseq	= 5;
	////////////////////////////////////////////////////
	// Registers
	reg rIOSW,rSeqBurstRW;
	reg [bw_srseq-1:0] rSRSeq;	//Shift reg
	reg [1:0] rMUXSel;
	reg [15:0] rData,rDataBWrite;
	reg [17:0] rWrAddrBWrite;

	////////////////////////////////////////////////////
	// Net
	assign IO	=	(rIOSW) ?	rData	:  16'hzzzz;
	assign nOE	= 1'b0;
	
	////////////////////////////////////////////////////
	// Instantiations
	
	//Address mux
	MUX4 #(.bw_in(18)) address_mux
	(.Clock(Clock),.Reset(Reset),
		.Select(rMUXSel),
		.IN0(RdAddrLCDCtrl),
		.IN1(WrAddrCacher),
		.IN2(rWrAddrBWrite),	//Burst Read
		.IN3(RdAddrBRead),	//Burst Write
		.OUT(Address)		// SRAM Address
	);
	
	reg rReqBurstWrite;
	
	localparam bw_avalid = 33;
	reg [bw_avalid-1:0] rAValidBurstRW;
	
	wire wAValidBurstRW		= rSeqBurstRW & ~FrameStart;
	wire wIOSW			= rSRSeq[4] | rAValidBurstRW[0] & rReqBurstWrite;
	wire wSeqLCDC		= |{FrameStart,rSRSeq[2:0]};
	
	assign AValidBWrite	= rAValidBurstRW[30];
	assign AValidBRead	= rAValidBurstRW[32];
	
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			{
				rIOSW,rSRSeq,rMUXSel,rWrAddrBWrite,
				rSeqBurstRW,rData,rDataBWrite,rReqBurstWrite,
				AValidLCDCtrl,rAValidBurstRW,
				Q,nWE
			}	<= 1'b0;
		end else begin
			// タイミング調節のため遅延
			rDataBWrite		<= DataBWrite;
			rWrAddrBWrite	<= WrAddrBWrite;
			rReqBurstWrite	<= ReqBurstWrite;
		
			rSRSeq	<= {rSRSeq[bw_srseq-2:0],FrameStart};
			AValidLCDCtrl	<= |{FrameStart,rSRSeq[2:0]};
			
			// rSeqBurstRW : バーストR/Wシーケンス区間の間はHI
			if(FrameStart)
				rSeqBurstRW		<= 1'b0;
			else if(rSRSeq[3])
				rSeqBurstRW		<= 1'b1;
				
			rAValidBurstRW 	<={rAValidBurstRW[bw_avalid-2:0],wAValidBurstRW};
			
			if(wSeqLCDC)
				rMUXSel	<= 2'h0;	// LCDCtrl
			else if (rSRSeq[3])
				rMUXSel <= 2'h1;	// Cacher
			else if (wAValidBurstRW & ReqBurstWrite)
				rMUXSel <= 2'h2;	// Burst Write
			else
				rMUXSel <= 2'h3;	// Burst Read
			
			nWE		<= ~wIOSW;
			Q		<= IO;
			rIOSW	<= wIOSW;
			
			// Data MUX
			rData	<= (rSRSeq[4]) ?	DataCacher	:	rDataBWrite ;
		end
	end
endmodule 