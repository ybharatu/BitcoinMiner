// $Id: $
// File name:   decoder.sv
// Created:     11/26/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: USB Decoder

module USB_decoder
(
	input wire d_plus_sync,
	input wire shift_enable,
	input wire eop,
	input wire clk,
	input wire n_rst,
	output wire d_orig
);

logic d_plus_sync_prev;
logic d_plus_sync_shift;
logic temp_d_orig;


always_ff @ (posedge clk, negedge n_rst)
begin
	if(n_rst == 1'b0)
		d_plus_sync_prev <= 0;
	else
		d_plus_sync_prev <= d_plus_sync_shift; 
end

always_comb 
begin

	if(shift_enable)
	begin
		d_plus_sync_shift = d_plus_sync;
	end
	else
	begin
		d_plus_sync_shift = d_plus_sync_prev; 
	end
	
	if(shift_enable && eop)
	begin
		temp_d_orig = 1;
	end
	else
	begin
		temp_d_orig = (d_plus_sync ~^ d_plus_sync_prev);
	end

end

assign  d_orig = temp_d_orig;

endmodule

