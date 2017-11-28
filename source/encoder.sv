// $Id: $
// File name:   encoder.sv
// Created:     11/26/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: USB Encoder

module encoder
(
	input wire tx_out,
	input wire clk,
	input wire n_rst,
	input wire hash_sent,
	output logic d_minus_out
);