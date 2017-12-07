// $Id: $
// File name:   main_controller.sv
// Created:     12/5/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Main State Machine
`define DATA0   8'b11000011
`define DATA1   8'b01001011
`define NACK	8'b01011010
`define ACK	8'b11010010
`define EMPTY_HASH 16'b0000000000000000

module main_controller
(
	input clk, n_rst,
	input host_ready,
	input rcv_error,
	input p_error,
	input hash_done,
	input new_block,
	input valid_hash_flag,
	input transmit_ack,
	input transmit_nack,
	output logic quit_hash,
	output logic begin_hash,
	output logic transmit_empty,
	output logic transmit_start,
	output logic [7:0] pid_byte,
	output logic [15:0] data_bytes,
	output logic increment,
	output logic load_pid,
	output logic transmit_response
);


typedef enum bit [3:0] {IDLE, BLOCK_READY, HASH_DONE, TRANSMIT_START, TRANSMIT_EMPTY, TRANSMIT_ACK, TRANSMIT_NACK, BEGIN_HASH} states;

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
	transmit_response = 0;
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
			if(transmit_ack)//Transmit_ack
				next_state = TRANSMIT_ACK;
			if(transmit_nack)
				next_state = TRANSMIT_NACK;
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
			transmit_response = 1;
			pid_byte = `ACK;
			load_pid = 1;
			next_state = IDLE;
		end
		TRANSMIT_NACK: begin
			transmit_response = 1;
			pid_byte = `NACK;
			load_pid = 1;
			next_state = IDLE;
		end
	endcase
end

endmodule
