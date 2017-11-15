/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Tue Nov  7 19:43:03 2017
/////////////////////////////////////////////////////////////


module flex_counter_DW01_inc_0 ( A, SUM );
  input [6:0] A;
  output [6:0] SUM;

  wire   [6:2] carry;

  HAX1 U1_1_5 ( .A(A[5]), .B(carry[5]), .YC(carry[6]), .YS(SUM[5]) );
  HAX1 U1_1_4 ( .A(A[4]), .B(carry[4]), .YC(carry[5]), .YS(SUM[4]) );
  HAX1 U1_1_3 ( .A(A[3]), .B(carry[3]), .YC(carry[4]), .YS(SUM[3]) );
  HAX1 U1_1_2 ( .A(A[2]), .B(carry[2]), .YC(carry[3]), .YS(SUM[2]) );
  HAX1 U1_1_1 ( .A(A[1]), .B(A[0]), .YC(carry[2]), .YS(SUM[1]) );
  INVX2 U1 ( .A(A[0]), .Y(SUM[0]) );
  XOR2X1 U2 ( .A(carry[6]), .B(A[6]), .Y(SUM[6]) );
endmodule


module flex_counter_DW01_inc_1 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;

  wire   [7:2] carry;

  HAX1 U1_1_6 ( .A(A[6]), .B(carry[6]), .YC(SUM[7]), .YS(SUM[6]) );
  HAX1 U1_1_5 ( .A(A[5]), .B(carry[5]), .YC(carry[6]), .YS(SUM[5]) );
  HAX1 U1_1_4 ( .A(A[4]), .B(carry[4]), .YC(carry[5]), .YS(SUM[4]) );
  HAX1 U1_1_3 ( .A(A[3]), .B(carry[3]), .YC(carry[4]), .YS(SUM[3]) );
  HAX1 U1_1_2 ( .A(A[2]), .B(carry[2]), .YC(carry[3]), .YS(SUM[2]) );
  HAX1 U1_1_1 ( .A(A[1]), .B(A[0]), .YC(carry[2]), .YS(SUM[1]) );
  INVX2 U1 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module flex_counter ( n_rst, clear, clk, count_enable, rollover_val, count_out, 
        rollover_flag );
  input [6:0] rollover_val;
  output [6:0] count_out;
  input n_rst, clear, clk, count_enable;
  output rollover_flag;
  wire   N5, N6, N7, N8, N9, N10, N11, N12, N16, N17, N18, N19, N20, N21, N22,
         N28, N29, N30, N31, N32, N33, N34, n37, n38, n39, n40, n41, n42, n43,
         n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57,
         n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71,
         n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85,
         n86;

  DFFSR \count_reg_reg[0]  ( .D(n80), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[0]) );
  DFFSR \count_reg_reg[1]  ( .D(n81), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[1]) );
  DFFSR \count_reg_reg[2]  ( .D(n82), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[2]) );
  DFFSR \count_reg_reg[3]  ( .D(n83), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[3]) );
  DFFSR \count_reg_reg[4]  ( .D(n84), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[4]) );
  DFFSR \count_reg_reg[5]  ( .D(n85), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[5]) );
  DFFSR \count_reg_reg[6]  ( .D(n86), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[6]) );
  DFFSR rollover_reg_reg ( .D(n37), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        rollover_flag) );
  flex_counter_DW01_inc_0 add_49_aco ( .A({N34, N33, N32, N31, N30, N29, N28}), 
        .SUM({N22, N21, N20, N19, N18, N17, N16}) );
  flex_counter_DW01_inc_1 add_50 ( .A({1'b0, count_out}), .SUM({N12, N11, N10, 
        N9, N8, N7, N6, N5}) );
  OAI21X1 U35 ( .A(n38), .B(n39), .C(n40), .Y(n80) );
  NAND2X1 U36 ( .A(N16), .B(n41), .Y(n40) );
  OAI21X1 U37 ( .A(n38), .B(n42), .C(n43), .Y(n81) );
  NAND2X1 U38 ( .A(N17), .B(n41), .Y(n43) );
  OAI21X1 U39 ( .A(n38), .B(n44), .C(n45), .Y(n82) );
  NAND2X1 U40 ( .A(N18), .B(n41), .Y(n45) );
  OAI21X1 U41 ( .A(n38), .B(n46), .C(n47), .Y(n83) );
  NAND2X1 U42 ( .A(N19), .B(n41), .Y(n47) );
  OAI21X1 U43 ( .A(n38), .B(n48), .C(n49), .Y(n84) );
  NAND2X1 U44 ( .A(N20), .B(n41), .Y(n49) );
  OAI21X1 U45 ( .A(n38), .B(n50), .C(n51), .Y(n85) );
  NAND2X1 U46 ( .A(N21), .B(n41), .Y(n51) );
  OAI21X1 U47 ( .A(n38), .B(n52), .C(n53), .Y(n86) );
  NAND2X1 U48 ( .A(N22), .B(n41), .Y(n53) );
  INVX1 U49 ( .A(n54), .Y(n38) );
  OAI21X1 U50 ( .A(n55), .B(n56), .C(n57), .Y(n37) );
  NAND2X1 U51 ( .A(rollover_flag), .B(n54), .Y(n57) );
  NAND3X1 U52 ( .A(n58), .B(n59), .C(n60), .Y(n56) );
  NOR2X1 U53 ( .A(n61), .B(n62), .Y(n60) );
  XOR2X1 U54 ( .A(rollover_val[4]), .B(N9), .Y(n62) );
  XOR2X1 U55 ( .A(rollover_val[3]), .B(N8), .Y(n61) );
  XNOR2X1 U56 ( .A(rollover_val[5]), .B(N10), .Y(n59) );
  NOR2X1 U57 ( .A(n63), .B(n64), .Y(n58) );
  XOR2X1 U58 ( .A(rollover_val[2]), .B(N7), .Y(n64) );
  XOR2X1 U59 ( .A(rollover_val[6]), .B(N11), .Y(n63) );
  NAND3X1 U60 ( .A(n65), .B(n41), .C(n66), .Y(n55) );
  NOR2X1 U61 ( .A(n67), .B(n68), .Y(n66) );
  XOR2X1 U62 ( .A(rollover_val[1]), .B(N6), .Y(n68) );
  XOR2X1 U63 ( .A(rollover_val[0]), .B(N5), .Y(n67) );
  NOR2X1 U64 ( .A(n54), .B(clear), .Y(n41) );
  NOR2X1 U65 ( .A(count_enable), .B(clear), .Y(n54) );
  NOR2X1 U66 ( .A(N12), .B(n69), .Y(n65) );
  NOR2X1 U67 ( .A(n69), .B(n52), .Y(N34) );
  INVX1 U68 ( .A(count_out[6]), .Y(n52) );
  NOR2X1 U69 ( .A(n69), .B(n50), .Y(N33) );
  INVX1 U70 ( .A(count_out[5]), .Y(n50) );
  NOR2X1 U71 ( .A(n69), .B(n48), .Y(N32) );
  INVX1 U72 ( .A(count_out[4]), .Y(n48) );
  NOR2X1 U73 ( .A(n69), .B(n46), .Y(N31) );
  INVX1 U74 ( .A(count_out[3]), .Y(n46) );
  NOR2X1 U75 ( .A(n69), .B(n44), .Y(N30) );
  INVX1 U76 ( .A(count_out[2]), .Y(n44) );
  NOR2X1 U77 ( .A(n69), .B(n42), .Y(N29) );
  NOR2X1 U78 ( .A(n69), .B(n39), .Y(N28) );
  NOR2X1 U79 ( .A(n70), .B(n71), .Y(n69) );
  NAND3X1 U80 ( .A(n72), .B(n73), .C(n74), .Y(n71) );
  XNOR2X1 U81 ( .A(count_out[5]), .B(rollover_val[5]), .Y(n74) );
  XNOR2X1 U82 ( .A(count_out[6]), .B(rollover_val[6]), .Y(n73) );
  XNOR2X1 U83 ( .A(count_out[4]), .B(rollover_val[4]), .Y(n72) );
  NAND3X1 U84 ( .A(n75), .B(n76), .C(n77), .Y(n70) );
  NOR2X1 U85 ( .A(n78), .B(n79), .Y(n77) );
  XNOR2X1 U86 ( .A(rollover_val[1]), .B(n42), .Y(n79) );
  INVX1 U87 ( .A(count_out[1]), .Y(n42) );
  XNOR2X1 U88 ( .A(rollover_val[0]), .B(n39), .Y(n78) );
  INVX1 U89 ( .A(count_out[0]), .Y(n39) );
  XNOR2X1 U90 ( .A(count_out[2]), .B(rollover_val[2]), .Y(n76) );
  XNOR2X1 U91 ( .A(count_out[3]), .B(rollover_val[3]), .Y(n75) );
endmodule

