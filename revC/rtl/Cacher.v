/* 
左詰めフォーマットで入力
データを保存するSRAMアドレス
   Start       End
L: 18'h0C000 ~ 18'h0DFFF
R: 18'h1C000 ~ 18'h1DFFF

   16   12    8    4    0
L: 00 1110 0000 0000 0000 ~ 00 1111 1111 1111 1111
R: 01 1110 0000 0000 0000 ~ 01 1111 1111 1111 1111

Y:112

LRCK LがHI,RがLOW

Portlist
Cacher cacher	(	
		.Clock(Clock),
		.Reset(Reset),	
		.BCK(BCK),
		.LRCK(LRCK),
		.SData(SData),
		.LastWriteAddr(LastWriteAddr),	// o:bw_fftp+1
		.WrAddress(WrAddress),			// o:18
		.OutData(OutData)				// o:16
	);
*/

module Cacher 
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,
	input BCK,LRCK,SData,
	
	// For FFTLoader
	output [12:0] LastWriteAddr,	//最後に書き込んだアドレスを提供
	
	// For SRAM
	output [17:0] WrAddress,
	output reg [15:0] OutData
);
	reg [31:0] rSR;
	reg [12:0] rAddress;	//0 ~ 8191
	reg [1:0] rBCK,rSData;
	
	reg rLR;
	reg [1:0] rLRCK;
	wire wLRCKBIEdge	= ^rLRCK;			//両エッジ
	wire wLRCKPEdge		= rLRCK == 2'b01;	//立ち上がり
	wire wLRCKNEdge		= rLRCK == 2'b10;	//立下り
	
	assign WrAddress = {1'b0,rLR,3'b111,rAddress};
	assign LastWriteAddr	= rAddress;
	always@(posedge Clock or posedge Reset) begin	//LRClock
		if(Reset) begin
			{rSR,rBCK,rSData,rLRCK,rAddress,OutData,rLR} <= 1'b0;
		end else begin
			rLRCK	<= {rLRCK[0],LRCK};
			rBCK	<= {rBCK[0],BCK};
			rSData	<= {rSData[0],SData};
			
			if(wLRCKBIEdge) //両エッジ
				OutData	<= rSR[31:16];
				
			if(wLRCKNEdge) begin
				rAddress	<= rAddress+1;
			end
				
			if(wLRCKNEdge)
				rLR	<= 1'b0;
			else if(wLRCKPEdge)
				rLR	<= 1'b1;
			
			if(wLRCKBIEdge)
				rSR	<= 32'b0;
			else if(rBCK == 2'b01)
				rSR	<= {rSR[30:0],rSData[1]};
		end
	end
endmodule 