// SHA 256 main module

module HM_SHA_256
(
	input wire halt, clear,
	input wire [15:0][31:0] data, //watch out here before we were using [31:0][7:0] to adress data
	input wire clk,
	input wire n_rst,
	input wire [7:0] count,
	output reg [7:0][31:0] out_hash 
);

reg [7:0][31:0]curr_hash;
reg [63:0][31:0] w;
reg [47:0][31:0]s0;
reg [47:0][31:0]s1;
logic [47:0][31:0] rr7;    // Right rotated W by 7
logic [47:0][31:0] rr18;   // by 18
logic [47:0][31:0] rr17;   // by 17
logic [47:0][31:0] rr19;   // by 19
logic [31:0] a;
logic [31:0] b;
logic [31:0] c;
logic [31:0] d;
logic [31:0] e;
logic [31:0] f;
logic [31:0] g;
logic [31:0] h;
logic [31:0] S1;
logic [31:0] ch;
logic [31:0] temp1;
logic [31:0] temp2;
logic [31:0] maj;
logic [31:0] S0;
logic [31:0] rr6;  // Right rotated e by 6
logic [31:0] rr11; // by 11
logic [31:0] rr25; // by 25
logic [31:0] rr2;  // Right rotated a by 2
logic [31:0] rr13; // by 13
logic [31:0] rr22; // by 22
logic [31:0] anext;
logic [31:0] bnext;
logic [31:0] cnext;
logic [31:0] dnext;
logic [31:0] enext;
logic [31:0] fnext;
logic [31:0] gnext;
logic [31:0] hnext;
logic [31:0] wsel;
logic [31:0] ksel;
logic [7:0][31:0] selected_hash;


reg [64:0][31:0] k = { 32'h428a2f98, 32'h71374491, 32'hb5c0fbcf, 32'he9b5dba5, 32'h3956c25b, 32'h59f111f1, 32'h923f82a4, 32'hab1c5ed5,
   32'hd807aa98, 32'h12835b01, 32'h243185be, 32'h550c7dc3, 32'h72be5d74, 32'h80deb1fe, 32'h9bdc06a7, 32'hc19bf174,
   32'he49b69c1, 32'hefbe4786, 32'h0fc19dc6, 32'h240ca1cc, 32'h2de92c6f, 32'h4a7484aa, 32'h5cb0a9dc, 32'h76f988da,
   32'h983e5152, 32'ha831c66d, 32'hb00327c8, 32'hbf597fc7, 32'hc6e00bf3, 32'hd5a79147, 32'h06ca6351, 32'h14292967,
   32'h27b70a85, 32'h2e1b2138, 32'h4d2c6dfc, 32'h53380d13, 32'h650a7354, 32'h766a0abb, 32'h81c2c92e, 32'h92722c85,
   32'ha2bfe8a1, 32'ha81a664b, 32'hc24b8b70, 32'hc76c51a3, 32'hd192e819, 32'hd6990624, 32'hf40e3585, 32'h106aa070,
   32'h19a4c116, 32'h1e376c08, 32'h2748774c, 32'h34b0bcb5, 32'h391c0cb3, 32'h4ed8aa4a, 32'h5b9cca4f, 32'h682e6ff3,
   32'h748f82ee, 32'h78a5636f, 32'h84c87814, 32'h8cc70208, 32'h90befffa, 32'ha4506ceb, 32'hbef9a3f7, 32'hc67178f2};




assign selected_hash = (clear ? 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19 : out_hash);
// initialize to either previous hash or  fractional parts of the square roots of the first 8 primes 2..19):

assign out_reg = ((halt == 1)? out_hash : curr_hash); // TODO (change with current hash value)
assign w[15:0] = data;


always_ff @ ( posedge clk, negedge n_rst) begin //change back to always_ff and make a new alwasy comb
	if(n_rst == 0) begin
		a <= 0;
		b <= 0;
		c <= 0;
		d <= 0;
		e <= 0;
		f <= 0;
		g <= 0;
		h <= 0;
		out_hash <= 0;
	end		
	else if(count == 1) begin //or maybe 0 im not sure	
		a <= selected_hash[0];
		b <= selected_hash[1];
		c <= selected_hash[2];
		d <= selected_hash[3];
		e <= selected_hash[4];
		f <= selected_hash[5];
		g <= selected_hash[6];
		h <= selected_hash[7];
	end
	else begin
		a <= anext;
		b <= bnext;
		c <= cnext;
		d <= dnext;
		e <= enext;
		f <= fnext;
		g <= gnext;
		h <= hnext;
		out_hash <= out_reg;
	end
	
	//out_hash <= out_reg;

end

genvar i;

generate  // W calculations, OPTIMIZE THIS
	for (i = 16; i < 64; i= i + 1) begin
		HM_rightrotate #(7) RR7 (.in(w[i-15]), .out(rr7[i-16])); //double check all bounds on this
		HM_rightrotate #(18) RR18 (.in(w[i-15]), .out(rr18[i-16]));
		HM_rightrotate #(17) RR17 (.in(w[i-2]), .out(rr17[i-16]));
		HM_rightrotate #(19) RR19 (.in(w[i-2]), .out(rr19[i-16]));
		assign s0[i] = rr7[i-16] ^ rr18[i-16] ^ (w[i-15] >> 3);
		assign s1[i] = rr17[i-16] ^ rr19[i-16] ^ (w[i-15] >> 10);
		assign w[i] = w[i-16] + s0[i] + w[i-7] + s1[i];
	end
endgenerate

always_comb begin
	integer j;
	for( j = 0; j < 32; j = j + 1) begin
		if(count == j)begin
		wsel = w[j];
		ksel = k[j];
		end
	end
end

// Initial Right Rotate

HM_rightrotate #(6) RR6 (.in(e), .out(rr6));
HM_rightrotate #(25) RR25 (.in(e), .out(rr25));
HM_rightrotate #(11) RR11 (.in(e), .out(rr11));
HM_rightrotate #(13) RR13 (.in(a), .out(rr13));
HM_rightrotate #(22) RR22 (.in(a), .out(rr22));
HM_rightrotate #(2) RR2 (.in(a), .out(rr2));

always_comb begin // Compression Core
	S1 = rr6 ^ rr11 ^ rr25;
	ch  = (e & f) ^ ((~e) & g);
	temp1 = h + S1 + ch + ksel + wsel; // Carry look ahead adders
	S0 = rr2 ^ rr13 ^ rr22;
	maj = (a & b) ^ (a & c) ^ (b & c);
	temp2 = S0 + maj;

	hnext = g;
	gnext = f;
	fnext = e;
	enext = d + temp1;
	dnext = c;
	cnext = b;
	bnext = a;
	anext = temp1 + temp2;
end


assign curr_hash = {h + selected_hash[7], g + selected_hash[6], f + selected_hash[5], e + selected_hash[4], d + selected_hash[3], c + selected_hash[2], b + selected_hash[1], a + selected_hash[0]};



endmodule
