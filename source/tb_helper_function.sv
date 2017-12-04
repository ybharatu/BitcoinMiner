// $Id: $
// File name:   tb_helper_function.sv
// Created:     12/3/2017
// Author:      Rahul Patni
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test Bench with Helper Functions

//===============++++++++++++++++==========================//

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

//===============++++++++++++++++==========================//

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

//===============++++++++++++++++==========================//

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

//===============++++++++++++++++==========================//
