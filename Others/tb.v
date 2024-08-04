`timescale 1ps/1ps
`include "./aaa.v"
module tb;

reg clk = 0;
reg rst = 0;
reg win_last = 0;
wire wr_en;

always #5 clk = ~clk;
initial begin
    #10 rst = 1;
    #10 rst = 0;
    #20 win_last = 1;
    #10 win_last = 0;
    #30 win_last = 1;
    #10 win_last = 0;
end

aaa myaaa(
    .clk(clk),
    .rst(rst),
    .win_last(win_last),
    .wr_en(wr_en)
);

////////////////////////////////////////////////////////////
    initial begin
        $dumpfile("wave.vcd");  //生成的vcd文件名称
        $dumpvars(0, tb);  //tb模块名称
        #20000 $finish;
    end
////////////////////////////////////////////////////////////
endmodule