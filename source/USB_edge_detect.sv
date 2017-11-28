// $Id: $
// File name:   edge_detect.sv
// Created:     11/14/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Edge Detect for Transitions

module USB_edge_detect
(
	input wire clk,
	input wire n_rst,
	input wire d_plus_sync,
	output wire d_edge
);

	reg d;

	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 1'b0)
			d <= 0;
		else
			d <= d_plus_sync; 
	end

	assign d_edge = (d_plus_sync ^ d);

endmodule
