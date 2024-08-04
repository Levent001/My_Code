// VL5 位拆分与运算
`timescale 1ns / 1ns

module data_cal (
    input        clk,
    input        rst,
    input [15:0] d,
    input [ 1:0] sel,

    output [4:0] out,
    output       validout
);
    //*************code***********//
    reg [15:0] d_tmp;
    reg [ 4:0] out_tmp;
    reg        validout_tmp;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            d_tmp <= 0;
        end else if (!sel) begin
            d_tmp <= d;
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            out_tmp <= 0;
        end else begin
            case (sel)
                2'b00: out_tmp <= 0;
                2'b01: out_tmp <= d_tmp[3:0] + d_tmp[7:4];
                2'b10: out_tmp <= d_tmp[3:0] + d_tmp[11:8];
                2'b11: out_tmp <= d_tmp[3:0] + d_tmp[15:12];
            endcase
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            validout_tmp <= 0;
        end else begin
            case (sel)
                2'b00: validout_tmp <= 0;
                2'b01: validout_tmp <= 1;
                2'b10: validout_tmp <= 1;
                2'b11: validout_tmp <= 1;
            endcase
        end
    end

    assign out      = out_tmp;
    assign validout = validout_tmp;
    //*************code***********//
endmodule
