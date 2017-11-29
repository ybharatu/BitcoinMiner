// $Id: $
// File name:   tb_USB_transceiver_selector.sv
// Created:     11/28/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test Bench for USB transceiver selector

`timescale 1ns / 10ps

module tb_USB_transceiver_selector ();

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
	logic tb_d_minus_out;
	logic tb_d_plus_out;
	logic tb_receiving;
	logic tb_d_minus_in;
	logic tb_d_plus_in;
	logic output_val_plus;
	logic output_val_minus;
	wire tb_d_minus;
	wire tb_d_plus;
	integer i = 0;

	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		// output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output  d_minus_out = tb_d_minus_out,
			d_plus_out = tb_d_plus_out,
			receiving = tb_receiving;
		input	minus_in = tb_d_minus_in,
			plus_in = tb_d_plus_in;
	endclocking

	USB_transceiver_selector DUT(.d_minus_out(tb_d_minus_out), .d_plus_out(tb_d_plus_out), .receiving(tb_receiving), 
		.d_minus_in(tb_d_minus_in), .d_plus_in(tb_d_plus_in), .d_minus(tb_d_minus), .d_plus(tb_d_plus));
	
	assign tb_d_plus = (tb_receiving == 'b1) ? output_val_plus : 'bz;
	assign tb_d_minus = (tb_receiving == 'b1) ? output_val_minus : 'bz;

	initial
	begin
		@cb;
		@cb;
		tb_test_num = tb_test_num + 1;
		// Test Case 1 Writing to data bus
		cb.receiving <= 'b0;
		cb.d_minus_out <= 'b0;
		cb.d_plus_out <= 'b1;
		@cb;
		cb.d_minus_out <= 'b1;
		cb.d_plus_out <= 'b0;
		@cb;
		cb.d_minus_out <= 'b0;
		cb.d_plus_out <= 'b1;
		@cb;
		cb.d_minus_out <= 'b0;
		cb.d_plus_out <= 'b1;
		@cb;
		cb.receiving <= 'b1;
		// Test Case 2 Reading from bus
		tb_test_num = tb_test_num + 1;
		output_val_plus <= 'b1;
		output_val_minus <= 'b0;
		cb.d_minus_out <= 'b1;
		cb.d_plus_out <= 'b0;
		@cb;
		output_val_plus <= 'b0;
		output_val_minus <= 'b1;
		@cb;
		output_val_plus <= 'b1;
		output_val_minus <= 'b0;
		@cb;
		output_val_plus <= 'b0;
		output_val_minus <= 'b1;
		@cb;
		// Test Case 3 Writing after reading
		tb_test_num = tb_test_num + 1;
		cb.receiving <= 'b0;
		cb.d_minus_out <= 'b0;
		cb.d_plus_out <= 'b1;
		@cb;
		cb.d_minus_out <= 'b0;
		cb.d_plus_out <= 'b1;
		@cb;
		cb.d_minus_out <= 'b1;
		cb.d_plus_out <= 'b0;
		@cb;
		cb.d_minus_out <= 'b0;
		cb.d_plus_out <= 'b1;
		@cb;
		cb.d_minus_out <= 'b1;
		cb.d_plus_out <= 'b0;
		@cb;
	end
endmodule
