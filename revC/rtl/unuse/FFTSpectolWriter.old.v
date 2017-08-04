//
/* Portlist
FFTSpectolWriter sw
(.Clock(),.ClockEn(),.Reset(),.End(),.Busy(),.Start(),
.LRChange(),.Bar(),.X(),.Y(),.Color());
*/
//memo
//表示期間	X : 0 ~ 399
//			Y : 0 ~ 95

module FFTSpectolWriterOld
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,ClockEn,Reset,Start,LRChange,
	input [6:0] Bar,			//スペクトルの高さ 0~96
	output Screen,
	output reg [8:0] X,			//座標。左上からx0,y0
	output reg [6:0] Y,
	output reg [14:0] Color,	//MSB  R54321,G54321,B54321  LSB
	output reg 		End,Busy
);

	////////////////////////////////////////////////////
	// Registers
	reg [6:0] rBarTop;
	reg rSeqEn;
	reg rLR;	//rLR:1 == L;

	////////////////////////////////////////////////////
	// Net
	wire Barbottom = (Y == 0);	//Barの下端まで到達したらHI
	
	////////////////////////////////////////////////////
	// Instantiations
	assign Screen	= rLR;
	wire [8:0] wX;
	Inc_Dec #(.width(9)) incdec(.DecEn(rLR),.A(X),.S(wX));

	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			Y		<= 0;
			X		<= 0;
			rBarTop	<= 0;
			Color	<= 0;
			{End,Busy,rSeqEn,rLR}		<= 0;
		end else begin
			if(Start)begin	//ClockEnがLOWでもStartは受け付ける
				rBarTop	<= 7'd96 - Bar; //バーの高さを変換
				rSeqEn	<= 1'b1;
				Busy	<= 1'b1;
				Y		<= 96;
				X		<= wX;			//Startパルスを入れるたびにXアドレスを加算or減算
			end else
			if( rSeqEn ) begin
				if (!Barbottom && ClockEn ) begin
					Y	<= Y - 1;
				end else
				if ( Barbottom ) begin
					rSeqEn	<= 1'b0;
					End		<= 1'b1;
					Busy	<= 1'b0;
				end else if (End) begin
					End	<= 1'b0;
				end
			end else if ( LRChange ) begin
				if(rLR)
					X	<= 9'h1ff;	//Rch
				else 				
					X	<= 9'd400;	//Lch		
			end
			
			if (LRChange) begin
				rLR	<= ~rLR;
			end
				
			if (Start) begin
				Color	<= 15'h7fff;
			end else if ((Y == rBarTop) && !Barbottom) begin
				Color	<= 15'h0;//バーを描画
			end
				
			
		end
	end

endmodule 