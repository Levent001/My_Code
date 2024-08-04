`timescale 10ns/1ns
`include "../rtl/fifo2.v"
module fifo2_tb;
    reg rst_n,clk,rd_en,wr_en;
    reg [7:0] data_in;
    wire [7:0] data_out;

//例化一个电路
fifo2 u_fifo2(
    .clk          (clk          ),
    .rst_n        (rst_n        ),
    .write_enable (wr_en        ),
    .read_enable  (rd_en        ),
    .write_data   (data_in      ),
    .empty        (empty        ),
    .full         (full         ),
    .read_data    (data_out     )
);

initial begin
    rst_n = 1;
    clk   = 0;
    #1 rst_n = 0; //一个时间单位10ns
    #5 rst_n = 1; 
end

always #20 clk = ~clk;

initial begin
    wr_en = 0;
    #1 wr_en = 1;
end

initial begin
    rd_en = 0;
    #650 rd_en = 1;
         wr_en = 0;
end

initial begin
    data_in = 8'b0;
    #40 data_in = 8'h1;
    #40 data_in = 8'h2;
    #40 data_in = 8'h3;
    #40 data_in = 8'h4;
    #40 data_in = 8'h5;
    #40 data_in = 8'h6;
    #40 data_in = 8'h7;
    #40 data_in = 8'h8;
    #40 data_in = 8'h9;
    #40 data_in = 8'ha;
    #40 data_in = 8'hb;
    #40 data_in = 8'hc;
    #40 data_in = 8'hd;
    #40 data_in = 8'he;
    #40 data_in = 8'hf;
    #200 $finish;
end

// initial begin
//     $vcdpluson();
// end
    initial
    begin            
        $dumpfile("wave.vcd");        //生成的vcd文件名称
        $dumpvars(0, fifo2_tb);    //tb模块名称
    end

endmodule