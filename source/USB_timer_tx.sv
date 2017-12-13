// $Id: $
// File name:   timer_tx.sv
// Created:     11/26/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Transmitter Timer counts to know when we are supposed to send out a bit, send out a byte (16 bits in this context) and when we are supposed to inset a suff bit.
// It also counts when the whole data has been sent and knows when to transmit an EOP signal

module USB_timer_tx
(
	input wire clk,
	input wire n_rst,
	input wire transmitting,
	input wire transmit_empty,
	input wire transmit_start,
	input wire transmit_response,
	input wire tx_hold,
	output logic byte_sent,
	output logic data_sent,
	output logic tx_shift
);

logic [4:0] value;

flex_counter #(4) TX_SHIFT (.clk(clk), .n_rst(n_rst), .clear(!transmitting), .count_enable(transmitting), .rollover_val(4'd8), .count_out(), .rollover_flag(tx_shift));

flex_counter #(5) FLEX_COUNTER (.clk(clk), .n_rst(n_rst), .clear(!transmitting || byte_sent), .count_enable(tx_shift && !tx_hold), .rollover_val(5'd16), .count_out(), .rollover_flag(byte_sent));

flex_counter #(5) FLEX_COUNTER2 (.clk(clk), .n_rst(n_rst), .clear(!transmitting || data_sent), .count_enable(byte_sent), .rollover_val(value), .count_out(), .rollover_flag(data_sent));


typedef enum bit [1:0] {IDLE, HOLD_EMPTY, HOLD_START, HOLD_ACK}
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

// State Machine
always_comb
	begin

		case(current_state)
				
				IDLE: begin
					value = 'b0;
					if(transmit_empty)
						next_state = HOLD_EMPTY;
					else if(transmit_start)
						next_state = HOLD_START;
					else if(transmit_response)
						next_state = HOLD_ACK;
					else
						next_state = IDLE; 
				end
	
				HOLD_EMPTY: begin
					value = 5'd3;
					if(data_sent)
						next_state = IDLE;
					else
						next_state = HOLD_EMPTY;
				end
				
				HOLD_START: begin
					value = 5'd19; // Increase this
					if(data_sent)
						next_state = IDLE;
					else
						next_state = HOLD_START;
				end
				HOLD_ACK: begin
					value = 5'd01;
					if(data_sent)
						next_state = IDLE;
					else
						next_state = HOLD_ACK;
				end
		endcase
	end

endmodule
