// $Id: $
// File name:   tb_USB_tx_controller.sv
// Created:     12/1/2017
// Author:      Chinar Dhamija
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: USB Test Bench for Controller_TX

`timescale 1ns / 10ps

module tb_USB_tx_controller ();

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
	logic tb_transmit_empty;
	logic tb_byte_sent;
	logic tb_data_sent;
	logic tb_crc_sent;
	logic tb_tx_hold;
	logic tb_transmit_start;
	logic tb_read_enable;
	logic tb_load_enable;
	logic tb_tx_enable;
	logic tb_crc_enable;
	logic tb_transmitting;
	logic tb_create_eop;

	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		// output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output  transmit_empty = tb_transmit_empty,
			data_sent = tb_data_sent,
			byte_sent = tb_byte_sent,
			crc_sent = tb_crc_sent,
			tx_hold = tb_tx_hold,
			transmit_start = tb_transmit_start,
			n_rst = tb_n_rst;
		input	read_enable = tb_read_enable,
			load_enable = tb_load_enable,
			tx_enable = tb_tx_enable,
			crc_enable = tb_crc_enable,
			transmitting = tb_transmitting,
			create_eop = tb_create_eop;

	endclocking

	USB_tx_controller DUT (.clk(tb_clk), .n_rst(tb_n_rst), .transmit_empty(tb_transmit_empty), .byte_sent(tb_byte_sent), .data_sent(tb_data_sent), .crc_sent(tb_crc_sent), .tx_hold(tb_tx_hold), .transmit_start(tb_transmit_start), .read_enable(tb_read_enable), .load_enable(tb_load_enable), .tx_enable(tb_tx_enable), .crc_enable(tb_crc_enable), .transmitting(tb_transmitting), .create_eop(tb_create_eop));
	
	initial
	begin	
		// Initial Reset
		cb.n_rst <= 'b0;
		@cb;
		cb.n_rst <= 'b1;
		@cb;
/*		// Enables first flex counter for byte_sent
		cb.transmitting <= 'b1;
		@cb;
		cb.transmitting <= 'b0;
		#(BUS_PERIOD);
		@cb;
		// Enables second flex counter for data_sent
		cb.transmit_start <= 'b1;
		@cb;
		cb.transmit_start <= 'b0;
		#(BUS_PERIOD);
*/
	end

endmodule
