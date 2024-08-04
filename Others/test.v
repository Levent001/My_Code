`timescale 1ns / 1ps
module test_module;
    reg       clk = 1;
    reg       rst = 1;
    reg       a;
    reg [1:0] b;
    parameter PERIOD = 10;

    initial begin
        forever #(PERIOD / 2) clk = ~clk;
    end

    initial begin
        #PERIOD rst = 0;
        #PERIOD rst = 1;
        #PERIOD a = 1;
        b = 2'b10;
    end
    Even_Freq_Div_N U_Even_Freq_Div_N (
        .clk_in (clk),
        .rst_n  (rst),
        .clk_out(clkout)

    );

    ////////////////////////////////////////////////////////////
    initial begin
        $dumpfile("wave.vcd");  //生成的vcd文件名称
        $dumpvars(0, test_module);  //tb模块名称
        #2000 $finish;
    end
    ////////////////////////////////////////////////////////////

endmodule

module Even_Freq_Div_N (
    input      clk_in,
    input      rst_n,
    output reg clk_out
);

    reg [3:0] cnt;
    parameter N = 7;

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 4'b0000;
        end else if (cnt == N-1) begin
            cnt <= 4'b0000;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            clk_out <= 0;
        end else if (cnt == ((N-1) / 2)) begin
            clk_out <= ~clk_out;
        end else if (cnt == 0) begin
            clk_out <= ~clk_out;
        end else begin
            clk_out <= clk_out;
        end
    end

endmodule

