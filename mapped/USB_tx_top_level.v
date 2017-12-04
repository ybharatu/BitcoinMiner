/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Sun Dec  3 21:17:56 2017
/////////////////////////////////////////////////////////////


module flex_counter_NUM_CNT_BITS4_1 ( n_rst, clear, clk, count_enable, 
        rollover_val, count_out, rollover_flag );
  input [3:0] rollover_val;
  output [3:0] count_out;
  input n_rst, clear, clk, count_enable;
  output rollover_flag;
  wire   N5, N6, N7, N8, N9, N12, N14, N15, N16, n22, n23, n24, n25, n26, n27,
         n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41,
         n42, n43, n44, n45, N25, N23, N22, \add_50/carry[3] ,
         \add_50/carry[2] , n1, n2, n3, n4, n5, n6, n7, n8, n9;

  DFFSR \count_reg_reg[3]  ( .D(n45), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[3]) );
  DFFSR \count_reg_reg[2]  ( .D(n44), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[2]) );
  DFFSR \count_reg_reg[1]  ( .D(n43), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[1]) );
  DFFSR \count_reg_reg[0]  ( .D(n42), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[0]) );
  DFFSR rollover_reg_reg ( .D(n41), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        rollover_flag) );
  OAI21X1 U15 ( .A(n22), .B(n23), .C(n24), .Y(n41) );
  NAND2X1 U16 ( .A(rollover_flag), .B(n25), .Y(n24) );
  NAND3X1 U17 ( .A(n26), .B(n27), .C(n28), .Y(n23) );
  XNOR2X1 U18 ( .A(rollover_val[1]), .B(N6), .Y(n28) );
  XNOR2X1 U19 ( .A(rollover_val[0]), .B(N5), .Y(n27) );
  XNOR2X1 U20 ( .A(rollover_val[2]), .B(N7), .Y(n26) );
  NAND3X1 U21 ( .A(n29), .B(n30), .C(n31), .Y(n22) );
  NOR2X1 U22 ( .A(N9), .B(n4), .Y(n31) );
  XNOR2X1 U23 ( .A(rollover_val[3]), .B(N8), .Y(n29) );
  OAI21X1 U24 ( .A(N5), .B(n7), .C(n32), .Y(n42) );
  NAND2X1 U25 ( .A(n3), .B(n30), .Y(n32) );
  OAI21X1 U26 ( .A(n6), .B(n7), .C(n33), .Y(n43) );
  NAND2X1 U27 ( .A(N14), .B(n30), .Y(n33) );
  OAI21X1 U28 ( .A(n5), .B(n7), .C(n34), .Y(n44) );
  NAND2X1 U29 ( .A(N15), .B(n30), .Y(n34) );
  OAI21X1 U30 ( .A(n2), .B(n7), .C(n35), .Y(n45) );
  NAND2X1 U31 ( .A(N16), .B(n30), .Y(n35) );
  NOR2X1 U32 ( .A(n25), .B(clear), .Y(n30) );
  NOR2X1 U33 ( .A(clear), .B(count_enable), .Y(n25) );
  NAND3X1 U34 ( .A(n36), .B(n37), .C(n38), .Y(N12) );
  NOR2X1 U35 ( .A(n39), .B(n40), .Y(n38) );
  XOR2X1 U36 ( .A(rollover_val[0]), .B(count_out[0]), .Y(n40) );
  XOR2X1 U37 ( .A(rollover_val[3]), .B(count_out[3]), .Y(n39) );
  XOR2X1 U38 ( .A(n5), .B(rollover_val[2]), .Y(n37) );
  XOR2X1 U39 ( .A(n6), .B(rollover_val[1]), .Y(n36) );
  HAX1 \add_50/U1_1_1  ( .A(count_out[1]), .B(count_out[0]), .YC(
        \add_50/carry[2] ), .YS(N6) );
  HAX1 \add_50/U1_1_2  ( .A(count_out[2]), .B(\add_50/carry[2] ), .YC(
        \add_50/carry[3] ), .YS(N7) );
  HAX1 \add_50/U1_1_3  ( .A(count_out[3]), .B(\add_50/carry[3] ), .YC(N9), 
        .YS(N8) );
  NAND2X1 U8 ( .A(count_out[2]), .B(N12), .Y(n1) );
  AND2X1 U9 ( .A(count_out[0]), .B(N12), .Y(N22) );
  AND2X1 U10 ( .A(count_out[1]), .B(N12), .Y(N23) );
  AND2X1 U11 ( .A(N12), .B(count_out[3]), .Y(N25) );
  INVX2 U12 ( .A(count_out[0]), .Y(N5) );
  INVX2 U13 ( .A(count_out[3]), .Y(n2) );
  INVX2 U14 ( .A(N22), .Y(n3) );
  INVX2 U40 ( .A(N12), .Y(n4) );
  INVX2 U41 ( .A(count_out[2]), .Y(n5) );
  INVX2 U42 ( .A(count_out[1]), .Y(n6) );
  INVX2 U43 ( .A(n25), .Y(n7) );
  XOR2X1 U44 ( .A(N25), .B(n8), .Y(N16) );
  NOR2X1 U45 ( .A(n9), .B(n1), .Y(n8) );
  XOR2X1 U46 ( .A(n1), .B(n9), .Y(N15) );
  NAND2X1 U47 ( .A(N23), .B(N22), .Y(n9) );
  XOR2X1 U48 ( .A(N23), .B(N22), .Y(N14) );
endmodule


