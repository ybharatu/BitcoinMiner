// $Id: $
// File name:   eop_detect.sv
// Created:     11/27/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: USB Transceiver Selector

module USB_transceiver_selector
(
	input wire d_minus_out,
	input wire d_plus_out,
	input wire in_out,
	output logic d_minus_in,
	output logic d_plus_in,
	inout wire d_minus,
	inout wire d_plus
);

assign d_minus = (in_out == 1) ? d_minus_out : 'bz;
assign d_plus = (in_out == 1) ? d_plus_out : 'bz;

assign d_minus_in = (in_out == 0) ? d_minus : 'bz;
assign d_plus_in = (in_out == 0) ? d_plus : 'bz;

endmodule