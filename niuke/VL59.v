`timescale 1ns / 1ns

module RTL (
    input      clk,
    input      rst_n,
    input      data_in,
    output reg data_out
);
    reg data_in_tmp;
    wire data_tmp;
    always @(posedge clk) begin
        if(!rst_n)
            data_in_tmp <= 0;
        else
            data_in_tmp <= data_in;
    end

    assign data_tmp = data_in & (~data_in_tmp);

    always @(posedge clk) begin
        if(!rst_n)
            data_out <= 0;
        else
            data_out <= data_tmp;
    end
endmodule
