// VL2 异步复位的串联T触发器
// T触发器的原理：输入1则结果反转，输入0则结果保持不变
// 列真值表可知可以如下运算
`timescale 1ns/1ns
module Tff_2 (
input wire data, clk, rst_n,
output reg q  
);
//*************code***********//
reg tmp;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        tmp <= 0;
        q   <= 0;
    end
    else begin
      tmp <= tmp ^ data;
      q   <= tmp ^ q; 
    end
end

//*************code***********//
endmodule