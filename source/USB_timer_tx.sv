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
	output wire byte_sent,
	output wire data_sent,
	output wire tx_shift
);

logic temp_byte_sent;
logic [4:0] value;
logic temp_data_sent;

flex_counter #(4) FLEX_COUNTER (.clk(clk), .n_rst(n_rst), .clear(!transmitting), .count_enable(transmitting), .rollover_val(4'd8), .count_out(), .rollover_flag(temp_byte_sent));

flex_counter #(5) FLEX_COUNTER2 (.clk(clk), .n_rst(n_rst), .clear(!transmitting), .count_enable(temp_byte_sent), .rollover_val(value), .count_out(), .rollover_flag(temp_data_sent));

always_comb
begin
	if(transmit_empty)
	begin
		value = 5'd5;
	end
	else
	begin
		value = 5'd34;
	end
end

assign byte_sent = temp_byte_sent;
assign data_sent = temp_data_sent;
assign tx_shift = temp_byte_sent;

endmodule
