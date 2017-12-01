// $Id: $
// File name:   HM_top_level.sv
// Created:     11/28/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Top level for Hashing Module
module HM_top_level
#(
	parameter MODULE_NUM = 0
)

(
	input begin_hash, quit_hash,
	input [255:0] difficulty,
	input [511:0] data_to_hash,
	input clk, n_rst,
	output logic hash_done,
	output logic valid_hash_flag,
	output logic [255:0] valid_hash,
	output logic [1:0] hash_select
);

	logic clear; //internal wires
	logic halt;
	logic [6:0] count;
	logic cnt_up;
	logic [7:0][31:0] out_hash; //Need to do some wire reassignments 
	logic [511:0] data;
	logic hash_rollover;
	logic init;
	logic out_load;



	HM_hash_selection #(MODULE_NUM) HASH_SEL (.data_to_hash(data_to_hash), .hash_select(hash_select), .data(data), .prev_hash(out_hash));
	HM_controller CTRL (.clk(clk), .n_rst(n_rst), .begin_hash(begin_hash), .quit_hash(quit_hash), .hash_done(hash_done), .cnt_up(cnt_up),
			    .clear(clear), .halt(halt), .hash_select(hash_select), .hash_rollover(hash_rollover), .out_load(out_load), .init(init));
	HM_check_hash CHECK (.hash_done(hash_done), .out_hash(out_hash), .difficulty(difficulty), .valid_hash_flag(valid_hash_flag));
	HM_bus_select BUS (.valid_hash_flag(valid_hash_flag), .out_hash(out_hash), .valid_hash(valid_hash));
	HM_SHA_256 SHA (.clk(clk), .n_rst(n_rst), .data(data), .clear(clear), .halt(halt), .out_hash(out_hash), .count(count), .init(init), .out_load(out_load));
	HM_timer TIMER (.clk(clk), .n_rst(n_rst), .count(count), .cnt_up(cnt_up), .hash_rollover(hash_rollover));
	



endmodule