module flex_counter_NUM_CNT_BITS5_2 ( n_rst, clear, clk, count_enable, 
        rollover_val, count_out, rollover_flag );
  input [4:0] rollover_val;
  output [4:0] count_out;
  input n_rst, clear, clk, count_enable;
  output rollover_flag;
  wire   N5, N6, N7, N8, N9, N10, N13, N14, N15, N16, N17, N18, n24, n25, n26,
         n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40,
         n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, N28,
         N27, N26, N25, N24, \add_50/carry[4] , \add_50/carry[3] ,
         \add_50/carry[2] , \add_49_aco/carry[4] , \add_49_aco/carry[3] ,
         \add_49_aco/carry[2] , n1, n2, n3, n4, n5, n6;

  DFFSR \count_reg_reg[4]  ( .D(n53), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[4]) );
  DFFSR \count_reg_reg[3]  ( .D(n52), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[3]) );
  DFFSR \count_reg_reg[2]  ( .D(n51), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[2]) );
  DFFSR \count_reg_reg[1]  ( .D(n50), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[1]) );
  DFFSR \count_reg_reg[0]  ( .D(n49), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[0]) );
  DFFSR rollover_reg_reg ( .D(n48), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        rollover_flag) );
  OAI21X1 U17 ( .A(n24), .B(n25), .C(n26), .Y(n48) );
  NAND2X1 U18 ( .A(rollover_flag), .B(n27), .Y(n26) );
  NAND3X1 U19 ( .A(n28), .B(n29), .C(n30), .Y(n25) );
  NOR2X1 U20 ( .A(n31), .B(n32), .Y(n30) );
  XOR2X1 U21 ( .A(rollover_val[0]), .B(N5), .Y(n32) );
  XOR2X1 U22 ( .A(rollover_val[2]), .B(N7), .Y(n31) );
  XNOR2X1 U23 ( .A(rollover_val[1]), .B(N6), .Y(n29) );
  XNOR2X1 U24 ( .A(rollover_val[3]), .B(N8), .Y(n28) );
  NAND3X1 U25 ( .A(n33), .B(n34), .C(n35), .Y(n24) );
  NOR2X1 U26 ( .A(N10), .B(n3), .Y(n35) );
  XNOR2X1 U27 ( .A(rollover_val[4]), .B(N9), .Y(n33) );
  OAI21X1 U28 ( .A(N5), .B(n1), .C(n36), .Y(n49) );
  NAND2X1 U29 ( .A(N14), .B(n34), .Y(n36) );
  OAI21X1 U30 ( .A(n6), .B(n1), .C(n37), .Y(n50) );
  NAND2X1 U31 ( .A(N15), .B(n34), .Y(n37) );
  OAI21X1 U32 ( .A(n5), .B(n1), .C(n38), .Y(n51) );
  NAND2X1 U33 ( .A(N16), .B(n34), .Y(n38) );
  OAI21X1 U34 ( .A(n4), .B(n1), .C(n39), .Y(n52) );
  NAND2X1 U35 ( .A(N17), .B(n34), .Y(n39) );
  OAI21X1 U36 ( .A(n2), .B(n1), .C(n40), .Y(n53) );
  NAND2X1 U37 ( .A(N18), .B(n34), .Y(n40) );
  NOR2X1 U38 ( .A(n27), .B(clear), .Y(n34) );
  NOR2X1 U39 ( .A(clear), .B(count_enable), .Y(n27) );
  NAND3X1 U40 ( .A(n41), .B(n42), .C(n43), .Y(N13) );
  NOR2X1 U41 ( .A(n44), .B(n45), .Y(n43) );
  XOR2X1 U42 ( .A(rollover_val[1]), .B(count_out[1]), .Y(n45) );
  XOR2X1 U43 ( .A(rollover_val[0]), .B(count_out[0]), .Y(n44) );
  XOR2X1 U44 ( .A(n5), .B(rollover_val[2]), .Y(n42) );
  NOR2X1 U45 ( .A(n46), .B(n47), .Y(n41) );
  XOR2X1 U46 ( .A(rollover_val[4]), .B(count_out[4]), .Y(n47) );
  XOR2X1 U47 ( .A(rollover_val[3]), .B(count_out[3]), .Y(n46) );
  HAX1 \add_50/U1_1_1  ( .A(count_out[1]), .B(count_out[0]), .YC(
        \add_50/carry[2] ), .YS(N6) );
  HAX1 \add_50/U1_1_2  ( .A(count_out[2]), .B(\add_50/carry[2] ), .YC(
        \add_50/carry[3] ), .YS(N7) );
  HAX1 \add_50/U1_1_3  ( .A(count_out[3]), .B(\add_50/carry[3] ), .YC(
        \add_50/carry[4] ), .YS(N8) );
  HAX1 \add_50/U1_1_4  ( .A(count_out[4]), .B(\add_50/carry[4] ), .YC(N10), 
        .YS(N9) );
  HAX1 \add_49_aco/U1_1_1  ( .A(N25), .B(N24), .YC(\add_49_aco/carry[2] ), 
        .YS(N15) );
  HAX1 \add_49_aco/U1_1_2  ( .A(N26), .B(\add_49_aco/carry[2] ), .YC(
        \add_49_aco/carry[3] ), .YS(N16) );
  HAX1 \add_49_aco/U1_1_3  ( .A(N27), .B(\add_49_aco/carry[3] ), .YC(
        \add_49_aco/carry[4] ), .YS(N17) );
  AND2X1 U8 ( .A(count_out[0]), .B(N13), .Y(N24) );
  AND2X1 U10 ( .A(count_out[1]), .B(N13), .Y(N25) );
  AND2X1 U11 ( .A(count_out[2]), .B(N13), .Y(N26) );
  AND2X1 U12 ( .A(count_out[3]), .B(N13), .Y(N27) );
  AND2X1 U13 ( .A(N13), .B(count_out[4]), .Y(N28) );
  XOR2X1 U14 ( .A(\add_49_aco/carry[4] ), .B(N28), .Y(N18) );
  INVX2 U15 ( .A(N24), .Y(N14) );
  INVX2 U16 ( .A(count_out[0]), .Y(N5) );
  INVX2 U48 ( .A(n27), .Y(n1) );
  INVX2 U49 ( .A(count_out[4]), .Y(n2) );
  INVX2 U50 ( .A(N13), .Y(n3) );
  INVX2 U51 ( .A(count_out[3]), .Y(n4) );
  INVX2 U52 ( .A(count_out[2]), .Y(n5) );
  INVX2 U53 ( .A(count_out[1]), .Y(n6) );
endmodule


module flex_counter_NUM_CNT_BITS5_1 ( n_rst, clear, clk, count_enable, 
        rollover_val, count_out, rollover_flag );
  input [4:0] rollover_val;
  output [4:0] count_out;
  input n_rst, clear, clk, count_enable;
  output rollover_flag;
  wire   N5, N6, N7, N8, N9, N10, N13, N14, N15, N16, N17, N18, N28, N27, N26,
         N25, N24, \add_50/carry[4] , \add_50/carry[3] , \add_50/carry[2] ,
         \add_49_aco/carry[4] , \add_49_aco/carry[3] , \add_49_aco/carry[2] ,
         n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n17, n18, n19, n20, n21, n22,
         n23, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55,
         n56, n57, n58, n59, n60, n61;

  DFFSR \count_reg_reg[4]  ( .D(n7), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[4]) );
  DFFSR \count_reg_reg[3]  ( .D(n8), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[3]) );
  DFFSR \count_reg_reg[2]  ( .D(n9), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[2]) );
  DFFSR \count_reg_reg[1]  ( .D(n10), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[1]) );
  DFFSR \count_reg_reg[0]  ( .D(n17), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[0]) );
  DFFSR rollover_reg_reg ( .D(n18), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        rollover_flag) );
  OAI21X1 U17 ( .A(n61), .B(n60), .C(n59), .Y(n18) );
  NAND2X1 U18 ( .A(rollover_flag), .B(n58), .Y(n59) );
  NAND3X1 U19 ( .A(n57), .B(n56), .C(n55), .Y(n60) );
  NOR2X1 U20 ( .A(n54), .B(n53), .Y(n55) );
  XOR2X1 U21 ( .A(rollover_val[0]), .B(N5), .Y(n53) );
  XOR2X1 U22 ( .A(rollover_val[2]), .B(N7), .Y(n54) );
  XNOR2X1 U23 ( .A(rollover_val[1]), .B(N6), .Y(n56) );
  XNOR2X1 U24 ( .A(rollover_val[3]), .B(N8), .Y(n57) );
  NAND3X1 U25 ( .A(n52), .B(n51), .C(n50), .Y(n61) );
  NOR2X1 U26 ( .A(N10), .B(n2), .Y(n50) );
  XNOR2X1 U27 ( .A(rollover_val[4]), .B(N9), .Y(n52) );
  OAI21X1 U28 ( .A(N5), .B(n6), .C(n49), .Y(n17) );
  NAND2X1 U29 ( .A(N14), .B(n51), .Y(n49) );
  OAI21X1 U30 ( .A(n5), .B(n6), .C(n48), .Y(n10) );
  NAND2X1 U31 ( .A(N15), .B(n51), .Y(n48) );
  OAI21X1 U32 ( .A(n4), .B(n6), .C(n47), .Y(n9) );
  NAND2X1 U33 ( .A(N16), .B(n51), .Y(n47) );
  OAI21X1 U34 ( .A(n3), .B(n6), .C(n46), .Y(n8) );
  NAND2X1 U35 ( .A(N17), .B(n51), .Y(n46) );
  OAI21X1 U36 ( .A(n1), .B(n6), .C(n45), .Y(n7) );
  NAND2X1 U37 ( .A(N18), .B(n51), .Y(n45) );
  NOR2X1 U38 ( .A(n58), .B(clear), .Y(n51) );
  NOR2X1 U39 ( .A(clear), .B(count_enable), .Y(n58) );
  NAND3X1 U40 ( .A(n44), .B(n43), .C(n23), .Y(N13) );
  NOR2X1 U41 ( .A(n22), .B(n21), .Y(n23) );
  XOR2X1 U42 ( .A(rollover_val[1]), .B(count_out[1]), .Y(n21) );
  XOR2X1 U43 ( .A(rollover_val[0]), .B(count_out[0]), .Y(n22) );
  XOR2X1 U44 ( .A(n4), .B(rollover_val[2]), .Y(n43) );
  NOR2X1 U45 ( .A(n20), .B(n19), .Y(n44) );
  XOR2X1 U46 ( .A(rollover_val[4]), .B(count_out[4]), .Y(n19) );
  XOR2X1 U47 ( .A(rollover_val[3]), .B(count_out[3]), .Y(n20) );
  HAX1 \add_50/U1_1_1  ( .A(count_out[1]), .B(count_out[0]), .YC(
        \add_50/carry[2] ), .YS(N6) );
  HAX1 \add_50/U1_1_2  ( .A(count_out[2]), .B(\add_50/carry[2] ), .YC(
        \add_50/carry[3] ), .YS(N7) );
  HAX1 \add_50/U1_1_3  ( .A(count_out[3]), .B(\add_50/carry[3] ), .YC(
        \add_50/carry[4] ), .YS(N8) );
  HAX1 \add_50/U1_1_4  ( .A(count_out[4]), .B(\add_50/carry[4] ), .YC(N10), 
        .YS(N9) );
  HAX1 \add_49_aco/U1_1_1  ( .A(N25), .B(N24), .YC(\add_49_aco/carry[2] ), 
        .YS(N15) );
  HAX1 \add_49_aco/U1_1_2  ( .A(N26), .B(\add_49_aco/carry[2] ), .YC(
        \add_49_aco/carry[3] ), .YS(N16) );
  HAX1 \add_49_aco/U1_1_3  ( .A(N27), .B(\add_49_aco/carry[3] ), .YC(
        \add_49_aco/carry[4] ), .YS(N17) );
  AND2X1 U8 ( .A(count_out[0]), .B(N13), .Y(N24) );
  AND2X1 U10 ( .A(count_out[1]), .B(N13), .Y(N25) );
  AND2X1 U11 ( .A(count_out[2]), .B(N13), .Y(N26) );
  AND2X1 U12 ( .A(count_out[3]), .B(N13), .Y(N27) );
  AND2X1 U13 ( .A(N13), .B(count_out[4]), .Y(N28) );
  XOR2X1 U14 ( .A(\add_49_aco/carry[4] ), .B(N28), .Y(N18) );
  INVX2 U15 ( .A(N24), .Y(N14) );
  INVX2 U16 ( .A(count_out[0]), .Y(N5) );
  INVX2 U48 ( .A(count_out[4]), .Y(n1) );
  INVX2 U49 ( .A(N13), .Y(n2) );
  INVX2 U50 ( .A(count_out[3]), .Y(n3) );
  INVX2 U51 ( .A(count_out[2]), .Y(n4) );
  INVX2 U52 ( .A(count_out[1]), .Y(n5) );
  INVX2 U53 ( .A(n58), .Y(n6) );
