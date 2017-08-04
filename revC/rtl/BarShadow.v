//
//	Ratency = 2[Clock]
//	
/* Portlist
BarTop bt(
		.Clock(Clock),
		.Reset(Reset),
		.Start(Start),
		.NewFrame(NewFrame),
		.FallSpeedDown(FallSpeedDown),
		.Bar(Bar),
		.Top(Top)
	);
*/

module BarShadow
(
	input Clock,Reset,Start,NewFrame,
	input [6:0] Bar,
	output reg [4:0] Color,
	output reg [6:0] Top
);
	localparam depth_ram = 800;
	localparam bw_addr = 10;
	localparam fp = 2;	//固定小数点位置　右から
	localparam preset_val_color = 7'd16<<2;
	localparam bw_color		= 5+fp;
	localparam bw_height	= 7;
	
	reg [bw_addr-1:0]	rRAMAddr;
	reg [bw_height-1:0]	rHeightData;
	reg [bw_color-1:0]	rColorData;
	reg rWE,rStart;

	wire [bw_color-1:0] wColor;
	wire [bw_height-1:0] wHeight;		//位置

	pmi_ram_dq #(
		.pmi_addr_depth(depth_ram),
	   .pmi_addr_width(bw_addr),
	   .pmi_data_width(bw_height+bw_color),
	   .pmi_regmode("reg"),
	   .pmi_gsr("disable"),
	   .pmi_resetmode("sync"),
	   .pmi_optimization("speed"),
	   .pmi_init_file("none"),
	   .pmi_init_file_format("binary"),
	   .pmi_write_mode("normal"),
	   .pmi_family("XP2"),
	   .module_type("pmi_ram_dq") )
	spram(.Data({rColorData,rHeightData}),
	   .Address(rRAMAddr),
	   .Clock(Clock),
	   .ClockEn(1'b1),
	   .WE(rWE),
	   .Reset(Reset),
	   .Q({wColor,wHeight})
   );
   
	wire wInBarIsBig = Bar > wHeight;
	
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{rRAMAddr,rHeightData,Top,rStart,rColorData,rWE}
			<= 1'b0;
		end else begin
			
			if(wInBarIsBig)
				rHeightData	<= Bar;		//高さをリセット
			else
				rHeightData	<= wHeight;
				
			if(wInBarIsBig)				//色をリセット
				rColorData	<= preset_val_color;
			else if(wColor > 1'b0)
				rColorData	<= wColor - 1'b1;
			else
				rColorData	<= 1'b0;
				
			rWE	<= wInBarIsBig | Start;
			
			rStart	<= Start;
			
			if(NewFrame)
				rRAMAddr	<= 1'b0;
			else if(rStart)
				rRAMAddr	<= rRAMAddr + 1'b1;
			
			if(rStart) 
				Top			<= rHeightData[bw_height-1:0];
			
			if(rStart)
				Color		<= rColorData[bw_color-1:fp];
		end
	end

	
endmodule 