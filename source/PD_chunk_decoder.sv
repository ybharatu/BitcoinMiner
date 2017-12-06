// $Id: $
// File name:   chunk_decoder.sv
// Created:     11/26/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Check decoder in Packet Decoder
module PD_chunk_decoder
(
	input [1:0] hash_select,
	input [511:0] chunk_1,
	input [127:0] chunk_2,
	// input new_block, idk if we need this
	output wire [511:0] data_to_hash
);

logic [511:0]data;
//logic [511:0]flipped_data;

assign data_to_hash = data;

always_comb
begin
	if(hash_select == 0) begin
		data = chunk_1;
	end
	else begin
		data = {chunk_2, 1'b1, 319'b0, 64'd640}; // Message W + 1 + 319 0's + 640
	end
end

endmodule
