// $Id: $
// File name:   USB_controller.sv
// Created:     11/27/2017
// Author:      Chinar Dhamija
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: State Transition Diagram for USB Controller

module USB_controller
(
	input wire clk,
	input wire n_rst,
	input wire shift_enable,
	input wire byte_received,
	input wire [0:7] rx_data,
	input wire transmit_empty,
	input wire data_sent,
	input wire byte_sent,
	input wire crc_sent,
	input wire tx_hold,
	input wire eop,
	input wire transmit_start,
	input wire crc_chk,
	input wire d_edge,
	output reg receiving,
	output reg write_enable,
	output reg error,
	output reg read_enable,
	output reg load_enable,
	output reg tx_enable,
	output reg crc_enable,
	output reg transmitting,
	output reg in_out,
	output reg create_eop
);

	typedef enum bit [3:0] {IDLE, START_RCV, RCV_BYTE, RCVING, RCV_DONE, CRC_CHK, ERROR, CREATE_EOP,
							LOAD, START_TX, HOLD_TX, READ, CHK_CRC, HOLD_CRC}
	stateType;
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

	always_comb
	begin
		next_state = current_state;

		receiving = 0;
		write_enable = 0;
		error = 0;
		read_enable = 0;
		load_enable = 0;
		tx_enable = 0;
		crc_enable = 0;
		transmitting = 0;
		in_out = 0;	
		create_eop = 0;

		case(current_state)
			IDLE: begin
				next_state = IDLE;
				receiving = 0;
				write_enable = 0;
				error = 0;
				read_enable = 0;
				load_enable = 0;
				tx_enable = 0;
				crc_enable = 0;
				transmitting = 0;
				in_out = 0;

				if(d_edge)
					next_state = START_RCV;
				if(transmit_start || transmit_empty)
					next_state = LOAD;
			end
			START_RCV: begin
				next_state = START_RCV;
				receiving = 1;
				in_out = 0;
				if(byte_received)
					next_state = RCV_BYTE;
			end
			RCV_BYTE: begin
				next_state = RCV_BYTE;
				receiving = 1;
				if(rx_data == 8'b01010100) //sync pattern
					next_state = RCVING;
				else
					next_state = ERROR;
			end
			ERROR: begin
				next_state = ERROR;
				error = 1;
				if(eop)
					next_state = IDLE;
			end
			RCVING: begin
				next_state = RCVING;
				receiving = 1;
				if(!eop && !byte_received)
					next_state = RCVING;
				if(eop)
					next_state = ERROR;
				if(!eop & byte_received)
					next_state = RCV_DONE;
			end
			RCV_DONE: begin
				next_state = RCV_DONE;
				receiving = 1;
				write_enable = 1;
				if(!eop && shift_enable)
					next_state = RCVING;
				if(eop && shift_enable)
					next_state = CRC_CHK;
			end
			CRC_CHK: begin
				next_state = CRC_CHK;
				if(crc_chk)
					next_state = IDLE;
				else
					next_state = ERROR;
			end
			LOAD: begin
				next_state = START_TX;
				load_enable = 1;
				transmitting = 1;
				in_out = 1;
			end
			START_TX: begin
				next_state = START_TX;
				load_enable = 0;
				tx_enable = 1;
				if(!byte_sent && !tx_hold)
					next_state = START_TX;
				if(tx_hold)
					next_state = HOLD_TX;
				if(byte_sent && !tx_hold)
					next_state = READ;
			end
			HOLD_TX: begin
				next_state = START_TX;
				tx_enable = 0;
			end
			READ: begin
				next_state = READ;
				read_enable = 1;
				tx_enable = 0;
				if(!data_sent)
					next_state = LOAD;
				else
					next_state = CHK_CRC;
			end
			CHK_CRC: begin
				next_state = CHK_CRC;
				crc_enable = 1;
				if(crc_sent)
					next_state = CREATE_EOP;
				else
					next_state = HOLD_CRC;
			end
			CREATE_EOP: begin
				create_eop = 1;
				next_state = IDLE;
			end
			HOLD_CRC: begin
				next_state = CHK_CRC;
				crc_enable = 0;
			end
			default: begin
				next_state = IDLE;
			end
			
		endcase
	end

endmodule
