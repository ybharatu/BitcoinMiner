// $Id: $
// File name:   USB_crc_16.sv
// Created:     11/28/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: crc 16 block for USB receiver

module USB_crc_16
(
	input wire clk,
	input wire n_rst,
	input wire crc_clear,
	input wire shift_enable,
	input wire d_orig,
	input wire crc_enable,
	output logic crc_check_16
);

reg [15:0] q;
reg [15:0] q_next;

always_ff @(posedge clk, negedge n_rst)
begin
	if(n_rst == 'b0)
	begin
		q <= ~(16'b0);
	end
	else
	begin	
		q <= q_next;
	end
end

always_comb 
begin
	if(shift_enable && crc_enable)
	begin
		q_next[0] = (d_orig ^ q[15]);
		q_next[1] = q[0];
		q_next[2] = (q_next[0] ^ q[1]);
		q_next[14:3] = q[13:2];
		q_next[15] = (q_next[0] ^ q[14]);
	end
	else
	begin
		q_next = q;
	end
	if(crc_clear)
	begin
		q_next = ~(16'b0);
	end
	
end


assign crc_check_16 = ~(~q[0] | q[1] | ~q[2] | ~q[3] | q[4] | q[5] | q[6] | q[7] | q[8] | q[9] | q[10] | q[11] | q[12] | q[13] | q[14] | ~q[15]);

endmodule
