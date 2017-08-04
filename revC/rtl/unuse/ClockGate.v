//DCSをカプセル化
/* Portlist
ClockGate cgate
	(.InClock(),.Gate(),.OutClock());
*/

module ClockGate
(
	////////////////////////////////////////////////////
	// Ports
	input InClock,Gate,
	output OutClock
);
	
	////////////////////////////////////////////////////
	// Instantiations
	DCS dcs (.SEL(Gate),.CLK0(InClock),.CLK1(1'b0),.DCSOUT(OutClock));
	defparam dcs.DCSMODE = "LOW_LOW";
	
	
endmodule 