// $Id: $
// File name:   main_controller.sv
// Created:     12/5/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Main State Machine
`define DATA0   8'b11000011
`define DATA1   8'b01001011
`define NACK	8'b
`define ACK	8'b
`define EMPTY_HASH 8'b0000000000000000
module main_controller
(
	input host_ready,
	input rcv_error,
	input p_error,
	input hash_done,
	input new_block,
	input valid_hash_flag,
	output logic quit_hash,
	output logic begin_hash,
	output logic transmit_empty,
	output logic transmit_start,
	output logic transmit_ack,
	output logic [7:0] pid_byte,
	output logic [15:0] data_bytes,
	output logic increment
);


typedef enum bit [3:0] {IDLE, BLOCK_READY, HASH_DONE, TRANSMIT_START, TRANSMIT_EMPTY, TRANSMIT_ACK, TRANSMIT_NACK} states;

states curr_state, next_state;


always_ff @ (posedge clk, negedge n_rst)
begin
	if(n_rst == 1'b0)
	begin
		curr_state <= IDLE;
	end	
	else
	begin
		curr_state <= next_state;
	end
end


always_comb
begin
	quit_hash = 0;
	begin_hash = 0;
	transmit_empty = 0;
	transmit_start = 0;
	transmit_ack = 0;
	next_state = curr_state;

	case(curr_state)
		IDLE: begin
			if(new_block)
				next_state = BEGIN_HASH;
			if(host_ready) begin
				if(valid_hash_flag)
					next_state = TRANSMIT_START;
				else
					next_state = TRANSMIT_EMPTY;
			end
			if()//Transmit_ack
				if(p_error || rcv_error)
					next_state = TRANSMIT_NACK;
				else
					next_state = TRANSMIT_ACK;
			if(hash_done)
				next_state = HASH_DONE;
		end
		BEGIN_HASH: begin
			begin_hash = 1;
			next_state = IDLE;		
		end
		HASH_DONE: begin
			increment = 1;
			next_state = BEGIN_HASH;
		end
		TRANSMIT_START: begin
			transmit_start = 1;
			pid_byte = `DATA0;
			load_pid = 1;
			next_state = IDLE; //might need a load state
		end
		TRANSMIT_EMPTY: begin
			transmit_empty = 1;
			pid_byte = `DATA0;
			data_bytes = `EMPTY_HASH;
			load_pid = 1;
			next_state = IDLE; //LOAD??
		end
		TRANSMIT_ACK: begin
			transmit_ack = 1;
			pid_byte = `ACK;
			load_pid = 1;
			next_state = IDLE;
		end
		TRANSMIT_NACK: begin
			transmit_ack = 1;
			pid_byte = `NACK;
			load_pid = 1;
			next_state = IDLE;
		end
end

endmodule
