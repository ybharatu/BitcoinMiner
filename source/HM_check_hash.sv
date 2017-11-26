// $Id: $
// File name:   HM_check_hash.sv
// Created:     11/16/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Check Hash Module
module check_hash
(
	input [7:0][31:0] out_hash,
	input [31:0] difficulty,
	input check_hash,
	output valid_hash
);

reg[7:0][31:0] difficulty_decoded;
reg[15:0] exponent;


assign exponent = (difficulty[31:23] - 3 ) << 3;


always_comb begin
	if( out_hash < difficulty_decoded)
		valid_hash = 1;
	else
		valid_hash = 0;
end





endmodule
