// $Id: $
// File name:   tb_USB_rx_controller.sv
// Created:     12/1/2017
// Author:      Chinar Dhamija
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: USB Test Bench for Controller_RX

`timescale 1ns / 10ps

module tb_USB_rx_controller ();

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
	logic tb_shift_enable;
	logic tb_byte_received;
	logic [0:15] tb_rx_data;
	logic tb_eop;
	logic tb_crc_chk;
	logic tb_d_edge;
	logic tb_receiving;
	logic tb_write_enable;
	logic tb_error;

	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		// output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output  shift_enable = tb_shift_enable,
			byte_received = tb_byte_received,
			rx_data = tb_rx_data,
			eop = tb_eop,
			crc_chk = tb_crc_chk,
			d_edge = tb_d_edge,
			n_rst = tb_n_rst;
		input	receiving = tb_receiving,
			write_enable = tb_write_enable,
			error = tb_error;

	endclocking

	USB_rx_controller DUT (.clk(tb_clk), .n_rst(tb_n_rst), .shift_enable(tb_shift_enable), .byte_received(tb_byte_received), .rx_data(tb_rx_data), .eop(tb_eop), .crc_chk(tb_crc_chk), .d_edge(tb_d_edge), .receiving(tb_receiving), .write_enable(tb_write_enable), .error(tb_error));
	
	initial
	begin	
		// Initial Reset
		cb.n_rst <= 'b0;
		@cb;
		cb.n_rst <= 'b1;
		@cb;
		//
	end

endmodule
