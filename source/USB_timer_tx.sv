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
	output logic tx_shift,
	output logic crc_sent
);

logic temp_byte_sent;
logic [5:0] value;
logic temp_data_sent;

flex_counter #(5) FLEX_COUNTER (.clk(clk), .n_rst(n_rst), .clear(!transmitting), .count_enable(transmitting), .rollover_val(5'd16), .count_out(), .rollover_flag(temp_byte_sent));

flex_counter #(5) FLEX_COUNTER2 (.clk(clk), .n_rst(n_rst), .clear(!transmitting), .count_enable(temp_byte_sent), .rollover_val(value), .count_out(), .rollover_flag(temp_data_sent));

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

assign crc_sent = temp_data_sent;
assign byte_sent = temp_byte_sent;
assign data_sent = temp_data_sent;
assign tx_shift = temp_byte_sent;

endmodule
