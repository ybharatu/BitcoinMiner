// $Id: $
// File name:   chunk_decoder.sv
// Created:     11/26/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Check decoder in Packet Decoder
module chunk_decoder
(
	input [1:0] hash_select,
	input [511:0] chunk1,
	input [127:0] chunk2,
	// input new_block, idk if we need this
	output logic [511:0] data_to_hash
);

always_comb
begin
	if(hash_select == 0) begin
		data_to_hash = chunk1;
	end
	else begin
		data_to_hash = {chunk2, 1'b1, 319'b0, 64'd128};
	end

end

endmodule
