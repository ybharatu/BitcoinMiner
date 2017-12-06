// $Id: $
// File name:   USB_tx_controller.sv
// Created:     11/29/2017
// Author:      Chinar Dhamija
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: USB Transmitter Controller

module USB_tx_controller
(
	input wire clk,
	input wire n_rst,
	input wire transmit_empty,
	input wire data_sent,
	input wire byte_sent,
	input wire transmit_start,
	input wire tx_shift,
	output reg crc_load,
	output reg read_enable,
	output reg load_enable,
	output reg tx_enable,
	output reg crc_enable,
	output reg transmitting,
	output reg crc_clear, //Find use for this
	output reg create_eop
);
	typedef enum bit [3:0] {IDLE, LOAD_INIT, TRANSMIT_INIT, READ_INIT ,CREATE_EOP, LOAD, START_TX, READ, CHK_CRC, HOLD_CRC, LOAD_CRC, TX_CRC, EOP_WAIT,LOAD_CRC_WAIT, LOAD_WAIT}
	
	stateType;
	stateType current_state, next_state;

	logic read_enable_delay;

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

	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 1'b0)
		begin
			read_enable <= 1'b0;
		end	
		else
		begin
			read_enable <= read_enable_delay;
		end
	end

	always_comb
	begin
		next_state = current_state;
		read_enable_delay = 0;
		load_enable = 0;
		tx_enable = 0;
		crc_enable = 0;
		transmitting = 0;
		create_eop = 0;
		crc_enable = 0;
		crc_clear = 0;
		crc_load = 0;

		case(current_state)
			IDLE: begin
				next_state = IDLE;
				read_enable_delay = 0;
				load_enable = 0;
				tx_enable = 0;
				crc_enable = 0;
				transmitting = 0;
				create_eop = 0;
				crc_clear = 1;
				if(transmit_start || transmit_empty)
					next_state = LOAD_INIT;
			end
			LOAD_INIT: begin
				crc_enable = 0;
				load_enable = 1;
				transmitting = 1;
				next_state = TRANSMIT_INIT;
			end
			
			TRANSMIT_INIT: begin
				load_enable = 0;
				transmitting = 1;
				tx_enable = 1;
				crc_enable = 0;
				if(byte_sent)
					next_state = READ_INIT;
				else
					next_state = TRANSMIT_INIT;
			end
			
			READ_INIT: begin
				read_enable_delay = 1;
				tx_enable = 0;
				transmitting = 1;
				next_state = LOAD_WAIT;
			end
			LOAD_WAIT: begin
				crc_enable = 1;
				transmitting = 1;
				next_state = LOAD;
			end
			LOAD: begin
				next_state = START_TX;
				load_enable = 1;
				transmitting = 1;
				crc_enable = 1;
			end
			START_TX: begin
				next_state = START_TX;
				load_enable = 0;
				transmitting = 1;
				tx_enable = 1;
				crc_enable = 1;
				if(!byte_sent)
					next_state = START_TX;
				else
					next_state = READ;
			end
			READ: begin
				read_enable_delay = 1;
				tx_enable = 0;
				transmitting = 1;
				crc_enable = 1;
				if(!data_sent)
					next_state = LOAD_WAIT;
				else
					next_state = LOAD_CRC_WAIT;
			end
			LOAD_CRC_WAIT: begin
				crc_enable = 1;
				transmitting = 1;
				next_state = LOAD_CRC;
			end
			LOAD_CRC: begin
				crc_enable = 1;
				crc_load = 1;
				read_enable_delay = 0;
				transmitting = 1;
				load_enable = 1;
				next_state = TX_CRC;
			end
			TX_CRC: begin
				transmitting = 1;
				load_enable = 0;
				tx_enable = 1;
				crc_enable = 0;
				if(byte_sent)
					next_state = CREATE_EOP;
				else
					next_state = TX_CRC;
			end
			CREATE_EOP: begin
				create_eop = 1;
				crc_enable = 0;
				transmitting = 1;
				next_state = IDLE;
			end
			default: begin
				next_state = IDLE;
			end
			
		endcase
	end

endmodule
