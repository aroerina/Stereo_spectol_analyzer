//FFT Radix2 DIT 用Index生成module
//A-B交互にIndexを出力
/*
FFTIndexer_R2 #(.bw_fftp(bw_fftp),.bw_stage(bw_stage)) 
	indexer(.Clock(Clock),Reset(Reset),.Index(),Start(),.Busy(),.End());
*/
module FFTIndexer_R2 #(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_fftp = 4,		//Bit width of output index
	parameter bw_stage = 2		//bw_fftpが収まるビット幅
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,Start,
	output [bw_stage-1:0] Stage,
	output reg [bw_fftp-1:0] Index,
	output reg Busy,End
);
	localparam bw_count = bw_fftp+bw_stage;
	
	////////////////////////////////////////////////////
	// Registers
	reg rEnd;
	reg [bw_count-2:0] Count;
	reg [bw_fftp-2:0] rMask;
	reg [bw_fftp-1:0] rMaskB;
	reg [bw_stage-1:0] rStage;
	reg rSW;
	////////////////////////////////////////////////////
	// Net
	
	wire [bw_count-1:0] wCount		= Count + 1'b1;
	wire [bw_fftp-1:0] Pre_IndexA	=
	(Count[bw_fftp-2:0]&rMask)|({Count[bw_fftp-2:0]&(~rMask),1'b0});
	
	wire [bw_fftp-1:0] Pre_IndexB	= Pre_IndexA | rMaskB;
	
	assign	Stage		= Count[bw_count-2:bw_fftp-1];
	wire	wEnd		= (Stage == bw_fftp);
	
	always@(posedge Clock or posedge Reset) begin
		if(Reset) begin
			Busy		<= 1'b0;
			End			<= 1'b0;
			rEnd		<= 1'b0;
			rStage		<= 1'b0;
			Count		<= 1'b0;
			rMask		<= {(bw_fftp-1){1'b1}};
			rMaskB		<= 1'b1<<(bw_fftp-1);
			rSW			<= 1'b0;
			Index		<= 1'b0;
		end else begin
			if(Start)
				Busy	<= 1'b1;
			else if (rEnd)
				Busy	<= 1'b0;
				
			if(rEnd)
				rEnd		<= 1'b0;
			else if(wEnd)
				rEnd		<= 1'b1;
			
			if (End)
				End		<= 1'b0;
			else if(rEnd) begin
				End		<= 1'b1;
			end
				
			if(wEnd || rEnd)
				Count	<= 0;
			else if((Busy||Start) && rSW) begin	
				Count	<= wCount[bw_count-2:0];
			end
			
			if(Start)
				rSW			<= 1'b1;
			else if(Busy)
				rSW			<= ~rSW;
					
			if(!rSW)
				Index	<= Pre_IndexA;
			else
				Index	<= Pre_IndexB;
				
			rStage	<= Stage;
			
			if(Start) begin
				rMaskB		<= 1'b1<<(bw_fftp-1);
				rMask		<= {(bw_fftp-1){1'b1}};
			end else if(Stage != rStage) begin
				rMask		<= rMask	>> 1;
				rMaskB		<= rMaskB	>> 1;
			end
				
		end
	end
endmodule 