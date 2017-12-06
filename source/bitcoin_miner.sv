// $Id: $
// File name:   bitcoin_miner.sv
// Created:     12/5/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Bitcoin Miner Top Top Level file
module bitcoin_miner
(
	input clk,
	input n_rst,
	inout wire d_plus,
	inout wire d_minus
);

logic transmit_ack;
logic write_enable;
logic rcv_error;
logic eop;
logic [7:0] rx_data;
logic read_enable;
logic [15:0] tx_data;
logic transmit_empty;
logic transmit_start;

US_rx_top_level USB_RX (.clk(clk), .n_rst(n_rst), .d_plus_in(d_plus), .d_minus_in(d_minus), .packet_type(packet_type), .transmit_ack(transmit_ack), // INPUTS
			.rx_data(rx_data), .write_enable(write_enable), .rcv_error(rcv_error), .eop(eop)); // OUTPUTS

US_tx_top_level USB_TX (.clk(clk), .n_rst(n_rst), .tx_data(tx_data), .transmit_empty(transmit_empty), .transmit_start(transmit_start), // INPUTS
			.d_plus_out(d_plus), .d_minus_out(d_minus), .read_enable(read_enable), ); // OUTPUTS

PD_hash_separation HASH_SEPARATION (.clk(clk), .n_rst(n_rst));




main_controller MAIN_CONTROLLER (.clk(clk), .n_rst(n_rst));
HM_top_level HM_1 (.clk(clk), .n_rst(n_rst));

PD_top_level PD (.clk(clk), .n_rst(n_rst), .chunk_1(chunk_1), .chunk_2(chunk_2), )

endmodule


// Things to figure out
// packet_type