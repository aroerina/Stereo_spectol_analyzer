

/* Portlist
RightShifter2 rs2(.Clock(Clock),.Reset(Reset),.Start(),.IN1(),.IN2(),
	.Amount(),.OUT1(),.OUT2(),.Busy(),.End());
*/
module RightShifter2
#(
	parameter bw_in = 15
)
(
	input Clock,Reset,Start,
	input [bw_in-1:0] IN1,IN2,
	input [4:0]	Amount,
	
	output reg [bw_in-1:0] OUT1,OUT2,
	output reg Busy,End
);
	
	//シフトレジスタを使って任意桁の右ビットシフト
	reg [3:0] rCount,rAmount;
	reg [bw_in-1:0]	rSR1,rSR2;
	
	wire wSeqEn = (rCount < rAmount);
	
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			rCount		<= 0;
			rSR1		<= 0;
			rSR2		<= 0;
			End			<= 0;
			Busy		<= 0;
			rAmount		<= 0;
			OUT1		<= 0;
			OUT2		<= 0;
		end else begin
			if(Start) begin
				rSR1		<= IN1;
				rSR2		<= IN2;
				rCount		<= 0;
				rAmount		<= Amount;
			end else if(wSeqEn) begin
				rSR1	<= {1'b0,rSR1[bw_in-1:1]};
				rSR2	<= {1'b0,rSR2[bw_in-1:1]};
				rCount	<= rCount + 1;
			end else if (!wSeqEn && Busy) begin
				OUT1	<= rSR1;
				OUT2	<= rSR2;
			end
			
			if(Start)
				Busy	<= 1'b1;
			else if (!wSeqEn)
				Busy	<= 1'b0;
			
			if(End)
				End		<= 1'b0;
			else if (!wSeqEn && Busy)
				End		<= 1'b1;
		end
	end
endmodule 