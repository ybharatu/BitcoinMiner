// $Id: $
// File name:   tb_USB_rx_top_level.sv
// Created:     12/2/2017
// Author:      Yashwanth Bharatula
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test Bench for RX Top Level File

`timescale 1ns / 10ps
`define DATA0 8'b00000000
`define SYNC_BYTE 8'b10000000


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
	logic tb_eop;
	
	clocking cb @(posedge tb_clk);
		 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output  
			packet_type = tb_packet_type,
			d_plus_in = tb_d_plus_in,
			d_minus_in = tb_d_minus_in;
		input	rx_data = tb_rx_data,
			write_enable = tb_write_enable,
			rcv_error = tb_rcv_error,
			eop = tb_eop;
	endclocking

	task send_header;
		input [639:0] header;
		input [255:0] difficulty;
		input [15:0] crc_1;
		input [15:0] crc_2;
		reg [111:0][7:0] data;
	begin
		integer i;
		integer j;
		integer one_cnt;
		one_cnt = 0;

		data = {header, difficulty};
		send_sync();
		send_pid(`DATA0);

		for(i = 111; i >= 48; i = i - 1)
		begin
			for(j = 0; j < 8; j = j + 1)
			begin
				if(one_cnt == 6)
				begin
					j = j - 1; //STUFF BIT
					one_cnt = 0;
					if(tb_d_plus_in == 1)
					begin
						cb.d_plus_in <= 0;
						cb.d_minus_in <= 1;
					end
					else
					begin
						cb.d_plus_in <= 1;
						cb.d_minus_in <= 0;
					end
				end
				else if(data[i][j] == 0)
				begin
					one_cnt = 0;
					if(tb_d_plus_in == 1)
					begin
						cb.d_plus_in <= 0;
						cb.d_minus_in <= 1;
					end
					else
					begin
						cb.d_plus_in <= 1;
						cb.d_minus_in <= 0;
					end
				end
				else
				begin
					one_cnt = one_cnt + 1;
					if(tb_d_plus_in == 1)
					begin
						cb.d_plus_in <= 1;
						cb.d_minus_in <= 0;
					end
					else
					begin
						cb.d_plus_in <= 0;
						cb.d_minus_in <= 1;
					end
				end
				#(BUS_PERIOD);
			end
		end;
		send_crc_16(crc_1);
		send_eop();
		#(BUS_PERIOD);
		send_sync();
		send_pid(`DATA0);
		
		for(i = 48; i >= 64; i = i - 1)
		begin
			for(j = 0; j < 8; j = j + 1)
			begin
				if(one_cnt == 6)
				begin
					i = i - 1; //STUFF BIT
					one_cnt = 0;
					if(tb_d_plus_in == 1)
					begin
						cb.d_plus_in <= 0;
						cb.d_minus_in <= 1;
					end
					else
					begin
						cb.d_plus_in <= 1;
						cb.d_minus_in <= 0;
					end
				end
				else if(data[i][j] == 0)
				begin
					one_cnt = 0;
					if(tb_d_plus_in == 1)
					begin
						cb.d_plus_in <= 0;
						cb.d_minus_in <= 1;
					end
					else
					begin
						cb.d_plus_in <= 1;
						cb.d_minus_in <= 0;
					end
				end
				else
				begin
					one_cnt = one_cnt + 1;
					if(tb_d_plus_in == 1)
					begin
						cb.d_plus_in <= 1;
						cb.d_minus_in <= 0;
					end
					else
					begin
						cb.d_plus_in <= 0;
						cb.d_minus_in <= 1;
					end
				end
				#(BUS_PERIOD);
			end
		end
		send_crc_16(crc_1);
		send_eop();

	end
	endtask


	task send_byte;
		input [7:0] data;
	begin
		integer i;
		for(i = 0; i < 8; i = i + 1)
		begin
			if(data[i] == 0)
			begin
				if(tb_d_plus_in == 1)
				begin
					cb.d_plus_in <= 0;
					cb.d_minus_in <= 1;
				end
				else
				begin
					cb.d_plus_in <= 1;
					cb.d_minus_in <= 0;
				end
			end
			else
			begin
				if(tb_d_plus_in == 1)
				begin
					cb.d_plus_in <= 1;
					cb.d_minus_in <= 0;
				end
				else
				begin
					cb.d_plus_in <= 0;
					cb.d_minus_in <= 1;
				end
			end
			#(BUS_PERIOD);
		end
	end
	endtask
	
	task send_sync;
	begin
		send_byte(`SYNC_BYTE);
	end
	endtask

	task send_pid;
		input [7:0] pid;
	begin
		send_byte(pid);
	end
	endtask

	task send_crc_16;
		input [15:0] crc;
	begin
		send_byte(crc[15:8]);
		send_byte(crc[7:0]);
	end
	endtask

	task send_bit;
		input data;
	begin	
		cb.d_plus_in <= data;
		cb.d_minus_in <= ~data;
		#(BUS_PERIOD);
	end
	endtask

	task send_eop;
	begin
		cb.d_plus_in <= 0;
		cb.d_minus_in <= 0;
		#(BUS_PERIOD);
		#(BUS_PERIOD);
		cb.d_plus_in <= 1;
	end
	endtask

	USB_rx_top_level TOP_LEVEL (.clk(tb_clk), .d_plus_in(tb_d_plus_in), .d_minus_in(tb_d_minus_in), .n_rst(tb_n_rst), .packet_type(tb_packet_type), .rx_data(tb_rx_data), 
		.write_enable(tb_write_enable), .rcv_error(tb_rcv_error));

	initial
	begin
		// Initial Reset
		tb_n_rst = 'b0;
		cb.d_plus_in <= 'b1;
		cb.d_minus_in <= 'b0;
		tb_packet_type = 'b0;
		@cb;
		@cb;
		cb.n_rst <= 'b1;
		@cb;

		//Test 1:
		send_sync();
		send_byte(8'b10110100);
		send_byte(8'b10101000);
		send_byte(8'b11110111);
		//send_byte(8'b11110000);
		//send_byte(8'b11111101);
		send_eop;
		#(BUS_PERIOD);

		send_sync();
		send_byte(8'b10000111);
		send_byte(8'b01011100);
		send_byte(8'b10111100);
		send_eop;

		#(BUS_PERIOD);
		tb_packet_type = 'b1;
		send_sync();
		send_byte(8'b11000011);
		send_byte(8'b00000000);
		send_byte(8'b10000000);
		send_byte(8'b01000000);
		send_byte(8'b11000000);
		send_byte(8'b11110111);
		send_byte(8'b01011110);
		send_eop;

		#(BUS_PERIOD);
		tb_packet_type = 'b1;
		send_sync();
		send_byte(8'b11010010);
		send_byte(8'b11000100);
		send_byte(8'b10100010);
		send_byte(8'b11100110);
		send_byte(8'b10010001);
		send_byte(8'b01110000);
		send_byte(8'b00111000);
		send_eop;
		#(BUS_PERIOD); 
		
		//Sending a whole block header
		// First 512  :   0100000050120119172a610421a6c3011dd330d9df07b63616c2cc1f1cd00200000000006657a9252aacd5c0b2940996ecff952228c3067cc38d4885efb5a4ac
		// Second 128 :   4247e9f337221b4d4c86041b0f2b5710
		// Diffficulty:   000000000004864c000000000000000000000000000000000000000000000000
		// First CRC  :   669D
		// Second CRC :	  0693
		send_header(640'h0100000050120119172a610421a6c3011dd330d9df07b63616c2cc1f1cd00200000000006657a9252aacd5c0b2940996ecff952228c3067cc38d4885efb5a4ac4247e9f337221b4d4c86041b0f2b5710,
				256'h000000000004864c000000000000000000000000000000000000000000000000,
				16'h669D,
				16'h0693);
	end

endmodule
