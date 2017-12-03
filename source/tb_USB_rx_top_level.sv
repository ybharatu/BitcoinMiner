// $Id: $
// File name:   tb_USB_rx_top_level.sv
// Created:     12/2/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test Bench for RX Top Level File

`timescale 1ns / 10ps

module tb_USB_rx_top_level ();

 	localparam	CLK_PERIOD = 10; //??
	localparam	BUS_PERIOD = 80;
	localparam	CHECK_DELAY = 1; // Check 1ns after the rising edge to allow for propagation delay
	
	// Shared Test Variables
	reg tb_clk;
	// Clock generation block

	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end


	integer tb_test_num = 0;
	logic tb_d_plus_in;
	logic tb_d_minus_in;
	logic tb_n_rst;
	logic tb_packet_type;
	logic [7:0] tb_rx_data;
	logic tb_write_enable;
	logic tb_rcv_error;
	
	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output  
			packet_type = tb_packet_type;
		input	rx_data = tb_rx_data,
			write_enable = tb_write_enable,
			rcv_error = tb_rcv_error;

	endclocking

	task send_byte;
		input [7:0] data;
	begin
		integer i;
		for(i = 7; i >= 0; i = i - 1)
		begin
			if(data[i] == 0)
			begin
				if(tb_d_plus_in == 1)
				begin
					tb_d_plus_in = 0;
					tb_d_minus_in = 1;
				end
				else
				begin
					tb_d_plus_in = 1;
					tb_d_minus_in = 0;
				end
			end
			else
			begin
				if(tb_d_plus_in == 1)
				begin
					tb_d_plus_in = 1;
					tb_d_minus_in = 0;
				end
				else
				begin
					tb_d_plus_in = 0;
					tb_d_minus_in = 1;
				end
			end
			#(BUS_PERIOD);
		end
	end
	endtask

	task send_bit;
		input data;
	begin	
		tb_d_plus_in = data;
		tb_d_minus_in = ~data;
		#(BUS_PERIOD);
	end
	endtask

	task send_eop;
	begin
		tb_d_plus_in = 0;
		tb_d_minus_in = 0;
		#(BUS_PERIOD);
	end
	endtask

	USB_rx_top_level TOP_LEVEL (.clk(tb_clk), .d_plus_in(tb_d_plus_in), .d_minus_in(tb_d_minus_in), .n_rst(tb_n_rst), .packet_type(tb_packet_type), .rx_data(tb_rx_data), 
		.write_enable(tb_write_enable), .rcv_error(tb_rcv_error));

	initial
	begin
		// Initial Reset
		tb_n_rst = 'b0;
		tb_d_plus_in = 'b1;
		tb_d_minus_in = 'b0;
		tb_packet_type = 'b0;
		@cb;
		@cb;
		cb.n_rst <= 'b1;
		@cb;
		send_byte(8'b01010100);
		send_byte(8'b11110000);
		send_byte(8'b11111101);
		send_eop;
		
		
	end

endmodule
