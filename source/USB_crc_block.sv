// $Id: $
// File name:   USB_crc_block.sv
// Created:     12/1/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: CRC Block

module USB_crc_block
(
	input wire clk,
	input wire n_rst,
	input wire crc_clear,
	input wire shift_enable,
	input wire d_orig,
	input wire packet_type,
	output logic crc_check
);

logic crc_check_5;
logic crc_check_16;

assign crc_check = (packet_type) ? crc_check_16 : crc_check_5;


USB_crc_5 CRC_5 (.clk(clk), .n_rst(n_rst), .crc_clear(crc_clear), .shift_enable(shift_enable), .d_orig(d_orig), .crc_check_5(crc_check_5));

USB_crc_16 CRC_16 (.clk(clk), .n_rst(n_rst), .crc_clear(crc_clear), .shift_enable(shift_enable), .d_orig(d_orig), .crc_check_16(crc_check_16));

endmodule
