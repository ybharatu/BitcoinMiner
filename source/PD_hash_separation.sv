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
	input wire [17:0][15:0] valid_hash, // SYNC+PID, METADATA, HASH+NONCE
	input wire transmit_empty,
	input wire transmit_empty_en,
	input wire [7:0] PID,
	input data_sent,
	input wire PID_en,
	input wire read_enable, // changed from write_fifio
	output wire [15:0] tx_data // changed from write_enable
);

localparam [7:0] sync_byte = 8'b10000000;
// localparam [7:0] PID = 8'b00000000; // Need to change

logic [15:0] check_write_data;
assign tx_data = check_write_data;

logic [4:0] count_out;

reg transmit_empty_reg;
reg [7:0] PID_reg;

always_ff @(posedge clk, negedge n_rst) begin
	if (n_rst == 0) begin
		transmit_empty_reg <= '0;
	end
	else if (transmit_empty_en == 1'b1) begin
		transmit_empty_reg <= transmit_empty;
	end
	else begin
		transmit_empty_reg <= transmit_empty_reg;
	end 
end

always_ff @(posedge clk, negedge n_rst) begin
	if (n_rst == 0) begin
		PID_reg <= '0;
	end
	else if (PID_en == 1'b1) begin 
		PID_reg <= PID;
	end 
	else begin
		PID_reg <= PID_reg;
	end
end

flex_counter_fix #(5) FLEX_COUNTER_FIX (.clear(data_sent), .count_enable(read_enable), .clk(clk), .n_rst(n_rst), .rollover_val(5'd19), .rollover_flag(), .count_out(count_out));

always_comb begin
	integer j;
	check_write_data = '0;

	for (j = 0; j < 20; j = j + 1) begin
		if (j == 0 && j == count_out) begin	
			check_write_data = {sync_byte, PID_reg};
		end
		else if (j == 1 && j == count_out) begin
			if (transmit_empty_reg == 1'b0) begin
				check_write_data = 16'd0;
			end
			else begin
				check_write_data = 16'd1;
			end
		end
		else if (j == count_out) begin
			check_write_data = valid_hash[17-(j-2)];
		end
		
	end
end 

endmodule

/*
	for (j = 0; j < 17; j = j + 1) begin
		if (j == count_out && j < 18) begin
			check_write_data = hash[j];
		end
		else if (count_out == j && j == 18) begin
			check_write_data = {sync_byte, PID_reg};
		end
*/