// $Id: $
// File name:   sync_high.sv
// Created:     9/5/2017
// Author:      Chinar Dhamija
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Reset to Logic High Synchronizer

module USB_sync_high
(
	input wire clk,
	input wire n_rst,
	input wire async_in,
	output reg sync_out
);

	reg signal;

	always_ff @ (posedge clk, negedge n_rst)
	begin 
		if(1'b0 == n_rst)
		begin
			signal <= 1'b1;
			sync_out <= 1'b1;
		end
		else
		begin
			signal <= async_in;
			sync_out <= signal;
		end
	end

endmodule
