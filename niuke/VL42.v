//VL42 无占空比要去的奇数分频
`timescale 1ns/1ns

module odd_div (    
    input     wire rst ,
    input     wire clk_in,
    output    wire clk_out5
);
//*************code***********//
reg [2:0] clk_cnt;
reg       clk_out5_r;

always @ (posedge clk_in or negedge rst) begin
    if(!rst) begin
        clk_cnt <= 0;
    end
    else begin
        clk_cnt <= (clk_cnt==3'd4)? 0:(clk_cnt+1);
    end
end

always @ (posedge clk_in or negedge rst) begin
    if(!rst) begin
        clk_out5_r <= 0;
    end
    else begin
        clk_out5_r <= clk_cnt<=((clk_cnt>>2)+1);
    end
end

assign clk_out5 = clk_out5_r;


//*************code***********//
endmodule