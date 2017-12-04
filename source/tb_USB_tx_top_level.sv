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
	logic eop;
	
	assign eop = !tb_d_plus_out && !tb_d_minus_out;



	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output  
			tx_data = tb_tx_data,
			transmit_empty = tb_transmit_empty,
			transmit_start = tb_transmit_start;
		input	d_plus_out = tb_d_plus_out,
			d_minus_out = tb_d_minus_out,
			read_enable = tb_read_enable,
			tx_error = tb_tx_error;

	endclocking
	
	USB_tx_top_level TOP_LEVEL (.clk(tb_clk), .n_rst(tb_n_rst), .tx_data(tb_tx_data), .transmit_empty(tb_transmit_empty), .transmit_start(tb_transmit_start), .d_plus_out(tb_d_plus_out), 
		.d_minus_out(tb_d_minus_out), .read_enable(tb_read_enable), .tx_error(tb_tx_error));

	task send_hash;
		input [255:0] hash;
	begin
		integer i;
		cb.transmit_start <= 'b1;
		cb.tx_data <= 16'b0101010011010010;
		@cb;
		@cb;
		cb.transmit_start <= 'b0;
		@cb;
		@cb;
		@(posedge tb_read_enable);
		cb.tx_data <= hash[255:240];
		@(posedge tb_read_enable);
		cb.tx_data <= hash[239:224];
		@(posedge tb_read_enable);
		cb.tx_data <= hash[223:208];
		@(posedge tb_read_enable);
		cb.tx_data <= hash[207:192];
		@(posedge tb_read_enable);
		cb.tx_data <= hash[191:176];
		@(posedge tb_read_enable);
		cb.tx_data <= hash[175:160];
		@(posedge tb_read_enable);
		cb.tx_data <= hash[159:144];
		@(posedge tb_read_enable);
		cb.tx_data <= hash[143:128];
		@(posedge tb_read_enable);
		cb.tx_data <= hash[127:112];
		@(posedge tb_read_enable);
		cb.tx_data <= hash[111:96];
		@(posedge tb_read_enable);
		cb.tx_data <= hash[95:80];
		@(posedge tb_read_enable);
		cb.tx_data <= hash[79:64];
		@(posedge tb_read_enable);
		cb.tx_data <= hash[63:48];
		@(posedge tb_read_enable);
		cb.tx_data <= hash[47:32];
		@(posedge tb_read_enable);
		cb.tx_data <= hash[31:16];
		@(posedge tb_read_enable);
		cb.tx_data <= hash[15:0];
		@(posedge eop);
		
	end
	endtask

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
		cb.transmit_empty <= 'b1;
		cb.tx_data <= 16'b0101010011010010;
		@cb;
		cb.transmit_empty <= 'b0;
		@(posedge tb_read_enable);
		cb.tx_data <= 16'h0001;
		@(posedge tb_read_enable);
		cb.tx_data <= 16'h0203;
		@(posedge eop);

		cb.transmit_empty <= 'b1;
		cb.tx_data <= 16'b0101010011000011;
		@cb;
		@cb;
		cb.transmit_empty <= 'b0;
		@(posedge tb_read_enable);
		cb.tx_data <= 16'h2345;
		@(posedge tb_read_enable);
		cb.tx_data <= 16'h6789;
		@(posedge eop);

		send_hash(256'h00000000000080b66c911bd5ba14a74260057311eaeb1982802f7010f1a9f090); //BE4E HASH 100001

		send_hash(256'h000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506); //74B5 HASH 100000

		send_hash(256'h000000000002d01c1fccc21636b607dfd930d31d01c3a62104612a1719011250); //A7AA HASH 99999

		
		
	
	end


endmodule
