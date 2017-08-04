//Pseudo PLL
//pdo_PLL pdo_pll(.Reset(Reset),.Clock(Clock));

module pdo_PLL (
	output reg CLKOP,CLKOK
	);
	
	initial begin
		CLKOP = 1'b0;
		CLKOK = 1'b0;
		#10.5;
		forever fork
			#0.5	CLKOP = ~CLKOP;
			#8		CLKOK = ~CLKOK;
		join
	end
	
endmodule 