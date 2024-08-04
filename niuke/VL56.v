`timescale 1ns/1ns
 
module multi_pipe#(
    parameter size = 4
)(
    input                       clk         ,  
    input                       rst_n       ,
    input   [size-1:0]          mul_a       ,
    input   [size-1:0]          mul_b       ,
  
    output  reg [size*2-1:0]    mul_out    
);

    parameter OUT_WIDTH = 2 * size;
    
    wire [OUT_WIDTH - 1 : 0] mul_tmp [3:0];
    reg  [OUT_WIDTH - 1 : 0] adder_0;
    reg  [OUT_WIDTH - 1 : 0] adder_1;

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin:loop
            assign mul_tmp [i] = mul_b[i] ? (mul_a << i) : 0;
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            adder_0 <= 0;
        else begin
            adder_0 <= mul_tmp[0] + mul_tmp[1];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            adder_1 <= 0;
        else begin
            adder_1 <= mul_tmp[2] + mul_tmp[3];
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) 
            mul_out <= 'd0;
        else 
            mul_out <= adder_0 + adder_1;
    end
endmodule