// $Id: $
// File name:   USB_rx_counter.sv
// Created:     12/2/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: 'Counter module for USB_timer_rx

module USB_rx_counter
#(
	parameter NUM_CNT_BITS = 4
)
(
	input wire n_rst,
	input wire clear,
	input wire clk,
	input wire count_enable,
	input wire [NUM_CNT_BITS-1:0] rollover_val,
	output wire [NUM_CNT_BITS-1:0] count_out,
	output wire rollover_flag
);

reg [NUM_CNT_BITS-1:0] count_reg;
logic roll;
logic [NUM_CNT_BITS-1:0] cnt_o;
reg rollover_reg;

assign count_out = count_reg;
assign rollover_flag = rollover_reg;

always_ff @ (posedge clk, negedge n_rst)
begin
	if(n_rst == 0)
	begin
		count_reg <= '0;
		rollover_reg <= 0;
	end
	else
	begin
		count_reg <= cnt_o;
		rollover_reg <= roll;
	end

end

always_comb begin : Inc_logic
	roll = 1'b0;
	if(count_enable)
	begin
		cnt_o = count_reg + 1;
		if(count_reg + 1 == rollover_val)
			roll = 1;
		if(count_reg == rollover_val)
		begin
			cnt_o = 1;
			roll = 0;
		end
	end
	else
	begin
		cnt_o = count_reg;
		roll = rollover_reg;
	end
	
	if(clear)
	begin
		roll = 0;
		cnt_o = 6;
	end
end
endmodule