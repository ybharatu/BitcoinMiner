// $Id: $
// File name:   PD_top_level.sv
// Created:     11/28/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Top level file for Packet Decoder
module PD_top_level
(
	input clk,
	input n_rst,
	input write_enable,
	input [7:0] rx_data,
	input [7:0] byte_cnt,
	input valid_hash,
	input hash_done,
	input packet_done,
);


endmodule
