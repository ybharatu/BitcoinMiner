/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Wed Dec 13 19:33:58 2017
/////////////////////////////////////////////////////////////


module USB_sync_high ( clk, n_rst, async_in, sync_out );
  input clk, n_rst, async_in;
  output sync_out;
  wire   signal;

  DFFSR signal_reg ( .D(async_in), .CLK(clk), .R(1'b1), .S(n_rst), .Q(signal)
         );
  DFFSR sync_out_reg ( .D(signal), .CLK(clk), .R(1'b1), .S(n_rst), .Q(sync_out) );
endmodule


module USB_sync_low ( clk, n_rst, async_in, sync_out );
  input clk, n_rst, async_in;
  output sync_out;
  wire   signal;

  DFFSR signal_reg ( .D(async_in), .CLK(clk), .R(n_rst), .S(1'b1), .Q(signal)
         );
  DFFSR sync_out_reg ( .D(signal), .CLK(clk), .R(n_rst), .S(1'b1), .Q(sync_out) );
endmodule


module USB_eop_detect ( clk, n_rst, d_plus_sync, d_minus_sync, eop );
  input clk, n_rst, d_plus_sync, d_minus_sync;
  output eop;
  wire   n2;

  DFFSR temp_eop_reg ( .D(n2), .CLK(clk), .R(n_rst), .S(1'b1), .Q(eop) );
  NOR2X1 U4 ( .A(d_plus_sync), .B(d_minus_sync), .Y(n2) );
endmodule


module USB_decoder ( d_plus_sync, shift_enable, eop, clk, n_rst, d_orig );
  input d_plus_sync, shift_enable, eop, clk, n_rst;
  output d_orig;
  wire   d_plus_sync_prev, n3, n4, n2;

  DFFSR d_plus_sync_prev_reg ( .D(n4), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        d_plus_sync_prev) );
  OAI21X1 U5 ( .A(shift_enable), .B(n2), .C(n3), .Y(n4) );
  OAI21X1 U6 ( .A(d_plus_sync), .B(eop), .C(shift_enable), .Y(n3) );
  XNOR2X1 U7 ( .A(d_plus_sync), .B(d_plus_sync_prev), .Y(d_orig) );
  INVX2 U4 ( .A(d_plus_sync_prev), .Y(n2) );
endmodule


module USB_edge_detect ( clk, n_rst, d_plus_sync, d_edge );
  input clk, n_rst, d_plus_sync;
  output d_edge;
  wire   d;

  DFFSR d_reg ( .D(d_plus_sync), .CLK(clk), .R(1'b1), .S(n_rst), .Q(d) );
  XOR2X1 U4 ( .A(d_plus_sync), .B(d), .Y(d_edge) );
endmodule


module USB_crc_5 ( clk, n_rst, crc_clear, shift_enable, d_orig, crc_enable, 
        crc_check_5 );
  input clk, n_rst, crc_clear, shift_enable, d_orig, crc_enable;
  output crc_check_5;
  wire   n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24,
         n25, n6, n7, n8, n9, n10;
  wire   [4:0] q;

  DFFSR \q_reg[0]  ( .D(n25), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[0]) );
  DFFSR \q_reg[1]  ( .D(n24), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[1]) );
  DFFSR \q_reg[2]  ( .D(n23), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[2]) );
  DFFSR \q_reg[3]  ( .D(n22), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[3]) );
  DFFSR \q_reg[4]  ( .D(n21), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[4]) );
  OAI21X1 U13 ( .A(n11), .B(n9), .C(n12), .Y(n21) );
  AOI21X1 U14 ( .A(q[4]), .B(n11), .C(crc_clear), .Y(n12) );
  OAI21X1 U15 ( .A(n11), .B(n8), .C(n13), .Y(n22) );
  AOI21X1 U16 ( .A(q[3]), .B(n11), .C(crc_clear), .Y(n13) );
  OAI21X1 U17 ( .A(n14), .B(n11), .C(n15), .Y(n23) );
  AOI21X1 U18 ( .A(q[2]), .B(n11), .C(crc_clear), .Y(n15) );
  XNOR2X1 U19 ( .A(n7), .B(n16), .Y(n14) );
  OAI21X1 U20 ( .A(n11), .B(n6), .C(n17), .Y(n24) );
  AOI21X1 U21 ( .A(q[1]), .B(n11), .C(crc_clear), .Y(n17) );
  OAI21X1 U22 ( .A(n16), .B(n11), .C(n18), .Y(n25) );
  AOI21X1 U23 ( .A(q[0]), .B(n11), .C(crc_clear), .Y(n18) );
  NAND2X1 U24 ( .A(shift_enable), .B(crc_enable), .Y(n11) );
  XNOR2X1 U25 ( .A(q[4]), .B(d_orig), .Y(n16) );
  NOR2X1 U26 ( .A(n19), .B(n20), .Y(crc_check_5) );
  NAND2X1 U27 ( .A(q[2]), .B(q[3]), .Y(n20) );
  NAND3X1 U28 ( .A(n7), .B(n10), .C(n6), .Y(n19) );
  INVX2 U8 ( .A(q[0]), .Y(n6) );
  INVX2 U9 ( .A(q[1]), .Y(n7) );
  INVX2 U10 ( .A(q[2]), .Y(n8) );
  INVX2 U11 ( .A(q[3]), .Y(n9) );
  INVX2 U12 ( .A(q[4]), .Y(n10) );
endmodule


module USB_crc_16 ( clk, n_rst, crc_clear, shift_enable, d_orig, crc_enable, 
        crc_check_16 );
  input clk, n_rst, crc_clear, shift_enable, d_orig, crc_enable;
  output crc_check_16;
  wire   n33, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47,
         n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61,
         n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75,
         n76, n77, n78, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27,
         n28, n29, n30, n31, n32, n34, n79, n80;
  wire   [15:0] q;

  DFFSR \q_reg[0]  ( .D(n78), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[0]) );
  DFFSR \q_reg[1]  ( .D(n77), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[1]) );
  DFFSR \q_reg[2]  ( .D(n76), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[2]) );
  DFFSR \q_reg[3]  ( .D(n75), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[3]) );
  DFFSR \q_reg[4]  ( .D(n74), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[4]) );
  DFFSR \q_reg[5]  ( .D(n73), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[5]) );
  DFFSR \q_reg[6]  ( .D(n72), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[6]) );
  DFFSR \q_reg[7]  ( .D(n71), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[7]) );
  DFFSR \q_reg[8]  ( .D(n70), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[8]) );
  DFFSR \q_reg[9]  ( .D(n69), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[9]) );
  DFFSR \q_reg[10]  ( .D(n68), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[10]) );
  DFFSR \q_reg[11]  ( .D(n67), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[11]) );
  DFFSR \q_reg[12]  ( .D(n66), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[12]) );
  DFFSR \q_reg[13]  ( .D(n65), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[13]) );
  DFFSR \q_reg[14]  ( .D(n64), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[14]) );
  DFFSR \q_reg[15]  ( .D(n63), .CLK(clk), .R(1'b1), .S(n_rst), .Q(q[15]) );
  AND2X2 U19 ( .A(n53), .B(n54), .Y(crc_check_16) );
  AND2X2 U20 ( .A(q[15]), .B(q[3]), .Y(n61) );
  OAI21X1 U37 ( .A(n33), .B(n18), .C(n35), .Y(n63) );
  AOI21X1 U38 ( .A(q[15]), .B(n18), .C(crc_clear), .Y(n35) );
  XNOR2X1 U39 ( .A(q[14]), .B(n36), .Y(n33) );
  OAI21X1 U40 ( .A(n19), .B(n34), .C(n37), .Y(n64) );
  AOI21X1 U41 ( .A(q[14]), .B(n18), .C(crc_clear), .Y(n37) );
  OAI21X1 U42 ( .A(n19), .B(n32), .C(n38), .Y(n65) );
  AOI21X1 U43 ( .A(q[13]), .B(n19), .C(crc_clear), .Y(n38) );
  OAI21X1 U44 ( .A(n19), .B(n31), .C(n39), .Y(n66) );
  AOI21X1 U45 ( .A(q[12]), .B(n19), .C(crc_clear), .Y(n39) );
  OAI21X1 U46 ( .A(n19), .B(n30), .C(n40), .Y(n67) );
  AOI21X1 U47 ( .A(q[11]), .B(n19), .C(crc_clear), .Y(n40) );
  OAI21X1 U48 ( .A(n19), .B(n29), .C(n41), .Y(n68) );
  AOI21X1 U49 ( .A(q[10]), .B(n19), .C(crc_clear), .Y(n41) );
  OAI21X1 U50 ( .A(n19), .B(n28), .C(n42), .Y(n69) );
  AOI21X1 U51 ( .A(q[9]), .B(n19), .C(crc_clear), .Y(n42) );
  OAI21X1 U52 ( .A(n18), .B(n27), .C(n43), .Y(n70) );
  AOI21X1 U53 ( .A(q[8]), .B(n19), .C(crc_clear), .Y(n43) );
  OAI21X1 U54 ( .A(n19), .B(n26), .C(n44), .Y(n71) );
  AOI21X1 U55 ( .A(q[7]), .B(n18), .C(crc_clear), .Y(n44) );
  OAI21X1 U56 ( .A(n18), .B(n25), .C(n45), .Y(n72) );
  AOI21X1 U57 ( .A(q[6]), .B(n18), .C(crc_clear), .Y(n45) );
  OAI21X1 U58 ( .A(n19), .B(n24), .C(n46), .Y(n73) );
  AOI21X1 U59 ( .A(q[5]), .B(n18), .C(crc_clear), .Y(n46) );
  OAI21X1 U60 ( .A(n18), .B(n23), .C(n47), .Y(n74) );
  AOI21X1 U61 ( .A(q[4]), .B(n18), .C(crc_clear), .Y(n47) );
  OAI21X1 U62 ( .A(n19), .B(n22), .C(n48), .Y(n75) );
  AOI21X1 U63 ( .A(q[3]), .B(n18), .C(crc_clear), .Y(n48) );
  OAI21X1 U64 ( .A(n49), .B(n18), .C(n50), .Y(n76) );
  AOI21X1 U65 ( .A(q[2]), .B(n18), .C(crc_clear), .Y(n50) );
  XNOR2X1 U66 ( .A(q[1]), .B(n36), .Y(n49) );
  OAI21X1 U67 ( .A(n19), .B(n20), .C(n51), .Y(n77) );
  AOI21X1 U68 ( .A(q[1]), .B(n18), .C(crc_clear), .Y(n51) );
  OAI21X1 U69 ( .A(n80), .B(n18), .C(n52), .Y(n78) );
  AOI21X1 U70 ( .A(q[0]), .B(n18), .C(crc_clear), .Y(n52) );
  XOR2X1 U72 ( .A(q[15]), .B(d_orig), .Y(n36) );
  NOR2X1 U73 ( .A(n55), .B(n56), .Y(n54) );
  NAND3X1 U74 ( .A(n79), .B(n21), .C(n57), .Y(n56) );
  NOR2X1 U75 ( .A(q[5]), .B(q[4]), .Y(n57) );
  NAND3X1 U76 ( .A(n26), .B(n27), .C(n58), .Y(n55) );
  NOR2X1 U77 ( .A(q[9]), .B(q[8]), .Y(n58) );
  NOR2X1 U78 ( .A(n59), .B(n60), .Y(n53) );
  NAND3X1 U79 ( .A(q[0]), .B(q[2]), .C(n61), .Y(n60) );
  NAND3X1 U80 ( .A(n30), .B(n31), .C(n62), .Y(n59) );
  NOR2X1 U81 ( .A(q[13]), .B(q[12]), .Y(n62) );
  INVX2 U21 ( .A(n17), .Y(n18) );
  INVX2 U22 ( .A(n17), .Y(n19) );
  AND2X2 U23 ( .A(shift_enable), .B(crc_enable), .Y(n17) );
  INVX2 U24 ( .A(q[0]), .Y(n20) );
  INVX2 U25 ( .A(q[1]), .Y(n21) );
  INVX2 U26 ( .A(q[2]), .Y(n22) );
  INVX2 U27 ( .A(q[3]), .Y(n23) );
  INVX2 U28 ( .A(q[4]), .Y(n24) );
  INVX2 U29 ( .A(q[5]), .Y(n25) );
  INVX2 U30 ( .A(q[6]), .Y(n26) );
  INVX2 U31 ( .A(q[7]), .Y(n27) );
  INVX2 U32 ( .A(q[8]), .Y(n28) );
  INVX2 U33 ( .A(q[9]), .Y(n29) );
  INVX2 U34 ( .A(q[10]), .Y(n30) );
  INVX2 U35 ( .A(q[11]), .Y(n31) );
  INVX2 U36 ( .A(q[12]), .Y(n32) );
  INVX2 U71 ( .A(q[13]), .Y(n34) );
  INVX2 U82 ( .A(q[14]), .Y(n79) );
  INVX2 U83 ( .A(n36), .Y(n80) );
endmodule


module USB_crc_rx ( clk, n_rst, crc_clear, shift_enable, d_orig, packet_type, 
        crc_enable, crc_check );
  input clk, n_rst, crc_clear, shift_enable, d_orig, packet_type, crc_enable;
  output crc_check;
  wire   crc_check_16, crc_check_5, n4, n2, n3;

  DFFSR temp_crc_check_reg ( .D(n2), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        crc_check) );
  AOI22X1 U6 ( .A(packet_type), .B(crc_check_16), .C(crc_check_5), .D(n3), .Y(
        n4) );
  USB_crc_5 CRC_5 ( .clk(clk), .n_rst(n_rst), .crc_clear(crc_clear), 
        .shift_enable(shift_enable), .d_orig(d_orig), .crc_enable(crc_enable), 
        .crc_check_5(crc_check_5) );
  USB_crc_16 CRC_16 ( .clk(clk), .n_rst(n_rst), .crc_clear(crc_clear), 
        .shift_enable(shift_enable), .d_orig(d_orig), .crc_enable(crc_enable), 
        .crc_check_16(crc_check_16) );
  INVX2 U4 ( .A(n4), .Y(n2) );
  INVX2 U5 ( .A(packet_type), .Y(n3) );
endmodule


module flex_stp_sr_NUM_BITS8_SHIFT_MSB0 ( clk, n_rst, shift_enable, serial_in, 
        parallel_out );
  output [7:0] parallel_out;
  input clk, n_rst, shift_enable, serial_in;
  wire   n3, n10, n12, n14, n16, n18, n20, n22, n24, n26, n1, n2, n4, n5, n6,
         n7, n8, n9, n27;

  DFFSR \q_reg[7]  ( .D(n26), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[7]) );
  DFFSR \q_reg[6]  ( .D(n24), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[6]) );
  DFFSR \q_reg[5]  ( .D(n22), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[5]) );
  DFFSR \q_reg[4]  ( .D(n20), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[4]) );
  DFFSR \q_reg[3]  ( .D(n18), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[3]) );
  DFFSR \q_reg[2]  ( .D(n16), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[2]) );
  DFFSR \q_reg[1]  ( .D(n14), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[1]) );
  DFFSR \q_reg[0]  ( .D(n12), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[0]) );
  OAI21X1 U2 ( .A(n9), .B(n27), .C(n3), .Y(n12) );
  NAND2X1 U3 ( .A(parallel_out[0]), .B(n27), .Y(n3) );
  OAI22X1 U4 ( .A(n27), .B(n8), .C(n1), .D(n9), .Y(n14) );
  OAI22X1 U6 ( .A(n27), .B(n7), .C(n1), .D(n8), .Y(n16) );
  OAI22X1 U8 ( .A(n27), .B(n6), .C(n1), .D(n7), .Y(n18) );
  OAI22X1 U10 ( .A(n27), .B(n5), .C(n1), .D(n6), .Y(n20) );
  OAI22X1 U12 ( .A(n27), .B(n4), .C(n1), .D(n5), .Y(n22) );
  OAI22X1 U14 ( .A(n27), .B(n2), .C(n1), .D(n4), .Y(n24) );
  OAI21X1 U17 ( .A(n1), .B(n2), .C(n10), .Y(n26) );
  NAND2X1 U18 ( .A(serial_in), .B(n1), .Y(n10) );
  BUFX2 U5 ( .A(shift_enable), .Y(n1) );
  INVX2 U7 ( .A(parallel_out[7]), .Y(n2) );
  INVX2 U9 ( .A(parallel_out[6]), .Y(n4) );
  INVX2 U11 ( .A(parallel_out[5]), .Y(n5) );
  INVX2 U13 ( .A(parallel_out[4]), .Y(n6) );
  INVX2 U15 ( .A(parallel_out[3]), .Y(n7) );
  INVX2 U16 ( .A(parallel_out[2]), .Y(n8) );
  INVX2 U19 ( .A(parallel_out[1]), .Y(n9) );
  INVX2 U28 ( .A(n1), .Y(n27) );
