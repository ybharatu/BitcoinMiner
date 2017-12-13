// $Id: $
// File name:   flip_endian
// Created:     12/5/2017
// Author:      Rahul Patni
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Helper file that flips byte order of various chunks of data. Very helpful getting data between modules
module flip_endian
#(
	parameter LENGTH = 512,
	parameter FLIP_LENGTH = 32
)

(
	input wire [LENGTH - 1:0] data,
	output wire [LENGTH - 1:0] flipped
);

logic [LENGTH - 1:0] temp;
assign flipped = temp;

always_comb begin
	integer j;
	integer k;
	for (j = 0; j < LENGTH; j = j + FLIP_LENGTH) begin
		for (k = 0; k < FLIP_LENGTH; k = k + 1) begin
			temp[j+k] = data[LENGTH-FLIP_LENGTH-j+k];
//			$info("k: %0d opp: %0d", k, length-flip_length-j+k);
			temp[LENGTH-FLIP_LENGTH-j+k] = data[k+j];
		end
	end
end

endmodule
