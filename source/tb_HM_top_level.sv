// $Id: $
// File name:   tb_HM_top_level.sv
// Created:     11/28/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Top Level test bench for hashing module

`timescale 1ns / 10ps

module tb_HM_top_level ();

	reg tb_begin_hash, tb_quit_hash;
	reg [255:0] tb_difficulty;
	reg [511:0] tb_data_to_hash;
	reg tb_clk, tb_n_rst;
	reg tb_hash_done;
	reg tb_valid_hash_flag;
	reg [255:0] tb_valid_hash;
	reg [1:0] tb_hash_select;


HM_top_level #(0) HM0 (.begin_hash(tb_begin_hash), .quit_hash(tb_quit_hash), .difficulty(tb_difficulty),
		 	.data_to_hash(tb_data_to_hash), .clk(tb_clk), .n_rst(tb_n_rst), .valid_hash_flag(tb_valid_hash_flag),
			.valid_hash(tb_valid_hash), .hash_select(tb_hash_select), .hash_done(tb_hash_done));


endmodule
