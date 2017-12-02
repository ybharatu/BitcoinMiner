// $Id: $
// File name:   USB_rx_controller.sv
// Created:     11/29/2017
// Author:      Chinar Dhamija
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: USB Receiver Controller

module USB_rx_controller
(
	input wire clk,
	input wire n_rst,
	input wire shift_enable,
	input wire byte_received,
	input wire [7:0] rx_data,
	input wire eop,
	input wire crc_check,
	input wire d_edge,
	output reg receiving,
	output reg write_enable,
	output reg rcv_error
);

	typedef enum bit [3:0] {IDLE, START_RCV, RCV_BYTE, RCVING, RCV_DONE, CRC_CHK, ERROR}
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
		rcv_error = 0;

		case(current_state)
			IDLE: begin
				receiving = 0;
				write_enable = 0;
				rcv_error = 0;
				if(d_edge)
					next_state = START_RCV;
				else
					next_state = IDLE;
			end
			START_RCV: begin
				receiving = 1;
				if(byte_received)
					next_state = RCV_BYTE;
				else
					next_state = START_RCV;
			end
			RCV_BYTE: begin;
				receiving = 1;
				if(rx_data == 8'b01010100) //sync pattern
					next_state = RCVING;
				else
					next_state = ERROR;
			end
			ERROR: begin
				rcv_error = 1;
				receiving = 1;
				if(eop)
					next_state = IDLE;
				else
					next_state = ERROR;
			end
			RCVING: begin
				receiving = 1;
				write_enable = 0;
				if(!eop && !byte_received)
					next_state = RCVING;
				if(eop)
					next_state = ERROR;
				if(!eop & byte_received)
					next_state = RCV_DONE;
			end
			RCV_DONE: begin
				receiving = 1;
				write_enable = 1;
				if(!eop && shift_enable)
					next_state = RCVING;
				else if(eop && shift_enable)
					next_state = CRC_CHK;
				else
					next_state = RCV_DONE;
			end
			CRC_CHK: begin
				receiving = 1;
				write_enable = 0;
				if(crc_check)
					next_state = IDLE;
				else
					next_state = ERROR;
			end
			default: begin
				next_state = IDLE;
			end
			
		endcase
	end

endmodule
