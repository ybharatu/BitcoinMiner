// $Id: $
// File name:   PD_controller.sv
// Created:     12/3/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Controller for Packet Decoder
module PD_controller
(
	input write_enable,
	input [7:0] rx_data,
	input [7:0] byte_count,
	output logic i_data_en,
	output logic i_data_sel,
	output logic [7:0] r_data,
	output logic p_error
	output logic host_error,
	output logic stop_calc,
	output logic new_block
)

	typedef enum bit [3:0] {IDLE,}
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
		p_error = 0;
		host_error = 0;
		stop_calc = 0;
		new_block = 0;
		i_data_en = 0;
		i_data_sel = 0;
		r_data = 0;

		case(current_state)
			IDLE: begin
				if(write_enable)
					next_state = READ_PID;
			end
		endcase
	end
			
endmodule
