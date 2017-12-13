// $Id: $
// File name:   USB_tx_sr.sv
// Created:     11/27/2017
// Author:      Chinar Dhamija
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: USB Transmitter Shift Register, Shifts out 16 bits at a time and then shifts out the 16 CRC bits

module USB_tx_sr
(
	input wire clk,
	input wire n_rst,
	input wire tx_enable,
	input wire load_enable,
	input wire tx_shift,
	input wire tx_hold,
	input wire [15:0] tx_data,
	input wire [15:0] crc_16,
	input wire crc_load,
	output wire tx_out_bit
);

	reg [15:0] data;
	reg [15:0] flip_data;

	assign data = crc_load ? crc_16 : tx_data;
	assign flip_data = {data[8], data[9], data[10], data[11], data[12], data[13], data[14], data[15], data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7]};

	flex_pts_sr #(16,1) TX_SR
	(
		.clk(clk),
		.n_rst(n_rst),
		.shift_enable(tx_enable && tx_shift && !tx_hold),
		.load_enable(load_enable || crc_load), 
		.parallel_in(flip_data),
		.serial_out(tx_out_bit)
	);

endmodule
