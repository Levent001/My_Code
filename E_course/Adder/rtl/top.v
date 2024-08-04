module top (
    input  wire a_in,
    input  wire b_in,
    input  wire c_in,
    
    output wire sum_out,
    output wire c_out
);

assign sum_out = a_in ^ b_in ^ c_in;
assign c_out = (a_in & b_in) | (b_in & c_in) | (a_in & c_in);

endmodule //full_adder
