// $Id: $
// File name:   timer_tx.sv
// Created:     11/26/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Transmitter Timer

module USB_timer_tx
(
	input wire clk,
	input wire n_rst,
	input wire transmitting,
	input wire transmit_empty,
	output logic byte_sent,
	output logic data_sent,
	output logic tx_shift
);

logic [4:0] value;

flex_counter #(4) TX_SHIFT (.clk(clk), .n_rst(n_rst), .clear(!transmitting), .count_enable(transmitting), .rollover_val(4'd8), .count_out(), .rollover_flag(tx_shift));

flex_counter #(5) FLEX_COUNTER (.clk(clk), .n_rst(n_rst), .clear(!transmitting || byte_sent), .count_enable(tx_shift), .rollover_val(5'd16), .count_out(), .rollover_flag(byte_sent));

flex_counter #(5) FLEX_COUNTER2 (.clk(clk), .n_rst(n_rst), .clear(!transmitting || data_sent), .count_enable(byte_sent), .rollover_val(value), .count_out(), .rollover_flag(data_sent));

always_comb
begin
	if(transmit_empty)
	begin
		value = 5'd3;
	end
	else
	begin
		value = 5'd17;
	end
end


endmodule
