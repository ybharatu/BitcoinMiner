// $Id: $
// File name:   test.sv
// Created:     11/29/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Testing File for synthesis
module test
(
	input [2:0] count,
	output out,
	input clk
);

reg [7:0] test;

assign out = test[7];

always_ff @ (posedge clk) begin

	test[count] = test[count-1];

end

endmodule

