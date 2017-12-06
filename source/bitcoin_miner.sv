// $Id: $
// File name:   bitcoin_miner.sv
// Created:     12/5/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Bitcoin Miner Top Top Level file
module bitcoin_miner
(
	input clk,
	input n_rst,
	inout d_plus,
	inout d_minus,
);
	
	PD_top_level PD (.clk(clk), .n_rst(n_rst), .chunk_1(chunk_1), .chunk_2(chunk_2), )


endmodule

