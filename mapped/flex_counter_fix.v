/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Fri Dec  1 15:21:08 2017
/////////////////////////////////////////////////////////////


module flex_counter_fix ( n_rst, clear, clk, count_enable, rollover_val, 
        count_out, rollover_flag );
  input [3:0] rollover_val;
  output [3:0] count_out;
  input n_rst, clear, clk, count_enable;
  output rollover_flag;
  wire   N4, N5, N6, N7, N12, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32,
         n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46,
         n47, n48, n49, n50;
  wire   [4:2] \r300/carry ;

  DFFSR \count_reg_reg[0]  ( .D(n46), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[0]) );
  DFFSR \count_reg_reg[1]  ( .D(n47), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[1]) );
  DFFSR \count_reg_reg[2]  ( .D(n44), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[2]) );
  DFFSR \count_reg_reg[3]  ( .D(n45), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[3]) );
  DFFSR rollover_reg_reg ( .D(n43), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        rollover_flag) );
  AOI22X1 U16 ( .A(count_out[1]), .B(n24), .C(n48), .D(N5), .Y(n23) );
  AOI22X1 U17 ( .A(count_out[0]), .B(n24), .C(n48), .D(N4), .Y(n25) );
  OAI21X1 U18 ( .A(n26), .B(n27), .C(n28), .Y(n43) );
  NAND2X1 U19 ( .A(rollover_flag), .B(n24), .Y(n28) );
  NAND3X1 U20 ( .A(n29), .B(n30), .C(n31), .Y(n27) );
  XNOR2X1 U21 ( .A(N5), .B(rollover_val[1]), .Y(n31) );
  XNOR2X1 U22 ( .A(N6), .B(rollover_val[2]), .Y(n30) );
  XNOR2X1 U23 ( .A(N4), .B(rollover_val[0]), .Y(n29) );
  NAND2X1 U24 ( .A(n32), .B(n33), .Y(n26) );
  XNOR2X1 U25 ( .A(N7), .B(rollover_val[3]), .Y(n33) );
  NOR2X1 U26 ( .A(N12), .B(n34), .Y(n32) );
  AOI22X1 U27 ( .A(count_out[3]), .B(n24), .C(n48), .D(N7), .Y(n35) );
  AOI22X1 U28 ( .A(count_out[2]), .B(n24), .C(n48), .D(N6), .Y(n36) );
  NAND3X1 U29 ( .A(n37), .B(n49), .C(n50), .Y(n34) );
  NAND3X1 U30 ( .A(n38), .B(n39), .C(n40), .Y(n37) );
  NOR2X1 U31 ( .A(n41), .B(n42), .Y(n40) );
  XOR2X1 U32 ( .A(rollover_val[0]), .B(count_out[0]), .Y(n42) );
  XOR2X1 U33 ( .A(rollover_val[3]), .B(count_out[3]), .Y(n41) );
  XNOR2X1 U34 ( .A(count_out[2]), .B(rollover_val[2]), .Y(n39) );
  XNOR2X1 U35 ( .A(count_out[1]), .B(rollover_val[1]), .Y(n38) );
  NOR2X1 U36 ( .A(clear), .B(count_enable), .Y(n24) );
  HAX1 \r300/U1_1_1  ( .A(count_out[1]), .B(count_out[0]), .YC(\r300/carry [2]), .YS(N5) );
  HAX1 \r300/U1_1_2  ( .A(count_out[2]), .B(\r300/carry [2]), .YC(
        \r300/carry [3]), .YS(N6) );
  HAX1 \r300/U1_1_3  ( .A(count_out[3]), .B(\r300/carry [3]), .YC(N12), .YS(N7) );
  INVX2 U37 ( .A(count_out[0]), .Y(N4) );
  INVX2 U38 ( .A(n36), .Y(n44) );
  INVX2 U39 ( .A(n35), .Y(n45) );
  INVX2 U40 ( .A(n25), .Y(n46) );
  INVX2 U41 ( .A(n23), .Y(n47) );
  INVX2 U42 ( .A(n34), .Y(n48) );
  INVX2 U43 ( .A(clear), .Y(n49) );
  INVX2 U44 ( .A(n24), .Y(n50) );
endmodule

