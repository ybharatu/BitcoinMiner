// $Id: $
// File name:   tb_bitcoin_miner.sv
// Created:     12/6/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Bitcoin Miner

`timescale 1ns / 10ps
`define SYNC_BYTE 8'b10000000
`define DATA0   8'b11000011
`define DATA1   8'b01001011
`define IN  8'b01101001
`define OUT 8'b11100001
`define INTERRUPT   8'b00000000
`define HASH   8'b00000001
`define CORRECT_ADDRESS 7'b0010101
`define END_P 8'b11101111

module tb_bitcoin_miner ();

	localparam	CLK_PERIOD = 10; //??
	localparam	BUS_PERIOD = 80;
	localparam	CHECK_DELAY = 1; // Check 1ns after the rising edge to allow for propagation delay


	integer tb_test_num = 0;
	logic tb_n_rst;
	wire tb_d_minus;
	wire tb_d_plus;
	logic tb_clk;
	logic tb_d_minus_reg;
	logic tb_d_plus_reg;
	logic tb_transmitting;
	reg eop;

	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end


	always_ff @ (posedge tb_clk) begin
		eop <= !tb_d_minus && !tb_d_plus;
	end

	bitcoin_miner MINER (.clk(tb_clk), .n_rst(tb_n_rst), .d_plus(tb_d_plus), .d_minus(tb_d_minus));


	
	assign tb_d_plus = (tb_transmitting == 'b1) ? tb_d_plus_reg : 'bz;
	assign tb_d_minus = (tb_transmitting == 'b1) ? tb_d_minus_reg : 'bz;

	// TASKS: 
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
		send_byte(`HASH);

		for(i = 111; i > 48; i = i - 1)
		begin
			for(j = 0; j < 8; j = j + 1)
			begin
				if(one_cnt == 6)
				begin
					j = j - 1; //STUFF BIT
					one_cnt = 0;
					if(tb_d_plus_reg == 1)
					begin
						tb_d_plus_reg = 0;
						tb_d_minus_reg = 1;
					end
					else
					begin
						tb_d_plus_reg = 1;
						tb_d_minus_reg = 0;
					end
				end
				else if(data[i][j] == 0)
				begin
					one_cnt = 0;
					if(tb_d_plus_reg == 1)
					begin
						tb_d_plus_reg = 0;
						tb_d_minus_reg = 1;
					end
					else
					begin
						tb_d_plus_reg = 1;
						tb_d_minus_reg = 0;
					end
				end
				else
				begin
					one_cnt = one_cnt + 1;
					if(tb_d_plus == 1)
					begin
						tb_d_plus_reg = 1;
						tb_d_minus_reg = 0;
					end
					else
					begin
						tb_d_plus_reg = 0;
						tb_d_minus_reg = 1;
					end
				end
				#(BUS_PERIOD);
			end
		end
		send_byte(crc_1[7:0]);
		send_byte(crc_1[15:8]);
		send_eop();

		tb_transmitting = 0;
		@(posedge eop);
		#(BUS_PERIOD * 2);

		tb_transmitting = 1;
		send_token(`OUT);

		send_sync();
		send_pid(`DATA1);
		
		for(i = 48; i >= 0; i = i - 1)
		begin
			for(j = 0; j < 8; j = j + 1)
			begin
				if(one_cnt == 6)
				begin
					j = j - 1; //STUFF BIT
					one_cnt = 0;
					if(tb_d_plus == 1)
					begin
						tb_d_plus_reg = 0;
						tb_d_minus_reg = 1;
					end
					else
					begin
						tb_d_plus_reg = 1;
						tb_d_minus_reg = 0;
					end
				end
				else if(data[i][j] == 0)
				begin
					one_cnt = 0;
					if(tb_d_plus == 1)
					begin
						tb_d_plus_reg = 0;
						tb_d_minus_reg = 1;
					end
					else
					begin
						tb_d_plus_reg = 1;
						tb_d_minus_reg = 0;
					end
				end
				else
				begin
					one_cnt = one_cnt + 1;
					if(tb_d_plus == 1)
					begin
						tb_d_plus_reg = 1;
						tb_d_minus_reg = 0;
					end
					else
					begin
						tb_d_plus_reg = 0;
						tb_d_minus_reg = 1;
					end
				end
				#(BUS_PERIOD);
			end
		end
		send_byte(crc_2[7:0]);
		send_byte(crc_2[15:8]);
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
				if(tb_d_plus == 1)
				begin
					tb_d_plus_reg = 0;
					tb_d_minus_reg = 1;
				end
				else
				begin
					tb_d_plus_reg = 1;
					tb_d_minus_reg = 0;
				end
			end
			else
			begin
				if(tb_d_plus == 1)
				begin
					tb_d_plus_reg = 1;
					tb_d_minus_reg = 0;
				end
				else
				begin
					tb_d_plus_reg = 0;
					tb_d_minus_reg = 1;
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
		tb_d_plus_reg = data;
		tb_d_minus_reg = ~data;
		#(BUS_PERIOD);
	end
	endtask

	task send_eop;
	begin
		tb_d_plus_reg = 0;
		tb_d_minus_reg = 0;
		#(BUS_PERIOD);
		#(BUS_PERIOD);
		tb_d_plus_reg = 1;
		#(BUS_PERIOD);
	end
	endtask

	task send_address;
		reg [15:0] data;
		reg one_cnt;
	begin
		integer j;
		one_cnt = 0;	
		data = 16'b1010100011110111;
			for(j = 15; j >= 0; j = j - 1)
			begin
				if(one_cnt == 6)
				begin
					j = j + 1; //STUFF BIT
					one_cnt = 0;
					if(tb_d_plus == 1)
					begin
						tb_d_plus_reg = 0;
						tb_d_minus_reg = 1;
					end
					else
					begin
						tb_d_plus_reg = 1;
						tb_d_minus_reg = 0;
					end
				end
				else if(data[j] == 0)
				begin
					one_cnt = 0;
					if(tb_d_plus == 1)
					begin
						tb_d_plus_reg = 0;
						tb_d_minus_reg = 1;
					end
					else
					begin
						tb_d_plus_reg = 1;
						tb_d_minus_reg = 0;
					end
				end
				else
				begin
					one_cnt = one_cnt + 1;
					if(tb_d_plus == 1)
					begin
						tb_d_plus_reg = 1;
						tb_d_minus_reg = 0;
					end
					else
					begin
						tb_d_plus_reg = 0;
						tb_d_minus_reg = 1;
					end
				end
				#(BUS_PERIOD);
			end
	end
	endtask
	
	task send_token;
		input [7:0] pid;
	begin
		#(BUS_PERIOD);
		send_sync();
		send_pid(pid);
		send_address();
		send_eop();
		
	end
	endtask

	// ENDTASKS

	initial
	begin

		tb_n_rst = 1'b0;
		tb_transmitting = 1;
		tb_d_minus_reg = 0;
		tb_d_plus_reg = 1;
		@(posedge tb_clk);
		@(posedge tb_clk);
		tb_n_rst = 1'b1;
		#(2);



		send_token(`OUT);

		send_header(640'h0100000050120119172a610421a6c3011dd330d9df07b63616c2cc1f1cd00200000000006657a9252aacd5c0b2940996ecff952228c3067cc38d4885efb5a4ac4247e9f337221b4d4c86041b0f2b5710,
		256'h000000000004864c000000000000000000000000000000000000000000000000,
		16'h8364,
		16'hE83C);

		tb_transmitting = 0;
		@(posedge eop);
		#(BUS_PERIOD * 2);

		tb_transmitting = 1;

		send_token(`IN);
		
		tb_transmitting = 0;
		@(posedge eop);
		#(BUS_PERIOD * 2);

		tb_transmitting = 0;

	end

endmodule


