//
/* Portlist
HannWindowROM hw
	(.Clock(),.ClockEn(),.Start(),.Reset(),
	.InData(),.InputValid(),.OutData(),
	.OutValid(),.WrRAMAddr(),.End());
*/

//差分波形ROM moduleの名前

`define NAME_HW_DISTROM DISTROM_DIFFNCOS7b1024d_for_FFT4096P
`define BW_ROM_Q 		7

`ifdef N2048
`define NAME_HW_DISTROM DISTROM_DIFFNCOS8b512d_for_16b2048d
`define BW_ROM_Q 		8	
`endif

`ifdef N64
`define NAME_HW_DISTROM DISTROM_DIFFNCOS17b16d_for_FFT64P
`define BW_ROM_Q 		17
`endif

//出力ビット幅 :b_indata-2

module HannWindowROM
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter b_indata	= 16,
	parameter b_outdata = 18,
	parameter b_fftp	= 12
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,ClockEn,Reset,Start,
	input signed [b_indata-1:0] InData,
	output signed [b_outdata-1:0] OutData,
	output reg InputValid,
	output reg Busy,OutValid,
	output reg End,					//要素の０番目の１クロック前にHI
	output [b_fftp-1:0] WrRAMAddr
);

	localparam b_acm	= 18;	//data + 1bit
	localparam b_raddr	= b_fftp-2;		//ROM address bit width
	localparam b_romout = `BW_ROM_Q;		//ROM output bit width
	
	////////////////////////////////////////////////////
	// Registers
	reg [b_fftp-1:0] rX;				//MSBが１でシーケンス終了
	reg [1:0] rEnd;
	reg rJoint,rDownEn,rSeqStop;
	reg [1:0] rSubEn;
	reg [2:0] rStart;
	////////////////////////////////////////////////////
	// Net
	wire [1:0] wArea = rX[b_fftp-1:b_fftp-2];	//波形の区間
	wire [b_raddr-1:0] wROMAddr;
	wire [b_fftp:0] wCount = rX + 1'b1;
	wire wEnd	= wCount[b_fftp];
	wire wClockEn	= ClockEn & Busy;
	////////////////////////////////////////////////////
	// Instantiations

	// ROM Address Counter
	wire wDownEn	= rX[b_fftp-2] && !(wCount[b_raddr]^rX[b_raddr]);		//波形の1/4ごとに切り替え
	wire wJoint 	= wCount[b_raddr]^rX[b_raddr];
	wire wUDClockEn = wClockEn & (!rJoint) & !rStart[0];
	UDCounter #(.width(b_raddr)) udcounter(
		.Clock(Clock),
		.CountEn(wUDClockEn),
		.Reset(Reset),
		.SClear(End),
		//.SClear(1'b0),
		.DownEn(rDownEn),
		.Count(wROMAddr)
	);
	
	//Negative Cosine n-n+1 Difference ROM
	`NAME_HW_DISTROM rom_diffncos(
		.Address(wROMAddr),
		.OutClock(Clock),
		.OutClockEn(wClockEn), 
		.Reset(Reset),
		.Q(wDiff)
	);

	wire [b_romout-1:0] wDiff;
	wire [17:0] wAcm;
	localparam bw_span = 18-b_romout;
	AddSub #(.width(b_acm))
		as(.Clock(Clock),.ClockEn(wClockEn&(~rStart[1])),.Reset(Reset),
		.SubEn(rSubEn[1]),.A(wAcm),.B({{bw_span{1'b0}},wDiff}),.S(wAcm));
	
	//乗算機
	//A:Signed 16bit	B:Unsigned 18bit	S:Signed 34bit
	//Output Register
	localparam b_mult = b_indata+b_outdata;
	
	wire [b_mult-1:0] wMULTP;
	localparam sft = 1;
	assign OutData	= {wMULTP[b_mult-1],wMULTP[b_mult-(2+sft):b_mult-(b_outdata+sft)]};	//算術左シフト
	
	//in-out delay 1
	MULT_S16b_US18b mult_han (
		.CLK0(Clock),
		.RST0(Reset), 
		.A(InData),
		.B(wAcm),
		.P(wMULTP),
		.CE0(wClockEn)
	);
	
	//ClockEnabe Delay
	reg rDelayCE;
	always@(posedge Clock,posedge Reset) begin
		if(Reset)begin
			rDelayCE <= 3'b0;
		end else begin
			rDelayCE <= |{wEnd,rEnd[1:0]};
		end
	end
	//rXを遅延する
	PipeReg #(.b_width(b_fftp),.depth(3)) preghw
	(.Clock(Clock),.Reset(Reset),.ClockEn(|{ClockEn,wEnd,rDelayCE}),.In(rX),.Out(WrRAMAddr));
	
	
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			{rJoint,rEnd,Busy,rDownEn,rSeqStop}	<= 1'b0;
			{rSubEn,End,OutValid,InputValid}	<= 1'b0;
			rStart 	<= 1'b0;
			rX		<= 1'b0;
		end else begin
			rStart	<= {rStart[1:0],Start};
			rEnd	<= {rEnd[0],wEnd};
			End		<= rEnd[1];
			
			if(ClockEn) begin
				rSubEn	<= {rSubEn[0],rX[b_fftp-1]};//波形の1/2で切り替え
				rJoint	<= wJoint;
			end
			
			if(End)
				rDownEn	<= 1'b0;
			if(ClockEn)
				rDownEn	<= wDownEn;
				
			if(Start)
				Busy	<= 1'b1;
			else if(rEnd[1])
				Busy	<= 1'b0;
				
			if(Start)
				OutValid	<= 1'b0;
			else if(rStart[2])
				OutValid	<= 1'b1;
				
			if(wEnd)
				rSeqStop	<= 1'b1;
			else if(Start)
				rSeqStop	<= 1'b0;
				
			if(rStart[1])
				InputValid	<= 1'b1;
			else if(rEnd[1])
				InputValid	<= 1'b0;
				
			if(wEnd)
				rX	<= 0;
			else if(wClockEn&&!rSeqStop)
				rX	<= wCount;	//Carryを拾う
				
		end
	end

endmodule 