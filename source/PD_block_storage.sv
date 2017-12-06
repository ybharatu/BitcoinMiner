// $Id: $
// File name:   block_storage.sv
// Created:     11/26/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: 640 bit block storage for the block header
module PD_block_storage
(
	input i_data_en,
	input [7:0] i_data,
	input [6:0] i_data_sel, //address of data being stored
	input clk,
	input increment,
	output wire [63:0][7:0] chunk_1,
	output wire [15:0][7:0] chunk_2,
	output wire [31:0][7:0] difficulty
	
);

reg [111:0][7:0] storage;
reg [111:0] write_en;

always_ff @ (posedge clk) begin
	integer j;
	for(j = 0; j < 112; j = j + 1)begin
		
		if(write_en[j] == 1)
			storage[j][7:0] <= i_data[7:0];
		else
			storage[j][7:0] <= storage[j][7:0];

		
	end
	if(increment)
	begin
		storage[67:64] <= storage[67:64] + 8;
	end  
end


always_comb begin
	integer i;
	if(i_data_en) begin
		for(i = 0; i < 112; i = i + 1) begin
			if(i_data_sel == i) begin
				//assert(i_data_sel == i)
				//	$info("Block storage Decoder detects row %d", i);
				write_en[i] = 1'b1;
			end
			else begin
				write_en[i] = 1'b0;
			end
		end
	end
end

//Be aware of byte order and double check this with how the data is sent via USB
assign chunk_1[63:0] = storage [63:0];

//previously before increment: 
assign chunk_2[15:0] = storage [79:64];
//assign chunk_2[15:4] = storage [79:68]; // after adding increment
//assign chunk_2[3:0] = (increment) ? storage [67:64] + 1 : storage[67:64] ; // after adding increment

assign difficulty[31:0] = storage [111:80];

endmodule
