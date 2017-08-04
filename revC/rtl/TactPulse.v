//
//		タクトスイッチの入力をクロック一位相分のパルスに変換
//	
/* Portlist

TactPulse #(
		num_tact=1
	) tpulse (
		.Clock(Clock),	//i
		.Reset(Reset),	//i
		.Frame(),		//i
		.Tact(),		//i:num_tact
		.Push()			//o:num_tact
	);
*/

module TactPulse
#(parameter num_tact = 1)
(
	input Clock,Reset,Frame,
	input [num_tact-1:0] Tact,
	output reg [num_tact-1:0]Push
);

	localparam bw_framecount = 5;
	reg rSampleFrame;
	reg [bw_framecount-1:0] rFrameCount;
	reg [num_tact-1:0] rTactBefore,rTactAfter;
	wire wSampleFrame = (rFrameCount[0]==1'b0) && Frame;
	
	wire  [num_tact-1:0] wPush = (rTactAfter&{num_tact{1'b1}}) & (~rTactBefore&{num_tact{1'b1}}) & {num_tact{wSampleFrame}};
	
	wire wSampleEnable = rFrameCount[bw_framecount-1];	//リセット直後は入力しない
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{rFrameCount,Push,rTactAfter,rTactBefore,rSampleFrame}		<= 1'b0;
			rTactBefore		<= {num_tact{1'b1}};
			rTactAfter		<= {num_tact{1'b1}};
		end else begin
			rSampleFrame	<= wSampleFrame;
			
			if(Frame) begin
				if(wSampleEnable)
					rFrameCount[1:0]	<= rFrameCount[1:0] + 1'b1;
				else
					rFrameCount			<= rFrameCount + 1'b1;
			end
				
			if(rSampleFrame & wSampleEnable) begin
				rTactBefore		<= Tact;
				rTactAfter		<= rTactBefore;
			end	
			Push	<= wPush;
		end
	end

endmodule 