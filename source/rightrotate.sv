module rightrotate
#(BITS = 1)
(
	input wire [31:0]in,
	output wire [31:0]out
);

assign out [31:31-BITS + 1] = in[BITS - 1:0];
assign out [31-BITS:0] = in[31:BITS];

endmodule
