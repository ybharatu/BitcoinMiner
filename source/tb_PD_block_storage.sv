// $Id: $
// File name:   tb_block_storage.sv
// Created:     11/28/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test bench for block storage

`timescale 1ns / 10ps

module tb_PD_block_storage ();


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
	reg tb_i_data_en;
	reg [7:0] tb_i_data;
	reg [6:0] tb_i_data_sel;
	reg [63:0][7:0] tb_chunk_1;
	reg [15:0][7:0] tb_chunk_2;
	reg [3:0][7:0] tb_difficulty;
	reg [79:0][7:0] prev_storage;
	reg [79:0][7:0] curr_storage;

	assign curr_storage = {tb_chunk_2, tb_chunk_1};
	integer i;

	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		// output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output  data = tb_i_data,
			sel = tb_i_data_sel,
			en = tb_i_data_en;
		input	chunk_1 = tb_chunk_1,
			chunk_2 = tb_chunk_2,
			difficulty = tb_difficulty;
	endclocking

	PD_block_storage DUT (.i_data_en(tb_i_data_en), .i_data(tb_i_data), .i_data_sel(tb_i_data_sel),
			   .chunk_1(tb_chunk_1), .chunk_2(tb_chunk_2), .difficulty(tb_difficulty), .clk(tb_clk));

	initial
	begin

	tb_i_data_en 	= 1'b0;
	tb_i_data 	= 8'b0;
	tb_i_data_sel	= 7'b0;
	@cb;
	@cb; //give some time to do nothing
	//Test 1 - 80 write 80 bytes of memory to storage
	tb_i_data_en = 1'b1;
	for(i = 0; i < 80; i = i + 1) begin
		prev_storage = {cb.chunk_2,cb.chunk_1};
		tb_test_num = tb_test_num + 1;
		cb.sel <= i;
		cb.data <= i;
		@cb;
		assert(curr_storage[i][7:0] == i)
			$info("Test Case %d Passed",tb_test_num);
		else
			$error("Test Case %d Failed", tb_test_num);
	end
		
	end


endmodule
