`timescale 1ns / 1ps
module asyn_fifo_tb;

    logic       w_clk;
    logic       w_req;
    logic [7:0] w_data;

    logic       r_clk;
    logic       rst_n;
    logic       r_req;

    logic [7:0] r_data;
    logic       w_full;
    logic       r_empty;

    always #2 w_clk = ~w_clk;
    always #8 r_clk = ~r_clk;

    initial begin
        w_req  = 0;
        w_data = 0;
        r_req  = 0;
        w_clk  = 0;
        r_clk  = 0;
        rst_n  = 0;

        #30;
        rst_n = 1;
        #20;

        r_req = 1;
        w_req = 1;
        forever begin //一直往里面写数据
            @(w_full)
                if (!w_full) begin
                    w_data = w_data + 1'b1;
                end
        end
    end

    fifo3 #(
        .DEPTH  (256),
        .WIDTH_A(8),
        .WIDTH_D(8)
    ) asyn_fifo (
        .w_clk  (w_clk),
        .rst_n  (rst_n),
        .w_req  (w_req),
        .w_data (w_data),
        
        .r_clk  (r_clk),
        .r_req  (r_req),
        
        .r_data (r_data),
        
        .w_full (w_full),
        .r_empty(r_empty)
    );


endmodule
