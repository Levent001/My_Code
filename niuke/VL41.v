//VL41 任意小数分频
`timescale 1ns/1ns

module div_M_N(
 input  wire clk_in,
 input  wire rst,
 output wire clk_out
);
parameter M_N = 8'd87; 
parameter c89 = 8'd24; // 8/9时钟切换点
parameter div_e = 5'd8; //偶数周期
parameter div_o = 5'd9; //奇数周期
//*************code***********//
//10个8.7分频输出等于3个8分频，7个9分频

reg div_flag;//0为8分频 1为9分频
reg [3:0] clk_cnt;
reg [6:0] cyc_cnt;
reg       clk_out_r;

always @ (posedge clk_in or negedge rst) begin
    if(!rst) begin
        clk_cnt <= 0;
    end
    else if(!div_flag) begin
        clk_cnt <= clk_cnt==(div_e-1)? 0:(clk_cnt+1);
    end
    else begin
        clk_cnt <= clk_cnt==(div_o-1)? 0:(clk_cnt+1);
    end
end

always @ (posedge clk_in or negedge rst) begin
    if(!rst) begin
        cyc_cnt <= 0;
    end
    else begin
        cyc_cnt <= cyc_cnt==(M_N-1)? 0: (cyc_cnt+1);
    end
end

always @ (posedge clk_in or negedge rst) begin
    if(!rst) begin
        div_flag <= 0;
    end
    else begin
        div_flag <= cyc_cnt == (M_N-1)||cyc_cnt == (c89-1) ? ~div_flag:div_flag;
    end
end

always @ (posedge clk_in or negedge rst) begin
    if(!rst) begin
        clk_out_r <= 0;
    end
    else if(!div_flag) begin
        clk_out_r <= clk_cnt<=((div_e>>2)+1);
    end
    else begin
        clk_out_r <= clk_cnt<=((div_o>>2)+1);
    end
end

assign clk_out = clk_out_r;

//*************code***********//
endmodule