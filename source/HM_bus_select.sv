// $Id: $
// File name:   HM_bus_select.sv
// Created:     11/28/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Bus selection module for Hashing Module
module HM_bus_select
(
	input [255:0] out_hash, //Dimensions...
	input valid_hash_flag,
	output logic [31:0][7:0] valid_hash //Dimenion ordering is sketch
);

always_comb begin
	if(valid_hash_flag)
		valid_hash = out_hash;
	else
		valid_hash = 256'bz;
end



endmodule
