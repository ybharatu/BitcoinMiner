// $Id: $
// File name:   tb_HM_SHA_256.sb
// Created:     11/15/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: SHA test bench

`timescale 1ns / 10ps

module tb_HM_SHA_256 ();


	// Define parameters
	// basic test bench parameters
	localparam	CLK_PERIOD	= 10;
	localparam	CHECK_DELAY 	= 2; // Check 1ns after the rising edge to allow for propagation delay
	
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
	reg tb_n_rst;
	reg tb_clear;
	reg tb_halt;
	reg tb_init;
	reg tb_out_load;
	reg [15:0][31:0] tb_data;
	reg [6:0] tb_count;
	reg [19:0][31:0] check_data;
//	reg [19:0][31:0] flip_check_data;
//	reg [19:0][31:0] flip_check_data_32;

	reg [31:0][31:0] converted_check_data;
	reg [15:0][31:0] converted_check_data_1;
	reg [15:0][31:0] converted_check_data_2;

	reg [7:0][31:0] tb_out_hash;

	reg [7:0][31:0] expected_1 = {32'hf20015ad,32'hb410ff61,32'h96177a9c,32'hb00361a3,
				      32'h5dae2223,32'h414140de,32'h8f01cfea,32'hba7816bf};

	reg [7:0][31:0] expected_2 = {32'h19DB06C1,32'hF6ECEDD4,32'h64FF2167,32'hA33CE459,
				      32'h0C3E6039,32'hE5C02693,32'hD20638B8,32'h248D6A61};	

	reg [7:0][31:0] expected_3 = {256'h000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506};   
	
	reg [15:0][31:0] data_1 = {32'h00000018,32'h00000000,32'h00000000,32'h00000000,
				   32'h00000000,32'h00000000,32'h00000000,32'h00000000,
				   32'h00000000,32'h00000000,32'h00000000,32'h00000000,
				   32'h00000000,32'h00000000,32'h00000000,32'h61626380 };

	reg [15:0][31:0] data_2 = {32'h00000000,32'h80000000,32'h6E6F7071,32'h6D6E6F70,
				   32'h6C6D6E6F,32'h6B6C6D6E,32'h6A6B6C6D,32'h696A6B6C,
				   32'h68696A6B,32'h6768696A,32'h66676869,32'h65666768,
				   32'h64656667,32'h63646566,32'h62636465,32'h61626364};

	reg [0:15][31:0] data_3 = {32'h000001C0,32'h00000000,32'h00000000,32'h00000000,
				   32'h00000000,32'h00000000,32'h00000000,32'h00000000,
				   32'h00000000,32'h00000000,32'h00000000,32'h00000000,
				   32'h00000000,32'h00000000,32'h00000000,32'h00000000 };


	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output halt = tb_halt,
			clear = tb_clear,
			count = tb_count,
			data = tb_data,
			init = tb_init,
			load = tb_out_load;
		input out_hash = tb_out_hash;
			
	endclocking

	HM_SHA_256 DUT (.n_rst(tb_n_rst), .clk(tb_clk), .halt(tb_halt),
			.clear(tb_clear), .data(tb_data), .count(tb_count), .out_hash(tb_out_hash), .init(tb_init), .out_load(tb_out_load)); 

	task get_formatted_data;
		input [639:0] data;
		output [1023:0] converted;
	begin 
		converted = '0;
		converted[1023:384] = data;
		converted[383] = 1'b1;
		converted[63:0] = 64'd640;
	end
	endtask

	task flip_endian;
	parameter length = 640;
	parameter flip_length = 8;
		input [length - 1:0] data;
		output [length - 1:0] flipped;
	
	begin
		integer j;
		integer k;
		for (j = 0; j < length; j = j + flip_length) begin
			for (k = 0; k < flip_length; k = k + 1) begin
				flipped[j+k] = data[length-flip_length-j+k];
				$info("k: %0d opp: %0d", k, length-flip_length-j+k);
				flipped[length-flip_length-j+k] = data[k+j];
			end
		end
	end
	endtask

	task flip_endian_32;
	parameter length = 512;
	parameter flip_length = 32;
		input [length - 1:0] data;
		output [length - 1:0] flipped;
	
	begin
		integer j;
		integer k;
		for (j = 0; j < length; j = j + flip_length) begin
			for (k = 0; k < flip_length; k = k + 1) begin
				flipped[j+k] = data[length-flip_length-j+k];
				$info("k: %0d opp: %0d", k, length-flip_length-j+k);
				flipped[length-flip_length-j+k] = data[k+j];
			end
		end
	end
	endtask
	
	task wait_hash;
	begin
		integer w;
		count = 0;
		for(w = 0; w < 64; w = w + 1) begin
			cb.count <= count;
			@cb;
			count = count + 1;
		end
	end
	endtask

	initial
	begin
	
	//Test 0: n_rst test
 	tb_n_rst 	= 1'b0;
	tb_clear	= 1'b1;
	tb_data 	= 512'b0;
	tb_count	= 7'b0;
	tb_halt		= 1'b1;
	tb_data		= data_1;
	tb_init		= 1'b0;
	tb_out_load		= 1'b0;
	check_data = '0;
	check_data = 640'h0100000050120119172a610421a6c3011dd330d9df07b63616c2cc1f1cd00200000000006657a9252aacd5c0b2940996ecff952228c3067cc38d4885efb5a4ac4247e9f337221b4d4c86041b0f2b5710;
	//check_data[7:0] = 8'd14;
	//flip_endian(check_data, flip_check_data);
	//flip_endian_32(check_data,flip_check_data_32);
	get_formatted_data(check_data, converted_check_data);

	flip_endian_32(converted_check_data[31:16], converted_check_data_1);
	flip_endian_32(converted_check_data[15:0], converted_check_data_2);

	@cb;

	if (tb_out_hash == 512'b0)
		$info("Case %0d:: PASSED", tb_test_num);
	else // Test case failed
		$error("Case %0d:: FAILED", tb_test_num);

	//Test 1: reset off calculate a hash
	
	cb.n_rst <= 1'b1;
	@cb;
	@cb;
	cb.init <= 1;
	@cb;
	cb.init <= 0;
	@cb;
	@cb;
	@cb;
	cb.halt <= 0;
	cb.clear <= 1; 

	wait_hash(); //Run 64 clocks
	cb.load <= 1;
	@cb;
	cb.load <= 0;
	cb.halt <= 1;
	#CHECK_DELAY

	if( tb_out_hash == expected_1)
		$info("HOLY SHIT IT WORKS");
	else
		$error("To be expected");

	//Test 2: 2- Chunk Block

	@cb;
	@cb;
	@cb;
	cb.data <= data_2;
	cb.init <= 1;
	@cb;
	cb.init <= 0;
	@cb;
	cb.halt <= 0;
	cb.clear <= 1;

	wait_hash(); //Run 64 clocks
	//@cb; //Wait one clock then check
	cb.halt <= 1;
	cb.load <= 1;
	@cb;
	cb.load <= 0;
	cb.clear <= 0;
	cb.init <= 1;
	@cb;
	cb.halt <= 0;
	cb.data <= data_3;
	cb.init <= 0;
	wait_hash();
	cb.load <= 1;
	@cb;
	cb.load <= 0;
	cb.halt <= 1;
	#CHECK_DELAY
	if( tb_out_hash == expected_2)
		$info("HOLY SHIT IT WORKS");
	else
		$error("To be expected");
	end

endmodule
