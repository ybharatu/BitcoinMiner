// $Id: $
// File name:   PD_timer.sv
// Created:     12/4/2017
// Author:      Chinar Dhamija
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Packet Decoder Timer

module PD_timer(
	input wire clk,
	input wire n_rst,
	input wire cnt_up,
	input wire clr_cnt,
	output logic packet_done
);
	logic byte_count;

	flex_counter #(7) TIMER_PD (.clk(clk), .n_rst(n_rst), .clear(clr_cnt), .count_enable(cnt_up), .rollover_val(7'd79), .count_out(byte_count), .rollover_flag());

	assign packet_done = (byte_count == 7'd64 || byte_count == 7'd80) ? 1 : 0;

endmodule
