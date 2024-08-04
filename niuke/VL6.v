//VL6 多功能数据处理器
`timescale 1ns/1ns
module data_select(
	input clk,
	input rst_n,
	input signed[7:0]a,
	input signed[7:0]b,
	input [1:0]select,
	output reg signed [8:0]c
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        c <= 0;
    end
    else begin
        case(select)
            0:begin
                c <= a;
            end
            1:begin
                c <= b;
            end
            2:begin
                c <= a+b;
            end
            3:begin
                c <= a-b;
            end
            default: 
                c <= 'd0;
        endcase
    end
end

endmodule
