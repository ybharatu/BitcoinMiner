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
	integer count = 0;
	logic tb_n_rst;
	logic [15:0] tb_tx_data;
	logic tb_transmit_empty;
	logic tb_transmit_start;
	logic tb_d_plus_out;
	logic tb_d_minus_out;
	logic tb_read_enable;
	logic tb_tx_error;
	logic eop;
	
	//logic tb_d_plus_in;
	//logic tb_d_minus_in;
	//logic tb_n_rst;
	logic tb_packet_type;
	logic [7:0] tb_rx_data;
	logic tb_write_enable;
	logic tb_rcv_error;


	always_ff @ (posedge tb_clk) begin
		eop <= !tb_d_plus_out && !tb_d_minus_out;
	end

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
	
	USB_tx_top_level TX_TOP_LEVEL (.clk(tb_clk), .n_rst(tb_n_rst), .tx_data(tb_tx_data), .transmit_empty(tb_transmit_empty), .transmit_start(tb_transmit_start), .d_plus_out(tb_d_plus_out), 
		.d_minus_out(tb_d_minus_out), .read_enable(tb_read_enable), .tx_error(tb_tx_error));
	USB_rx_top_level RX_TOP_LEVEL (.clk(tb_clk), .d_plus_in(tb_d_plus_out), .d_minus_in(tb_d_minus_out), .n_rst(tb_n_rst), .packet_type(tb_packet_type), .rx_data(tb_rx_data), 
		.write_enable(tb_write_enable), .rcv_error(tb_rcv_error));

	task wait_read;
	begin
		@(posedge tb_read_enable);
		#(1);
		if(tb_read_enable != 1)
			wait_read();
	end
	endtask

	task send_hash;
		input [255:0] hash;
	begin
		integer i;
		cb.transmit_start <= 'b1;
		cb.tx_data <= 16'b1000000011010010;
		@cb;
		@cb;
		cb.transmit_start <= 'b0;
		@cb;
		@cb;
		wait_read();
		cb.tx_data <= hash[255:240];
		wait_read();
		cb.tx_data <= hash[239:224];
		wait_read();
		cb.tx_data <= hash[223:208];
		wait_read();
		cb.tx_data <= hash[207:192];
		wait_read();
		cb.tx_data <= hash[191:176];
		wait_read();
		cb.tx_data <= hash[175:160];
		wait_read();
		cb.tx_data <= hash[159:144];
		wait_read();
		cb.tx_data <= hash[143:128];
		wait_read();
		cb.tx_data <= hash[127:112];
		wait_read();
		cb.tx_data <= hash[111:96];
		wait_read();
		cb.tx_data <= hash[95:80];
		wait_read();
		cb.tx_data <= hash[79:64];
		wait_read();
		cb.tx_data <= hash[63:48];
		wait_read();
		cb.tx_data <= hash[47:32];
		wait_read();
		cb.tx_data <= hash[31:16];
		wait_read();
		cb.tx_data <= hash[15:0];
		@(negedge eop);
		
	end
	endtask

	task send_hash_chunk;
		input [255:0] hash;
	begin
		wait_read();
		cb.tx_data <= hash[255:240];
		wait_read();
		cb.tx_data <= hash[239:224];
		wait_read();
		cb.tx_data <= hash[223:208];
		wait_read();
		cb.tx_data <= hash[207:192];
		wait_read();
		cb.tx_data <= hash[191:176];
		wait_read();
		cb.tx_data <= hash[175:160];
		wait_read();
		cb.tx_data <= hash[159:144];
		wait_read();
		cb.tx_data <= hash[143:128];
		wait_read();
		cb.tx_data <= hash[127:112];
		wait_read();
		cb.tx_data <= hash[111:96];
		wait_read();
		cb.tx_data <= hash[95:80];
		wait_read();
		cb.tx_data <= hash[79:64];
		wait_read();
		cb.tx_data <= hash[63:48];
		wait_read();
		cb.tx_data <= hash[47:32];
		wait_read();
		cb.tx_data <= hash[31:16];
		wait_read();
		cb.tx_data <= hash[15:0];
		
	end
	endtask
	


	task check_hash;
		input [255:0] data;
	begin
		integer i;
		tb_packet_type = 1;
		count = 0;
		@(posedge tb_write_enable);
		for(i = 255; i >= 0; i = i - 8)
		begin
			count = count + 1;
			@(posedge tb_write_enable);
			if(tb_rx_data != data[i -: 8])
			begin	
	
				$error("Failed Byte %d: Expected: %d, Actual: %d", count,data[i -: 8], tb_rx_data);
			end
			else
				$info("Byte %d Passed", count);
		end
		
		$info("End of test case\n");
	end
	endtask

	initial
	begin
		tb_packet_type = 1;
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
		cb.tx_data <= 16'b1000000011010010;
		@cb;
		cb.transmit_empty <= 'b0;
		wait_read();
		cb.tx_data <= 16'h0001;
		wait_read();
		cb.tx_data <= 16'h0203;
		@(negedge eop);
		#(BUS_PERIOD);

		cb.transmit_empty <= 'b1;
		cb.tx_data <= 16'b1000000011000011;
		@cb;
		@cb;
		cb.transmit_empty <= 'b0;
		wait_read();
		cb.tx_data <= 16'h2345;
		wait_read();
		cb.tx_data <= 16'h6789;
		@(negedge eop);
		#(BUS_PERIOD);

		//TEST CASE 1
		fork
			send_hash(256'h00000000000080b66c911bd5ba14a74260057311eaeb1982802f7010f1a9f090); //BE4E HASH 100001
			check_hash(256'h00000000000080b66c911bd5ba14a74260057311eaeb1982802f7010f1a9f090);
		join
		//TEST CASE 2
		fork
			send_hash(256'h000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506); //74B5 HASH 100000
			check_hash(256'h000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506);
		join
		//TEST CASE 3
		fork
			send_hash(256'h000000000002d01c1fccc21636b607dfd930d31d01c3a62104612a1719011250); //A7AA HASH 99999
			check_hash(256'h000000000002d01c1fccc21636b607dfd930d31d01c3a62104612a1719011250);
		join
		
		// transfer #1
	end


endmodule
