// $Id: $
// File name:   PD_hash_separation.sv
// Created:     12/2/2017
// Author:      Rahul Patni
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: hash separation

module PD_hash_separation
(
	input wire clk, n_rst,
	input wire [15:0][15:0] hash,
	input wire write_fifo,
	output wire [15:0] write_data
);

localparam [7:0] sync_byte = 8'b01010100;
localparam [7:0] PID = 8'b00000000; // Need to change

logic [15:0] check_write_data;
assign write_data = check_write_data;

logic [4:0] count_out;

flex_counter_fix #(5) FLEX_COUNTER_FIX (.clear(), .count_enable(write_fifo), .clk(clk), .n_rst(n_rst), .rollover_val(5'd16), .rollover_flag(), .count_out(count_out));

// assign write_data = (count_out < 16) ? hash[count_out] : {sync_byte, PID};

always_comb begin
	integer j;
	check_write_data = '0;
	for (j = 0; j < 17; j = j + 1) begin
		if (j == count_out && j < 16) begin
			check_write_data = hash[j];
		end
		else if (count_out == j && j == 16) begin
			check_write_data = {sync_byte, PID};
		end
	end
end 

endmodule
