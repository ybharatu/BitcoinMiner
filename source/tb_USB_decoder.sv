// $Id: $
// File name:   tb_USB_decoder.sv
// Created:     11/28/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test Bench for USB decoder

`timescale 1ns / 10ps

module tb_USB_decoder ();

	localparam	CLK_PERIOD = 10; //??
	localparam	BUS_PERIOD = 80;
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
	logic tb_d_plus_sync;
	logic tb_shift_enable;
	logic tb_eop;
	logic tb_n_rst;
	logic tb_d_orig;
 	integer i = 0;

	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		// output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output  d_plus_sync = tb_d_plus_sync,
			shift_enable = tb_shift_enable,
			eop = tb_eop,
			n_rst = tb_n_rst;
		input	d_orig = tb_d_orig;

	endclocking

	USB_decoder DUT (.clk(tb_clk), .d_plus_sync(tb_d_plus_sync), .shift_enable(tb_shift_enable), .eop(tb_eop), .n_rst(tb_n_rst), .d_orig(tb_d_orig));
	
	task send_bit;
		input data;
	begin		
		cb.d_plus_sync <= data;
		@(posedge tb_clk)
		tb_shift_enable <= 'b1;
		@(posedge tb_clk)
		tb_shift_enable <= 'b0;
		@(posedge tb_clk)
		#(BUS_PERIOD);
		
	end
	endtask

	task send_bit_noshift;
		input data;
	begin	
		cb.d_plus_sync <= data;
		#(BUS_PERIOD);
		
	end
	endtask

	initial
	begin
		// Initial Reset
		cb.n_rst <= 'b0;
		@(posedge tb_clk);
		@(posedge tb_clk);
		// Test Case 1: Shift Enable = 1 and eop = 0 
		tb_test_num = tb_test_num + 1;
		cb.n_rst <= 'b1;
		cb.shift_enable <= 'b0;
		cb.eop <= 'b0;
		send_bit(1);
		send_bit(0);
		send_bit(1);
		cb.eop <= 'b0;
		send_bit(1);
		send_bit(0);
		send_bit(1);
		send_bit(0);
		send_bit(0);
		send_bit(0);
		// Test Case 2: Shift Enable = 0 and eop = 0
		tb_test_num = tb_test_num + 1;
		send_bit_noshift(1);
		send_bit_noshift(0);
		send_bit_noshift(0);
		send_bit_noshift(1);
		send_bit_noshift(0);

	
	end
		

endmodule
