// $Id: $
// File name:   tb_USB_tx_top_level.s
// Created:     12/2/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Top Level Test bench for USB TX

`timescale 1ns / 10ps


module tb_USB_tx_top_level ();

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
	logic tb_n_rst;
	logic [15:0] tb_tx_data;
	logic tb_transmit_empty;
	logic tb_transmit_start;
	logic tb_d_plus_out;
	logic tb_d_minus_out;
	logic tb_read_enable;
	logic tb_tx_error;

	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output  
			[15:0] tx_data = tb_tx_data,
			transmit_empty = tb_transmit_empty,
			transmit_start = tb_transmit_start;
		input	d_plus_out = tb_d_plus_out,
			d_minus_out = tb_d_minus_out,
			read_enable = tb_read_enable,
			tx_error = tb_tx_error;

	endclocking
	
	USB_tx_top_level TOP_LEVEL (.clk(tb_clk), .n_rst(tb_n_rst), .tx_data(tb_tx_data), .transmit_empty(tb_transmit_empty), .transmit_start(tb_transmit_start), .d_plus_out(tb_d_plus_out), 
		.d_minus_out(tb_d_minus_out), .read_enable(tb_read_enable), .tx_error(tb_tx_error));

	initial
	begin
		// Initial Reset
		tb_n_rst = 'b0;
		cb.tx_data <= 'b0;
		cb.transmit_empty <= 'b0;
		cb.transmit_start <= 'b0;
		@cb;
		@cb;
		cb.n_rst <= 'b1;
		@cb;
	
	end


endmodule
