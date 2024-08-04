// VL3 奇偶校验
`timescale 1ns/1ns
module odd_sel(
input [31:0] bus,
input sel,
output check
);
//*************code***********//
wire tmp;
assign tmp = ^bus;
assign check = sel?tmp:~tmp;

//*************code***********//
endmodule