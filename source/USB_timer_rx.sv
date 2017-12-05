// $Id: $
// File name:   timer_rx.sv
// Created:     11/26/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Receiver Timer

module USB_timer_rx
(
	input wire d_edge,
	input wire receiving,
	input wire clk,
	input wire n_rst,
	input wire eop,
	output logic shift_enable,
	output logic byte_received
);

logic temp_shift_enable;
logic temp_byte_received;
logic rf_1;
logic rf_2;
logic clear_bit_stuffing;
logic rcv_edge;
logic rcv_reg;

typedef enum bit [3:0] {IDLE, SHIFT_ENABLE, CNT1, CNT2, CNT3, CNT4, CNT5, CNT6, CNT7}
	stateType;
	stateType current_state, next_state;


//assign clear_bit_stuffing = (rf_1 && rf_2);

//flex_counter #(4) FLEX_COUNTER (.clk(clk), .n_rst(n_rst), .clear(!receiving || d_edge), .count_enable(receiving), .rollover_val(4'd8), .count_out(), .rollover_flag(rf_1));

flex_counter #(4) FLEX_COUNTER2_BYTE_RECEIVED (.clk(clk), .n_rst(n_rst), .clear(!receiving || temp_byte_received), .count_enable(shift_enable), .rollover_val(4'd8), .count_out(), .rollover_flag(temp_byte_received));

flex_counter #(4) FLEX_COUNTER3_BIT_STUFFING (.clk(clk), .n_rst(n_rst), .clear(d_edge), .count_enable(!d_edge & shift_enable), .rollover_val(4'd6), .count_out(), .rollover_flag(rf_2));


always_comb
begin
	if(!rf_2 && rf_1 && receiving)
	begin
		shift_enable = 1;
	end
	else
	begin
		shift_enable = 0;
	end
end

// State Machine
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
			rcv_reg <= 0;
		end	
		else
		begin
			rcv_reg <= receiving;
		end
	end

assign rcv_edge = (rcv_reg && !receiving);

always_comb 
	begin
		next_state = current_state;
		rf_1 = 0;
		case(current_state)
			IDLE: begin
				next_state = IDLE;
				if(d_edge) next_state = SHIFT_ENABLE;
			end
			SHIFT_ENABLE: begin
				next_state = CNT1;
				rf_1 = 1;
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
		if(rcv_edge)
			next_state = IDLE;
	end

//assign shift_enable = temp_shift_enable;
assign byte_received = temp_byte_received;

endmodule
