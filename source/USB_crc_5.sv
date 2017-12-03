// $Id: $
// File name:   USB_crc_5.sv
// Created:     11/28/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: CRC 5

module USB_crc_5
(
	input wire clk,
	input wire n_rst,
	input wire crc_clear,
	input wire shift_enable,
	input wire d_orig,
	output logic crc_check_5
);

reg [4:0] q;
reg [4:0] q_next;

always_ff @(posedge clk, negedge n_rst)
begin
	if(n_rst == 'b0)
	begin
		q <= 5'b11111;
	end
	else
	begin	
		q <= q_next;
	end
end

always_comb 
begin
	if(shift_enable)
	begin
	
		q_next[0] = (d_orig ^ q[4]);
		q_next[1] = q[0];
		q_next[2] = q[1] ^ q_next[0];
		q_next[3] = q[2]; 
		q_next[4] = q[3];
	
	end
	else
	begin
		q_next = q;
	end
	if(crc_clear)
	begin
		q_next = 5'b11111;
	end
	
end

assign crc_check_5 = ~(q[0] | q[1] | ~q[2] | ~q[3] | q[4]);

endmodule
