// $Id: $
// File name:   USB_crc_16.sv
// Created:     11/28/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: crc 16

module USB_crc_tx
(
	input wire clk,
	input wire n_rst,
	input wire crc_clear,
	input wire tx_shift,
	input crc_enable,
	input tx_out_bit,
	input tx_hold,
	output logic [15:0] crc_16
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
	if(tx_shift && !tx_hold && crc_enable)
	begin
		q_next[0] = (tx_out_bit ^ q[15]);
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

assign crc_16 = q;

endmodule
