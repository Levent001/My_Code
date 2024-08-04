//VL37 时钟分频（偶数）
`timescale 1ns/1ns
module even_div
    (
    input     wire rst ,
    input     wire clk_in,
    output    wire clk_out2,
    output    wire clk_out4,
    output    wire clk_out8
    );
//*************code***********//
    reg clk_out2_r, clk_out4_r, clk_out8_r;
     
    always@(posedge clk_in or negedge rst) begin
        if(~rst)
            clk_out2_r <= 0;
        else
            clk_out2_r <= ~clk_out2_r;
    end
     
    always@(posedge clk_out2 or negedge rst) begin
        if(~rst)
            clk_out4_r <= 0;
        else
            clk_out4_r <= ~clk_out4_r;
    end
     
    always@(posedge clk_out4 or negedge rst) begin
        if(~rst)
            clk_out8_r <= 0;
        else
            clk_out8_r <= ~clk_out8_r;
    end
     
    assign clk_out2 = clk_out2_r;
    assign clk_out4 = clk_out4_r;
    assign clk_out8 = clk_out8_r;

//*************code***********//
endmodule