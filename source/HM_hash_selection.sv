// $Id: $
// File name:   HM_hash_selection.sb
// Created:     11/26/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: hash selector thing file
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
begin
	if(hash_select == 'd2)
		data = {prev_hash, 1'b1, 191'b0, 64'd256};
	else if(hash_select == 'd1)
		data = data_to_hash + MODULE_NUM;
end

endmodule
