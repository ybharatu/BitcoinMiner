// SHA 256 main module

module SHA_256
(
	input wire halt, clear,
	input wire [7:0][31:0] prev_hash,
	input wire [15:0][31:0] data,
	output reg [7:0][31:0] out_hash
);

reg [7:0][31:0]curr_hash;
reg [63:0][31:0] w;

reg [31:0]s0;
reg [31:0]s1;
logic[31:0] rr7;
logic[31:0] rr18;
logic[31:0] rr17;
logic[31:0] rr19;

assign out_hash = (halt == 1)? prev_hash : curr_hash; // TODO (change with current hash value)

assign w[15:0] = data;

genvar i;

generate 
	for (i = 16; i < 64; i= i + 1) begin
		HM_rightrotate #(7) RR7 (.in(w[i-15]), .out(rr7));
		HM_rightrotate #(18) RR18 (.in(w[i-15]), .out(rr18));
		HM_rightrotate #(17) RR17 (.in(w[i-2]), .out(rr17));
		HM_rightrotate #(19) RR19 (.in(w[i-2]), .out(rr19));
		assign s0 = rr7 ^ rr18 ^ (w[i-15] >> 3);
		assign s1 = rr17 ^ rr19 ^ (w[i-15] >> 10);
		assign w[i] = w[i-16] + s0 + w[i-7] + s1;
	end
endgenerate

endmodule
