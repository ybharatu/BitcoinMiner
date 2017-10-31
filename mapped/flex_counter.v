/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Tue Oct 31 18:55:56 2017
/////////////////////////////////////////////////////////////


module flex_counter ( n_rst, clear, clk, count_enable, rollover_val, count_out, 
        rollover_flag );
  input [3:0] rollover_val;
  output [3:0] count_out;
  input n_rst, clear, clk, count_enable;
  output rollover_flag;
  wire   n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47,
         n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61,
         n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72;

  DFFSR \count_reg_reg[0]  ( .D(n38), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[0]) );
  DFFSR \count_reg_reg[1]  ( .D(n37), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[1]) );
  DFFSR \count_reg_reg[2]  ( .D(n36), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[2]) );
  DFFSR \count_reg_reg[3]  ( .D(n35), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[3]) );
  DFFSR rollover_reg_reg ( .D(n34), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        rollover_flag) );
  OAI22X1 U36 ( .A(n39), .B(n40), .C(n41), .D(n42), .Y(n38) );
  OAI22X1 U37 ( .A(n43), .B(n40), .C(n44), .D(n42), .Y(n37) );
  XNOR2X1 U38 ( .A(n41), .B(n45), .Y(n44) );
  NOR2X1 U39 ( .A(n46), .B(n43), .Y(n45) );
  OAI22X1 U40 ( .A(n47), .B(n40), .C(n48), .D(n42), .Y(n36) );
  XNOR2X1 U41 ( .A(n49), .B(n50), .Y(n48) );
  OAI22X1 U42 ( .A(n51), .B(n40), .C(n52), .D(n42), .Y(n35) );
  XOR2X1 U43 ( .A(n53), .B(n54), .Y(n52) );
  NOR2X1 U44 ( .A(n46), .B(n51), .Y(n54) );
  NAND2X1 U45 ( .A(n49), .B(n50), .Y(n53) );
  AND2X1 U46 ( .A(n41), .B(count_out[1]), .Y(n50) );
  NOR2X1 U47 ( .A(n39), .B(n46), .Y(n41) );
  NOR2X1 U48 ( .A(n47), .B(n46), .Y(n49) );
  INVX1 U49 ( .A(n55), .Y(n46) );
  NAND3X1 U50 ( .A(n56), .B(n57), .C(n58), .Y(n55) );
  NOR2X1 U51 ( .A(n59), .B(n60), .Y(n58) );
  XNOR2X1 U52 ( .A(rollover_val[0]), .B(count_out[0]), .Y(n57) );
  XNOR2X1 U53 ( .A(rollover_val[2]), .B(count_out[2]), .Y(n56) );
  INVX1 U54 ( .A(n61), .Y(n40) );
  OAI21X1 U55 ( .A(n62), .B(n63), .C(n64), .Y(n34) );
  NAND2X1 U56 ( .A(rollover_flag), .B(n61), .Y(n64) );
  NAND3X1 U57 ( .A(n65), .B(n66), .C(n67), .Y(n63) );
  XOR2X1 U58 ( .A(n68), .B(n69), .Y(n67) );
  XNOR2X1 U59 ( .A(rollover_val[2]), .B(n47), .Y(n69) );
  INVX1 U60 ( .A(count_out[2]), .Y(n47) );
  NAND2X1 U61 ( .A(count_out[0]), .B(count_out[1]), .Y(n68) );
  XOR2X1 U62 ( .A(n70), .B(n59), .Y(n66) );
  XNOR2X1 U63 ( .A(n51), .B(rollover_val[3]), .Y(n59) );
  XNOR2X1 U64 ( .A(count_out[0]), .B(n60), .Y(n65) );
  XNOR2X1 U65 ( .A(n43), .B(rollover_val[1]), .Y(n60) );
  INVX1 U66 ( .A(count_out[1]), .Y(n43) );
  OR2X1 U67 ( .A(n42), .B(n71), .Y(n62) );
  OAI21X1 U68 ( .A(n51), .B(n70), .C(n72), .Y(n71) );
  XNOR2X1 U69 ( .A(rollover_val[0]), .B(n39), .Y(n72) );
  INVX1 U70 ( .A(count_out[0]), .Y(n39) );
  NAND3X1 U71 ( .A(count_out[0]), .B(count_out[1]), .C(count_out[2]), .Y(n70)
         );
  INVX1 U72 ( .A(count_out[3]), .Y(n51) );
  OR2X1 U73 ( .A(n61), .B(clear), .Y(n42) );
  NOR2X1 U74 ( .A(count_enable), .B(clear), .Y(n61) );
endmodule

