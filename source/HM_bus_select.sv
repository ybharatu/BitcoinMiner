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
	input [31:0] nonce,
	output logic [287:0] valid_hash //Dimenion ordering is sketch
);

logic [287:0] valid_hash_logic;

flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_0 (valid_hash_logic[31:0], valid_hash[31:0]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_1 (valid_hash_logic[63:32], valid_hash[63:32]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_2 (valid_hash_logic[95:64], valid_hash[95:64]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_3 (valid_hash_logic[127:96], valid_hash[127:96]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_4 (valid_hash_logic[159:128], valid_hash[159:128]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_5 (valid_hash_logic[191:160], valid_hash[191:160]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_6 (valid_hash_logic[223:192], valid_hash[223:192]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_7 (valid_hash_logic[255:224], valid_hash[255:224]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_8 (valid_hash_logic[287:256], valid_hash[287:256]);

assign valid_hash_logic = {out_hash, nonce};

/*always_comb begin
	if(valid_hash_flag)
		valid_hash_logic = {out_hash, nonce};
	else
		valid_hash_logic = 287'bz;
end*/



endmodule
