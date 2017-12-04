// $Id: $
// File name:   PD_controller.sv
// Created:     12/3/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Controller for Packet Decoder

`define IN_PID  8'b00000000
`define OUT_PID 8'b11111111
`define DATA0   8'b00000000
`define DATA1   8'b00000000
`define INTERRUPT   8'b00000000
`define HASH   8'b00000000

module PD_controller
(
	input clk,
	input n_rst,
	input write_enable,
	input [7:0] rx_data,
	input [7:0] byte_cnt,
	input valid_hash,
	input hash_done,
	input packet_done,
	output logic i_data_en,
	output logic i_data_sel,
	output logic [7:0] i_data,
	output logic p_error,
	output logic host_error,
	output logic stop_calc,
	output logic new_block,
	output logic transmit_empty,
	output logic transmit_start,
	output logic begin_hash,
	output logic quit_hash,
	output logic cnt_up
	
);

typedef enum bit [4:0] {IDLE, READ_PID, IN_PID, OUT_PID, TRANSMIT_START, TRANSMIT_EMPTY, READ_DATA_PID, WAIT_DATA_TYPE,
			CHECK_DATA_TYPE, INTERRUPT, PACKET_1_WAIT, WRITE_PACKET_1, PACKET_2_WAIT, WRITE_PACKET_2, BEGIN_HASH, ERROR} stateType;

stateType current_state, next_state;

always_ff @ (posedge clk, negedge n_rst)
begin
	if(n_rst == 1'b0)
	begin
		current_state <= IDLE;
	end	
	else
	begin
		current_state <= next_state;
	end
end

assign i_data = rx_data;

always_comb
begin
	next_state = current_state;
	p_error = 0;
	host_error = 0;
	transmit_empty = 0;
	transmit_start = 0;
	cnt_up = 0;
	stop_calc = 0;
	new_block = 0;
	i_data_en = 0;
	i_data_sel = 0;
	case(current_state)
		IDLE: begin
			if(write_enable)
				next_state = READ_PID;
		end
		READ_PID: begin
			if(rx_data[3:0] == ~(rx_data[7:4]))
			begin
				if(rx_data == `IN_PID)
					next_state = IN_PID;
				else if(rx_data == `OUT_PID) //ADD more cases
					next_state = OUT_PID;
				else;
			end
			else
			begin
				next_state = ERROR;
			end
		end
		IN_PID: begin
			if(valid_hash)
				next_state = TRANSMIT_START;
			else
				next_state = TRANSMIT_EMPTY;
		end
		TRANSMIT_START: begin
			transmit_start = 1;
			next_state = IDLE;
		end
		TRANSMIT_EMPTY: begin
			transmit_empty = 1;
			next_state = IDLE; // MAY HAVE MORE STATES
		end
		OUT_PID: begin
			if(write_enable)
				next_state = READ_DATA_PID;
			else
				next_state = OUT_PID;
		end
		READ_DATA_PID: begin
			if(rx_data == `DATA0)
				next_state = WAIT_DATA_TYPE;
			else if(rx_data == `DATA1)
				next_state = PACKET_2_WAIT;
			else
				next_state = ERROR;
		end
		WAIT_DATA_TYPE: begin
			if(write_enable)
				next_state = CHECK_DATA_TYPE;
			else
				next_state = WAIT_DATA_TYPE;
		end
		CHECK_DATA_TYPE: begin
			if(rx_data == `INTERRUPT)
				next_state = INTERRUPT;
			else if(rx_data == `HASH)
				next_state = PACKET_1_WAIT;
			else
				next_state = ERROR;
		end
		INTERRUPT: begin
			quit_hash = 1;
			next_state = IDLE;
		end
		PACKET_1_WAIT: begin
			if(write_enable)
				next_state = WRITE_PACKET_1;
			else
				next_state = PACKET_1_WAIT;
		end
		WRITE_PACKET_1: begin
			i_data_en = 1;
			cnt_up = 1;
			i_data_sel = byte_cnt;
			if(packet_done)
				next_state = IDLE;
			else
				next_state = PACKET_1_WAIT;
		end
		PACKET_2_WAIT: begin
			if(write_enable)
				next_state = WRITE_PACKET_2;
			else
				next_state = PACKET_2_WAIT;
		end
		WRITE_PACKET_2: begin
			i_data_en = 1;
			cnt_up = 1;
			i_data_sel = byte_cnt + 63; //TODO CHECK THAT NUM
			if(packet_done)
				next_state = BEGIN_HASH;
			else
				next_state = PACKET_2_WAIT;
		end
		BEGIN_HASH: begin
			begin_hash = 1;
		end
		ERROR: begin
		
		end
		
			
	endcase
end
		
endmodule
