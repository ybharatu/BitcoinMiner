// $Id: $
// File name:   flex_pts_sr.sv
// Created:     9/16/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Parallel to Serial Shift Register

module flex_pts_sr
#(
	parameter NUM_BITS = 4,
	parameter SHIFT_MSB = 1
)
(
	input wire clk,
	input wire n_rst,
	input wire shift_enable,
	input wire load_enable,
	input wire [NUM_BITS - 1:0] parallel_in,
	output wire serial_out 
);

reg [NUM_BITS - 1:0] q;

assign serial_out = (SHIFT_MSB == 1) ? (q[NUM_BITS - 1]) : q[0];

always_ff @ (posedge clk, negedge n_rst) 
begin
	if( n_rst == 0)
	begin
		q <= '1;
	end
	else
	begin
		//if (SHIFT_MSB == 1 && shift_enable == 1)
		if(load_enable == 1)
		begin
			q[NUM_BITS - 1:0] <= parallel_in[NUM_BITS - 1:0];
		end

		else if(SHIFT_MSB == 1 && shift_enable == 1)
		begin
			q[NUM_BITS - 1:0] <= {q[NUM_BITS - 2:0], 1'b1};
		end
		else if(SHIFT_MSB == 0 && shift_enable == 1)
		begin
			q[NUM_BITS - 1:0] <= {1'b1, q[NUM_BITS - 1:1]};
		end
		else
		begin
			q[NUM_BITS - 1:0] <= q[NUM_BITS - 1:0];
		end
	end
end
		

endmodule
