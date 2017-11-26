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

	assign eop = ~(d_plus_sync | d_minus_sync);

endmodule
