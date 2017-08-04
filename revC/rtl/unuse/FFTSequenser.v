// opcode
// 3210
//
// 0001(1):要素スキップ			SKIP
// 0010(2):スペクトル化			SPEC
// 0100(4):前のスペクトルをコピー	COPY
// 1000(8):シーケンスEnd			END
/*	memo
パターン
	Busy	SL	SW	動作
OPC
SL			L	L	パルスを入れてNextOp
SL			H	L	SLBusyがLowになればパルス入れる
SL 			L	H	パルス入れる
SL			H	H

SW			L	L
SW			H	L
SW			L	H
SW			H	H

SWに入れるパルスは`SPECのパルスと`COPYのパルスがあるので区別する

*/
`define SKIP	Opcode[0]
`define SPEC	Opcode[1]
`define	COPY	Opcode[2]
`define END		Opcode[3]

/* Portlist
FFTSequenser #(.bw_fftp()) fseq
	(
	.Clock(),
	.Reset(),
	.obstart(),
	.outvalid(),
	.Busy_SW(),
	.Busy_SL(),
	.CGate(),
	.Start_SL(),
	.Start_SW()
	);
*/

module FFTSequenser
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter	bw_fftp = 6
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,obstart,outvalid,Busy_SW,Busy_SL,
	output reg CGate,Start_SL,Start_SW
);

	wire [3:0] Opcode;
	////////////////////////////////////////////////////
	// Registers
	reg rSLSeq;			//`SPECシーケンス終了時までHI
	reg [1:0] rBlank;	//OPCAddress加算後の2Cycleブランク期間を作る
	reg [bw_fftp-1:0] OPCROMAddr;
	reg rWait_obstart;
	
	////////////////////////////////////////////////////
	// Net
	wire wSeqEn		= outvalid & (&(~rBlank));	//レジスタ転送待ち。これがHの時だけStartパルスを出す
	
	//Spectolizer Startパルス出力条件
	wire wStart_SL	= `SPEC & ~Busy_SL & wSeqEn & ~rSLSeq;
	
	//Spectol Writer Startパルス出力条件
	wire wStart_SW	= ( `COPY | rSLSeq ) & ~Busy_SW & ~Busy_SL & ~Start_SW & ~Start_SL ;
	
	//次のOpcodeを読み込む条件
	wire wNextOpc	= `SKIP & wSeqEn | wStart_SL | wStart_SW & ~rSLSeq ;
	
	//FFTC Clock 遮断条件 :Highで遮断	~( Clockスルー条件) | クロック遮断条件
	wire wCGate		= ~( wStart_SL | `SKIP & wSeqEn  | rWait_obstart ) | obstart;
	
	/////////////////////////////////////////////////////
	// Instantiations
	
	//OPCODE ROM
	//出力レジスタ付き
	`ifdef N64
	ROM_OPCODE_64_15
	`else
	ROM_OPCODE_DIST_2048
	`endif
	rom_opc (.Address(OPCROMAddr), .OutClock(Clock), .OutClockEn(1'b1), 
    .Reset(Reset), .Q(Opcode));
	
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin	//Reset
			{CGate,Start_SL,Start_SW,rSLSeq}	<= 4'b0;
			OPCROMAddr			<= 0;
			rBlank				<= 2'b0;
			rWait_obstart		<= 1'b0;
		end else begin	//Clock
		
			if(outvalid) begin
				CGate	<= wCGate;
			end
			
			rBlank[1]	<= wNextOpc | obstart;
			rBlank[0]	<= rBlank [1];
			
			Start_SL	<= wStart_SL;
			Start_SW	<= wStart_SW;
			
			// `SPEC の時アサート
			if(wStart_SL) begin
				rSLSeq	<=	1'b1;
			end else if ( wStart_SW && rSLSeq ) begin
				rSLSeq	<=	1'b0;
			end
			
			
			//オペコードROMアドレス加算条件
			
			if ( obstart )
				rWait_obstart <= 1'b0;
			else if ( `END && wSeqEn)
				rWait_obstart <= 1'b1;
				
			
			if ( obstart )//ROM アドレスリセット
				OPCROMAddr		<= 0;
			else if ( wNextOpc )
				OPCROMAddr		<= OPCROMAddr + 1;				
			
		end
	end
endmodule 