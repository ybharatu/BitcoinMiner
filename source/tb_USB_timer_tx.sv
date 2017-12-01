// $Id: $
// File name:   tb_USB_timer_tx.sv
// Created:     11/30/2017
// Author:      Chinar Dhamija
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: USB Test Bench for Timer_TX

`timescale 1ns / 10ps

module tb_USB_timer_tx ();

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
	logic tb_transmitting;
	logic tb_transmit_empty;
	logic tb_byte_sent;
	logic tb_data_sent;
	logic tb_tx_shift;
	
	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output  transmitting = tb_transmitting,
			transmit_empty = tb_transmit_empty;
			//n_rst = tb_n_rst;
		input	byte_sent = tb_byte_sent,
			data_sent = tb_data_sent,
			tx_shift = tb_tx_shift;

	endclocking

	USB_timer_tx DUT (.clk(tb_clk), .n_rst(tb_n_rst), .transmitting(tb_transmitting), .transmit_empty(tb_transmit_empty), .byte_sent(tb_byte_sent), .data_sent(tb_data_sent), .tx_shift(tb_tx_shift));
	
	initial
	begin	
		// Initial Reset
		cb.n_rst <= 'b0;
		@cb;
		@cb;
		cb.n_rst <= 'b1;
		@cb;
		// Enables first flex counter for byte_sent
		cb.transmitting <= 'b1;
		#(BUS_PERIOD);
		@cb;
		// Enables second flex counter for data_sent
		cb.transmit_empty <= 'b1;
		@cb;
		cb.transmit_empty <= 'b0;
		#(BUS_PERIOD);
	end

endmodule
