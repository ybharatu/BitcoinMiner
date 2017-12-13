// $Id: $
// File name:   HM_bus_select.sv
// Created:     11/28/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: SHA 256 Core Calculation Module

`define abc {a,b,c,d,e,f,g,h}
`define abcnext  {anext,bnext,cnext,dnext,enext,fnext,gnext,hnext}

module HM_SHA_256
(
	input wire halt, clear,
	input wire [15:0][31:0] data, //watch out here before we were using [31:0][7:0] to adress data
	input wire clk,
	input wire n_rst,
	input wire [6:0] count,
	input wire init,
	input wire out_load,
	input wire [1:0] hash_select,
	output reg [7:0][31:0] out_hash,
	output reg [31:0] nonce

);

reg [7:0][31:0]curr_hash;
reg [63:0][31:0] w; //Full array of W regs, can optimize to only 16x32 later on if time warrants
logic [63:16][31:0] w_next; // Next state of W
logic [6:0] w_count; //The count on w stays 16 clock cycles ahead of count;
logic [31:0] w_prep; //TODO remove, help variable
reg [31:0]s0;
reg [31:0]s1;
logic [31:0] rr7;    // Right rotated W by 7
logic [31:0] rr18;   // by 18
logic [31:0] rr17;   // by 17
logic [31:0] rr19;   // by 19
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
logic [7:0][31:0] out_reg; // Basically out_hash next
logic [31:0] nonce_next;

localparam [0:63][31:0] k = {  32'h428a2f98, 32'h71374491, 32'hb5c0fbcf, 32'he9b5dba5, 32'h3956c25b, 32'h59f111f1, 32'h923f82a4, 32'hab1c5ed5,
   			32'hd807aa98, 32'h12835b01, 32'h243185be, 32'h550c7dc3, 32'h72be5d74, 32'h80deb1fe, 32'h9bdc06a7, 32'hc19bf174,
   			32'he49b69c1, 32'hefbe4786, 32'h0fc19dc6, 32'h240ca1cc, 32'h2de92c6f, 32'h4a7484aa, 32'h5cb0a9dc, 32'h76f988da,
   			32'h983e5152, 32'ha831c66d, 32'hb00327c8, 32'hbf597fc7, 32'hc6e00bf3, 32'hd5a79147, 32'h06ca6351, 32'h14292967,
   			32'h27b70a85, 32'h2e1b2138, 32'h4d2c6dfc, 32'h53380d13, 32'h650a7354, 32'h766a0abb, 32'h81c2c92e, 32'h92722c85,
   			32'ha2bfe8a1, 32'ha81a664b, 32'hc24b8b70, 32'hc76c51a3, 32'hd192e819, 32'hd6990624, 32'hf40e3585, 32'h106aa070,
   			32'h19a4c116, 32'h1e376c08, 32'h2748774c, 32'h34b0bcb5, 32'h391c0cb3, 32'h4ed8aa4a, 32'h5b9cca4f, 32'h682e6ff3,
   			32'h748f82ee, 32'h78a5636f, 32'h84c87814, 32'h8cc70208, 32'h90befffa, 32'ha4506ceb, 32'hbef9a3f7, 32'hc67178f2};




