// $Id: $
// File name:   carry_adder.sv
// Created:     11/14/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Good Adder
module carry_adder
#(parameter NUM_BITS = 32)
(
	input [NUM_BITS - 1:0] a,
	input [NUM_BITS - 1:0] b,
	output [NUM_BITS - 1:0] sum,
	output overflow
);

wire [NUM_BITS:0] carry;
wire [NUM_BITS-1:0] gen, prop;

genvar i;
generate // Initial one bit adders
	for(i = 0; i < NUM_BITS; i = i + 1)
	begin
		full_adder full_adder ( .a(a[i]), .b(b[i]), .carry_in(carry[i]);, .sum(sum[i]));
	end
endgenerate

genvar j;
generate //Generate and propagation calculations
	for(j = 0; j < NUM_BITS; j = j + 1)
	begin
		assign gen[j] = a[j] & b[j];
		assign prop[j] = a[j] | b[j];
		assign carry[j] = gen[j] | (prop[j] & carry[j]);
	end
endgenerate

assign carry[0] = 1'b0;
assign s = sum;
assign overflow = carry[NUM_BITS];

endmodule
