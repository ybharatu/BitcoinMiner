// $Id: $
// File name:   PD_controller.sv
// Created:     12/3/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Controller for Packet Decoder

`define IN_PID  8'b01101001
`define OUT_PID 8'b11100001
`define DATA0   8'b11000011
`define DATA1   8'b01001011
`define INTERRUPT   8'b00000000
`define HASH   8'b00000000
`define CORRECT_ADDRESS 8'b00000000

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
	input eop,
	output logic i_data_en,
	output logic i_data_sel,
	output logic [7:0] i_data,
	output logic p_error,
	output logic stop_calc,
	output logic new_block,
	output logic host_ready,
	output logic begin_hash,
	output logic quit_hash,
	output logic cnt_up
	
);

typedef enum bit [4:0] {IDLE, READ_PID, IN_PID, WAIT_ADDRESS_IN, READ_ADDRESS_IN, EOP_WAIT, SEND_TRANSFER_PACKET, OUT_PID, WAIT_ADDRESS_OUT, READ_ADDRESS_OUT, VALID_ADDRESS_OUT,
			OUT_EOP_WAIT, WAIT_DATA_TYPE, CHECK_DATA_TYPE, INTERRUPT, PACKET_1_WAIT, WRITE_PACKET_1, PACKET_2_WAIT, WRITE_PACKET_2, NEW_BLOCK, ERROR} stateType;
stateType current_state, next_state;

logic valid_address;
logic valid_address_next;
logic valid_address_enable;

always_ff @ (posedge clk, negedge n_rst)
begin
	if(n_rst == 1'b0)
	begin
		valid_address <= 'b0;
	end	
	else if(valid_address_enable)
	begin
		valid_address <= valid_address_next;
	end
	else
	begin
		valid_address <= valid_address;
	end
end

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
	cnt_up = 0;
	stop_calc = 0;
	new_block = 0;
	i_data_en = 0;
	i_data_sel = 0;
	valid_address_next = 0;
	valid_address_enable = 0;
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
				else if(rx_data == `DATA0 && valid_address)
					next_state = WAIT_DATA_TYPE;
				else if(rx_data == `DATA1 && valid_address)
					next_state = PACKET_2_WAIT;
			end
			else
			begin
				next_state = ERROR;
			end
		end
		IN_PID: begin
			next_state = WAIT_ADDRESS_IN;
		end

		WAIT_ADDRESS_IN: begin
			if(write_enable)
				next_state = READ_ADDRESS_IN;
			else
				next_state = WAIT_ADDRESS_IN;
		end
		READ_ADDRESS_IN: begin
			if(rx_data == `CORRECT_ADDRESS)
				next_state = EOP_WAIT;
			else
				next_state = IDLE; 
		end
		EOP_WAIT: begin
			if(eop)
				next_state = SEND_TRANSFER_PACKET;
			else
				next_state = EOP_WAIT;
		end
		SEND_TRANSFER_PACKET: begin
			host_ready = 1;
			next_state = IDLE;
		end
		OUT_PID: begin
			if(write_enable)
				next_state = WAIT_ADDRESS_OUT;
			else
				next_state = OUT_PID;
		end
		WAIT_ADDRESS_OUT: begin
			if(write_enable)
				next_state = READ_ADDRESS_OUT;
			else
				next_state = WAIT_ADDRESS_OUT;
		end
		READ_ADDRESS_OUT: begin
			if(rx_data == `CORRECT_ADDRESS)
				next_state = VALID_ADDRESS_OUT;
			else
				next_state = IDLE; 
		end
		VALID_ADDRESS_OUT: begin
			valid_address_next = 1;
			valid_address_enable = 1;
			next_state = OUT_EOP_WAIT;
		end
		OUT_EOP_WAIT: begin
			if(eop)
				next_state = IDLE;
			else
				next_state = OUT_EOP_WAIT;
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
				next_state = NEW_BLOCK;
			else
				next_state = PACKET_2_WAIT;
		end
		NEW_BLOCK: begin
			new_block = 1;
			next_state = IDLE;			
		end
		ERROR: begin
			p_error = 1;
			next_state = IDLE;
		end
		
			
	endcase
end
		
endmodule

