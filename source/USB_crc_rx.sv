// $Id: $
// File name:   USB_crc_block.sv
// Created:     12/1/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: CRC Block

module USB_crc_rx
(
	input wire clk,
	input wire n_rst,
	input wire crc_clear,
	input wire shift_enable,
	input wire d_orig,
	input wire packet_type,
	input wire crc_enable,
	output logic crc_check
);

logic crc_check_5;
logic crc_check_16;
logic temp_crc_check;

always_ff @(posedge clk, negedge n_rst)
begin
	if(n_rst == 'b0)
		temp_crc_check <= 'b0;
	else
		temp_crc_check <= (packet_type) ? crc_check_16 : crc_check_5;
end

assign crc_check = temp_crc_check;


USB_crc_5 CRC_5 (.clk(clk), .n_rst(n_rst), .crc_clear(crc_clear), .shift_enable(shift_enable), .d_orig(d_orig), .crc_check_5(crc_check_5), .crc_enable(crc_enable));

USB_crc_16 CRC_16 (.clk(clk), .n_rst(n_rst), .crc_clear(crc_clear), .shift_enable(shift_enable), .d_orig(d_orig), .crc_check_16(crc_check_16), .crc_enable(crc_enable));

endmodule
