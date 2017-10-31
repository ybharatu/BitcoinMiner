// $Id: $
// File name:   tb_flex_counter.sv
// Created:     9/16/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test Bench for Flex Counter

`timescale 1ns / 10ps

module tb_flex_counter ();

	// Define parameters
	// basic test bench parameters
	localparam	CLK_PERIOD	= 2.5;
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
	
	localparam DEFAULT_SIZE = 4;

	tb_flex_counter_DUT #(.SIZE(DEFAULT_SIZE)) fourBit (.tb_clk(tb_clk));
	//tb_flex_counter_DUT #(.SIZE(8)) 	eightBit (.tb_clk(tb_clk));
	//tb_flex_counter_DUT #(.SIZE(16)) 	sixteenBit (.tb_clk(tb_clk));

endmodule

module tb_flex_counter_DUT
	#(parameter SIZE = 4)
	(input wire tb_clk);

	// Default Config Test Variables & constants
	localparam MAX_BIT = (SIZE - 1);


	integer tb_test_num;
	reg tb_n_rst;
	reg tb_clear;
	reg tb_count_enable;
	reg [MAX_BIT:0] tb_rollover_val;
	reg [MAX_BIT:0] tb_count_out;
	reg tb_rollover; 
	reg tb_expected_rollover;
	reg [MAX_BIT:0] tb_expected_count;
	
	clocking cb @(posedge tb_clk);
 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output count_enable = tb_count_enable,
			clear = tb_clear,
			rollover_val = tb_rollover_val;
		input rollover = tb_rollover,
			count = tb_count_out;
	endclocking

	flex_counter DUT ( .clk( tb_clk ), .n_rst( tb_n_rst ), .clear( tb_clear ), .count_enable( tb_count_enable ), .rollover_flag( tb_rollover), .rollover_val( tb_rollover_val ), .count_out(tb_count_out ) );


	initial
	begin
		// Initialize all of the test inputs
		tb_n_rst		= 1'b1;		// Initialize to be inactive
		tb_count_enable		= 1'b0;		// Initialize to be inactive
		tb_test_num 		= 0;
		tb_expected_rollover 	= 'd10;
		tb_expected_count 	= 0;
		tb_rollover_val		= 'd15;
		tb_clear		= 1'b0;
		
	
		// Power-on Reset of the DUT
		// Assume we start at negative edge. Immediately assert reset at first negative edge
		// without using clocking block in order to avoid metastable value warnings
		@(negedge tb_clk);
		tb_n_rst	<= 1'b0; 	// Need to actually toggle this in order for it to actually run dependent always blocks
		@cb;
		cb.n_rst	<= 1'b1; 	// Deactivate the chip reset
		
		// Wait for a while to see normal operation
		@cb;
		@cb;
		

		// Test 1: Check for Proper Reset w/ Idle (serial_in=1) input during reset signal
		tb_test_num = tb_test_num + 1;
		cb.n_rst <= 1'b0;

		tb_expected_rollover 	= 'd10;
		tb_expected_count 	= 0;

		@cb; // Measure slightly before the second clock edge
		@cb;
		if (tb_expected_rollover == cb.rollover && tb_expected_count == cb.count)
			$info("Case %0d:: PASSED", tb_test_num);
		else // Test case failed
			$error("Case %0d:: FAILED", tb_test_num);
		// De-assert reset for a cycle
		cb.n_rst <= 1'b1;
		@cb;

		// Test 2: Check for clear
		tb_test_num = tb_test_num + 1;
		cb.n_rst <= 1'b1;

		tb_expected_rollover 	= 1'b0;
		tb_expected_count 	= 0;
		tb_count_enable		= 1;
		@cb
		@cb
		@cb
		@cb
		@cb
		@cb
		tb_clear		= 0;

		@cb; // Measure slightly before the second clock edge
		if (tb_expected_rollover == cb.rollover && tb_expected_count == cb.count)
			$info("Case %0d:: PASSED", tb_test_num);
		else // Test case failed
			$error("Case %0d:: FAILED", tb_test_num);
		// De-assert reset for a cycle
		cb.n_rst <= 1'b1;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
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

