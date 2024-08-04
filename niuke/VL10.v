`timescale 1ns/1ns
module function_mod(
	input [3:0]a,
	input [3:0]b,
	
	output [3:0]c,
	output [3:0]d
);

    assign c = data_rev(a);
    assign d = data_rev(b);

    function [3:0] data_rev;
        integer i;
        input [3:0] data_in;
        for (i = 0; i<4; i=i+1) begin
            data_rev[i] = data_in[3-i];
        end
    endfunction
endmodule