endmodule


module USB_timer_tx ( clk, n_rst, transmitting, transmit_empty, transmit_start, 
        tx_hold, byte_sent, data_sent, tx_shift );
  input clk, n_rst, transmitting, transmit_empty, transmit_start, tx_hold;
  output byte_sent, data_sent, tx_shift;
  wire   _2_net_, _3_net_, _5_net_, N19, N20, N21, N22, N23, N24, n9, n10, n11,
         n3, n4, n5, n6, n7, n8;
  wire   [4:0] value;
  wire   [1:0] current_state;
  wire   [1:0] next_state;

  LATCH \value_reg[0]  ( .CLK(N19), .D(N20), .Q(value[0]) );
  LATCH \next_state_reg[1]  ( .CLK(N19), .D(N24), .Q(next_state[1]) );
  DFFSR \current_state_reg[1]  ( .D(next_state[1]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(current_state[1]) );
  LATCH \next_state_reg[0]  ( .CLK(N19), .D(N23), .Q(next_state[0]) );
  DFFSR \current_state_reg[0]  ( .D(next_state[0]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(current_state[0]) );
  LATCH \value_reg[4]  ( .CLK(N19), .D(N22), .Q(value[4]) );
  LATCH \value_reg[1]  ( .CLK(N19), .D(N21), .Q(value[1]) );
  OR2X1 U13 ( .A(n4), .B(data_sent), .Y(_5_net_) );
  NOR2X1 U14 ( .A(tx_hold), .B(n3), .Y(_3_net_) );
  OR2X1 U15 ( .A(byte_sent), .B(n4), .Y(_2_net_) );
  OAI21X1 U16 ( .A(data_sent), .B(n5), .C(n9), .Y(N24) );
  NAND3X1 U17 ( .A(transmit_start), .B(n8), .C(n10), .Y(n9) );
  NOR2X1 U18 ( .A(transmit_empty), .B(current_state[1]), .Y(n10) );
  OAI21X1 U19 ( .A(data_sent), .B(n7), .C(n11), .Y(N23) );
  NAND3X1 U20 ( .A(n8), .B(n6), .C(transmit_empty), .Y(n11) );
  NAND2X1 U21 ( .A(n5), .B(n7), .Y(N20) );
  NOR2X1 U22 ( .A(n8), .B(current_state[1]), .Y(N21) );
  NOR2X1 U23 ( .A(n6), .B(current_state[0]), .Y(N22) );
  NAND2X1 U24 ( .A(current_state[0]), .B(current_state[1]), .Y(N19) );
  flex_counter_NUM_CNT_BITS4_1 TX_SHIFT ( .n_rst(n_rst), .clear(n4), .clk(clk), 
        .count_enable(transmitting), .rollover_val({1'b1, 1'b0, 1'b0, 1'b0}), 
        .rollover_flag(tx_shift) );
  flex_counter_NUM_CNT_BITS5_2 FLEX_COUNTER ( .n_rst(n_rst), .clear(_2_net_), 
        .clk(clk), .count_enable(_3_net_), .rollover_val({1'b1, 1'b0, 1'b0, 
        1'b0, 1'b0}), .rollover_flag(byte_sent) );
  flex_counter_NUM_CNT_BITS5_1 FLEX_COUNTER2 ( .n_rst(n_rst), .clear(_5_net_), 
        .clk(clk), .count_enable(byte_sent), .rollover_val({value[4], 1'b0, 
        1'b0, value[1:0]}), .rollover_flag(data_sent) );
  INVX2 U7 ( .A(tx_shift), .Y(n3) );
  INVX2 U8 ( .A(transmitting), .Y(n4) );
  INVX2 U9 ( .A(N22), .Y(n5) );
  INVX2 U10 ( .A(current_state[1]), .Y(n6) );
  INVX2 U11 ( .A(N21), .Y(n7) );
  INVX2 U12 ( .A(current_state[0]), .Y(n8) );
endmodule


module USB_crc_tx ( clk, n_rst, crc_clear, tx_shift, crc_enable, tx_out_bit, 
        tx_hold, crc_16 );
  output [15:0] crc_16;
  input clk, n_rst, crc_clear, tx_shift, crc_enable, tx_out_bit, tx_hold;
  wire   n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
         n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n17, n18, n19, n20, n21, n22;
  wire   [15:0] q;

  DFFSR \q_reg[0]  ( .D(n70), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[0]) );
  DFFSR \q_reg[1]  ( .D(n69), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[1]) );
  DFFSR \q_reg[2]  ( .D(n68), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[2]) );
  DFFSR \q_reg[3]  ( .D(n67), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[3]) );
  DFFSR \q_reg[4]  ( .D(n66), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[4]) );
  DFFSR \q_reg[5]  ( .D(n65), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[5]) );
  DFFSR \q_reg[6]  ( .D(n64), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[6]) );
  DFFSR \q_reg[7]  ( .D(n63), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[7]) );
  DFFSR \q_reg[8]  ( .D(n62), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[8]) );
  DFFSR \q_reg[9]  ( .D(n61), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[9]) );
  DFFSR \q_reg[10]  ( .D(n60), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[10]) );
  DFFSR \q_reg[11]  ( .D(n59), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[11]) );
  DFFSR \q_reg[12]  ( .D(n58), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[12]) );
  DFFSR \q_reg[13]  ( .D(n57), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[13]) );
  DFFSR \q_reg[14]  ( .D(n56), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[14]) );
  DFFSR \q_reg[15]  ( .D(n55), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[15]) );
  OAI21X1 U37 ( .A(n35), .B(n19), .C(n37), .Y(n55) );
  AOI21X1 U38 ( .A(n19), .B(q[15]), .C(crc_clear), .Y(n37) );
  XOR2X1 U39 ( .A(crc_16[14]), .B(n22), .Y(n35) );
  OAI21X1 U40 ( .A(crc_16[13]), .B(n36), .C(n38), .Y(n56) );
  AOI21X1 U41 ( .A(n19), .B(q[14]), .C(n18), .Y(n38) );
  OAI21X1 U42 ( .A(crc_16[12]), .B(n36), .C(n39), .Y(n57) );
  AOI21X1 U43 ( .A(n19), .B(q[13]), .C(crc_clear), .Y(n39) );
  OAI21X1 U44 ( .A(crc_16[11]), .B(n36), .C(n40), .Y(n58) );
  AOI21X1 U45 ( .A(n19), .B(q[12]), .C(n18), .Y(n40) );
  OAI21X1 U46 ( .A(crc_16[10]), .B(n19), .C(n41), .Y(n59) );
  AOI21X1 U47 ( .A(n36), .B(q[11]), .C(n18), .Y(n41) );
  OAI21X1 U48 ( .A(crc_16[9]), .B(n36), .C(n42), .Y(n60) );
  AOI21X1 U49 ( .A(n19), .B(q[10]), .C(n18), .Y(n42) );
  OAI21X1 U50 ( .A(crc_16[8]), .B(n19), .C(n43), .Y(n61) );
  AOI21X1 U51 ( .A(n36), .B(q[9]), .C(crc_clear), .Y(n43) );
  OAI21X1 U52 ( .A(crc_16[7]), .B(n19), .C(n44), .Y(n62) );
  AOI21X1 U53 ( .A(n36), .B(q[8]), .C(n18), .Y(n44) );
  OAI21X1 U54 ( .A(crc_16[6]), .B(n19), .C(n45), .Y(n63) );
  AOI21X1 U55 ( .A(n36), .B(q[7]), .C(crc_clear), .Y(n45) );
  OAI21X1 U56 ( .A(crc_16[5]), .B(n19), .C(n46), .Y(n64) );
  AOI21X1 U57 ( .A(n36), .B(q[6]), .C(n18), .Y(n46) );
  OAI21X1 U58 ( .A(crc_16[4]), .B(n19), .C(n47), .Y(n65) );
  AOI21X1 U59 ( .A(n36), .B(q[5]), .C(crc_clear), .Y(n47) );
  OAI21X1 U60 ( .A(crc_16[3]), .B(n19), .C(n48), .Y(n66) );
  AOI21X1 U61 ( .A(n36), .B(q[4]), .C(n18), .Y(n48) );
  OAI21X1 U62 ( .A(crc_16[2]), .B(n19), .C(n49), .Y(n67) );
  AOI21X1 U63 ( .A(n19), .B(q[3]), .C(n18), .Y(n49) );
  OAI21X1 U64 ( .A(n50), .B(n19), .C(n51), .Y(n68) );
  AOI21X1 U65 ( .A(n19), .B(q[2]), .C(n18), .Y(n51) );
  XOR2X1 U66 ( .A(crc_16[1]), .B(n22), .Y(n50) );
  OAI21X1 U67 ( .A(crc_16[0]), .B(n19), .C(n53), .Y(n69) );
  AOI21X1 U68 ( .A(n19), .B(q[1]), .C(crc_clear), .Y(n53) );
  OAI21X1 U69 ( .A(n52), .B(n19), .C(n54), .Y(n70) );
  AOI21X1 U70 ( .A(n19), .B(q[0]), .C(n18), .Y(n54) );
  NAND3X1 U71 ( .A(crc_enable), .B(n21), .C(tx_shift), .Y(n36) );
  XOR2X1 U72 ( .A(crc_16[15]), .B(tx_out_bit), .Y(n52) );
  INVX2 U19 ( .A(n20), .Y(n19) );
  INVX2 U20 ( .A(n17), .Y(n18) );
  INVX2 U21 ( .A(n36), .Y(n20) );
  INVX2 U22 ( .A(crc_clear), .Y(n17) );
  INVX2 U23 ( .A(tx_hold), .Y(n21) );
  INVX2 U24 ( .A(n52), .Y(n22) );
  INVX2 U25 ( .A(q[0]), .Y(crc_16[0]) );
  INVX2 U26 ( .A(q[1]), .Y(crc_16[1]) );
  INVX2 U27 ( .A(q[2]), .Y(crc_16[2]) );
  INVX2 U28 ( .A(q[3]), .Y(crc_16[3]) );
  INVX2 U29 ( .A(q[4]), .Y(crc_16[4]) );
  INVX2 U30 ( .A(q[5]), .Y(crc_16[5]) );
  INVX2 U31 ( .A(q[6]), .Y(crc_16[6]) );
  INVX2 U32 ( .A(q[7]), .Y(crc_16[7]) );
  INVX2 U33 ( .A(q[8]), .Y(crc_16[8]) );
  INVX2 U34 ( .A(q[9]), .Y(crc_16[9]) );
  INVX2 U35 ( .A(q[10]), .Y(crc_16[10]) );
  INVX2 U36 ( .A(q[11]), .Y(crc_16[11]) );
  INVX2 U73 ( .A(q[12]), .Y(crc_16[12]) );
  INVX2 U74 ( .A(q[13]), .Y(crc_16[13]) );
  INVX2 U75 ( .A(q[14]), .Y(crc_16[14]) );
  INVX2 U76 ( .A(q[15]), .Y(crc_16[15]) );
