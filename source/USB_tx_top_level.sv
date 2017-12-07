// $Id: $
// File name:   USB_top_level.sv
// Created:     11/28/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Top Level File for USB module
module USB_tx_top_level
(
	input clk,
	input n_rst,
	input [15:0] tx_data,
	input transmit_empty,
	input transmit_start,
	input transmit_response,
	output d_plus_out,
	output d_minus_out,
	output read_enable
// deleted: you cannot have an error while transmitting	output tx_error
);


	logic load_enable;
	logic crc_enable;
	logic data_sent;
	logic create_eop;
	logic tx_shift;
	logic transmitting;
	logic byte_sent;
	logic tx_hold;
	logic tx_enable;
	logic tx_out_bit;
	logic crc_clear;
	logic crc_load;
	logic [15:0] crc_16;


	USB_timer_tx TIMER (.clk(clk), .n_rst(n_rst), .data_sent(data_sent), .byte_sent(byte_sent), .tx_hold(tx_hold), .transmitting(transmitting),
				.tx_shift(tx_shift), .transmit_empty(transmit_empty), .transmit_start(transmit_start), .transmit_response(transmit_response));

	USB_crc_tx CRC (.clk(clk), .tx_hold(tx_hold), .crc_clear(crc_clear), .n_rst(n_rst), .tx_out_bit(tx_out_bit), .crc_enable(crc_enable), .tx_shift(tx_shift), .crc_16(crc_16));

	USB_encoder ENCODER (.clk(clk), .n_rst(n_rst),.tx_hold(tx_hold), .create_eop(create_eop), .tx_shift(tx_shift),
				.tx_out_bit(tx_out_bit), .d_plus_out(d_plus_out), .d_minus_out(d_minus_out));

	USB_tx_controller CTRL (.clk(clk), .n_rst(n_rst), .transmit_empty(transmit_empty), .read_enable(read_enable), .tx_enable(tx_enable),
				.load_enable(load_enable), .crc_enable(crc_enable), .crc_load(crc_load), .transmitting(transmitting), .data_sent(data_sent),
				.byte_sent(byte_sent), .create_eop(create_eop), .transmit_start(transmit_start), .crc_clear(crc_clear), .tx_shift(tx_shift), .transmit_response(transmit_response));

	USB_tx_sr TX_SR (.clk(clk), .n_rst(n_rst), .load_enable(load_enable), .tx_enable(tx_enable), .tx_shift(tx_shift), .tx_data(tx_data), .tx_out_bit(tx_out_bit), .crc_16(crc_16), .crc_load(crc_load), 
				.tx_hold(tx_hold));

	
	

endmodule
