// $Id: $
// File name:   USB_tx_sr.sv
// Created:     11/27/2017
// Author:      Chinar Dhamija
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: USB Transmitter Shift Register

module USB_tx_sr
(
	input wire clk,
	input wire n_rst,
	input wire tx_enable,
	input wire load_enable,
	input wire tx_shift.
	input wire [7:0] read_data,
	output wire tx_out
);

	flex_pts_sr #(8,1) TX_SR
	(
		.clk(clk),
		.n_rst(n_rst),
		.shift_enable(tx_enable && tx_shift),
		.load_enable(load_enable), 
		.parallel_in(tx_data),
		.serial_out(tx_out)
	);

endmodule
