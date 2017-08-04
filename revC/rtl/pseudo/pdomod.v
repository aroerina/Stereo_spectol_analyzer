//Pseudo Module
//シミュレーション用
//Startパルスを入れると任意の時間BusyがHI
/* portlist
pdomod #(.busytime()) _(
	.Clock(),	//i
	.Reset(),	//i
	.Start(),	//i
	.Busy()		//o
	.End()		//o
	);
*/

module pdomod #(
	parameter busytime = 10
)
(
	input Clock,Reset,Start,
	output reg Busy,End	);
	
	
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			Busy	= 1'b0;
			End		= 1'b0;
		end else begin
			if(Start) begin
				Busy = 1'b1; #busytime;
				End	 = 1'b1;
				Busy = 1'b0;
				#1 End = 1'b0;
			end
		end
	end
endmodule 