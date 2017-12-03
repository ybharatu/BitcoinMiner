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
	reg [15:0][15:0]tb_hash;
	reg tb_write_fifo;
	reg [15:0]tb_write_data; 
	integer i;

	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output  n_rst = tb_n_rst,
			hash = tb_hash,
			write_fifo = tb_write_fifo;
		input	write_data = tb_write_data;
	endclocking

	PD_hash_separation DUT (.clk(tb_clk), .n_rst(tb_n_rst), .hash(tb_hash), .write_fifo(tb_write_fifo), .write_data(tb_write_data));

	initial
	begin
		tb_n_rst = 1'b0;
		tb_hash =  {32'hf20015ad,32'hb410ff61,32'h96177a9c,32'hb00361a3,
				32'h5dae2223,32'h414140de,32'h8f01cfea,32'hba7816bf};
		tb_write_data <= '0;
		tb_write_fifo <= 1'b0;
		@cb;
		tb_n_rst = 1'b1;
		@cb;
	
		tb_write_fifo <= 1'b1;
		for(i = 0; i < 17; i = i + 1) begin
			tb_test_num = tb_test_num + 1;
			#CHECK_DELAY;	 	
			if (i < 16) begin
				if (tb_write_data == tb_hash[i])
					$info("Test Case %d Passed REG",tb_test_num);
				else
					$info("Test Case %d Failed REG",tb_test_num);				
				
			end
			else begin
				if (tb_write_data == 16'b0101010000000000)
					$info("Test Case %d Passed SYNC",tb_test_num);
				else
					$info("Test Case %d Failed SYNC",tb_test_num);				
			end	
			@cb;
			#CHECK_DELAY;		
		end
	end
endmodule
