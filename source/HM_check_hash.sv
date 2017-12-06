// $Id: $
// File name:   HM_check_hash.sv
// Created:     11/16/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Check Hash Module
module HM_check_hash
(
	input [255:0] out_hash,
	input [7:0][31:0] difficulty,
	input hash_done,
	output logic valid_hash_flag
);

logic [255:0] out_hash_logic;

flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_0 (out_hash[31:0], out_hash_logic[31:0]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_1 (out_hash[63:32], out_hash_logic[63:32]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_2 (out_hash[95:64], out_hash_logic[95:64]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_3 (out_hash[127:96], out_hash_logic[127:96]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_4 (out_hash[159:128], out_hash_logic[159:128]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_5 (out_hash[191:160], out_hash_logic[191:160]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_6 (out_hash[223:192], out_hash_logic[223:192]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_7 (out_hash[255:224], out_hash_logic[255:224]);

always_comb begin
	if((out_hash_logic < difficulty) && (hash_done == 1))
		valid_hash_flag = 1;
	else
		valid_hash_flag = 0;
end

endmodule
