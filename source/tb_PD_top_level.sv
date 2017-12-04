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


module tb_PD_top_level
	
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

	

	



endmodule
