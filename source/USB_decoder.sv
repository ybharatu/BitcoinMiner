// $Id: $
// File name:   decoder.sv
// Created:     11/26/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: USB Decoder

module USB_decoder
(
	input wire d_plus_sync,
	input wire shift_enable,
	input wire eop,
	input wire clk,
	input wire n_rst,
	output wire d_orig
);

logic d_plus_sync_prev;
logic d_plus_sync_shift;
logic temp_d_orig;


always_ff @ (posedge clk, negedge n_rst)
begin
	if(n_rst == 1'b0)
		d_plus_sync_prev <= 1;
	
	else
		d_plus_sync_prev <= d_plus_sync_shift; 
end

always_comb 
begin

	if(shift_enable)
	begin
		if(eop & shift_enable)
		begin
			d_plus_sync_shift = 1;
		end
		else
		begin
			d_plus_sync_shift = d_plus_sync;
		end
	end
	else
	begin
		d_plus_sync_shift = d_plus_sync_prev; 
	end

end

/*
// State Machine
typedef enum bit [3:0] {IDLE, D_ORIG1, D_ORIG2}
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
		shift_enable = 0;
		case(current_state)
			IDLE: begin
				next_state = IDLE;
				if(d_edge) next_state = SHIFT_ENABLE;
			end
			SHIFT_ENABLE: begin
				next_state = CNT1;
				shift_enable = 1;
			end

			CNT1: begin
				if(d_edge) next_state = SHIFT_ENABLE;
				else next_state = CNT2;
			end
			CNT2: begin
				if(d_edge) next_state = SHIFT_ENABLE;
				else next_state = CNT3;
			end
			CNT3: begin
				if(d_edge) next_state = SHIFT_ENABLE;
				else next_state = CNT4;
			end
			CNT4: begin
				if(d_edge) next_state = SHIFT_ENABLE;
				else next_state = CNT5;
			end
			CNT5: begin
				if(d_edge) next_state = SHIFT_ENABLE;
				else next_state = CNT6;
			end
			CNT6: begin
				if(d_edge) next_state = SHIFT_ENABLE;
				else next_state = CNT7;
			end
			CNT7: begin
				if(d_edge) next_state = SHIFT_ENABLE;
				else next_state = SHIFT_ENABLE;
			end
		endcase
	end
*/
assign  d_orig = ~(d_plus_sync ^ d_plus_sync_prev);

endmodule

