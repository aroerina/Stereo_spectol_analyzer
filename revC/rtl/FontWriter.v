//
//		
//	
/* Portlist
FontWriter fw(
		.Clock(Clock),					//i
		.Reset(Reset),					//i
		.Start(Start),
		.AddrValid(AddrValid),			//i
		.SetInitPos(SetInitPos),		//i
		.ActiveScreen(ActiveScreen),	//i:2
		.CharNumber(CharNumber),		//i:6
		.CharColor(CharColor),			//i:15
		.Busy(Busy),					//o
		.End(End),						//o
		.ReqBurstWrite(ReqBurstWrite),	//o
		.WrAddress(WrAddress),			//o:18
		.WrData(WrData)					//o:16
	);
*/

module FontWriter
(
	input Clock,Reset,AddrValid,Start,SetInitPosX,
	input [1:0] ActiveScreen,
	input [5:0] CharNumber,
	input CharColor,
	input InitScr,
	input [8:0] InitPosX,
	input [6:0] InitPosY,
	output Busy,
	output reg End,
	output ReqBurstWrite,
	output [17:0] WrAddress,
	output [15:0] WrData
);

	localparam rom_char_width = 5;
	localparam rom_char_height = 7;
	localparam char_width = 7;
	localparam char_height = 9;
	
	wire [rom_char_height-1:0] wQ;
	
	localparam bw_romaddr = 9;
	pmi_distributed_rom #(
		.pmi_addr_depth(301),
		.pmi_addr_width(bw_romaddr),
		.pmi_data_width(rom_char_height),
		.pmi_regmode("reg"),
		.pmi_init_file("Font_301d7b.mem"),	//CharNum = 39
		.pmi_init_file_format("hex"),
		.pmi_family("XP2"),
		.module_type("pmi_distributed_rom")
	) font_rom  (
		.Address(rROMAddr),
		.OutClock(Clock),
		.OutClockEn(1'b1),
		.Reset(Reset),
		.Q(wQ)
   );
	
	reg rNextLine;
	
	reg [1:0] rStart;
   	reg rColor,rCharColor;
	assign WrData = {1'b0,{15{rColor}}};
	
	reg [3:0] rRowCounter,rColumnCounter;
	reg [8:0] rX;
	reg [6:0] rY;
	assign WrAddress = {ActiveScreen[1],InitScr,rY,rX};
	
	reg [bw_romaddr-1:0] rROMAddr;
	reg [char_height-1:0] rLineSR;
	wire wLineTop	= rLineSR[char_height-1];
	
	localparam bw_seqen  = 4;
	reg [bw_seqen-1:0] rSeqEn;
	wire [bw_seqen-1:0] wSeqEn;
	assign wSeqEn = rSeqEn & {bw_seqen{AddrValid}};
	
	wire wNextLine	= rRowCounter==(char_height-2);
	wire wEnd		= rColumnCounter == char_width;
	assign Busy = rSeqEn[0];
	assign ReqBurstWrite = rSeqEn[0];
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{rCharColor,rColor,rRowCounter,rX,rY,rStart,rLineSR,rSeqEn
			,rROMAddr,End,rColumnCounter,rCharColor,End,rNextLine}
				<= 1'b0;
		end else begin
		
			rStart[0]	<= Start;
			rStart[1]	<= rStart[0];
			
			if(wEnd)
				rSeqEn		<= 1'b0;
			else if(Start)
				rSeqEn[0]	<= 1'b1;
			else if(AddrValid)
				rSeqEn[3:1]	<= rSeqEn[2:0];
				
			if(AddrValid)
				rNextLine <= wNextLine;
				
			if(Start)
				rROMAddr <= char_width*CharNumber;	//アドレス変換
			else if(AddrValid&wNextLine||rStart[0])
				rROMAddr <=	rROMAddr + 1'b1;		

				
			if(rStart[1] || (wNextLine && AddrValid))
				rLineSR	<= {1'b0,wQ,1'b0};
			else if(wSeqEn[2])
				rLineSR	<= {rLineSR[char_height-2:0],1'b0};
			
			if(Start)
				rCharColor	<= CharColor;
				
			if(wSeqEn[0]) begin
				if(wLineTop)
					rColor	<= rCharColor;
				else
					rColor	<= ~rCharColor;
			end
					
			if(wEnd)
				rColumnCounter	<= 1'b0;
			else if(wNextLine & AddrValid)
				rColumnCounter	<= rColumnCounter+1'b1;
				
				
			if(Start || (rNextLine[0] && wSeqEn[0]))begin
				rRowCounter <= 1'b0;
				rY			<= InitPosY;
			end else if(wSeqEn[3]) begin
				rRowCounter <= rRowCounter + 1'b1;
				rY			<= rY + 1'b1;
			end
			
			if(Start)
				rX	<= rX - 1'b1;
			else if(SetInitPosX & ~Busy)
				rX	<= InitPosX;
			else if(AddrValid&&rNextLine[0])
				rX	<= rX + 1'b1;
				
			End	<= wEnd;
				
		end
	end

endmodule 