// $Id: $
// File name:   HM_controller.sv
// Created:     11/15/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Main Controller for Hashing Module
module HM_controller
(
	input begin_hash, quit_hash,
	input [6:0] hash_count,
	input clk, n_rst,	
	output logic cnt_up, hash_done, clear, halt,
	output logic [1:0] hash_select
);

typedef enum bit [2:0] {IDLE, CALC_HASH1, CALC_HASH2, CALC_HASH3, HASH_CHECK} states;

states currState;
states nextState;

always_ff @ (posedge clk, negedge n_rst) 
begin
	if(n_rst == 0) begin
		currState = IDLE;
	end
	else begin
		currState = nextState;
	end
end

always_comb
begin
	cnt_up = 0;
	hash_done = 0;
	clear = 0;
	halt = 0;
	hash_select = 0;
	nextState = currState;

	case(currState)
		IDLE: begin
			halt = 1;
			if(begin_hash == 1)
				nextState = CALC_HASH1;
		end
		CALC_HASH1: begin
			cnt_up = 1;
			clear = 1;
			hash_select = 0;
			if(hash_count == 64)
				nextState = CALC_HASH2;
		end
		CALC_HASH2: begin
			cnt_up = 1;
			clear = 0;
			hash_select = 1;
			if(hash_count == 64)
				nextState = CALC_HASH3;
		end
		CALC_HASH3: begin
			cnt_up = 1;
			clear = 1;
			hash_select = 2;
			if(hash_count == 'd64)
				nextState = HASH_CHECK;
		end
		HASH_CHECK: begin
			hash_done = 1;
			halt = 1;
			nextState = IDLE;
		end
	endcase
end


endmodule
