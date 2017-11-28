// $Id: $
// File name:   USB_rx_sr.sv
// Created:     11/27/2017
// Author:      Chinar Dhamija
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: USB Receiver Shift Register

module USB_rx_sr
(
	input wire clk,
	input wire n_rst,
	input wire shift_enable,
	input wire crc_chk,
	input wire d_orig, //-->WHAT ABOUT THIS?
	output wire [7:0] rx_data
);

	flex_stp_sr #(8,1) RX_SR
	(
		.clk(clk),
		.n_rst(n_rst),
		.shift_enable(shift_enable && crc_chk),
		.serial_in(d_orig),
		.parallel_out(rx_data)
	);

endmodule
