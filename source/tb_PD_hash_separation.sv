// $Id: $
// File name:   tb_PD_hash_separation.sv
// Created:     12/2/2017
// Author:      Rahul Patni
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test bench for hash separation

 `timescale 1ns / 10ps

module tb_PD_hash_separation ();

	// Define parameters
	// basic test bench parameters
	localparam	CLK_PERIOD = 10; //??
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

	reg tb_n_rst;

	reg [17:0][15:0]tb_hash;
	reg tb_transmit_empty;
	reg tb_transmit_empty_en;	
	reg [7:0]tb_PID;
	reg tb_PID_en;
	reg tb_read_enable;
	reg [15:0]tb_tx_data;

	integer i;

	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output  n_rst = tb_n_rst,
			hash = tb_hash,
			transmit_empty = tb_transmit_empty,
			transmit_empty_en = tb_transmit_empty_en,
			PID = tb_PID,
			PID_en = tb_PID_en,
			read_enable = tb_read_enable;
		input	tx_data = tb_tx_data;
	endclocking

	PD_hash_separation DUT (.clk(tb_clk), .n_rst(tb_n_rst), .valid_hash(tb_hash), .transmit_empty(tb_transmit_empty), .transmit_empty_en(tb_transmit_empty_en),
				.PID(tb_PID), .PID_en(tb_PID_en), .read_enable(tb_read_enable),	.tx_data(tb_tx_data));

	initial
	begin
		//@cb;
		tb_read_enable <= 1'b0;
		@cb;
		tb_n_rst = 1'b0;
		@cb;
		tb_n_rst = 1'b1;

		//@cb;
		@cb;

		tb_hash =  {32'hf20015ad,32'hb410ff61,32'h96177a9c,32'hb00361a3,
				32'h5dae2223,32'h414140de,32'h8f01cfea,32'hba7816bf,32'hb5016bf};

		tb_tx_data <= '0;
		tb_PID <= 8'b11101100;
		tb_transmit_empty <= 1'b1;
		tb_read_enable <= 1'b0;
		tb_transmit_empty_en <= 1'b0;
		tb_PID_en <= 1'b0;
		@cb;
		@cb;
		@cb;
		tb_transmit_empty_en <= 1'b1;
		tb_PID_en <= 1'b1;
		@cb;
		tb_transmit_empty_en <= 1'b0;
		tb_PID_en <= 1'b0;
		
		//@cb;
		#CHECK_DELAY;	
		tb_read_enable <= 1'b1;
//		@cb;
		for(i = 0; i < 20; i = i + 1) begin
			tb_test_num = tb_test_num + 1;
			#CHECK_DELAY;	 
			if (i == 0) begin
				if ({8'b10000000, tb_PID} == tb_tx_data)
					$info("Test Case %d Passed SYNC",tb_test_num);
				else
					$error("Test Case %d Failed SYNC",tb_test_num);	
			end	
			else if (i == 1) begin
				if ({16'd1} == tb_tx_data)
					$info("Test Case %d Passed TRANSMIT",tb_test_num);
				else
					$error("Test Case %d Failed TRANSMIT",tb_test_num);	
			
			end
			else if (i < 20) begin
				if (tb_tx_data == tb_hash[17-(i-2)])
					$info("Test Case %d Passed REG",tb_test_num);
				else
					$info("Test Case %d Failed REG",tb_test_num);				
				
			end
			@cb;
			#CHECK_DELAY;		
		end
	end
endmodule
