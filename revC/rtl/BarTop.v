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

module BarTop
(
	input Clock,Reset,Start,NewFrame,
	input [2:0] FallSpeed,
	input [6:0] Bar,
	output reg [6:0] Top
);
	localparam depth_ram = 800;
	localparam bw_addr = 10;
	localparam preset_resetval = 0;
	localparam hfp = 4;	//Heightの固定小数点位置　右から
	localparam sfp = 5;
	localparam bw_speed		= 2+sfp;
	localparam bw_height	= 7+hfp;
	
	reg [bw_addr-1:0] rRAMAddr;
	reg [bw_height-1:0] rHeightData;
	reg rWE;
	reg rStart;

	reg [bw_speed-1:0] rSpeedData;
	wire [bw_speed-1:0] wSpeed;	//落下速度

	wire [bw_height-1:0] wHeight;		//位置
	wire wInBarIsBig = Bar > wHeight[bw_height-1:hfp];

	pmi_ram_dq #(
		.pmi_addr_depth(800),
	   .pmi_addr_width(bw_addr),
	   .pmi_data_width(bw_height+bw_speed),
	   .pmi_regmode("reg"),
	   .pmi_gsr("disable"),
	   .pmi_resetmode("sync"),
	   .pmi_optimization("speed"),
	   .pmi_init_file("none"),
	   .pmi_init_file_format("binary"),
	   .pmi_write_mode("normal"),
	   .pmi_family("XP2"),
	   .module_type("pmi_ram_dq") )
	spram(.Data({rSpeedData,rHeightData}),
	   .Address(rRAMAddr),
	   .Clock(Clock),
	   .ClockEn(1'b1),
	   .WE(rWE),
	   .Reset(Reset),
	   .Q({wSpeed,wHeight})
   );
   
	reg [2:0] rFallSpeed;
	localparam max_speed = (2**bw_speed)-1;
	//reg rFallFrame;
	
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			{rRAMAddr,rHeightData,Top,rStart,rSpeedData,rWE/*,rFallFrame*/}
			<= 1'b0;

		end else begin
		
			/*
			if(NewFrame)	//落下するフレーム
				rFallFrame	<= ~rFallFrame;
			*/
			if(wInBarIsBig)
				rHeightData	<= {Bar,{hfp{1'b0}}};		//高さをリセット
			else if(wHeight >= wSpeed)
				rHeightData	<= wHeight - wSpeed[bw_speed-1:sfp-hfp];
			else
				rHeightData	<= 1'b0;
				
				
			if(wInBarIsBig)				//速度をリセット
				rSpeedData	<= 1'b0;
			else if((wSpeed < max_speed)/*&&rFallFrame*/)	//速度MAXでない
				rSpeedData	<= wSpeed + FallSpeed;
			else						//速度MAXなら
				rSpeedData	<= wSpeed;
				
			rWE	<= Start;
			
			rStart	<= Start;
			
			if(NewFrame)
				rRAMAddr	<= 1'b0;
			else if(rStart)
				rRAMAddr	<= rRAMAddr + 1'b1;
			
			if(rStart)
				Top	<= rHeightData[bw_height-1:hfp];
				
		end
	end

	
endmodule 