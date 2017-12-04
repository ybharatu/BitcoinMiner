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
	input wire tx_shift,
	output wire tx_hold,
	output reg d_plus_out,
	output reg d_minus_out
);

	reg d, d_out, d_plus;
	reg eop_wait;
	reg stuff_bit;
	reg hold_eop;
	reg restart;

	typedef enum bit [1:0] {IDLE, WAIT, ORIG_VAL}
	stateType;
	stateType current_state, next_state;



	flex_counter #(4) FLEX_COUNTER 
	(
		.clk(clk), 
		.n_rst(n_rst), 
		.clear((!tx_out_bit && tx_shift) || eop_wait || restart), 
		.count_enable(tx_out_bit && tx_shift), 
		.rollover_val(4'd6), 
		.count_out(),
		.rollover_flag(stuff_bit)
	);

	flex_counter #(5) FLEX_COUNTER2 
	(
		.clk(clk), 
		.n_rst(n_rst), 
		.clear(eop_wait), 
		.count_enable(hold_eop), 
		.rollover_val(5'd16), 
		.count_out(),
		.rollover_flag(eop_wait)
	);


	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 1'b0)
		begin
			current_state <= IDLE;
			d_out <= 1;
			d_plus <= 1;
		end	
		else
		begin
			current_state <= next_state;
			d_out <= d;
			d_plus <= d_plus_out;
		end
	end
	
	always_comb 
	begin
		next_state = current_state;
		d = stuff_bit ? 0 : tx_out_bit;
		//d_plus_out = 1;
		//d_minus_out = 0;
		hold_eop = 0;
		restart = 0;
		case(current_state)
			IDLE: begin
				next_state = IDLE;

				if(tx_shift == 1)
				begin
				if(d == 1)
				begin
					if(d_plus == 0)
					begin
						d_plus_out = 0;
						d_minus_out = 1;
					end
					else
					begin
						d_plus_out = 1;
						d_minus_out = 0;
					end
				end
				else
				begin
					if(d_plus == 0)
					begin
						d_plus_out = 1;
						d_minus_out = 0;
					end
					else
					begin
						d_plus_out = 0;
						d_minus_out = 1;
					end

					
				end
				end
				else
				begin
					if(d_plus == 0)
					begin
						d_plus_out = 0;
						d_minus_out = 1;
					end
					else
					begin
						d_plus_out = 1;
						d_minus_out = 0;
					end
				end
				
				if(create_eop) next_state = WAIT;
			end
			WAIT: begin
				next_state = WAIT;
				d_plus_out = 0;
				hold_eop = 1;
				d_minus_out = 0;
				if(eop_wait) next_state = ORIG_VAL;
			end
			ORIG_VAL: begin
				next_state = IDLE;
				d_plus_out = 1;
				d_minus_out = 0;
				restart = 1;
			end
		endcase
	end

	assign tx_hold = stuff_bit;

endmodule


