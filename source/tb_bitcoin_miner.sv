// $Id: $
// File name:   tb_bitcoin_miner.sv
// Created:     12/6/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Main test bench for Overall Top Level Bitcoin Miner Test Bench

`timescale 1ns / 10ps
`define SYNC_BYTE 8'b10000000
`define DATA0   8'b11000011
`define DATA1   8'b01001011
`define IN  8'b01101001
`define OUT 8'b11100001
`define INTERRUPT   8'b00000100
`define HASH   8'b00000001
`define CORRECT_ADDRESS 7'b0010101
`define END_P 8'b11101111
`define NACK	8'b01011010
`define ACK	8'b11010010

module tb_bitcoin_miner ();

	localparam	CLK_PERIOD = 10; //??
	localparam	BUS_PERIOD = 80;
	localparam	BYTE_PERIOD = 640;
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
	reg rcv_minus;
	reg rcv_plus;
	reg tb_packet_type;
	reg [7:0] tb_rx_data;
	reg tb_write_enable;
	reg tb_rcv_error;

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

	always_comb begin
		if(!tb_transmitting) begin
			rcv_minus = tb_d_minus;
			rcv_plus = tb_d_plus;
		end
		else begin
			rcv_minus = 1'b0;
			rcv_plus = 1'b1;
		end
	end

	bitcoin_miner MINER (.clk(tb_clk), .n_rst(tb_n_rst), .d_plus(tb_d_plus), .d_minus(tb_d_minus));

	USB_rx_top_level RX_TOP_LEVEL (.clk(tb_clk), .d_plus_in(rcv_plus), .d_minus_in(rcv_minus), .n_rst(tb_n_rst), .packet_type(tb_packet_type), .rx_data(tb_rx_data), 
		.write_enable(tb_write_enable), .rcv_error(tb_rcv_error), .eop());


	
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
	
	task check_ack;
	begin
		@(posedge tb_write_enable);
		#(CHECK_DELAY);
		if(tb_rx_data == `ACK)
			$info("received ACK");
		else
			$error("FAILED: Received NOT ACK");
		#(BUS_PERIOD *2);
	end
	endtask


	task check_hash;
		input [271:0] data;
		input [31:0] nonce;
	begin
		integer count;
		integer i;
		tb_packet_type = 1;
		count = 0;
		@(posedge tb_write_enable);
			count = count + 1;
			@(posedge tb_write_enable);
			#(CHECK_DELAY);
			if(tb_rx_data != 8'h00)
			begin	
	
				$error("Failed Byte %d: Expected: %d, Actual: %d", count,data[i -: 8], tb_rx_data);
			end
			else
				$info("Byte %d Passed", count);

			count = count + 1;
			@(posedge tb_write_enable);
			#(CHECK_DELAY);
			if(tb_rx_data != 8'h00)
			begin	
	
				$error("Failed Byte %d: Expected: %d, Actual: %d", count,data[i -: 8], tb_rx_data);
			end
			else
				$info("Byte %d Passed", count);
		for(i = 255; i > 0; i = i - 8)
		begin
			count = count + 1;
			@(posedge tb_write_enable);
			#(CHECK_DELAY);
			if(tb_rx_data != data[i -: 8])
			begin	
	
				$error("Failed Byte %d: Expected: %d, Actual: %d", count,data[i -: 8], tb_rx_data);
			end
			else
				$info("Byte %d Passed", count);
		end

			count = count + 1;
			@(posedge tb_write_enable);
			#(CHECK_DELAY);
			if(tb_rx_data != nonce[i -: 8])
			begin	
	
				$error("Failed Byte %d: Expected: %d, Actual: %d", count,data[i -: 8], tb_rx_data);
			end
			else
				$info("Byte %d Passed", count);

			count = count + 1;
			@(posedge tb_write_enable);
			#(CHECK_DELAY);
			if(tb_rx_data != nonce[i -: 8])
			begin	
	
				$error("Failed Byte %d: Expected: %d, Actual: %d", count,data[i -: 8], tb_rx_data);
			end
			else
				$info("Byte %d Passed", count);
		
		$info("******End of test case******\n");
	end
	endtask

	// ENDTASKS

	initial
	begin

		tb_packet_type = 0;

		tb_n_rst = 1'b0;
		tb_transmitting = 1;
		tb_d_minus_reg = 0;
		tb_d_plus_reg = 1;
		@(posedge tb_clk);
		@(posedge tb_clk);
		tb_n_rst = 1'b1;
		#(1);



		send_token(`OUT);

		send_header(640'h0100000050120119172a610421a6c3011dd330d9df07b63616c2cc1f1cd00200000000006657a9252aacd5c0b2940996ecff952228c3067cc38d4885efb5a4ac4247e9f337221b4d4c86041b0f2b5710,
		256'h000000000004864c000000000000000000000000000000000000000000000000,
		16'h8364,
		16'hE83C);

		tb_transmitting = 0;

		check_ack();

		tb_transmitting = 1;

		send_token(`IN);
		
		tb_transmitting = 0;

		check_hash(272'h000000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506, 32'h10572b0f);

		@(posedge eop);
		#(BUS_PERIOD * 2);
		#(CHECK_DELAY);

		tb_transmitting = 1;
		tb_d_plus_reg = 1;
		tb_d_minus_reg = 0;

		#(BYTE_PERIOD);
		
		tb_n_rst = 0;
		#(30);
		tb_n_rst = 1;

		send_token(`OUT);

		send_header(640'h0100000050120119172a610421a6c3011dd330d9df07b63616c2cc1f1cd00200000000006657a9252aacd5c0b2940996ecff952228c3067cc38d4885efb5a4ac4247e9f337221b4d4c86041b002b5710,
		256'h000000000004864c000000000000000000000000000000000000000000000000,
		16'h8364,
		16'h577C);

		tb_transmitting = 0;

		check_ack();

		tb_transmitting = 1;

		#(100*BYTE_PERIOD);

		tb_transmitting = 1;

		send_token(`IN);
		
		tb_transmitting = 0;

		check_hash(272'h000000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506, 32'h10572b0f);

		@(posedge eop);
		#(BUS_PERIOD * 2);
		#(CHECK_DELAY);

		tb_transmitting = 1;
		tb_d_plus_reg = 1;
		tb_d_minus_reg = 0;

		#(BYTE_PERIOD);

		tb_n_rst = 0;
		#(30);
		tb_n_rst = 1;


		send_token(`OUT);

		send_header(640'h0100000050120119172a610421a6c3011dd330d9df07b63616c2cc1f1cd00200000000006657a9252aacd5c0b2940996ecff952228c3067cc38d4885efb5a4ac4247e9f337221b4d4c86041b002b5700, 
		256'h000000000004864c000000000000000000000000000000000000000000000000,
		16'h8364,
		16'h91BD);

;


		//00000000000080b66c911bd5ba14a74260057311eaeb1982802f7010f1a9f090

		tb_transmitting = 0;

		check_ack();

		tb_transmitting = 1;

		#(BYTE_PERIOD);
		
		send_token(`OUT);

		send_sync();
		send_pid(`DATA0);
		send_byte(`INTERRUPT);
		send_byte(8'h41); //BF40
		send_byte(8'h7C);
		send_eop();

		
		tb_transmitting = 0;

		check_ack();

		tb_transmitting = 1;
		#(BYTE_PERIOD);
		

		send_token(`OUT);
	
		send_sync();
		send_pid(`DATA0);
		send_byte(8'b10101010);
		send_byte(8'h41); //BF40
		send_byte(8'h7C);
		send_eop();

		tb_transmitting = 0;
		
		check_ack();

	/*			  send_header(640'h0100000006e533fd1ada86391f3f6c343204b0d278d4aaec1c0b20aa27ba0300000000006abbb3eb3d733a9fe18967fd7d4c117e4ccbbac5bec4d910d900b3ae0793e77f54241b4d4c86041b4089cc00,//9Bcc8940
		256'h000000000004864c000000000000000000000000000000000000000000000000,
		16'hA2F9,
		16'hC13E)
*/
		tb_transmitting = 1;

	end

endmodule


