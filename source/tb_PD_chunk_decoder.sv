// $Id: $
// File name:   tb_PD_chunck_decoder.sv
// Created:     12/5/2017
// Author:      Rahul Patni
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test if flip endian stuff works

`timescale 1ns / 10ps

module tb_PD_chunk_decoder();


	// Define parameters
	// basic test bench parameters
	localparam	CLK_PERIOD = 10; //??
	localparam	CHECK_DELAY = 1; // Check 1ns after the rising edge to allow for propagation delay
	
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


	integer tb_test_num = 0;

	reg [1:0] tb_hash_select;
	reg [511:0] tb_chunk1;
	reg [127:0] tb_chunk2;
	// input new_block, idk if we need this
	reg [511:0] tb_data_to_hash;

	
	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		// output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output  hash_select = tb_hash_select,
			chunk1 = tb_chunk1,
			chunk2 = tb_chunk2; // after increment
		input	data_to_hash = tb_data_to_hash;
	endclocking

	PD_chunk_decoder DUT (.hash_select(tb_hash_select), .chunk1(tb_chunk1), .chunk2(tb_chunk2), .data_to_hash(tb_data_to_hash));

initial 
begin

	tb_hash_select <= 2'b0;
	tb_chunk1 <= 512'h0100000050120119172a610421a6c3011dd330d9df07b63616c2cc1f1cd00200000000006657a9252aacd5c0b2940996ecff952228c3067cc38d4885efb5a4ac;

	//tb_chunk2 <= '0;
	tb_chunk2 <= 128'h4247e9f337221b4d4c86041b0f2b5710;

	@cb;
	@cb;
	@cb;
	@cb;

	@cb;
	@cb;
	@cb;
	@cb;

	tb_hash_select <= 2'b1;

	@cb;
	@cb;
	@cb;
	@cb;

	@cb;
	@cb;
	@cb;
	@cb;
	
end
endmodule
	