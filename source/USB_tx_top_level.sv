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
	output d_plus_out,
	output d_minus_out,
	output read_enable,
	output tx_error
);


	logic load_enable;
	logic crc_enable;
	logic data_sent;
	logic create_eop;
	logic tx_shift;
	logic crc_sent;
	logic transmitting;
	logic byte_sent;
	logic tx_out;
	logic tx_hold;
	logic tx_enable;
	logic tx_out_bit;
	logic crc_clear;
	logic [15:0] crc_16;


	USB_timer_tx TIMER (.clk(clk), .n_rst(n_rst), .data_sent(data_sent), .byte_sent(byte_sent), .transmitting(transmitting),
				.tx_shift(tx_shift), .crc_sent(crc_sent));
	USB_crc_tx CRC (.clk(clk), .clear(clear), .n_rst(n_rst), .tx_out(tx_out), .tx_out_bit(tx_out_bit), .crc_enable(crc_enable), .tx_shift(tx_shift), .crc_16(crc_16));
	USB_encoder ENCODER (.clk(clk), .tx_hold(tx_hold), .create_eop(create_eop), .tx_shift(tx_shift),
				.tx_out_bit(tx_out_bit), .d_plus_out(d_plus_out), .d_minus_out(d_minus_out));
	USB_controller CTRL (.clk(clk), .n_rst(n_rst), .transmit_empty(transmit_empty), .read_enable(read_enable), .tx_enable(tx_enable),
				.load_enable(load_enable), .crc_enable(crc_enable), .transmitting(transmitting), .data_sent(data_sent),
				.byte_sent(byte_sent), .crc_sent(crc_sent), .create_eop(create_eop), .tx_hold(tx_hold), .transmit_start(transmit_start));
	USB_tx_sr TX_SR (.clk(clk), .n_rst(n_rst), .load_enable(load_enable), .tx_enable(tx_enable), .tx_shift(tx_shift), .tx_data(tx_data), .tx_out(tx_out), .crc_16(crc_16), .crc_enable(crc_enable));
	
	

endmodule
