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

logic write_enable;
logic rcv_error;
logic eop;
logic [7:0] rx_data;
logic read_enable;
logic r_enable; // is this the same as read_enable? only an output from PD_top_level (not an input to anything else)
logic [15:0] tx_data;
logic [15:0] data_bytes; // is this the same as tx_data? only an output from main_controller
logic transmit_empty;
logic transmit_start;
logic [7:0] PID; // only an input for PD_hash_separation
//logic [7:0] pid_byte; // is this the same as PID? only an output from main_controller
logic hash_done; // 2 inputs and 1 output
logic new_block;
logic valid_hash_flag;
logic quit_hash;
logic transmit_ack; // 1 input and 2 outputs
logic transmit_nack;
logic transmit_response;
logic increment; // only an input in PD_top_level
logic [255:0] difficulty;
logic [511:0] data_to_hash;
logic [287:0] valid_hash; 
logic [1:0] hash_select;
logic p_error; // only an input to main_controller
logic host_ready;
logic d_plus_out;
logic d_minus_out;
logic receiving;
logic d_minus_in;
logic d_plus_in;
logic transmitting;
logic load_pid;
logic begin_hash;
logic transmit_eop;
// Things to figure out (their declarations are commented)
logic PID_en; // input to hash_separation
logic transmit_empty_en; // input to hash_separation
logic packet_type; // input to USB_rx

// Not sure how to handle d_plus and d_minus as inputs and outputs

USB_rx_top_level USB_RX (.clk(clk), .n_rst(n_rst), .d_plus_in(d_plus_in), .d_minus_in(d_minus_in), .packet_type(packet_type), .transmit_ack(transmit_ack), // INPUTS
			.rx_data(rx_data), .write_enable(write_enable), .rcv_error(rcv_error), .eop(eop)); // OUTPUTS

USB_tx_top_level USB_TX (.clk(clk), .n_rst(n_rst), .tx_data(tx_data), .transmit_empty(transmit_empty), .transmit_start(transmit_start), // INPUTS
			.d_plus_out(d_plus_out), .d_minus_out(d_minus_out), .read_enable(read_enable), .transmitting(transmitting), .transmit_response(transmit_response), .transmit_eop(transmit_eop), .data_sent(data_sent)); // OUTPUTS

USB_transceiver_selector TX_RX (.d_minus_out(d_minus_out), .d_plus_out(d_plus_out), .transmitting(transmitting), .d_minus_in(d_minus_in), .d_plus_in(d_plus_in), .d_minus(d_minus), .d_plus(d_plus), .transmit_eop(transmit_eop));

PD_hash_separation HASH_SEPARATION (.clk(clk), .n_rst(n_rst),.transmit_empty(transmit_empty), .transmit_empty_en(transmit_empty_en), .PID(PID), .PID_en(PID_en), .read_enable(read_enable), .valid_hash(valid_hash), .data_sent(data_sent), // INPUTS
				    .tx_data(tx_data)); // OUTPUTS

main_controller MAIN_CONTROLLER (.clk(clk), .n_rst(n_rst), .host_ready(host_ready), .rcv_error(rcv_error), .p_error(p_error), .hash_done(hash_done), .new_block(new_block), .valid_hash_flag(valid_hash_flag) , .transmit_nack(transmit_nack), .transmit_response(transmit_response), // INPUTS
				.begin_hash(begin_hash),	 
				.quit_hash(quit_hash), .transmit_empty(transmit_empty), .transmit_start(transmit_start), .transmit_ack(transmit_ack), .data_bytes(data_bytes), .increment(increment), .PID_en(PID_en), .PID(PID), .transmit_empty_en(transmit_empty_en)); // OUTPUTS

HM_top_level HM_1 (.clk(clk), .n_rst(n_rst), .begin_hash(begin_hash), .quit_hash(quit_hash), .difficulty(difficulty), .data_to_hash(data_to_hash), // INPUTS
		   .hash_done(hash_done), .valid_hash_flag(valid_hash_flag), .valid_hash(valid_hash), .hash_select(hash_select)); // OUTPUTS

PD_top_level PD (.clk(clk), .n_rst(n_rst), .write_enable(write_enable), .rx_data(rx_data), .eop(eop), .hash_select(hash_select), .increment(increment), .hash_done(hash_done), // INPUTS
		 .data_to_hash(data_to_hash), .host_ready(host_ready), .difficulty(difficulty), .new_block(new_block), .r_enable(r_enable), .transmit_ack(transmit_ack), .transmit_nack(transmit_nack), .p_error(p_error), .rcv_error(rcv_error), .packet_type(packet_type)); // OUTPUT

endmodule
