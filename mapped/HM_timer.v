/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Fri Dec  1 15:20:49 2017
/////////////////////////////////////////////////////////////


module HM_timer ( cnt_up, clk, n_rst, hash_rollover, count );
  output [6:0] count;
  input cnt_up, clk, n_rst;
  output hash_rollover;

  tri   \*Logic1* ;
  tri   \*Logic0* ;
  tri   cnt_up;
  tri   clk;
  tri   n_rst;
  tri   hash_rollover;
  tri   [6:0] count;

  flex_counter_fix HASH_CNT ( .count_enable(cnt_up), .clk(clk), .n_rst(n_rst), 
        .rollover_val({1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1}), 
        .rollover_flag(hash_rollover), .count_out(count) );
endmodule

