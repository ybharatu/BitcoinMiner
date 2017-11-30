// $Id: $
// File name:   HM_timer.sv
// Created:     11/15/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Flex Counter Wrapper for Hashing Module
module HM_timer
(
	input cnt_up, clk, n_rst,
	output logic hash_rollover,
	output logic [6:0] count	
);
	reg [6:0] flex_count;
	assign count = flex_count - 1; //IDK about this

	flex_counter #(7) HASH_CNT (.clear(), .count_enable(cnt_up), .clk(clk), .n_rst(n_rst), .rollover_val(7'd64), .rollover_flag(hash_rollover), .count_out(flex_count));

endmodule
