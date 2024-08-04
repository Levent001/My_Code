/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06
// Date      : Fri Oct 28 22:47:47 2022
/////////////////////////////////////////////////////////////


module top ( a_in, b_in, c_in, sum_out, c_out );
  input a_in, b_in, c_in;
  output sum_out, c_out;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10;

  XOR2X8 U4 ( .A(n3), .B(c_in), .Y(n2) );
  CLKINVX40 U5 ( .A(n2), .Y(n7) );
  XOR2X8 U6 ( .A(n9), .B(n10), .Y(n3) );
  AND2X6 U7 ( .A(n5), .B(n6), .Y(n4) );
  CLKINVX40 U8 ( .A(n4), .Y(c_out) );
  NAND2X4 U9 ( .A(n1), .B(c_in), .Y(n6) );
  NAND2X2 U10 ( .A(n10), .B(n9), .Y(n5) );
  BUFX6 U11 ( .A(b_in), .Y(n10) );
  CLKINVX4 U12 ( .A(a_in), .Y(n8) );
  CLKINVX12 U13 ( .A(n8), .Y(n9) );
  XOR2X8 U14 ( .A(n9), .B(n10), .Y(n1) );
  CLKINVX40 U15 ( .A(n7), .Y(sum_out) );
endmodule