assign selected_hash = (clear ? 256'h5BE0CD191F83D9AB9B05688C510E527FA54FF53A3C6EF372BB67AE856A09E667 : out_hash);
// initialize to either previous hash or  fractional parts of the square roots of the first 8 primes 2..19):

assign out_reg = ((out_load == 0)? out_hash : curr_hash);
assign w[15:0] = data;
assign w_count = count + 16;

/*
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_NONCE (nonce_logic, nonce);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_0 (out_hash_logic[0], out_hash[0]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_1 (out_hash_logic[1], out_hash[1]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_2 (out_hash_logic[2], out_hash[2]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_3 (out_hash_logic[3], out_hash[3]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_4 (out_hash_logic[4], out_hash[4]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_5 (out_hash_logic[5], out_hash[5]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_6 (out_hash_logic[6], out_hash[6]);
flip_endian #(.LENGTH(32), .FLIP_LENGTH(8)) FLIP_HASH_7 (out_hash_logic[7], out_hash[7]);
*/

always_ff @ ( posedge clk, negedge n_rst) begin //abc registers
	if(n_rst == 0) begin
		`abc <= 0;
	end		
	else if(init == 1) begin //or maybe 0 im not sure
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
		`abc <= `abcnext;
	end

end


always_ff @(posedge clk, negedge n_rst) begin //Nonce Reg
	if(n_rst == 0)
		nonce <= 0;
	else
		nonce <= nonce_next;
		
end

always_comb begin
	if(out_load && hash_select == 2'b01)
		nonce_next = w[3];
	else
		nonce_next = nonce;
end


always_ff @(posedge clk, negedge n_rst) begin //W Register
	if(n_rst == 0)
		w[63:16] <= 'b0;
	else
		w[63:16] <= w_next[63:16];
end

always_ff @(posedge clk, negedge n_rst) begin //Out hash Register
	if(n_rst == 0)
		out_hash <= 'b0;
	else
		out_hash <= out_reg;
end



always_comb W_PREP: begin  // W Prep Calculations
	integer i;
	w_next[63:16] = w[63:16];
	for(i = 16; i < 64; i = i + 1) begin
		if(w_count == i) begin
			w_prep = w[i-15];
			rr7  = {w[i - 15][6:0] , w[i - 15][31:7]  };
			rr17 = {w[i - 2 ][16:0], w[i - 2 ][31:17] };
			rr18 = {w[i - 15][17:0], w[i - 15][31:18] };
			rr19 = {w[i - 2 ][18:0], w[i - 2 ][31:19] };
			
			s0 = rr7 ^ rr18 ^ (w[i-15] >> 3);
			s1 = rr17 ^ rr19 ^ (w[i-2] >> 10);
			w_next[i] = w[i-16] + s0 + w[i-7] + s1;
		end
	end
end

always_comb begin
	integer j;
	wsel = '0;
	ksel = 32'hFFFFFFFF;
	for( j = 0; j < 64; j = j + 1) begin
		if(count == j) begin
			wsel = w[j];
			ksel = k[j];
		end
	end
end

// Initial Right Rotate

//rightrotate #(6) RR6 (.in(e), .out(rr6));
//rightrotate #(25) RR25 (.in(e), .out(rr25));
//rightrotate #(11) RR11 (.in(e), .out(rr11));
//rightrotate #(13) RR13 (.in(a), .out(rr13));
//rightrotate #(22) RR22 (.in(a), .out(rr22));
//rightrotate #(2) RR2 (.in(a), .out(rr2));

always_comb CORE: begin // Compression Core
	
	rr6  = {e[5:0] , e[31:6] };
	rr25 = {e[24:0], e[31:25]};
	rr11 = {e[10:0], e[31:11]};
	rr13 = {a[12:0], a[31:13]};
	rr22 = {a[21:0], a[31:22]};
	rr2   = {a[1:0] , a[31:2] };

	S1 = rr6 ^ rr11 ^ rr25;
	ch  = (e & f) ^ ((~e) & g);
	temp1 = h + S1 + ch + ksel + wsel;
	S0 = rr2 ^ rr13 ^ rr22;
	maj = (a & b) ^ (a & c) ^ (b & c);
	temp2 = S0 + maj;

	if(halt == 0) begin //Maybe remove
		hnext = g;
		gnext = f;
		fnext = e;
		enext = d + temp1;
		dnext = c;
		cnext = b;
		bnext = a;
		anext = temp1 + temp2;
	end
	else begin
		`abcnext = `abc;
	end
end


assign curr_hash = {h + selected_hash[7], g + selected_hash[6], f + selected_hash[5], e + selected_hash[4], d + selected_hash[3], c + selected_hash[2], b + selected_hash[1], a + selected_hash[0]};



endmodule
