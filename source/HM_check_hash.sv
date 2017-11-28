// $Id: $
// File name:   HM_check_hash.sv
// Created:     11/16/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Check Hash Module
module HM_check_hash
(
	input [7:0][31:0] out_hash,
	input [7:0][31:0] difficulty,
	input hash_done,
	output logic valid_hash_flag
);


always_comb begin
	if((out_hash < difficulty) && (hash_done == 1))
		valid_hash_flag = 1;
	else
		valid_hash_flag = 0;
end

endmodule
