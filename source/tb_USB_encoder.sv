// $Id: $
// File name:   tb_USB_encoder.sv
// Created:     11/29/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test Bench for USB encoder

`timescale 1ns / 10ps

module tb_USB_encoder ();

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
	logic tb_tx_out_bit;
	logic tb_create_eop;
	logic tb_tx_hold;
	logic tb_d_plus_out;
	logic tb_d_minus_out;
	logic tb_tx_shift;
	
	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		// output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output  tx_out_bit = tb_tx_out_bit,
			create_eop = tb_create_eop,
			n_rst = tb_n_rst,
			tx_shift = tb_tx_shift;
		input	d_orig = tb_tx_hold,
			d_plus_out = tb_d_plus_out,
			d_minus_out = tb_d_minus_out;

	endclocking

	USB_encoder DUT (.clk(tb_clk), .n_rst(tb_n_rst), .tx_out_bit(tb_tx_out_bit), .create_eop(tb_create_eop),.tx_shift(tb_tx_shift), .tx_hold(tb_tx_hold), .d_plus_out(tb_d_plus_out), .d_minus_out(tb_d_minus_out));
	
	task send_bit;
		input data;
	begin	
		cb.tx_out_bit <= data;
		@(posedge tb_clk)
		tb_tx_shift <= 'b1;
		@(posedge tb_clk)
		tb_tx_shift <= 'b0;
		#(BUS_PERIOD);
	end
	endtask
	
	initial
	begin
		
	// Initial Reset
	cb.n_rst <= 'b0;
	cb.tx_out_bit <= 'b0;
	cb.create_eop <= 'b0;
	@cb;
	@cb;
	cb.n_rst <= 'b1;
	@cb;
	// Checks Bit stuffing
	send_bit(1);
	send_bit(1);
	send_bit(1);
	send_bit(1);
	send_bit(1);
	send_bit(1);
	send_bit(1);
	send_bit(1);
	send_bit(1);
	send_bit(1);
	send_bit(0);
	send_bit(0);
	send_bit(1);
	send_bit(0);
	send_bit(1);
	send_bit(1);
	cb.create_eop <= 'b1;
	@cb;
	@cb;
	cb.create_eop <= 'b0;
	tb_tx_shift <= 'b1;
	@cb;
	@cb;
	tb_tx_shift <= 'b0;
	#(BUS_PERIOD);
	@cb;
	@cb;
	tb_tx_shift <= 'b1;
	@cb;
	@cb;
	tb_tx_shift <= 'b0;
	#(BUS_PERIOD);
	send_bit(1);
	send_bit(1);
	send_bit(1);
	send_bit(1);
	send_bit(1);
	send_bit(1);
	send_bit(1);
	

	end

endmodule
