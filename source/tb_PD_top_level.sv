// $Id: $
// File name:   tb_PD_top_level.sv
// Created:     12/4/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Top Level Test bench for packet decoder
`timescale 1ns/10ps
`define IN_PID 		8'b01101001
`define OUT_PID 	8'b11100001
`define DATA0		8'b11000011
`define DATA1 		8'b01001011
`define INTERRUPT 	8'b00000000
`define HASH		8'b00000000
`define CORRECT_ADDRESS 7'b1100001

module tb_PD_top_level ();
	
	localparam	CLK_PERIOD = 10;
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
	logic tb_write_enable;
	logic [7:0] tb_rx_data;
	logic tb_eop;
	logic [1:0] tb_hash_select;
	logic tb_increment;
	logic [511:0] tb_data_to_hash;
	logic tb_p_error;
	logic tb_host_ready;
	logic [255:0] tb_difficulty;
	logic tb_new_block;
	logic tb_r_enable;

	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output  write_enable = tb_write_enable,
			rx_data = tb_rx_data,
			eop = tb_eop,
			hash_select = tb_hash_select,
			increment = tb_increment;
		input	data_to_hash = tb_data_to_hash,
			p_error = tb_p_error,
			host_ready = tb_host_ready,
			difficulty = tb_difficulty,
			new_block = tb_new_block,
			r_enable = tb_r_enable;
	endclocking
	
	PD_top_level PD_TOP_LEVEL (.clk(tb_clk), .n_rst(tb_n_rst), .write_enable(tb_write_enable), .rx_data(tb_rx_data), .eop(tb_eop), .hash_select(tb_hash_select), .increment(tb_increment), 
					.data_to_hash(tb_data_to_hash), .p_error(tb_p_error), .host_ready(tb_host_ready), .difficulty(tb_difficulty), .new_block(tb_new_block), .r_enable(tb_r_enable));

	initial
	begin	
		//RESET
		cb.n_rst <= 'b0;
		@cb;
		cb.n_rst <= 'b1;
		@cb;
		
		//READING IN_PID
		cb.write_enable <= 'b1;
		@cb;
		cb.rx_data <= `IN_PID;
		@cb;
		@cb;
		cb.write_enable <= 'b1;
		@cb;
		cb.rx_data <= `CORRECT_ADDRESS;
		@cb;
		cb.eop <= 'b1;
		@cb;
		@cb;

		//READING OUT_PID
		cb.write_enable <= 'b1;
		@cb;
		cb.rx_data <= `OUT_PID;
		@cb;
		cb.write_enable <= 'b1;
		@cb;
		cb.write_enable <= 'b1;
		@cb;
		cb.rx_data <= `CORRECT_ADDRESS;
		@cb;
		@cb;
		cb.eop <= 'b1;
		@cb;

		//READING DATA0 w/ INTERRUPT
		cb.write_enable <= 'b1;
		@cb;
		cb.rx_data <= `DATA0;
		@cb;	
		@cb;
		cb.write_enable <= 'b1;
		@cb;
		cb.rx_data <= `INTERRUPT;
		@cb;

		//READING DATA0 w/o INTERRUPT
		cb.write_enable <= 'b1;
		@cb;
		cb.rx_data <= `DATA0;
		@cb;	
		@cb;
		cb.write_enable <= 'b1;
		@cb;
		cb.rx_data <= `HASH;
		@cb;
		cb.write_enable <= 'b1;
		@cb;
		for(int i = 0; i < 63; i=i+1)
		begin
			cb.rx_data <= i;
			@cb;
			@cb;
			@cb;
			cb.write_enable <= 1;
			@cb;
			
		end
		//@(posedge packet_done);
		@cb;
		@cb;
		@cb;
		for(int i = 0; i < 63; i=i+1)
		begin
			if(cb.data_to_hash[i] != i)
			begin
				$error("DATA0 is invalid. Expected: %d Acutal: %d", i, data_to_hash[i]);
			end
		end
		
		//READING DATA1
		cb.write_enable <= 'b1;
		@cb;
		cb.rx_data <= `DATA1;
		@cb;	
		@cb;
		cb.write_enable <= 'b1;
		@cb;
		for(int i = 0; i < 63; i=i+1)
		begin
			cb.rx_data <= i;
			@cb;
			@cb;
			@cb;
			cb.write_enable <= 1;
			@cb;
			
		end
		@(posedge cb.new_block);
		for(int i = 0; i < 63; i=i+1)
		begin
			if(cb.data_to_hash[i] != i)
			begin
				$error("DATA0 is invalid. Expected: %d Acutal: %d", i, data_to_hash[i]);
			end
		end
	end

endmodule



