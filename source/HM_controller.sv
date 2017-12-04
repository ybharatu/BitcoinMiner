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
	input hash_rollover,
	input valid_hash,
	input clk, n_rst,	
	output logic cnt_up, hash_done, clear, halt, init, out_load,
	output logic increment;
	output logic [1:0] hash_select
);

typedef enum bit [3:0] {IDLE, INIT_LOAD1, CALC_HASH1, OUT_LOAD1, INIT_LOAD2, CALC_HASH2, OUT_LOAD2, INIT_LOAD3, CALC_HASH3, OUT_LOAD3, HASH_CHECK} states;

states currState;
states nextState;

always_ff @ (posedge clk, negedge n_rst) 
begin
	if(n_rst == 0) begin
		currState <= IDLE;
	end
	else begin
		currState <= nextState;
	end
end

always_comb
begin
	cnt_up = 0;
	hash_done = 0;
	clear = 0;
	halt = 0;
	hash_select = 0;
	init = 0;
	out_load = 0;
	nextState = currState;

	case(currState)
		IDLE: begin
			halt = 1;
			if(begin_hash == 1)
				nextState = INIT_LOAD1;
		end
		INIT_LOAD1: begin
			halt = 1;
			clear = 1;
			init = 1;
			hash_select = 0;
			nextState = CALC_HASH1;
		end
		CALC_HASH1: begin
			cnt_up = 1;
			clear = 1;
			if(hash_rollover == 1)
				nextState = OUT_LOAD1;
		end
		OUT_LOAD1: begin
			cnt_up = 0;
			out_load = 1;
			halt = 1;
			clear = 1;
			nextState = INIT_LOAD2;
		end
		INIT_LOAD2: begin
			init = 1;
			clear = 0;
			halt = 1;
			out_load = 0;
			hash_select = 1;
			nextState = CALC_HASH2;
		end
		CALC_HASH2: begin
			cnt_up = 1;
			clear = 0;
			hash_select = 1;
			if(hash_rollover == 1)
				nextState = OUT_LOAD2;
		end
		OUT_LOAD2: begin
			cnt_up = 0;
			out_load = 1;
			halt = 1;
			clear = 0;
			hash_select = 1;
			nextState = INIT_LOAD3;
		end
		INIT_LOAD3: begin
			halt = 1;
			clear = 1;
			init = 1;
			hash_select = 2;
			nextState = CALC_HASH3;
		end
		CALC_HASH3: begin
			cnt_up = 1;
			clear = 1;
			hash_select = 2;
			if(hash_rollover == 1)
				nextState = OUT_LOAD3;;
		end
		OUT_LOAD3: begin
			cnt_up = 0;
			out_load = 1;
			halt = 1;
			clear = 1;
			hash_select = 2;
			nextState = HASH_CHECK;
		end
		HASH_CHECK: begin
			hash_done = 1;
			halt = 1;
			if(valid_hash_flag)
				nextState = HOLD_HASH;
			else
				nextState = INCREMENT;
		end
		HOLD_HASH: begin
			hash_done = 1;
			halt = 1;
			if(quit_hash)
				nextState = IDLE;
			if(begin_hash)
				nextState = INIT_LOAD1;
		end
		INCREMENT: begin
			increment = 1;
			nextState = INIT_LOAD1;
		end
		
		
		default: begin
			nextState = currState;
		end
	endcase

	if(quit_hash == 1) begin
		nextState = IDLE;
	end
end


endmodule
