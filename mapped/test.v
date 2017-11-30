/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Wed Nov 29 15:33:49 2017
/////////////////////////////////////////////////////////////


module test ( count, out, clk );
  input [2:0] count;
  input clk;
  output out;
  wire   n25, n26, n27, n28, n29, n30, n31, n32, n34, n35, n36, n37, n38, n39,
         n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53,
         n54, n55, n56, n57, n58, n59, n60;
  wire   [6:0] test;

  DFFPOSX1 \test_reg[7]  ( .D(n32), .CLK(clk), .Q(out) );
  DFFPOSX1 \test_reg[6]  ( .D(n31), .CLK(clk), .Q(test[6]) );
  DFFPOSX1 \test_reg[5]  ( .D(n30), .CLK(clk), .Q(test[5]) );
  DFFPOSX1 \test_reg[4]  ( .D(n29), .CLK(clk), .Q(test[4]) );
  DFFPOSX1 \test_reg[3]  ( .D(n28), .CLK(clk), .Q(test[3]) );
  DFFPOSX1 \test_reg[2]  ( .D(n27), .CLK(clk), .Q(test[2]) );
  DFFPOSX1 \test_reg[1]  ( .D(n26), .CLK(clk), .Q(test[1]) );
  DFFPOSX1 \test_reg[0]  ( .D(n25), .CLK(clk), .Q(test[0]) );
  INVX1 U38 ( .A(n34), .Y(n32) );
  MUX2X1 U39 ( .B(out), .A(test[6]), .S(n35), .Y(n34) );
  NOR2X1 U40 ( .A(n36), .B(n37), .Y(n35) );
  OAI21X1 U41 ( .A(n38), .B(n39), .C(n40), .Y(n31) );
  OAI21X1 U42 ( .A(n41), .B(n38), .C(test[6]), .Y(n40) );
  OAI21X1 U43 ( .A(n39), .B(n42), .C(n43), .Y(n30) );
  OAI21X1 U44 ( .A(n41), .B(n42), .C(test[5]), .Y(n43) );
  OAI21X1 U45 ( .A(count[1]), .B(n39), .C(n44), .Y(n29) );
  OAI21X1 U46 ( .A(count[1]), .B(n41), .C(test[4]), .Y(n44) );
  OR2X1 U47 ( .A(n45), .B(n41), .Y(n39) );
  MUX2X1 U48 ( .B(n46), .A(n45), .S(n47), .Y(n28) );
  NOR2X1 U49 ( .A(n48), .B(n49), .Y(n47) );
  NAND2X1 U50 ( .A(count[1]), .B(n41), .Y(n49) );
  MUX2X1 U51 ( .B(n50), .A(n45), .S(n51), .Y(n27) );
  NOR2X1 U52 ( .A(count[2]), .B(n38), .Y(n51) );
  MUX2X1 U53 ( .B(n52), .A(n45), .S(n53), .Y(n26) );
  NOR2X1 U54 ( .A(count[2]), .B(n42), .Y(n53) );
  MUX2X1 U55 ( .B(n54), .A(n55), .S(count[0]), .Y(n45) );
  MUX2X1 U56 ( .B(n50), .A(n56), .S(n57), .Y(n55) );
  MUX2X1 U57 ( .B(test[0]), .A(test[4]), .S(count[2]), .Y(n56) );
  INVX1 U58 ( .A(test[2]), .Y(n50) );
  MUX2X1 U59 ( .B(n46), .A(n58), .S(n57), .Y(n54) );
  MUX2X1 U60 ( .B(test[1]), .A(test[5]), .S(count[2]), .Y(n58) );
  INVX1 U61 ( .A(test[3]), .Y(n46) );
  INVX1 U62 ( .A(test[1]), .Y(n52) );
  INVX1 U63 ( .A(n59), .Y(n25) );
  MUX2X1 U64 ( .B(test[0]), .A(out), .S(n60), .Y(n59) );
  AND2X1 U65 ( .A(n37), .B(n36), .Y(n60) );
  AOI22X1 U66 ( .A(count[1]), .B(count[0]), .C(n57), .D(count[2]), .Y(n36) );
  XOR2X1 U67 ( .A(n57), .B(n41), .Y(n37) );
  INVX1 U68 ( .A(count[2]), .Y(n41) );
  NAND2X1 U69 ( .A(n42), .B(n38), .Y(n57) );
  NAND2X1 U70 ( .A(count[1]), .B(n48), .Y(n38) );
  OR2X1 U71 ( .A(n48), .B(count[1]), .Y(n42) );
  INVX1 U72 ( .A(count[0]), .Y(n48) );
endmodule

