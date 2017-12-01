// $Id: $
// File name:   timer_rx.sv
// Created:     11/26/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Receiver Timer

module USB_timer_rx
(
	input wire d_edge,
	input wire receiving,
	input wire clk,
	input wire n_rst,
	output logic shift_enable,
	output logic byte_received
);

logic temp_shift_enable;
logic temp_byte_received;
logic rf_1;
logic rf_2;
logic clear_bit_stuffing;

assign clear_bit_stuffing = (rf_1 && rf_2);

flex_counter #(4) FLEX_COUNTER (.clk(clk), .n_rst(n_rst), .clear(!receiving), .count_enable(receiving), .rollover_val(4'd8), .count_out(), .rollover_flag(rf_1));

flex_counter #(4) FLEX_COUNTER2_BYTE_RECEIVED (.clk(clk), .n_rst(n_rst), .clear(!receiving), .count_enable(shift_enable), .rollover_val(4'd8), .count_out(), .rollover_flag(temp_byte_received));

flex_counter #(4) FLEX_COUNTER3_BIT_STUFFING (.clk(clk), .n_rst(n_rst), .clear(d_edge || clear_bit_stuffing), .count_enable(!d_edge & shift_enable), .rollover_val(4'd6), .count_out(), .rollover_flag(rf_2));

always_comb
begin
	if(!rf_2 && rf_1)
	begin
		temp_shift_enable = 1;
	end
	else
	begin
		temp_shift_enable = 0;
	end
end

assign shift_enable = temp_shift_enable;
assign byte_received = temp_byte_received;

endmodule