endmodule


module flex_counter_NUM_CNT_BITS4_0 ( n_rst, clear, clk, count_enable, 
        rollover_val, count_out, rollover_flag );
  input [3:0] rollover_val;
  output [3:0] count_out;
  input n_rst, clear, clk, count_enable;
  output rollover_flag;
  wire   N5, N6, N7, N8, N9, N12, N14, N15, N16, N25, N23, N22,
         \add_50/carry[3] , \add_50/carry[2] , n1, n2, n3, n4, n5, n6, n7, n8,
         n9, n10, n16, n17, n18, n19, n20, n21, n39, n40, n41, n42, n43, n44,
         n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55;

  DFFSR \count_reg_reg[3]  ( .D(n10), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[3]) );
  DFFSR \count_reg_reg[2]  ( .D(n16), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[2]) );
  DFFSR \count_reg_reg[1]  ( .D(n17), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[1]) );
  DFFSR \count_reg_reg[0]  ( .D(n18), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[0]) );
  DFFSR rollover_reg_reg ( .D(n19), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        rollover_flag) );
  OAI21X1 U15 ( .A(n55), .B(n54), .C(n53), .Y(n19) );
  NAND2X1 U16 ( .A(rollover_flag), .B(n52), .Y(n53) );
  NAND3X1 U17 ( .A(n51), .B(n50), .C(n49), .Y(n54) );
  XNOR2X1 U18 ( .A(rollover_val[1]), .B(N6), .Y(n49) );
  XNOR2X1 U19 ( .A(rollover_val[0]), .B(N5), .Y(n50) );
  XNOR2X1 U20 ( .A(rollover_val[2]), .B(N7), .Y(n51) );
  NAND3X1 U21 ( .A(n48), .B(n47), .C(n46), .Y(n55) );
  NOR2X1 U22 ( .A(N9), .B(n5), .Y(n46) );
  XNOR2X1 U23 ( .A(rollover_val[3]), .B(N8), .Y(n48) );
  OAI21X1 U24 ( .A(N5), .B(n2), .C(n45), .Y(n18) );
  NAND2X1 U25 ( .A(n4), .B(n47), .Y(n45) );
  OAI21X1 U26 ( .A(n7), .B(n2), .C(n44), .Y(n17) );
  NAND2X1 U27 ( .A(N14), .B(n47), .Y(n44) );
  OAI21X1 U28 ( .A(n6), .B(n2), .C(n43), .Y(n16) );
  NAND2X1 U29 ( .A(N15), .B(n47), .Y(n43) );
  OAI21X1 U30 ( .A(n3), .B(n2), .C(n42), .Y(n10) );
  NAND2X1 U31 ( .A(N16), .B(n47), .Y(n42) );
  NOR2X1 U32 ( .A(n52), .B(clear), .Y(n47) );
  NOR2X1 U33 ( .A(clear), .B(count_enable), .Y(n52) );
  NAND3X1 U34 ( .A(n41), .B(n40), .C(n39), .Y(N12) );
  NOR2X1 U35 ( .A(n21), .B(n20), .Y(n39) );
  XOR2X1 U36 ( .A(rollover_val[0]), .B(count_out[0]), .Y(n20) );
  XOR2X1 U37 ( .A(rollover_val[3]), .B(count_out[3]), .Y(n21) );
  XOR2X1 U38 ( .A(n6), .B(rollover_val[2]), .Y(n40) );
  XOR2X1 U39 ( .A(n7), .B(rollover_val[1]), .Y(n41) );
  HAX1 \add_50/U1_1_1  ( .A(count_out[1]), .B(count_out[0]), .YC(
        \add_50/carry[2] ), .YS(N6) );
  HAX1 \add_50/U1_1_2  ( .A(count_out[2]), .B(\add_50/carry[2] ), .YC(
        \add_50/carry[3] ), .YS(N7) );
  HAX1 \add_50/U1_1_3  ( .A(count_out[3]), .B(\add_50/carry[3] ), .YC(N9), 
        .YS(N8) );
  NAND2X1 U8 ( .A(count_out[2]), .B(N12), .Y(n1) );
  AND2X1 U9 ( .A(count_out[0]), .B(N12), .Y(N22) );
  AND2X1 U10 ( .A(count_out[1]), .B(N12), .Y(N23) );
  AND2X1 U11 ( .A(N12), .B(count_out[3]), .Y(N25) );
  INVX2 U12 ( .A(count_out[0]), .Y(N5) );
  INVX2 U13 ( .A(n52), .Y(n2) );
  INVX2 U14 ( .A(count_out[3]), .Y(n3) );
  INVX2 U40 ( .A(N22), .Y(n4) );
  INVX2 U41 ( .A(N12), .Y(n5) );
  INVX2 U42 ( .A(count_out[2]), .Y(n6) );
  INVX2 U43 ( .A(count_out[1]), .Y(n7) );
  XOR2X1 U44 ( .A(N25), .B(n8), .Y(N16) );
  NOR2X1 U45 ( .A(n9), .B(n1), .Y(n8) );
  XOR2X1 U46 ( .A(n1), .B(n9), .Y(N15) );
  NAND2X1 U47 ( .A(N23), .B(N22), .Y(n9) );
  XOR2X1 U48 ( .A(N23), .B(N22), .Y(N14) );
