//Startパルスを受けて波形データ読み出す
/* Portlist
FFTSeq_Loader #(.bw_dpram()) loader
	(Clock(Clock),.Reset(Reset),.Start(),.RAM_Q(),. ibend() ,
	.rfib(),.OutReadAddr(),.ibstart() );
*/
/* memo
FFT順序
VRAMCtrlからStartパルスを受け取る⇒Lch⇒Rch
*/

module FFTSeq_Loader
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_dpram =	12,
	parameter bw_data = 	16
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,Start,rfib,ibend,
	input [bw_data-1:0]	RAM_Q,
	output [bw_dpram-1:0] OutReadAddr,
	output [bw_data-1:0] dire,
	output reg ibstart
);
	localparam bw_counter = bw_dpram-1;
	////////////////////////////////////////////////////
	// Registers
	reg rSeqEn,rLRSW,rStat_Waiting_rfib_HI;
	reg [1:0]rPreibs;
	reg [bw_counter-1:0] rCount;
		
	////////////////////////////////////////////////////
	// Net
	wire [bw_dpram-1:0] wCount = rCount + 1;		//Counter キャリ先読み用+1bit
	assign OutReadAddr = {rLRSW,rCount[bw_counter-1:0]};
	wire wStart = Start | (rfib & rStat_Waiting_rfib_HI);	//RAMアドレス加算開始
	
	////////////////////////////////////////////////////
	// Instantiations

	always@(posedge Clock or posedge Reset) begin
		if ( Reset ) begin
			rStat_Waiting_rfib_HI <= 0;
			rLRSW		<= 1'b0;
			rSeqEn		<= 1'b0;
			rCount		<= 0;
			ibstart		<= 0;
			rPreibs		<= 0;
		end else begin
		
			rPreibs[1]	<= wStart; //遅延させる
			rPreibs[0]	<= rPreibs[1];
			ibstart 	<= rPreibs[0];
				
			if ( wStart ) begin
				rLRSW		<= ~rLRSW;
				rCount		<= 0;
			end else
			if ( !wCount[bw_dpram-1] ) begin	//キャリ先読み
				rCount		<= wCount[bw_counter-1:0];
			end
			
			if(ibstart) begin
				if (!rSeqEn) 
					rSeqEn	<= 1'b1;
				else
					rSeqEn	<= 1'b0;
			end
			
			if (rSeqEn ) begin
				if (ibend)
					rStat_Waiting_rfib_HI	<= 1'b1;
				else if ( rfib )
					rStat_Waiting_rfib_HI	<= 1'b0;
			end
			
		end
	end

endmodule 