endmodule


module USB_rx_sr ( clk, n_rst, shift_enable, d_orig, rx_hold, rx_data );
  output [7:0] rx_data;
  input clk, n_rst, shift_enable, d_orig, rx_hold;
  wire   _0_net_, n1;

  NOR2X1 U2 ( .A(rx_hold), .B(n1), .Y(_0_net_) );
  flex_stp_sr_NUM_BITS8_SHIFT_MSB0 RX_SR ( .clk(clk), .n_rst(n_rst), 
        .shift_enable(_0_net_), .serial_in(d_orig), .parallel_out(rx_data) );
  INVX2 U1 ( .A(shift_enable), .Y(n1) );
endmodule


module USB_rx_controller ( clk, n_rst, shift_enable, byte_received, rx_data, 
        eop, crc_check, d_edge, crc_clear, receiving, write_enable, rcv_error, 
        crc_enable );
  input [7:0] rx_data;
  input clk, n_rst, shift_enable, byte_received, eop, crc_check, d_edge;
  output crc_clear, receiving, write_enable, rcv_error, crc_enable;
  wire   write_enable_delay, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44,
         n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58,
         n59, n60, n61, n6, n7, n8, n9, n10, n11, n12, n13, n14, n16, n17, n18,
         n19, n20;
  wire   [3:0] current_state;
  wire   [3:0] next_state;

  DFFSR \current_state_reg[0]  ( .D(next_state[0]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(current_state[0]) );
  DFFSR \current_state_reg[1]  ( .D(next_state[1]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(current_state[1]) );
  DFFSR \current_state_reg[3]  ( .D(next_state[3]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(current_state[3]) );
  DFFSR \current_state_reg[2]  ( .D(next_state[2]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(current_state[2]) );
  DFFSR write_enable_reg ( .D(write_enable_delay), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(write_enable) );
  AND2X2 U8 ( .A(n29), .B(n41), .Y(n40) );
  AND2X2 U9 ( .A(current_state[1]), .B(current_state[3]), .Y(n43) );
  AND2X2 U10 ( .A(n48), .B(n49), .Y(n28) );
  AND2X2 U11 ( .A(eop), .B(shift_enable), .Y(n52) );
  AND2X2 U12 ( .A(n48), .B(n61), .Y(crc_clear) );
  OR2X1 U28 ( .A(n21), .B(n22), .Y(receiving) );
  NAND3X1 U29 ( .A(n23), .B(n24), .C(n25), .Y(n22) );
  NAND3X1 U30 ( .A(n26), .B(n11), .C(n27), .Y(n21) );
  NOR2X1 U31 ( .A(n28), .B(n17), .Y(n27) );
  NAND3X1 U32 ( .A(n25), .B(n29), .C(n30), .Y(next_state[3]) );
  AOI21X1 U33 ( .A(n31), .B(shift_enable), .C(n32), .Y(n30) );
  NOR2X1 U34 ( .A(n20), .B(n33), .Y(n31) );
  NAND2X1 U35 ( .A(n34), .B(n9), .Y(next_state[2]) );
  AOI22X1 U36 ( .A(n10), .B(n20), .C(byte_received), .D(n28), .Y(n34) );
  OR2X1 U37 ( .A(n35), .B(n36), .Y(next_state[1]) );
  OAI21X1 U38 ( .A(shift_enable), .B(n33), .C(n37), .Y(n36) );
  AOI22X1 U39 ( .A(n38), .B(n17), .C(crc_check), .D(n13), .Y(n37) );
  OAI21X1 U40 ( .A(eop), .B(n39), .C(n40), .Y(n35) );
  NAND3X1 U41 ( .A(n42), .B(n14), .C(n43), .Y(n29) );
  NOR2X1 U42 ( .A(d_edge), .B(current_state[2]), .Y(n42) );
  AOI21X1 U43 ( .A(byte_received), .B(n10), .C(n16), .Y(n39) );
  NAND3X1 U44 ( .A(n44), .B(n9), .C(n45), .Y(next_state[0]) );
  AOI21X1 U45 ( .A(n16), .B(byte_received), .C(n46), .Y(n45) );
  OAI21X1 U46 ( .A(crc_check), .B(n25), .C(n47), .Y(n46) );
  OAI21X1 U47 ( .A(n10), .B(n28), .C(n6), .Y(n47) );
  NAND3X1 U48 ( .A(n48), .B(n14), .C(current_state[3]), .Y(n25) );
  OAI21X1 U49 ( .A(n52), .B(n33), .C(n12), .Y(n51) );
  NAND2X1 U50 ( .A(n26), .B(n41), .Y(write_enable_delay) );
  NAND3X1 U51 ( .A(current_state[1]), .B(n19), .C(n49), .Y(n26) );
  AOI21X1 U52 ( .A(d_edge), .B(crc_clear), .C(n32), .Y(n44) );
  OAI21X1 U53 ( .A(eop), .B(n23), .C(n53), .Y(n32) );
  AOI22X1 U54 ( .A(eop), .B(n54), .C(n17), .D(n7), .Y(n53) );
  NOR2X1 U55 ( .A(n55), .B(n56), .Y(n38) );
  NAND3X1 U56 ( .A(rx_data[7]), .B(n8), .C(n57), .Y(n56) );
  NOR2X1 U57 ( .A(rx_data[2]), .B(rx_data[1]), .Y(n57) );
  NAND2X1 U58 ( .A(n58), .B(n59), .Y(n55) );
  NOR2X1 U59 ( .A(rx_data[6]), .B(rx_data[5]), .Y(n59) );
  NOR2X1 U60 ( .A(rx_data[4]), .B(rx_data[3]), .Y(n58) );
  NAND3X1 U61 ( .A(n61), .B(n18), .C(current_state[2]), .Y(n60) );
  NAND2X1 U62 ( .A(n24), .B(n50), .Y(n54) );
  NAND3X1 U63 ( .A(n61), .B(n19), .C(current_state[1]), .Y(n24) );
  NAND3X1 U64 ( .A(n48), .B(current_state[0]), .C(current_state[3]), .Y(n23)
         );
  NAND3X1 U65 ( .A(n50), .B(n41), .C(n33), .Y(crc_enable) );
  NAND3X1 U66 ( .A(current_state[2]), .B(current_state[1]), .C(n49), .Y(n33)
         );
  NAND3X1 U67 ( .A(current_state[1]), .B(n61), .C(current_state[2]), .Y(n41)
         );
  NAND3X1 U68 ( .A(current_state[2]), .B(n18), .C(n49), .Y(n50) );
  NOR2X1 U69 ( .A(n14), .B(current_state[3]), .Y(n49) );
  NOR2X1 U70 ( .A(current_state[3]), .B(current_state[0]), .Y(n61) );
  NOR2X1 U71 ( .A(current_state[2]), .B(current_state[1]), .Y(n48) );
  INVX2 U13 ( .A(byte_received), .Y(n6) );
  INVX2 U14 ( .A(n38), .Y(n7) );
  INVX2 U15 ( .A(rx_data[0]), .Y(n8) );
  INVX2 U16 ( .A(n51), .Y(n9) );
  INVX2 U17 ( .A(n50), .Y(n10) );
  INVX2 U18 ( .A(crc_enable), .Y(n11) );
  INVX2 U19 ( .A(write_enable_delay), .Y(n12) );
  INVX2 U20 ( .A(n25), .Y(n13) );
  INVX2 U21 ( .A(current_state[0]), .Y(n14) );
  INVX2 U22 ( .A(n23), .Y(rcv_error) );
  INVX2 U23 ( .A(n24), .Y(n16) );
  INVX2 U24 ( .A(n60), .Y(n17) );
  INVX2 U25 ( .A(current_state[1]), .Y(n18) );
  INVX2 U26 ( .A(current_state[2]), .Y(n19) );
  INVX2 U27 ( .A(eop), .Y(n20) );
endmodule


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
  NOR2X1 U22 ( .A(N9), .B(n4), .Y(n46) );
  XNOR2X1 U23 ( .A(rollover_val[3]), .B(N8), .Y(n48) );
  OAI21X1 U24 ( .A(N5), .B(n7), .C(n45), .Y(n18) );
  NAND2X1 U25 ( .A(n3), .B(n47), .Y(n45) );
  OAI21X1 U26 ( .A(n6), .B(n7), .C(n44), .Y(n17) );
  NAND2X1 U27 ( .A(N14), .B(n47), .Y(n44) );
  OAI21X1 U28 ( .A(n5), .B(n7), .C(n43), .Y(n16) );
  NAND2X1 U29 ( .A(N15), .B(n47), .Y(n43) );
  OAI21X1 U30 ( .A(n2), .B(n7), .C(n42), .Y(n10) );
  NAND2X1 U31 ( .A(N16), .B(n47), .Y(n42) );
  NOR2X1 U32 ( .A(n52), .B(clear), .Y(n47) );
  NOR2X1 U33 ( .A(clear), .B(count_enable), .Y(n52) );
  NAND3X1 U34 ( .A(n41), .B(n40), .C(n39), .Y(N12) );
  NOR2X1 U35 ( .A(n21), .B(n20), .Y(n39) );
  XOR2X1 U36 ( .A(rollover_val[0]), .B(count_out[0]), .Y(n20) );
  XOR2X1 U37 ( .A(rollover_val[3]), .B(count_out[3]), .Y(n21) );
  XOR2X1 U38 ( .A(n5), .B(rollover_val[2]), .Y(n40) );
  XOR2X1 U39 ( .A(n6), .B(rollover_val[1]), .Y(n41) );
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
  INVX2 U43 ( .A(n52), .Y(n7) );
  XOR2X1 U44 ( .A(N25), .B(n8), .Y(N16) );
  NOR2X1 U45 ( .A(n9), .B(n1), .Y(n8) );
  XOR2X1 U46 ( .A(n1), .B(n9), .Y(N15) );
  NAND2X1 U47 ( .A(N23), .B(N22), .Y(n9) );
  XOR2X1 U48 ( .A(N23), .B(N22), .Y(N14) );
endmodule


module USB_timer_rx ( d_edge, receiving, clk, n_rst, eop, shift_enable, 
        byte_received, rx_hold );
  input d_edge, receiving, clk, n_rst, eop;
  output shift_enable, byte_received, rx_hold;
  wire   _0_net_, _1_net_, _3_net_, rf_2, rcv_reg, N51, N70, N71, N72, N73,
         n13, n14, n15, n16, n17, n18, n7, n8, n9, n10, n11, n12, n19, n20,
         n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n33, n34, n35,
         n36;
  wire   [3:0] current_state;
  wire   [3:0] next_state;

  DFFSR rcv_reg_reg ( .D(receiving), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        rcv_reg) );
  DFFSR \current_state_reg[3]  ( .D(next_state[3]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(current_state[3]) );
  DFFSR \current_state_reg[2]  ( .D(next_state[2]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(current_state[2]) );
  DFFSR \current_state_reg[1]  ( .D(next_state[1]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(current_state[1]) );
  DFFSR \current_state_reg[0]  ( .D(next_state[0]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(current_state[0]) );
  DFFSR rx_hold_reg ( .D(rf_2), .CLK(clk), .R(n_rst), .S(1'b1), .Q(rx_hold) );
  AND2X2 U10 ( .A(N73), .B(n13), .Y(next_state[3]) );
  AND2X2 U11 ( .A(N72), .B(n13), .Y(next_state[2]) );
  AND2X2 U12 ( .A(N71), .B(n13), .Y(next_state[1]) );
  AND2X2 U13 ( .A(N70), .B(n13), .Y(next_state[0]) );
  AND2X2 U14 ( .A(current_state[0]), .B(receiving), .Y(n18) );
  NAND2X1 U21 ( .A(rcv_reg), .B(n35), .Y(n13) );
  NOR2X1 U22 ( .A(n14), .B(n15), .Y(_3_net_) );
  NAND3X1 U23 ( .A(current_state[0]), .B(n34), .C(receiving), .Y(n15) );
  NAND3X1 U24 ( .A(n31), .B(n36), .C(n33), .Y(n14) );
  NOR2X1 U25 ( .A(rx_hold), .B(n16), .Y(_1_net_) );
  OR2X1 U26 ( .A(byte_received), .B(n35), .Y(_0_net_) );
  NOR2X1 U27 ( .A(eop), .B(n36), .Y(N51) );
  NAND3X1 U28 ( .A(n17), .B(n34), .C(n18), .Y(n16) );
  NOR2X1 U29 ( .A(current_state[3]), .B(current_state[2]), .Y(n17) );
  flex_counter_NUM_CNT_BITS4_1 FLEX_COUNTER2_BYTE_RECEIVED ( .n_rst(n_rst), 
        .clear(_0_net_), .clk(clk), .count_enable(_1_net_), .rollover_val({
        1'b1, 1'b0, 1'b0, 1'b0}), .rollover_flag(byte_received) );
  flex_counter_NUM_CNT_BITS4_0 FLEX_COUNTER3_BIT_STUFFING ( .n_rst(n_rst), 
        .clear(d_edge), .clk(clk), .count_enable(_3_net_), .rollover_val({1'b0, 
        1'b1, 1'b1, 1'b1}), .rollover_flag(rf_2) );
  NOR2X1 U4 ( .A(current_state[2]), .B(current_state[1]), .Y(n8) );
  NOR2X1 U15 ( .A(n8), .B(n27), .Y(n10) );
  NOR2X1 U16 ( .A(d_edge), .B(current_state[3]), .Y(n22) );
  NAND2X1 U17 ( .A(N51), .B(n8), .Y(n7) );
  OAI21X1 U18 ( .A(current_state[3]), .B(n8), .C(n7), .Y(n9) );
  AOI22X1 U19 ( .A(n10), .B(n29), .C(n9), .D(n27), .Y(n11) );
  OAI21X1 U20 ( .A(n28), .B(n31), .C(n11), .Y(N70) );
  AOI21X1 U30 ( .A(n27), .B(n36), .C(current_state[3]), .Y(n20) );
  OAI21X1 U31 ( .A(d_edge), .B(current_state[1]), .C(n28), .Y(n12) );
  NAND3X1 U32 ( .A(current_state[0]), .B(n31), .C(n12), .Y(n19) );
  OAI21X1 U33 ( .A(n34), .B(n20), .C(n19), .Y(N71) );
  NOR2X1 U34 ( .A(n27), .B(n34), .Y(n24) );
  OAI21X1 U35 ( .A(n24), .B(d_edge), .C(n31), .Y(n21) );
  NAND3X1 U36 ( .A(n22), .B(n33), .C(n24), .Y(n23) );
  OAI21X1 U37 ( .A(n33), .B(n30), .C(n23), .Y(N72) );
  NAND2X1 U38 ( .A(n24), .B(n36), .Y(n26) );
  OAI21X1 U39 ( .A(n28), .B(current_state[0]), .C(current_state[3]), .Y(n25)
         );
  OAI21X1 U40 ( .A(n33), .B(n26), .C(n25), .Y(N73) );
  INVX2 U41 ( .A(current_state[0]), .Y(n27) );
  INVX2 U42 ( .A(n8), .Y(n28) );
  INVX2 U43 ( .A(n22), .Y(n29) );
  INVX2 U44 ( .A(n21), .Y(n30) );
  INVX2 U45 ( .A(current_state[3]), .Y(n31) );
  INVX2 U46 ( .A(n16), .Y(shift_enable) );
  INVX2 U47 ( .A(current_state[2]), .Y(n33) );
  INVX2 U48 ( .A(current_state[1]), .Y(n34) );
  INVX2 U49 ( .A(receiving), .Y(n35) );
  INVX2 U50 ( .A(d_edge), .Y(n36) );
endmodule


module USB_rx_top_level ( d_plus_in, d_minus_in, clk, n_rst, packet_type, 
        rx_data, write_enable, rcv_error, eop );
  output [7:0] rx_data;
  input d_plus_in, d_minus_in, clk, n_rst, packet_type;
  output write_enable, rcv_error, eop;
  wire   d_plus_sync, d_minus_sync, shift_enable, d_orig, d_edge, crc_clear,
         _0_net_, crc_check, crc_enable, rx_hold, byte_received, receiving, n2
;

  NOR2X1 U2 ( .A(rx_hold), .B(n2), .Y(_0_net_) );
  USB_sync_high SYNC_HIGH ( .clk(clk), .n_rst(n_rst), .async_in(d_plus_in), 
        .sync_out(d_plus_sync) );
  USB_sync_low SYNC_LOW ( .clk(clk), .n_rst(n_rst), .async_in(d_minus_in), 
        .sync_out(d_minus_sync) );
  USB_eop_detect EOP_DETECT ( .clk(clk), .n_rst(n_rst), .d_plus_sync(
        d_plus_sync), .d_minus_sync(d_minus_sync), .eop(eop) );
  USB_decoder DECODER ( .d_plus_sync(d_plus_sync), .shift_enable(shift_enable), 
        .eop(eop), .clk(clk), .n_rst(n_rst), .d_orig(d_orig) );
  USB_edge_detect EDGE_DETECT ( .clk(clk), .n_rst(n_rst), .d_plus_sync(
        d_plus_sync), .d_edge(d_edge) );
  USB_crc_rx CRC ( .clk(clk), .n_rst(n_rst), .crc_clear(crc_clear), 
        .shift_enable(_0_net_), .d_orig(d_orig), .packet_type(packet_type), 
        .crc_enable(crc_enable), .crc_check(crc_check) );
  USB_rx_sr RX_SR ( .clk(clk), .n_rst(n_rst), .shift_enable(shift_enable), 
        .d_orig(d_orig), .rx_hold(rx_hold), .rx_data(rx_data) );
  USB_rx_controller RX_CONTROLLER ( .clk(clk), .n_rst(n_rst), .shift_enable(
        shift_enable), .byte_received(byte_received), .rx_data(rx_data), .eop(
        eop), .crc_check(crc_check), .d_edge(d_edge), .crc_clear(crc_clear), 
        .receiving(receiving), .write_enable(write_enable), .rcv_error(
        rcv_error), .crc_enable(crc_enable) );
  USB_timer_rx RX_TIMER ( .d_edge(d_edge), .receiving(receiving), .clk(clk), 
        .n_rst(n_rst), .eop(eop), .shift_enable(shift_enable), .byte_received(
        byte_received), .rx_hold(rx_hold) );
  INVX2 U3 ( .A(shift_enable), .Y(n2) );
endmodule

