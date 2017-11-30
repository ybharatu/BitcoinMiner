// $Id: $
// File name:   USB_encoder.sv
// Created:     11/27/2017
// Author:      Chinar Dhamija
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: USB Encoder

module USB_encoder
(
	input wire clk,
	input wire n_rst,
	input wire tx_out_bit,
	input wire create_eop,
	output wire tx_hold,
	output reg d_plus_out,
	output reg d_minus_out
);

	reg d, d_out;
	reg eop_wait;
	reg stuff_bit;

	typedef enum bit [1:0] {IDLE, WAIT, ORIG_VAL}
	stateType;
	stateType current_state, next_state;

	flex_counter #(4) FLEX_COUNTER 
	(
		.clk(clk), 
		.n_rst(n_rst), 
		.clear(!tx_out_bit), 
		.count_enable(tx_out_bit), 
		.rollover_val(4'd8), 
		.count_out(),
		.rollover_flag(stuff_bit)
	);

	flex_counter #(4) FLEX_COUNTER2 
	(
		.clk(clk), 
		.n_rst(n_rst), 
		.clear(), 
		.count_enable(create_eop), 
		.rollover_val(4'd2), 
		.count_out(),
		.rollover_flag(eop_wait)
	);

	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 1'b0)
		begin
			current_state <= IDLE;
			d_out <= 0;
		end	
		else
		begin
			current_state <= next_state;
			d_out <= d;
		end
	end
	
	always_comb 
	begin
		next_state = current_state;
		d = stuff_bit ? 0 : tx_out_bit;
		d_plus_out = d;
		d_minus_out = !d;

		case(current_state)
			IDLE: begin
				next_state = IDLE;
				d_plus_out = d;
				d_minus_out = !d;
				if(create_eop) next_state = WAIT;
			end
			WAIT: begin
				next_state = WAIT;
				d_plus_out = 0;
				d_minus_out = 0;
				if(create_eop) next_state = ORIG_VAL;
			end
			ORIG_VAL: begin
				next_state = IDLE;
				d_plus_out = 1;
				d_minus_out = 0;
			end
		endcase
	end

	assign tx_hold = stuff_bit;

endmodule