endmodule


module flex_counter_NUM_CNT_BITS5_0 ( n_rst, clear, clk, count_enable, 
        rollover_val, count_out, rollover_flag );
  input [4:0] rollover_val;
  output [4:0] count_out;
  input n_rst, clear, clk, count_enable;
  output rollover_flag;
  wire   N5, N6, N7, N8, N9, N10, N13, N14, N15, N16, N17, N18, N28, N27, N26,
         N25, N24, \add_50/carry[4] , \add_50/carry[3] , \add_50/carry[2] ,
         \add_49_aco/carry[4] , \add_49_aco/carry[3] , \add_49_aco/carry[2] ,
         n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n17, n18, n19, n20, n21, n22,
         n23, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55,
         n56, n57, n58, n59, n60, n61;

  DFFSR \count_reg_reg[4]  ( .D(n7), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[4]) );
  DFFSR \count_reg_reg[3]  ( .D(n8), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[3]) );
  DFFSR \count_reg_reg[2]  ( .D(n9), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[2]) );
  DFFSR \count_reg_reg[1]  ( .D(n10), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[1]) );
  DFFSR \count_reg_reg[0]  ( .D(n17), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[0]) );
  DFFSR rollover_reg_reg ( .D(n18), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        rollover_flag) );
  OAI21X1 U17 ( .A(n61), .B(n60), .C(n59), .Y(n18) );
  NAND2X1 U18 ( .A(rollover_flag), .B(n58), .Y(n59) );
  NAND3X1 U19 ( .A(n57), .B(n56), .C(n55), .Y(n60) );
  NOR2X1 U20 ( .A(n54), .B(n53), .Y(n55) );
  XOR2X1 U21 ( .A(rollover_val[0]), .B(N5), .Y(n53) );
  XOR2X1 U22 ( .A(rollover_val[2]), .B(N7), .Y(n54) );
  XNOR2X1 U23 ( .A(rollover_val[1]), .B(N6), .Y(n56) );
  XNOR2X1 U24 ( .A(rollover_val[3]), .B(N8), .Y(n57) );
  NAND3X1 U25 ( .A(n52), .B(n51), .C(n50), .Y(n61) );
  NOR2X1 U26 ( .A(N10), .B(n2), .Y(n50) );
  XNOR2X1 U27 ( .A(rollover_val[4]), .B(N9), .Y(n52) );
  OAI21X1 U28 ( .A(N5), .B(n6), .C(n49), .Y(n17) );
  NAND2X1 U29 ( .A(N14), .B(n51), .Y(n49) );
  OAI21X1 U30 ( .A(n5), .B(n6), .C(n48), .Y(n10) );
  NAND2X1 U31 ( .A(N15), .B(n51), .Y(n48) );
  OAI21X1 U32 ( .A(n4), .B(n6), .C(n47), .Y(n9) );
  NAND2X1 U33 ( .A(N16), .B(n51), .Y(n47) );
  OAI21X1 U34 ( .A(n3), .B(n6), .C(n46), .Y(n8) );
  NAND2X1 U35 ( .A(N17), .B(n51), .Y(n46) );
  OAI21X1 U36 ( .A(n1), .B(n6), .C(n45), .Y(n7) );
  NAND2X1 U37 ( .A(N18), .B(n51), .Y(n45) );
  NOR2X1 U38 ( .A(n58), .B(clear), .Y(n51) );
  NOR2X1 U39 ( .A(clear), .B(count_enable), .Y(n58) );
  NAND3X1 U40 ( .A(n44), .B(n43), .C(n23), .Y(N13) );
  NOR2X1 U41 ( .A(n22), .B(n21), .Y(n23) );
  XOR2X1 U42 ( .A(rollover_val[1]), .B(count_out[1]), .Y(n21) );
  XOR2X1 U43 ( .A(rollover_val[0]), .B(count_out[0]), .Y(n22) );
  XOR2X1 U44 ( .A(n4), .B(rollover_val[2]), .Y(n43) );
  NOR2X1 U45 ( .A(n20), .B(n19), .Y(n44) );
  XOR2X1 U46 ( .A(rollover_val[4]), .B(count_out[4]), .Y(n19) );
  XOR2X1 U47 ( .A(rollover_val[3]), .B(count_out[3]), .Y(n20) );
  HAX1 \add_50/U1_1_1  ( .A(count_out[1]), .B(count_out[0]), .YC(
        \add_50/carry[2] ), .YS(N6) );
  HAX1 \add_50/U1_1_2  ( .A(count_out[2]), .B(\add_50/carry[2] ), .YC(
        \add_50/carry[3] ), .YS(N7) );
  HAX1 \add_50/U1_1_3  ( .A(count_out[3]), .B(\add_50/carry[3] ), .YC(
        \add_50/carry[4] ), .YS(N8) );
  HAX1 \add_50/U1_1_4  ( .A(count_out[4]), .B(\add_50/carry[4] ), .YC(N10), 
        .YS(N9) );
  HAX1 \add_49_aco/U1_1_1  ( .A(N25), .B(N24), .YC(\add_49_aco/carry[2] ), 
        .YS(N15) );
  HAX1 \add_49_aco/U1_1_2  ( .A(N26), .B(\add_49_aco/carry[2] ), .YC(
        \add_49_aco/carry[3] ), .YS(N16) );
  HAX1 \add_49_aco/U1_1_3  ( .A(N27), .B(\add_49_aco/carry[3] ), .YC(
        \add_49_aco/carry[4] ), .YS(N17) );
  AND2X1 U8 ( .A(count_out[0]), .B(N13), .Y(N24) );
  AND2X1 U10 ( .A(count_out[1]), .B(N13), .Y(N25) );
  AND2X1 U11 ( .A(count_out[2]), .B(N13), .Y(N26) );
  AND2X1 U12 ( .A(count_out[3]), .B(N13), .Y(N27) );
  AND2X1 U13 ( .A(N13), .B(count_out[4]), .Y(N28) );
  XOR2X1 U14 ( .A(\add_49_aco/carry[4] ), .B(N28), .Y(N18) );
  INVX2 U15 ( .A(N24), .Y(N14) );
  INVX2 U16 ( .A(count_out[0]), .Y(N5) );
  INVX2 U48 ( .A(count_out[4]), .Y(n1) );
  INVX2 U49 ( .A(N13), .Y(n2) );
  INVX2 U50 ( .A(count_out[3]), .Y(n3) );
  INVX2 U51 ( .A(count_out[2]), .Y(n4) );
  INVX2 U52 ( .A(count_out[1]), .Y(n5) );
  INVX2 U53 ( .A(n58), .Y(n6) );
