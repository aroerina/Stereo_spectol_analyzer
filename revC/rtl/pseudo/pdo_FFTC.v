//擬似FFTCモジュール
/* Portlist
pdo_FFTC #(.bw_numelm()) pdofftc
( .Clock(),.Reset(),.NumElm(),.ibstart(),.ibend(),.outvalid(),.obstart());
*/
`timescale	1ns/100ps

module pdo_FFTC
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_numelm	= 6
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,
	output reg [bw_numelm-1:0] NumElm,
	output reg ibstart,ibend,outvalid,obstart
);

	////////////////////////////////////////////////////
	// Registers
	reg rInit = 0;
	////////////////////////////////////////////////////
	// Net
	
	////////////////////////////////////////////////////
	// Assign
	
	////////////////////////////////////////////////////
	// Instantiations

	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			{ibstart,ibend,outvalid,obstart}	= 3'b0;
			NumElm						= 6'bx;
		end else
		if(Clock)begin
			if ( !rInit ) begin
				rInit = 1;
				ibstart	= 1'b1; #1;
				ibstart = 1'b0; #20;
				
				ibend	= 1'b1; #1;
				ibend	= 1'b0; #20.1;
				
				NumElm		= 0;
				outvalid	= 1'b1;
				obstart		= 1'b1; #1;
				obstart		= 1'b0;
				
				
			end
			if(outvalid)
				NumElm	= NumElm + 1;
		end
	end

endmodule 