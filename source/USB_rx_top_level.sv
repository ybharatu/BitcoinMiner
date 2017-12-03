// $Id: $
// File name:   USB_rx_top_level.sv
// Created:     12/1/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Top Level file for USB Receiver

module USB_rx_top_level
(
	input wire d_plus_in,
	input wire d_minus_in,
	input wire clk,
	input wire n_rst,
	input wire packet_type,
	output logic [7:0] rx_data,
	output logic write_enable,
	output logic rcv_error
	
);

	logic d_plus_sync;
	logic d_minus_sync;
	logic eop;
	logic d_orig;
	logic d_edge;
	logic shift_enable;
	logic receiving;
	logic crc_clear;
	logic crc_check;
	logic crc_enable;
	
USB_sync_high SYNC_HIGH (.clk(clk), .n_rst(n_rst), .async_in(d_plus_in), .sync_out(d_plus_sync));

USB_sync_low SYNC_LOW (.clk(clk), .n_rst(n_rst), .async_in(d_minus_in), .sync_out(d_minus_sync));

USB_eop_detect EOP_DETECT (.clk(clk), .n_rst(n_rst), .d_plus_sync(d_plus_sync), .d_minus_sync(d_minus_sync), .eop(eop));

USB_decoder DECODER (.clk(clk), .n_rst(n_rst), .d_plus_sync(d_plus_sync), .shift_enable(shift_enable), .eop(eop), .d_orig(d_orig));

USB_edge_detect EDGE_DETECT (.clk(clk), .n_rst(n_rst), .d_plus_sync(d_plus_sync), .d_edge(d_edge));

USB_crc_block CRC (.clk(clk), .n_rst(n_rst), .crc_clear(crc_clear), .shift_enable(shift_enable), .d_orig(d_orig), .packet_type(packet_type), .crc_check(crc_check), .crc_enable(crc_enable));

USB_rx_sr RX_SR (.clk(clk), .n_rst(n_rst), .shift_enable(shift_enable), .d_orig(d_orig), .rx_data(rx_data));

USB_rx_controller RX_CONTROLLER (.clk(clk), .n_rst(n_rst), .shift_enable(shift_enable), .byte_received(byte_received), .rx_data(rx_data),
	.eop(eop), .crc_check(crc_check), .d_edge(d_edge), .receiving(receiving), .write_enable(write_enable),
	.rcv_error(rcv_error), .crc_enable(crc_enable), .crc_clear(crc_clear));

USB_timer_rx RX_TIMER (.clk(clk), .n_rst(n_rst), .d_edge(d_edge), .receiving(receiving), .shift_enable(shift_enable), .byte_received(byte_received));

endmodule


	