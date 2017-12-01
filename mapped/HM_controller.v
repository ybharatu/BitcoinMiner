/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Fri Dec  1 15:18:19 2017
/////////////////////////////////////////////////////////////


module HM_controller ( begin_hash, quit_hash, hash_rollover, clk, n_rst, 
        cnt_up, hash_done, clear, halt, init, out_load, hash_select );
  output [1:0] hash_select;
  input begin_hash, quit_hash, hash_rollover, clk, n_rst;
  output cnt_up, hash_done, clear, halt, init, out_load;
  wire   n5, n6, n7, n8, n9, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20,
         n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
         n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63;
  wire   [3:0] currState;

  DFFSR \currState_reg[0]  ( .D(n63), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        currState[0]) );
  DFFSR \currState_reg[1]  ( .D(n61), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        currState[1]) );
  DFFSR \currState_reg[3]  ( .D(n62), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        currState[3]) );
  DFFSR \currState_reg[2]  ( .D(n60), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        currState[2]) );
  AND2X2 U7 ( .A(n35), .B(n36), .Y(n44) );
  AND2X2 U8 ( .A(n39), .B(n56), .Y(n29) );
  AND2X2 U9 ( .A(n30), .B(n5), .Y(n58) );
  AND2X2 U10 ( .A(currState[2]), .B(n14), .Y(n57) );
  INVX2 U11 ( .A(n59), .Y(n5) );
  INVX2 U12 ( .A(n42), .Y(n6) );
  INVX2 U13 ( .A(n31), .Y(n7) );
  INVX2 U14 ( .A(n38), .Y(n8) );
  INVX2 U15 ( .A(out_load), .Y(n9) );
  INVX2 U16 ( .A(n46), .Y(hash_select[1]) );
  INVX2 U17 ( .A(n53), .Y(n11) );
  INVX2 U18 ( .A(init), .Y(n12) );
  INVX2 U19 ( .A(n27), .Y(n13) );
  INVX2 U20 ( .A(currState[3]), .Y(n14) );
  INVX2 U21 ( .A(n40), .Y(n15) );
  INVX2 U22 ( .A(n47), .Y(n16) );
  INVX2 U23 ( .A(currState[1]), .Y(n17) );
  INVX2 U24 ( .A(n25), .Y(n18) );
  INVX2 U25 ( .A(n48), .Y(n19) );
  INVX2 U26 ( .A(currState[0]), .Y(n20) );
  INVX2 U27 ( .A(quit_hash), .Y(n21) );
  INVX2 U28 ( .A(hash_rollover), .Y(n22) );
  AOI21X1 U29 ( .A(n23), .B(n24), .C(quit_hash), .Y(n60) );
  OAI21X1 U30 ( .A(currState[3]), .B(n25), .C(currState[2]), .Y(n23) );
  OAI21X1 U31 ( .A(n6), .B(n17), .C(n26), .Y(n61) );
  OAI21X1 U32 ( .A(n27), .B(n28), .C(n7), .Y(n26) );
  NAND2X1 U33 ( .A(n29), .B(n30), .Y(n28) );
  OAI22X1 U34 ( .A(n6), .B(n14), .C(n5), .D(n31), .Y(n62) );
  OAI21X1 U35 ( .A(n6), .B(n20), .C(n32), .Y(n63) );
  OAI21X1 U36 ( .A(n33), .B(n34), .C(n7), .Y(n32) );
  NAND3X1 U37 ( .A(n35), .B(n21), .C(n36), .Y(n31) );
  NAND2X1 U38 ( .A(n37), .B(n38), .Y(n34) );
  NAND3X1 U39 ( .A(n39), .B(n40), .C(n41), .Y(n33) );
  OAI21X1 U40 ( .A(cnt_up), .B(n43), .C(n44), .Y(n42) );
  NAND3X1 U41 ( .A(n22), .B(n21), .C(n8), .Y(n36) );
  NAND2X1 U42 ( .A(n45), .B(n21), .Y(n35) );
  OAI22X1 U43 ( .A(hash_rollover), .B(n13), .C(begin_hash), .D(n40), .Y(n45)
         );
  OR2X1 U44 ( .A(halt), .B(quit_hash), .Y(n43) );
  NAND3X1 U45 ( .A(n47), .B(n48), .C(n49), .Y(n46) );
  OAI21X1 U46 ( .A(n18), .B(n11), .C(n50), .Y(n49) );
  NAND2X1 U47 ( .A(n51), .B(n37), .Y(hash_select[0]) );
  NAND3X1 U48 ( .A(n12), .B(n9), .C(n52), .Y(halt) );
  NOR2X1 U49 ( .A(n15), .B(hash_done), .Y(n52) );
  NOR2X1 U50 ( .A(n48), .B(n11), .Y(hash_done) );
  NAND2X1 U51 ( .A(n54), .B(n55), .Y(n40) );
  NAND2X1 U52 ( .A(n29), .B(n24), .Y(out_load) );
  NAND2X1 U53 ( .A(n57), .B(n19), .Y(n39) );
  NAND3X1 U54 ( .A(n37), .B(n30), .C(n50), .Y(init) );
  NAND2X1 U55 ( .A(n54), .B(n57), .Y(n37) );
  NAND2X1 U56 ( .A(n13), .B(n38), .Y(cnt_up) );
  NAND2X1 U57 ( .A(n41), .B(n51), .Y(n27) );
  NAND2X1 U58 ( .A(n57), .B(n16), .Y(n51) );
  NAND3X1 U59 ( .A(n41), .B(n24), .C(n58), .Y(clear) );
  NAND3X1 U60 ( .A(n38), .B(n56), .C(n50), .Y(n59) );
  NAND2X1 U61 ( .A(n57), .B(n18), .Y(n50) );
  NAND2X1 U62 ( .A(n53), .B(n16), .Y(n56) );
  NAND2X1 U63 ( .A(n54), .B(n53), .Y(n38) );
  NOR2X1 U64 ( .A(n14), .B(currState[2]), .Y(n53) );
  NOR2X1 U65 ( .A(currState[0]), .B(currState[1]), .Y(n54) );
  NAND2X1 U66 ( .A(n16), .B(n55), .Y(n30) );
  NAND2X1 U67 ( .A(currState[0]), .B(n17), .Y(n47) );
  NAND2X1 U68 ( .A(n18), .B(n55), .Y(n24) );
  NAND2X1 U69 ( .A(currState[1]), .B(currState[0]), .Y(n25) );
  NAND2X1 U70 ( .A(n19), .B(n55), .Y(n41) );
  NOR2X1 U71 ( .A(currState[2]), .B(currState[3]), .Y(n55) );
  NAND2X1 U72 ( .A(currState[1]), .B(n20), .Y(n48) );
endmodule

