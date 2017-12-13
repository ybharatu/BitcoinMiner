// $Id: $
// File name:   HM_hash_selection.sb
// Created:     11/26/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Hash Selectector Determines whether to use the input data or the previous hash as an input to the SHA-256 Core
module HM_hash_selection
#(
	parameter MODULE_NUM = 0
)

(
	input [511:0] data_to_hash,
	input [1:0] hash_select,
	input [255:0] prev_hash,
	output logic [511:0] data
);

always_comb
begin //191 zeros and 64'h256
	if(hash_select == 'd2)
		data = {32'h00000100,32'h0,32'h0,32'h0,32'h0,32'h0,32'h0,32'h80000000,prev_hash};
	else
		data = data_to_hash + MODULE_NUM;
end

endmodule
