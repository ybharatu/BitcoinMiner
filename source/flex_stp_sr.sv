// $Id: $
// File name:   flex_stp_sr.sv
// Created:     9/14/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: N-bit Serial-to-Parallel Shift Register Design

module flex_stp_sr
#(
	parameter NUM_BITS = 4,
	parameter SHIFT_MSB = 1
)
(
	input wire clk,
	input wire n_rst,
	input wire shift_enable,
	input wire serial_in,
	output wire [NUM_BITS - 1:0] parallel_out 
);

reg [NUM_BITS - 1:0] q;

assign parallel_out[NUM_BITS - 1:0] = q[NUM_BITS - 1:0];

always_ff@(posedge clk, negedge n_rst)
begin
	if(n_rst == 0)
	begin
		q <= '1;
	end
	else
	begin
		if (SHIFT_MSB == 1 && shift_enable == 1)
		begin
			q <= {q[NUM_BITS - 2:0], serial_in};
		end
		else if (SHIFT_MSB == 0 && shift_enable == 1)
		begin
			q <= {serial_in, q[NUM_BITS - 1:1]};
		end
		else
		begin
			q[NUM_BITS - 1:0] <= q[NUM_BITS - 1:0];
		end
	end
end

endmodule
