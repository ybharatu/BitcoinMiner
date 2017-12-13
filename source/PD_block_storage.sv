// $Id: $
// File name:   block_storage.sv
// Created:     11/26/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: 896 bit block storage for the block header and the target difficulty. Also increments the nonce value in storage
module PD_block_storage
(
	input i_data_en,
	input [7:0] i_data,
	input [6:0] i_data_sel, //address of data being stored
	input clk,
	input n_rst,
	input increment,
	output wire [63:0][7:0] chunk_1,
	output wire [15:0][7:0] chunk_2,
	output wire [31:0][7:0] difficulty
	
);

reg [111:0][7:0] storage;
reg [111:0][7:0] storage_next;
reg [111:0] write_en;
reg [3:0][7:0] flipped;
reg [3:0][7:0] flipped_increment;
reg [3:0][7:0] unflipped;

always_ff @ (posedge clk) begin
	/*if(n_rst == 0)
		storage <= 'b0;
	else
	*/	storage <= storage_next;
end

always_comb begin
	integer j;
	for(j = 0; j < 112; j = j + 1)begin
		if(write_en[j] == 1)
			storage_next[j][7:0] = i_data[7:0];
		else
			storage_next[j][7:0] = storage[j][7:0];
	end
	if(increment)
	begin
		storage_next[79:76] = storage[79:76] + 1;
	end  
end

//flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP (storage[79:76], flipped[3:0]);

//assign flipped_increment = flipped + 1;

//flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) UNFLIP (flipped_increment[3:0], unflipped[3:0]);

always_comb begin
	integer i;
	if(i_data_en) begin
		for(i = 0; i < 112; i = i + 1) begin
			if(i_data_sel == i) begin
				write_en[i] = 1'b1;
			end
			else begin
				write_en[i] = 1'b0;
			end
		end
	end
	else begin
		write_en = 'b0;
	end
end

//Be aware of byte order and double check this with how the data is sent via USB
genvar i;
generate
	for(i = 0; i < 63; i = i + 4) begin	
		flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_CHUNK_1 (storage[i +: 4], chunk_1[i +: 4]); // Chunk_1 32 bit endian flipped
	end
endgenerate

generate
	for(i = 0; i < 16; i = i + 4) begin	
		flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_CHUNK_2 (storage[(i + 64) +: 4], chunk_2[i +: 4]); // Chunk_1 32 bit endian flipped
	end
endgenerate

		flip_endian #(.LENGTH(256), .FLIP_LENGTH(8)) FLIP_DIFF (storage[111:80], difficulty[31:0]); // Chunk_1 32 bit endian flipped



endmodule
