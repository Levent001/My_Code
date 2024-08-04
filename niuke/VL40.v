//VL40 占空比50%的奇数分频
`timescale 1ns/1ns

module odo_div_or
   (
    input    wire  rst ,
    input    wire  clk_in,
    output   wire  clk_out7
    );

//*************code***********//
reg [2:0] cnt;
reg       clk_out7_r;

always @ (clk_in or negedge rst) begin //此处时钟触发方式不太一样，变化就触发
    if(!rst) begin
        cnt <= 0;
    end
    else begin
        if(cnt == 6)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end
end

always @ (clk_in or negedge rst) begin
    if(!rst) begin
        clk_out7_r <= 0;
    end
    else begin
        if(cnt == 6)
            clk_out7_r <= ~clk_out7_r;
    end
end

assign clk_out7 = clk_out7_r;

//*************code***********//
endmodule