endmodule


module USB_encoder ( clk, n_rst, tx_out_bit, create_eop, tx_shift, tx_hold, 
        d_plus_out, d_minus_out );
  input clk, n_rst, tx_out_bit, create_eop, tx_shift;
  output tx_hold, d_plus_out, d_minus_out;
  wire   _0_net_, _1_net_, eop_wait, hold_eop, d_plus, n14, n15, n16, n17, n18,
         n19, n20, n21, n22, n23, n24, n25, n4, n5, n6, n7, n8, n9, n10, n11,
         n12, n13;
  wire   [1:0] current_state;

  DFFSR \current_state_reg[0]  ( .D(n25), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        current_state[0]) );
  DFFSR \current_state_reg[1]  ( .D(n4), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        current_state[1]) );
  DFFSR d_plus_reg ( .D(d_plus_out), .CLK(clk), .R(1'b1), .S(n_rst), .Q(d_plus) );
  OAI21X1 U16 ( .A(current_state[1]), .B(eop_wait), .C(current_state[0]), .Y(
        n14) );
  OAI21X1 U17 ( .A(eop_wait), .B(n10), .C(n15), .Y(n25) );
  AOI21X1 U18 ( .A(create_eop), .B(n16), .C(n9), .Y(n15) );
  OAI21X1 U19 ( .A(n17), .B(n13), .C(n18), .Y(d_plus_out) );
  AOI21X1 U20 ( .A(n19), .B(n5), .C(n8), .Y(n18) );
  NOR2X1 U21 ( .A(d_plus), .B(n12), .Y(n19) );
  OAI21X1 U22 ( .A(d_plus), .B(n17), .C(n20), .Y(d_minus_out) );
  NAND3X1 U23 ( .A(n5), .B(n16), .C(d_plus), .Y(n20) );
  AOI21X1 U24 ( .A(n21), .B(n16), .C(n9), .Y(n17) );
  NAND3X1 U25 ( .A(n10), .B(n12), .C(n23), .Y(n22) );
  NOR2X1 U26 ( .A(n11), .B(current_state[1]), .Y(hold_eop) );
  NOR2X1 U27 ( .A(current_state[0]), .B(current_state[1]), .Y(n16) );
  OAI21X1 U28 ( .A(tx_hold), .B(n6), .C(tx_shift), .Y(n21) );
  NOR2X1 U29 ( .A(n6), .B(n7), .Y(_1_net_) );
  OAI21X1 U30 ( .A(tx_out_bit), .B(n7), .C(n24), .Y(_0_net_) );
  NOR2X1 U31 ( .A(eop_wait), .B(n8), .Y(n24) );
  NAND2X1 U32 ( .A(current_state[1]), .B(n11), .Y(n23) );
  flex_counter_NUM_CNT_BITS4_0 FLEX_COUNTER ( .n_rst(n_rst), .clear(_0_net_), 
        .clk(clk), .count_enable(_1_net_), .rollover_val({1'b0, 1'b1, 1'b1, 
        1'b0}), .rollover_flag(tx_hold) );
  flex_counter_NUM_CNT_BITS5_0 FLEX_COUNTER2 ( .n_rst(n_rst), .clear(eop_wait), 
        .clk(clk), .count_enable(hold_eop), .rollover_val({1'b1, 1'b0, 1'b0, 
        1'b0, 1'b0}), .rollover_flag(eop_wait) );
  INVX2 U6 ( .A(n14), .Y(n4) );
  INVX2 U7 ( .A(n21), .Y(n5) );
  INVX2 U8 ( .A(tx_out_bit), .Y(n6) );
  INVX2 U9 ( .A(tx_shift), .Y(n7) );
  INVX2 U10 ( .A(n23), .Y(n8) );
  INVX2 U11 ( .A(n22), .Y(n9) );
  INVX2 U12 ( .A(hold_eop), .Y(n10) );
  INVX2 U13 ( .A(current_state[0]), .Y(n11) );
  INVX2 U14 ( .A(n16), .Y(n12) );
  INVX2 U15 ( .A(d_plus), .Y(n13) );
endmodule


module USB_tx_controller ( clk, n_rst, transmit_empty, data_sent, byte_sent, 
        transmit_start, crc_load, read_enable, load_enable, tx_enable, 
        crc_enable, transmitting, crc_clear, create_eop );
  input clk, n_rst, transmit_empty, data_sent, byte_sent, transmit_start;
  output crc_load, read_enable, load_enable, tx_enable, crc_enable,
         transmitting, crc_clear, create_eop;
  wire   n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33,
         n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n5, n6, n7, n8,
         n9, n11, n12, n13, n14, n15, n16, n17, n18, n19;
  wire   [3:0] current_state;
  wire   [3:0] next_state;

  DFFSR \current_state_reg[0]  ( .D(next_state[0]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(current_state[0]) );
  DFFSR \current_state_reg[3]  ( .D(next_state[3]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(current_state[3]) );
  DFFSR \current_state_reg[1]  ( .D(next_state[1]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(current_state[1]) );
  DFFSR \current_state_reg[2]  ( .D(next_state[2]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(current_state[2]) );
  NOR2X1 U22 ( .A(n17), .B(n20), .Y(tx_enable) );
  OAI21X1 U23 ( .A(n21), .B(n19), .C(n22), .Y(n20) );
  OR2X1 U24 ( .A(n23), .B(n24), .Y(transmitting) );
  OAI21X1 U25 ( .A(n19), .B(n25), .C(n13), .Y(n24) );
  NAND3X1 U26 ( .A(n11), .B(n14), .C(n26), .Y(n23) );
  NAND2X1 U27 ( .A(n27), .B(n28), .Y(read_enable) );
  OR2X1 U28 ( .A(n29), .B(n30), .Y(next_state[2]) );
  OAI21X1 U29 ( .A(n26), .B(n8), .C(n7), .Y(n30) );
  OAI21X1 U30 ( .A(n31), .B(n32), .C(n33), .Y(n29) );
  NAND2X1 U31 ( .A(current_state[2]), .B(n17), .Y(n32) );
  NAND3X1 U32 ( .A(n34), .B(n5), .C(n13), .Y(next_state[1]) );
  OAI21X1 U33 ( .A(n28), .B(n6), .C(n9), .Y(next_state[3]) );
  NAND3X1 U34 ( .A(n7), .B(n9), .C(n36), .Y(next_state[0]) );
  AOI21X1 U35 ( .A(byte_sent), .B(n35), .C(n37), .Y(n36) );
  NOR2X1 U36 ( .A(n25), .B(n38), .Y(n37) );
  OAI21X1 U37 ( .A(transmit_empty), .B(transmit_start), .C(n19), .Y(n38) );
  NAND3X1 U38 ( .A(n17), .B(n16), .C(n12), .Y(n25) );
  OAI21X1 U39 ( .A(current_state[0]), .B(n39), .C(n33), .Y(n35) );
  OAI21X1 U40 ( .A(byte_sent), .B(n26), .C(n41), .Y(n40) );
  OR2X1 U41 ( .A(n39), .B(n21), .Y(n26) );
  OAI21X1 U42 ( .A(data_sent), .B(n28), .C(n27), .Y(n42) );
  NAND2X1 U43 ( .A(n15), .B(n18), .Y(n27) );
  NAND3X1 U44 ( .A(current_state[1]), .B(current_state[2]), .C(n15), .Y(n28)
         );
  NAND2X1 U45 ( .A(n41), .B(n34), .Y(load_enable) );
  NAND2X1 U46 ( .A(n15), .B(n17), .Y(n34) );
  NOR2X1 U47 ( .A(n19), .B(n43), .Y(create_eop) );
  NAND2X1 U48 ( .A(n33), .B(n41), .Y(crc_enable) );
  NAND3X1 U49 ( .A(current_state[3]), .B(n12), .C(n18), .Y(n41) );
  NAND2X1 U50 ( .A(current_state[1]), .B(n19), .Y(n39) );
  NAND3X1 U51 ( .A(current_state[1]), .B(current_state[2]), .C(n44), .Y(n33)
         );
  NOR2X1 U52 ( .A(current_state[3]), .B(current_state[0]), .Y(n44) );
  NOR2X1 U53 ( .A(current_state[2]), .B(n43), .Y(crc_clear) );
  NAND3X1 U54 ( .A(n21), .B(n17), .C(n22), .Y(n43) );
  AOI21X1 U55 ( .A(n12), .B(current_state[3]), .C(n15), .Y(n22) );
  NAND2X1 U56 ( .A(current_state[0]), .B(n16), .Y(n31) );
  NAND2X1 U57 ( .A(current_state[0]), .B(current_state[3]), .Y(n21) );
  INVX2 U7 ( .A(next_state[3]), .Y(n5) );
  INVX2 U8 ( .A(data_sent), .Y(n6) );
  INVX2 U9 ( .A(n42), .Y(n7) );
  INVX2 U10 ( .A(byte_sent), .Y(n8) );
  INVX2 U11 ( .A(n40), .Y(n9) );
  INVX2 U12 ( .A(n41), .Y(crc_load) );
  INVX2 U13 ( .A(load_enable), .Y(n11) );
  INVX2 U14 ( .A(current_state[0]), .Y(n12) );
  INVX2 U15 ( .A(n35), .Y(n13) );
  INVX2 U16 ( .A(read_enable), .Y(n14) );
  INVX2 U17 ( .A(n31), .Y(n15) );
  INVX2 U18 ( .A(current_state[3]), .Y(n16) );
  INVX2 U19 ( .A(current_state[1]), .Y(n17) );
  INVX2 U20 ( .A(n39), .Y(n18) );
  INVX2 U21 ( .A(current_state[2]), .Y(n19) );
endmodule


module flex_pts_sr_NUM_BITS16_SHIFT_MSB1 ( clk, n_rst, shift_enable, 
        load_enable, parallel_in, serial_out );
  input [15:0] parallel_in;
  input clk, n_rst, shift_enable, load_enable;
  output serial_out;
  wire   n34, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
         n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n17, n18, n19, n20, n21, n22, n23, n24, n25,
         n26, n27, n28, n29, n30, n31, n32, n33, n35, n68, n69, n70;
  wire   [14:0] q;

  DFFSR \q_reg[0]  ( .D(n67), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[0]) );
  DFFSR \q_reg[1]  ( .D(n66), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[1]) );
  DFFSR \q_reg[2]  ( .D(n65), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[2]) );
  DFFSR \q_reg[3]  ( .D(n64), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[3]) );
  DFFSR \q_reg[4]  ( .D(n63), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[4]) );
  DFFSR \q_reg[5]  ( .D(n62), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[5]) );
  DFFSR \q_reg[6]  ( .D(n61), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[6]) );
  DFFSR \q_reg[7]  ( .D(n60), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[7]) );
  DFFSR \q_reg[8]  ( .D(n59), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[8]) );
  DFFSR \q_reg[9]  ( .D(n58), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[9]) );
  DFFSR \q_reg[10]  ( .D(n57), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[10]) );
  DFFSR \q_reg[11]  ( .D(n56), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[11]) );
  DFFSR \q_reg[12]  ( .D(n55), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[12]) );
  DFFSR \q_reg[13]  ( .D(n54), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[13]) );
  DFFSR \q_reg[14]  ( .D(n53), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[14]) );
  DFFSR \q_reg[15]  ( .D(n52), .CLK(clk), .R(1'b1), .S(n_rst), .Q(serial_out)
         );
  OAI21X1 U36 ( .A(n21), .B(n69), .C(n34), .Y(n52) );
  AOI22X1 U37 ( .A(parallel_in[15]), .B(n19), .C(q[14]), .D(n20), .Y(n34) );
  OAI21X1 U38 ( .A(n68), .B(n21), .C(n36), .Y(n53) );
  AOI22X1 U39 ( .A(parallel_in[14]), .B(load_enable), .C(q[13]), .D(n20), .Y(
        n36) );
  OAI21X1 U40 ( .A(n21), .B(n35), .C(n37), .Y(n54) );
  AOI22X1 U41 ( .A(parallel_in[13]), .B(n19), .C(q[12]), .D(n20), .Y(n37) );
  OAI21X1 U42 ( .A(n21), .B(n33), .C(n38), .Y(n55) );
  AOI22X1 U43 ( .A(parallel_in[12]), .B(load_enable), .C(q[11]), .D(n20), .Y(
        n38) );
  OAI21X1 U44 ( .A(n21), .B(n32), .C(n39), .Y(n56) );
  AOI22X1 U45 ( .A(parallel_in[11]), .B(load_enable), .C(q[10]), .D(n20), .Y(
        n39) );
  OAI21X1 U46 ( .A(n21), .B(n31), .C(n40), .Y(n57) );
  AOI22X1 U47 ( .A(parallel_in[10]), .B(load_enable), .C(q[9]), .D(n20), .Y(
        n40) );
  OAI21X1 U48 ( .A(n21), .B(n30), .C(n41), .Y(n58) );
  AOI22X1 U49 ( .A(parallel_in[9]), .B(load_enable), .C(q[8]), .D(n20), .Y(n41) );
  OAI21X1 U50 ( .A(n21), .B(n29), .C(n42), .Y(n59) );
  AOI22X1 U51 ( .A(parallel_in[8]), .B(load_enable), .C(q[7]), .D(n20), .Y(n42) );
  OAI21X1 U52 ( .A(n21), .B(n28), .C(n43), .Y(n60) );
  AOI22X1 U53 ( .A(parallel_in[7]), .B(n19), .C(q[6]), .D(n20), .Y(n43) );
  OAI21X1 U54 ( .A(n21), .B(n27), .C(n44), .Y(n61) );
  AOI22X1 U55 ( .A(parallel_in[6]), .B(n19), .C(q[5]), .D(n20), .Y(n44) );
  OAI21X1 U56 ( .A(n21), .B(n26), .C(n45), .Y(n62) );
  AOI22X1 U57 ( .A(parallel_in[5]), .B(n19), .C(q[4]), .D(n20), .Y(n45) );
  OAI21X1 U58 ( .A(n21), .B(n25), .C(n46), .Y(n63) );
  AOI22X1 U59 ( .A(parallel_in[4]), .B(n19), .C(q[3]), .D(n20), .Y(n46) );
  OAI21X1 U60 ( .A(n21), .B(n24), .C(n47), .Y(n64) );
  AOI22X1 U61 ( .A(parallel_in[3]), .B(n19), .C(q[2]), .D(n20), .Y(n47) );
  OAI21X1 U62 ( .A(n21), .B(n23), .C(n48), .Y(n65) );
  AOI22X1 U63 ( .A(parallel_in[2]), .B(n19), .C(q[1]), .D(n20), .Y(n48) );
  OAI21X1 U64 ( .A(n21), .B(n22), .C(n49), .Y(n66) );
  AOI22X1 U65 ( .A(parallel_in[1]), .B(n19), .C(q[0]), .D(n20), .Y(n49) );
  OAI21X1 U66 ( .A(n50), .B(n70), .C(n51), .Y(n67) );
  AOI21X1 U67 ( .A(q[0]), .B(n50), .C(n20), .Y(n51) );
  NOR2X1 U69 ( .A(n19), .B(shift_enable), .Y(n50) );
  INVX2 U19 ( .A(n18), .Y(n19) );
  INVX2 U20 ( .A(load_enable), .Y(n18) );
  INVX2 U21 ( .A(n17), .Y(n20) );
  OR2X1 U22 ( .A(n50), .B(n19), .Y(n17) );
  INVX2 U23 ( .A(n50), .Y(n21) );
  INVX2 U24 ( .A(q[1]), .Y(n22) );
  INVX2 U25 ( .A(q[2]), .Y(n23) );
  INVX2 U26 ( .A(q[3]), .Y(n24) );
  INVX2 U27 ( .A(q[4]), .Y(n25) );
  INVX2 U28 ( .A(q[5]), .Y(n26) );
  INVX2 U29 ( .A(q[6]), .Y(n27) );
  INVX2 U30 ( .A(q[7]), .Y(n28) );
  INVX2 U31 ( .A(q[8]), .Y(n29) );
  INVX2 U32 ( .A(q[9]), .Y(n30) );
  INVX2 U33 ( .A(q[10]), .Y(n31) );
  INVX2 U34 ( .A(q[11]), .Y(n32) );
  INVX2 U35 ( .A(q[12]), .Y(n33) );
  INVX2 U68 ( .A(q[13]), .Y(n35) );
  INVX2 U70 ( .A(q[14]), .Y(n68) );
  INVX2 U71 ( .A(serial_out), .Y(n69) );
  INVX2 U72 ( .A(parallel_in[0]), .Y(n70) );
endmodule


module USB_tx_sr ( clk, n_rst, tx_enable, load_enable, tx_shift, tx_hold, 
        tx_data, crc_16, crc_load, tx_out_bit );
  input [15:0] tx_data;
  input [15:0] crc_16;
  input clk, n_rst, tx_enable, load_enable, tx_shift, tx_hold, crc_load;
  output tx_out_bit;
  wire   _1_net_, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31,
         n32, n33, n34, n35, n36, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11,
         n12, n13, n14, n15, n16, n17, n18, n19;

  AOI22X1 U20 ( .A(crc_load), .B(crc_16[9]), .C(tx_data[9]), .D(n1), .Y(n20)
         );
  AOI22X1 U21 ( .A(crc_16[8]), .B(crc_load), .C(tx_data[8]), .D(n1), .Y(n21)
         );
  AOI22X1 U22 ( .A(crc_16[7]), .B(crc_load), .C(tx_data[7]), .D(n1), .Y(n22)
         );
  AOI22X1 U23 ( .A(crc_16[6]), .B(crc_load), .C(tx_data[6]), .D(n1), .Y(n23)
         );
  AOI22X1 U24 ( .A(crc_16[5]), .B(crc_load), .C(tx_data[5]), .D(n1), .Y(n24)
         );
  AOI22X1 U25 ( .A(crc_16[4]), .B(crc_load), .C(tx_data[4]), .D(n1), .Y(n25)
         );
  AOI22X1 U26 ( .A(crc_16[3]), .B(crc_load), .C(tx_data[3]), .D(n1), .Y(n26)
         );
  AOI22X1 U27 ( .A(crc_16[2]), .B(crc_load), .C(tx_data[2]), .D(n1), .Y(n27)
         );
  AOI22X1 U28 ( .A(crc_16[1]), .B(crc_load), .C(tx_data[1]), .D(n1), .Y(n28)
         );
  AOI22X1 U29 ( .A(crc_16[15]), .B(crc_load), .C(tx_data[15]), .D(n1), .Y(n29)
         );
  AOI22X1 U30 ( .A(crc_16[14]), .B(crc_load), .C(tx_data[14]), .D(n1), .Y(n30)
         );
  AOI22X1 U31 ( .A(crc_16[13]), .B(crc_load), .C(tx_data[13]), .D(n1), .Y(n31)
         );
  AOI22X1 U32 ( .A(crc_16[12]), .B(crc_load), .C(tx_data[12]), .D(n1), .Y(n32)
         );
  AOI22X1 U33 ( .A(crc_16[11]), .B(crc_load), .C(tx_data[11]), .D(n1), .Y(n33)
         );
  AOI22X1 U34 ( .A(crc_16[10]), .B(crc_load), .C(tx_data[10]), .D(n1), .Y(n34)
         );
  AOI22X1 U35 ( .A(crc_16[0]), .B(crc_load), .C(tx_data[0]), .D(n1), .Y(n35)
         );
  OR2X1 U36 ( .A(crc_load), .B(load_enable), .Y(_1_net_) );
  NAND3X1 U37 ( .A(tx_enable), .B(n3), .C(tx_shift), .Y(n36) );
  flex_pts_sr_NUM_BITS16_SHIFT_MSB1 TX_SR ( .clk(clk), .n_rst(n_rst), 
        .shift_enable(n2), .load_enable(_1_net_), .parallel_in({n18, n19, n5, 
        n6, n7, n8, n9, n10, n4, n11, n12, n13, n14, n15, n16, n17}), 
        .serial_out(tx_out_bit) );
  INVX2 U1 ( .A(crc_load), .Y(n1) );
  INVX2 U2 ( .A(n36), .Y(n2) );
  INVX2 U3 ( .A(tx_hold), .Y(n3) );
  INVX2 U4 ( .A(n35), .Y(n4) );
  INVX2 U5 ( .A(n34), .Y(n5) );
  INVX2 U6 ( .A(n33), .Y(n6) );
  INVX2 U7 ( .A(n32), .Y(n7) );
  INVX2 U8 ( .A(n31), .Y(n8) );
  INVX2 U9 ( .A(n30), .Y(n9) );
  INVX2 U10 ( .A(n29), .Y(n10) );
  INVX2 U11 ( .A(n28), .Y(n11) );
  INVX2 U12 ( .A(n27), .Y(n12) );
  INVX2 U13 ( .A(n26), .Y(n13) );
  INVX2 U14 ( .A(n25), .Y(n14) );
  INVX2 U15 ( .A(n24), .Y(n15) );
  INVX2 U16 ( .A(n23), .Y(n16) );
  INVX2 U17 ( .A(n22), .Y(n17) );
  INVX2 U18 ( .A(n21), .Y(n18) );
  INVX2 U19 ( .A(n20), .Y(n19) );
endmodule


module USB_tx_top_level ( clk, n_rst, tx_data, transmit_empty, transmit_start, 
        d_plus_out, d_minus_out, read_enable, tx_error );
  input [15:0] tx_data;
  input clk, n_rst, transmit_empty, transmit_start;
  output d_plus_out, d_minus_out, read_enable, tx_error;
  wire   data_sent, byte_sent, tx_hold, transmitting, tx_shift, crc_clear,
         tx_out_bit, crc_enable, create_eop, tx_enable, load_enable, crc_load;
  wire   [15:0] crc_16;

  USB_timer_tx TIMER ( .clk(clk), .n_rst(n_rst), .transmitting(transmitting), 
        .transmit_empty(transmit_empty), .transmit_start(transmit_start), 
        .tx_hold(tx_hold), .byte_sent(byte_sent), .data_sent(data_sent), 
        .tx_shift(tx_shift) );
  USB_crc_tx CRC ( .clk(clk), .n_rst(n_rst), .crc_clear(crc_clear), .tx_shift(
        tx_shift), .crc_enable(crc_enable), .tx_out_bit(tx_out_bit), .tx_hold(
        tx_hold), .crc_16(crc_16) );
  USB_encoder ENCODER ( .clk(clk), .n_rst(n_rst), .tx_out_bit(tx_out_bit), 
        .create_eop(create_eop), .tx_shift(tx_shift), .tx_hold(tx_hold), 
        .d_plus_out(d_plus_out), .d_minus_out(d_minus_out) );
  USB_tx_controller CTRL ( .clk(clk), .n_rst(n_rst), .transmit_empty(
        transmit_empty), .data_sent(data_sent), .byte_sent(byte_sent), 
        .transmit_start(transmit_start), .crc_load(crc_load), .read_enable(
        read_enable), .load_enable(load_enable), .tx_enable(tx_enable), 
        .crc_enable(crc_enable), .transmitting(transmitting), .crc_clear(
        crc_clear), .create_eop(create_eop) );
  USB_tx_sr TX_SR ( .clk(clk), .n_rst(n_rst), .tx_enable(tx_enable), 
        .load_enable(load_enable), .tx_shift(tx_shift), .tx_hold(tx_hold), 
        .tx_data(tx_data), .crc_16(crc_16), .crc_load(crc_load), .tx_out_bit(
        tx_out_bit) );
endmodule

