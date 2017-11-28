// $Id: $
// File name:   tb_HM_SHA_256.sb
// Created:     11/15/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: SHA test bench
module tb_HM_SHA_256


	// Define parameters
	// basic test bench parameters
	localparam	CLK_PERIOD	= 10; //??
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
	reg tb_n_rst;
	reg tb_clear;
	reg tb_halt;
	reg [15:0][31:0] tb_data;
	reg [7:0] tb_count;
	reg [7:0][31:0] tb_out_hash;

	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output halt = tb_halt,
			clear = tb_clear,
			count = tb_count,
			data = tb_data,
		input out_hash = tb_out_hash,
			
	endclocking

	HM_SHA_256 DUT (.n_rst(tb_n_rst), .clk(tb_clk), .halt(tb_halt),
			.clear(tb_clear), .data(tb_data), .count(tb_count), .out_hash(tb_out_hash)); 

	initial
	begin



	end
	
	tb_n_rst 	= 1'b1;
	tb_clear	= 1'b1;
	tb_data 	= 512'b0;
	tb_count	= 'b0;
	tb_halt		= 1'b0;



	

endmodule
