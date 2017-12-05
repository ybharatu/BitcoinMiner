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
	output logic [511:0] data_to_hash
);

logic [511:0]data;

always_comb
begin
	if(hash_select == 0) begin
<<<<<<< Updated upstream
		data = chunk1;
	end
	else begin
		data = {chunk2, 1'b1, 319'b0, 64'd640}; // Message W + 1 + 319 0's + 640
=======
		data_to_hash = chunk_1;
	end
	else begin
		data_to_hash = {chunk_2, 1'b1, 319'b0, 64'd640}; // Message W + 1 + 319 0's + 640
>>>>>>> Stashed changes
	end
end

flip_endian #(.LENGTH(512), .FLIP_LENGTH(32)) FE1 (.data(data), .flipped(data_to_hash));

endmodule
