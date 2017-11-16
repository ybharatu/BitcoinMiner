// $Id: $
// File name:   eop_detect.sv
// Created:     11/14/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: EOP Detect

module eop_detect
(
	input wire clk,
	input wire n_rst,
	input wire d_plus_sync,
	input wire d_minus_sync,
	output wire eop
);
	reg _EOP;

	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 1'b0)
			_EOP <= 0;
		else
			_EOP <= ~(d_plus_sync | d_minus_sync); 
	end

	assign eop = _EOP;

endmodule
