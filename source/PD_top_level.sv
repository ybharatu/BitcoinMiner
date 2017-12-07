// $Id: $
// File name:   PD_top_level.sv
// Created:     11/28/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Top level file for Packet Decoder
module PD_top_level
(
	input wire clk,
	input wire n_rst,
	input wire write_enable,
	input wire [7:0] rx_data,
	input wire eop,
	input wire [1:0] hash_select,
	input wire increment,
	input wire hash_done,
	input wire rcv_error,
	output logic [511:0] data_to_hash,
	output logic p_error,
	output logic host_ready,
	output logic [255:0] difficulty,
	output logic new_block,
	output logic r_enable,
	output logic transmit_ack,
	output logic transmit_nack,
	output logic packet_type
);

logic packet_done;
logic i_data_en;
logic [6:0] i_data_sel;
logic [7:0] i_data;
logic stop_calc;
logic begin_hash;
logic quit_hash;
logic cnt_up;
logic [511:0] chunk_1;
logic [127:0] chunk_2;
logic clr_cnt;
logic [6:0] byte_count;

PD_controller CONTROLLER (.clk(clk), .n_rst(n_rst), .write_enable(write_enable), .rx_data(rx_data), .packet_done(packet_done), .eop(eop), .i_data_en(i_data_en), .packet_type(packet_type),
				.i_data_sel(i_data_sel), .i_data(i_data), .p_error(p_error), .stop_calc(stop_calc), .new_block(new_block), .host_ready(host_ready), .begin_hash(begin_hash), 
				.quit_hash(quit_hash), .cnt_up(cnt_up), .hash_done(hash_done), .clr_cnt(clr_cnt), .transmit_ack(transmit_ack), .byte_count(byte_count), .transmit_nack(transmit_nack), .rcv_error(rcv_error));

PD_block_storage BLOCK_STORAGE (.clk(clk), .n_rst(n_rst), .i_data_en(i_data_en), .i_data_sel(i_data_sel), .i_data(i_data), .difficulty(difficulty), .chunk_1(chunk_1), .chunk_2(chunk_2), .increment(increment));

PD_chunk_decoder CHUNK_DECODER (.hash_select(hash_select), .chunk_1(chunk_1), .chunk_2(chunk_2), .data_to_hash(data_to_hash));

PD_timer TIMER (.clk(clk), .n_rst(n_rst), .cnt_up(cnt_up), .clr_cnt(clr_cnt), .packet_done(packet_done), .byte_count(byte_count));

endmodule
