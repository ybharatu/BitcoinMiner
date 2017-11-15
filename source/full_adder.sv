// $Id: $
// File name:   adder_1bit.sv
// Created:     9/5/2017
// Author:      Michael Toner
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: 1 Bit adder
module  full_adder
 (
   input wire a,
   input wire b,
   input wire carry_in,
   output wire sum,
   output wire carry_out
 );

   assign sum = carry_in ^ (a ^ b);
   assign carry_out = ((!carry_in) & b & a) | (carry_in & (b | a));

   
endmodule // full_adder


  
