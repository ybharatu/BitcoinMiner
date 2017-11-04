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

reg [64:0][31:0]s0;
reg [64:0][31:0]s1;
logic[64:0][31:0] rr7;    // Right rotated W by 7
logic[64:0][31:0] rr18;   // by 18
logic[64:0][31:0] rr17;   // by 17
logic[64:0][31:0] rr19;   // by 19
logic[64:0][7:0][31:0] hash; // selected previous hash
logic [64:0][31:0] a;
logic [64:0][31:0] b;
logic [64:0][31:0] c;
logic [64:0][31:0] d;
logic [64:0][31:0] e;
logic [64:0][31:0] f;
logic [64:0][31:0] g;
logic [64:0][31:0] h;
logic [64:0][31:0] S1;
logic [64:0][31:0] ch;
logic [64:0][31:0] temp1;
logic [64:0][31:0] temp2;
logic [64:0][31:0] maj;
logic [64:0][31:0] S0;
logic [64:0][31:0] rr6;  // Right rotated e by 6
logic [64:0][31:0] rr11; // by 11
logic [64:0][31:0] rr25; // by 25
logic [64:0][31:0] rr2;  // Right rotated a by 2
logic [64:0][31:0] rr13; // by 13
logic [64:0][31:0] rr22; // by 22


reg [64:0][31:0] k = { 32h'428a2f98, 32h'71374491, 32h'b5c0fbcf, 32h'e9b5dba5, 32h'3956c25b, 32h'59f111f1, 32h'923f82a4, 32h'ab1c5ed5,
   32h'd807aa98, 32h'12835b01, 32h'243185be, 32h'550c7dc3, 32h'72be5d74, 32h'80deb1fe, 32h'9bdc06a7, 32h'c19bf174,
   32h'e49b69c1, 32h'efbe4786, 32h'0fc19dc6, 32h'240ca1cc, 32h'2de92c6f, 32h'4a7484aa, 32h'5cb0a9dc, 32h'76f988da,
   32h'983e5152, 32h'a831c66d, 32h'b00327c8, 32h'bf597fc7, 32h'c6e00bf3, 32h'd5a79147, 32h'06ca6351, 32h'14292967,
   32h'27b70a85, 32h'2e1b2138, 32h'4d2c6dfc, 32h'53380d13, 32h'650a7354, 32h'766a0abb, 32h'81c2c92e, 32h'92722c85,
   32h'a2bfe8a1, 32h'a81a664b, 32h'c24b8b70, 32h'c76c51a3, 32h'd192e819, 32h'd6990624, 32h'f40e3585, 32h'106aa070,
   32h'19a4c116, 32h'1e376c08, 32h'2748774c, 32h'34b0bcb5, 32h'391c0cb3, 32h'4ed8aa4a, 32h'5b9cca4f, 32h'682e6ff3,
   32h'748f82ee, 32h'78a5636f, 32h'84c87814, 32h'8cc70208, 32h'90befffa, 32h'a4506ceb, 32h'bef9a3f7, 32h'c67178f2}




assign hash = clear ? 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19 : prev_hash;
// initialize to either previous hash or  fractional parts of the square roots of the first 8 primes 2..19):

assign out_hash = (halt == 1)? prev_hash : curr_hash; // TODO (change with current hash value)
assign w[15:0] = data;

genvar i;

generate 
	for (i = 16; i < 64; i= i + 1) begin
		HM_rightrotate #(7) RR7 (.in(w[i-15]), .out(rr7[i]));
		HM_rightrotate #(18) RR18 (.in(w[i-15]), .out(rr18[i]));
		HM_rightrotate #(17) RR17 (.in(w[i-2]), .out(rr17[i]));
		HM_rightrotate #(19) RR19 (.in(w[i-2]), .out(rr19[i]));
		assign s0[i] = rr7[i] ^ rr18[i] ^ (w[i-15] >> 3);
		assign s1[i] = rr17[i] ^ rr19[i] ^ (w[i-15] >> 10);
		assign w[i] = w[i-16] + s0[i] + w[i-7] + s1[i];
	end
endgenerate

generate
	for(i = 0; i < 64; i = i + 1) begin
		HW_rightrotate #(6) RR6 (.in(e[i]), .out(rr6[i]));
		HW_rightrotate #(25) RR25 (.in(e[i]), .out(rr25[i]));
		HW_rightrotate #(11) RR11 (.in(e[i]), .out(rr11[i]));
		HW_rightrotate #(13) RR13 (.in(a[i]), .out(rr13[i]));
		HW_rightrotate #(22) RR22 (.in(a[i]), .out(rr22[i]));
		HW_rightrotate #(2) RR2 (.in(a[i]), .out(rr2[i]));
		assign S1[i] = rr6[i] ^ rr11[i] ^ rr25[i];
		assign ch[i]  = (e[i] & f[i]) xor ((~e[i]) & g[i]);
		assign temp1[i] = h[i] + S1[i] + ch[i] + k[i] + w[i];
		assign S0[i] = rr2[i] ^ rr13[i] ^ rr22[i];
		assign maj[i] = (a[i] & b[i]) ^ (a[i] & c[i]) ^ (b[i] & c[i])
		assign temp2[i] = S0[i] + maj[i];


		assign h[i+1] = g[i];
		assign g[i+1] = f[i];
		assign f[i+1] = e[i];
		assign e[i+1] = d[i] + temp1[i];
		assign d[i+1] = c[i];
		assign c[i+1] = b[i];
		assign b[i+1] = a[i];
		assign a[i+1] = temp1[i] + temp2[i];
	end
endgenerate

assign curr_hash = 







endmodule
