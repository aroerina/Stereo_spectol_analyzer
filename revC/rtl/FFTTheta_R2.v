//FFT Radix2 DIT 用θ生成module
/*	Portlist
FFTTheta_R2 #(.bw_fftp(),.bw_stage()) theta
	(.Clock(),.Reset(),.Theta(),.Start(Start),.Busy(Busy),.End(End));
*/

module FFTTheta_R2 #(
	parameter bw_fftp = 4,
	parameter bw_stage	= 2 		//Bit Width of FFTstage
)
(
	input Clock,Reset,Start,
	output reg[bw_fftp-2:0] Theta,
	output [bw_stage-1:0] Stage,
	output reg Busy,End
);
	
	localparam bw_stagep1 = bw_stage+1;	//End信号生成のため1bit拡張する
	localparam bw_theta	= bw_fftp-1; //Bit Width of output theta	
	localparam bw_count = bw_theta+bw_stagep1;
	

	////////////////////////////////////////////////////
	// Registers
	reg [bw_count-1:0] Count,DCount,Mask;
	reg [bw_theta-1:0] GenThetaCount;
	reg rCSens,rDummy,rEnd,rGenThetaCountReset;
	
	////////////////////////////////////////////////////
	// wire
	wire [bw_theta-1:0] PreTheta;
	wire [bw_stagep1-1:0] wStage 	= Count[bw_count-1:bw_theta];
	assign Stage					= wStage[bw_stage-1:0];
	wire [bw_stagep1-1:0] wDStage	= DCount[bw_count-1:bw_theta];
	wire CSens						= |({1'b0,DCount}&Mask);
	
	wire wGenThetaCountReset		= wDStage != wStage;
	wire wGenThetaCountUp			= rCSens != CSens;
	wire wEnd						= (wStage == bw_fftp);
	//GenThetaCountをビット反転してPreThetaに割り当てる
	generate
		genvar i;
		for(i=0;i<bw_theta;i=i+1) begin :br
			assign PreTheta[i] = GenThetaCount[bw_theta-1-i];
		end
	endgenerate	
	
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			{
				Theta,Count,rCSens,DCount,
				GenThetaCount,rGenThetaCountReset,
				rDummy ,Busy,End,rEnd
			}			<=	1'b0;
			Mask		<=	1<<(bw_theta);
		end else begin
			if(Start)
				Busy	<= 1'b1;
			else if (rEnd)
				Busy	<= 1'b0;
			
			if(End) begin
				Count	<= 1'b0;
				rDummy	<= 1'b0;
			end else if(Busy)
				{Count,rDummy}	<= {Count,rDummy} + 1'b1;	//2クロックで１加算するようにする
				
			if(Start)
				rEnd	<= 1'b0;
			else
				rEnd <= wEnd;
			
			if(rEnd && !Busy)
				End <= 1'b0;
			else if(rEnd)
				End <= 1'b1;
			
			Theta		<= PreTheta;
			
			rGenThetaCountReset	<= wGenThetaCountReset;
			
			if(End)
				DCount	<= 1'b0;
			else
				DCount	<= Count;	//1サイクル遅延するだけ
			
			rCSens	<= CSens;
			
			if(rGenThetaCountReset)
				GenThetaCount	<= 1'b0;
			else if(wGenThetaCountUp)
				GenThetaCount	<= GenThetaCount+1;					
			
			if(Start)
				Mask	<= 1<<(bw_theta);
			else if(Count[bw_theta] != DCount[bw_theta])
				Mask	<= Mask>>1;
		end
	end
endmodule
