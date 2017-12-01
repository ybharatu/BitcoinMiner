// $Id: $
// File name:   tb_USB_timer_rx.sv
// Created:     12/1/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test Bench for RX Timer

`timescale 1ns / 10ps

module tb_USB_timer_rx ();

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
	integer i = 0;
	logic tb_d_edge;
	logic tb_receiving;
	logic tb_n_rst;
	logic tb_shift_enable;
	logic tb_byte_received;
	
	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		// output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output  d_edge = tb_d_edge,
			receiving = tb_receiving,
			n_rst = tb_n_rst;
		input	shift_enable = tb_shift_enable,
			byte_received = tb_byte_received;

	endclocking
	
	USB_timer_rx DUT (.clk(tb_clk), .d_edge(tb_d_edge), .receiving(tb_receiving), .n_rst(tb_n_rst), .shift_enable(tb_shift_enable), .byte_received(tb_byte_received));
	
	task send_bit;
		input data;
	begin	
		cb.d_edge <= data;
		#(80);
		//@(posedge tb_clk)
	end
	endtask
	
	initial
	begin
		// Initial Reset Phase
		cb.n_rst <= 'b0;
		cb.d_edge <= 'b0;
		cb.receiving <= 'b0;
		@cb;
		@cb;
		// Test Case 1: No Edge detects for 8 Cycles ( Shift enable should not be asserted on 7th cycle due to account for bit stuffing)
		tb_test_num = tb_test_num + 1;
		cb.receiving <= 'b1;
		cb.n_rst <= 'b1;
		#(800);
		// Test Case 2: Continous Edge detects ( Shift enable should assert every 8 clock cycles )
		tb_test_num = tb_test_num + 1;
		cb.d_edge <= 1;
		#(800);
		// Test Case 3: Receiving Turned off
		tb_test_num = tb_test_num + 1;
		cb.receiving <= 'b0;
		// Test Case 4: Varying Transitions
		tb_test_num = tb_test_num + 1;
		cb.receiving <= 'b1;
		send_bit(0);
		send_bit(0);
		send_bit(0);
		send_bit(0);
		send_bit(0);
		send_bit(0);
		send_bit(1);
		send_bit(1);
		send_bit(0);
		
	end

endmodule
