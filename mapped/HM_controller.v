/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Sun Nov 26 14:26:04 2017
/////////////////////////////////////////////////////////////


module HM_controller ( begin_hash, quit_hash, hash_count, clk, n_rst, cnt_up, 
        hash_done, clear, halt, hash_select );
  input [6:0] hash_count;
  output [1:0] hash_select;
  input begin_hash, quit_hash, clk, n_rst;
  output cnt_up, hash_done, clear, halt;
  wire   n17, n19, n21, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n38;
  wire   [2:0] currState;

  DFFSR \currState_reg[0]  ( .D(n21), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        currState[0]) );
  DFFSR \currState_reg[2]  ( .D(n19), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        currState[2]) );
  DFFSR \currState_reg[1]  ( .D(n17), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        currState[1]) );
  OAI21X1 U30 ( .A(n24), .B(n25), .C(n26), .Y(n21) );
  AOI22X1 U31 ( .A(n27), .B(begin_hash), .C(currState[0]), .D(n28), .Y(n26) );
  NAND2X1 U32 ( .A(n29), .B(n30), .Y(n28) );
  NOR2X1 U33 ( .A(currState[2]), .B(n31), .Y(n27) );
  OAI21X1 U34 ( .A(halt), .B(n30), .C(n32), .Y(n19) );
  NAND3X1 U35 ( .A(currState[0]), .B(n29), .C(currState[1]), .Y(n32) );
  XNOR2X1 U36 ( .A(currState[1]), .B(n33), .Y(n17) );
  NAND2X1 U37 ( .A(clear), .B(n29), .Y(n33) );
  INVX1 U38 ( .A(n24), .Y(n29) );
  NAND3X1 U39 ( .A(n34), .B(n35), .C(n36), .Y(n24) );
  AND2X1 U40 ( .A(n37), .B(hash_count[6]), .Y(n36) );
  NOR2X1 U41 ( .A(hash_count[1]), .B(hash_count[0]), .Y(n37) );
  NOR2X1 U42 ( .A(hash_count[5]), .B(hash_count[4]), .Y(n35) );
  NOR2X1 U43 ( .A(hash_count[3]), .B(hash_count[2]), .Y(n34) );
  AND2X1 U44 ( .A(currState[1]), .B(clear), .Y(hash_select[1]) );
  INVX1 U45 ( .A(n25), .Y(hash_select[0]) );
  NAND3X1 U46 ( .A(n38), .B(n30), .C(currState[1]), .Y(n25) );
  NOR2X1 U47 ( .A(n31), .B(n30), .Y(hash_done) );
  INVX1 U48 ( .A(currState[2]), .Y(n30) );
  INVX1 U49 ( .A(halt), .Y(n31) );
  NOR2X1 U50 ( .A(currState[2]), .B(halt), .Y(cnt_up) );
  NOR2X1 U51 ( .A(currState[0]), .B(currState[1]), .Y(halt) );
  NOR2X1 U52 ( .A(n38), .B(currState[2]), .Y(clear) );
  INVX1 U53 ( .A(currState[0]), .Y(n38) );
endmodule

