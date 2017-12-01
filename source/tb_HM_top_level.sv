// $Id: $
// File name:   tb_HM_top_level.sv
// Created:     11/28/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Top Level test bench for hashing module

`timescale 1ns / 10ps

module tb_HM_top_level ();


	localparam	CLK_PERIOD	= 10;
	localparam	CHECK_DELAY 	= 2; // Check 1ns after the rising edge to allow for propagation delay
	
	// Shared Test Variables
	reg tb_clk;

	// Clock generation block
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

	reg tb_begin_hash, tb_quit_hash;
	reg [255:0] tb_difficulty;
	reg [511:0] tb_data_to_hash;
	reg tb_n_rst;
	reg tb_hash_done;
	reg tb_valid_hash_flag;
	reg [255:0] tb_valid_hash;
	reg [1:0] tb_hash_select;

	localparam tb_chunk1 = {32'h00000000,32'h80000000,32'h6E6F7071,32'h6D6E6F70,
				32'h6C6D6E6F,32'h6B6C6D6E,32'h6A6B6C6D,32'h696A6B6C,
				32'h68696A6B,32'h6768696A,32'h66676869,32'h65666768,
				32'h64656667,32'h63646566,32'h62636465,32'h61626364};

	localparam tb_chunk2 = {32'h000001C0,32'h00000000,32'h00000000,32'h00000000,
				32'h00000000,32'h00000000,32'h00000000,32'h00000000,
				32'h00000000,32'h00000000,32'h00000000,32'h00000000,
				32'h00000000,32'h00000000,32'h00000000,32'h00000000 };

	localparam tb_expected = 256'h19db06c16ecedd464ff2167a33ce4590c3e6039e5c02693d20638b8248d6a61;


	HM_top_level HM0 (.begin_hash(tb_begin_hash), .quit_hash(tb_quit_hash), .difficulty(tb_difficulty),
		 	.data_to_hash(tb_data_to_hash), .clk(tb_clk), .n_rst(tb_n_rst), .valid_hash_flag(tb_valid_hash_flag),
			.valid_hash(tb_valid_hash), .hash_select(tb_hash_select), .hash_done(tb_hash_done));


	always_comb begin	
		if(tb_hash_select == 0)
			tb_data_to_hash = tb_chunk1;
		else if(tb_hash_select == 1)
			tb_data_to_hash = tb_chunk2;
		else
			tb_data_to_hash = tb_chunk1;
	end

	initial
	begin

	tb_n_rst 	= 1'b0;
	tb_begin_hash 	= 0;
	tb_quit_hash	= 0;
	tb_difficulty 	= ~(256'b0);


	@(posedge tb_clk);
	tb_n_rst = 1'b1;
	tb_begin_hash = 1;
	@(posedge tb_clk);
	#CHECK_DELAY;
	tb_begin_hash = 0;
	
	@(posedge tb_valid_hash_flag);


	end
endmodule
