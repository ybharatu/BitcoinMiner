// $Id: $
// File name:   tb_USB_crc_16.sv
// Created:     12/1/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test Bench for crc16
`timescale 1ns / 10ps

module tb_USB_crc_16 ();

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
	logic tb_n_rst;
	logic tb_clear;
	logic tb_shift_enable;
	logic tb_d_orig;
	logic tb_crc_check_16;

	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		// output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output  n_rst = tb_n_rst,
			clear = tb_clear,
			shift_enable = tb_shift_enable,
			d_orig = tb_d_orig;
		input	crc_check_16 = tb_crc_check_16;

	endclocking

	USB_crc_16 DUT (.clk(tb_clk), .n_rst(tb_n_rst), .clear(tb_clear), .shift_enable(tb_shift_enable), .d_orig(tb_d_orig), .crc_check_16(tb_crc_check_16));

	task send_bit;
		input data;
	begin
		cb.d_orig <= data;
		@cb;
	end
	endtask

	task send_data;
		input [15:0] data;
	begin
		integer i;
		for(i = 15; i >= 0; i = i - 1) begin
			send_bit(data[i]);
		end
	end
	endtask;

	initial
	begin
		cb.n_rst <= 0;
		cb.clear <= 0;
		cb.shift_enable <= 0;
		cb.d_orig <= 0;
		@cb;
		@cb;
		cb.n_rst <= 1;
		@cb;
		cb.shift_enable <= 1;
		send_data(16'b0000000010000000);
		send_data(16'b0100000011000000);
		send_data(16'b1111011101011110);
		
		if(tb_crc_check_16 == 1)
			$info("GO0D JOB");
		else
			$error("FAILED");
		
	end

endmodule
