// $Id: $
// File name:   tb_HM_top_level.sv
// Created:     11/28/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Top Level test bench for hashing module

`timescale 1ns / 10ps

module tb_HM_top_level ();


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
				flipped[length-flip_length-j+k] = data[k+j];
			end
		end
	end
	endtask

	task get_formatted_data;
		input [639:0] data;
		output [1023:0] converted;
	begin 
		converted = '0;
		converted[1023:384] = data;
		converted[383] = 1'b1;
		converted[63:0] = 64'd640;

		flip_endian_32(converted[1023:512],converted[1023:512]);
		flip_endian_32(converted[511:0],converted[511:0]);
	end
	endtask

	reg tb_begin_hash, tb_quit_hash;
	reg [255:0] tb_difficulty;
	reg [511:0] tb_data_to_hash;
	reg tb_n_rst;
	reg tb_hash_done;
	reg tb_valid_hash_flag;
	reg [255:0] tb_valid_hash;
	reg [1:0] tb_hash_select;
	reg [19:0][31:0] real_data;
	reg [31:0][31:0] converted_data;
	reg [15:0][31:0] real_data_1;
	reg [15:0][31:0] real_data_2;

	localparam tb_chunk1 = {32'h00000000,32'h80000000,32'h6E6F7071,32'h6D6E6F70,
				32'h6C6D6E6F,32'h6B6C6D6E,32'h6A6B6C6D,32'h696A6B6C,
				32'h68696A6B,32'h6768696A,32'h66676869,32'h65666768,
				32'h64656667,32'h63646566,32'h62636465,32'h61626364};
	// Written as

	localparam tb_chunk2 = {32'h000001C0,32'h00000000,32'h00000000,32'h00000000,
				32'h00000000,32'h00000000,32'h00000000,32'h00000000,
				32'h00000000,32'h00000000,32'h00000000,32'h00000000,
				32'h00000000,32'h00000000,32'h00000000,32'h00000000 };

//	localparam tb_expected = 256'h19db06c16ecedd464ff2167a33ce4590c3e6039e5c02693d20638b8248d6a61;
	
	localparam expected_2 = {32'h19DB06C1,32'hF6ECEDD4,32'h64FF2167,32'hA33CE459,
			         32'h0C3E6039,32'hE5C02693,32'hD20638B8,32'h248D6A61};
	// Written as 248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1	

	HM_top_level HM0 (.begin_hash(tb_begin_hash), .quit_hash(tb_quit_hash), .difficulty(tb_difficulty),
		 	.data_to_hash(tb_data_to_hash), .clk(tb_clk), .n_rst(tb_n_rst), .valid_hash_flag(tb_valid_hash_flag),
			.valid_hash(tb_valid_hash), .hash_select(tb_hash_select), .hash_done(tb_hash_done));

	always_comb begin	
		if(tb_hash_select == 0)
			tb_data_to_hash = real_data_1;
		else if(tb_hash_select == 1)
			tb_data_to_hash = real_data_2;
		else
			tb_data_to_hash = real_data_1;
	end

	initial
	begin

	real_data = {640'h0100000050120119172a610421a6c3011dd330d9df07b63616c2cc1f1cd00200000000006657a9252aacd5c0b2940996ecff952228c3067cc38d4885efb5a4ac4247e9f337221b4d4c86041b0f2b5710};
	get_formatted_data(real_data, converted_data);
//	output of second hash should be    00844eeb8713eb62bc33df34ca0cfa7af2ee152a6b16788fd3f2fea69861f3c8
//	OUTPUT TOTAL should be 		   06e533fd1ada86391f3f6c343204b0d278d4aaec1c0b20aa27ba030000000000

	real_data_1 = converted_data[31:16];
	real_data_2 = converted_data[15:0];

	//flip_endian_32( converted_data[31:16], real_data_1);
	//flip_endian_32(converted_data[15:0], real_data_2);

	tb_n_rst 	= 1'b0;
	tb_begin_hash 	= 0;
	tb_quit_hash	= 0;
	tb_difficulty 	= ~(256'b0);


	@(posedge tb_clk);
	tb_n_rst = 1'b1;
	tb_begin_hash = 1;
	@(posedge tb_clk);
	#CHECK_DELAY;
	tb_begin_hash = 0;
	
	@(posedge tb_valid_hash_flag);

	//if (tb_valid_hash == tb_expected)
		//$info("IT WORKS");
	//else
	//	$error("IT DOESN'T WORK");

	end
endmodule
