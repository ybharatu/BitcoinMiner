// $Id: $
// File name:   tb_HM_SHA_256.sb
// Created:     11/15/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: SHA test bench

`timescale 1ns / 10ps

module tb_HM_SHA_256 ();


	// Define parameters
	// basic test bench parameters
	localparam	CLK_PERIOD	= 20; //Not Target Clock
	localparam	CHECK_DELAY 	= 1; // Check 1ns after the rising edge to allow for propagation delay
	
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
	integer count = 0;
	reg tb_n_rst;
	reg tb_clear;
	reg tb_halt;
	reg tb_init;
	reg [15:0][31:0] tb_data;
	reg [6:0] tb_count;
	reg [7:0][31:0] tb_out_hash;
	integer i;

	reg [7:0][31:0] expected_1 = {32'hf20015ad,32'hb410ff61,32'h96177a9c,32'hb00361a3,32'h5dae2223,32'h414140de,32'h8f01cfea,32'hba7816bf};
				   
	reg  [15:0][31:0] data_1 = {32'h00000018,32'h00000000,32'h00000000,32'h00000000,
				   32'h00000000,32'h00000000,32'h00000000,32'h00000000,
				   32'h00000000,32'h00000000,32'h00000000,32'h00000000,
				   32'h00000000,32'h00000000,32'h00000000,32'h61626380 }; 


	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output halt = tb_halt,
			clear = tb_clear,
			count = tb_count,
			data = tb_data,
			init = tb_init;
		input out_hash = tb_out_hash;
			
	endclocking

	HM_SHA_256 DUT (.n_rst(tb_n_rst), .clk(tb_clk), .halt(tb_halt),
			.clear(tb_clear), .data(tb_data), .count(tb_count), .out_hash(tb_out_hash), .init(tb_init)); 

	
	task wait_hash;
	begin
		integer w;

		for(w = 0; w < 64; w = w + 1) begin
			cb.count <= count;
			@cb;
			count = count + 1;
		end
	end
	endtask

	initial
	begin
	
	//Test 0: n_rst test
 	tb_n_rst 	= 1'b0;
	tb_clear	= 1'b1;
	tb_data 	= 512'b0;
	tb_count	= 7'b0;
	tb_halt		= 1'b1;
	tb_data		= data_1;

	@cb;

	if (tb_out_hash == 512'b0)
		$info("Case %0d:: PASSED", tb_test_num);
	else // Test case failed
		$error("Case %0d:: FAILED", tb_test_num);

	//Test 1: reset off calculate a hash
	
	cb.n_rst <= 1'b1;
	@cb;
	@cb;
	cb.init <= 1;
	@cb;
	cb.init <= 0;
	@cb;
	@cb;
	@cb;
	cb.halt <= 0;
	cb.clear <= 1;
	
	cb.data <= data_1;

	wait_hash(); //Run 64 clocks
	@cb; //Wait one clock then check

	if( tb_out_hash == expected_1)
		$info("HOLY SHIT IT WORKS");
	else
		$error("To be expected");
	cb.halt <= 1;

	end

endmodule
