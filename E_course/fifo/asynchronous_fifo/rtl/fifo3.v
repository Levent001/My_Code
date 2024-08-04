//异步fifo
`timescale 1ns / 1ps
module fifo3 #(
    parameter DEPTH   = 256,
    parameter WIDTH_A = 8,
    parameter WIDTH_D = 16
) (
    input               w_clk,
    input               rst_n,
    input               w_req,
    input [WIDTH_D-1:0] w_data,

    input r_clk,
    input r_req,

    output [WIDTH_D-1:0] r_data,

    output w_full,
    output r_empty
);
    wire [WIDTH_A:0] w_addr;
    wire [WIDTH_A:0] r_addr;
    wire [WIDTH_A:0] w_gaddr;
    wire [WIDTH_A:0] r_gaddr;
    wire [WIDTH_A:0] r_gaddr_syn;
    wire [WIDTH_A:0] w_gaddr_syn;

    write_part #(
        .WIDTH_A(WIDTH_A)
    ) write_control (
        .w_clk(w_clk),
        .w_rst(rst_n),
        .w_req(w_req),

        .r_gaddr(r_gaddr_syn),

        .w_full(w_full),
        .w_addr(w_addr),

        .w_gaddr(w_gaddr)
    );

    RAM_DUAL_rst #(
        .ADDR_WIDTH(WIDTH_A),
        .DATA_WIDTH(WIDTH_D)
    ) RAM (
        .data_in(w_data),
        .w_addr (w_addr[WIDTH_A-1:0]),
        .w_en   (w_req & (!w_full)),
        .w_clk  (w_clk),

        .data_out(r_data),
        .r_addr  (r_addr[WIDTH_A-1:0]),
        .r_en    (r_req & (!r_empty)),
        .r_clk   (r_clk),

        .rst_n(rst_n)
    );

    syn #(
        .WIDTH_D(WIDTH_A)
    ) syn_w_2_r (
        .syn_clk(r_clk),
        .syn_rstn(rst_n),
        .data_in(w_gaddr),

        .syn_data(w_gaddr_syn)
    );

    syn #(
        .WIDTH_D(WIDTH_A)
    ) syn_r_2_w (
        .syn_clk(w_clk),
        .syn_rstn(rst_n),
        .data_in(r_gaddr),

        .syn_data(r_gaddr_syn)
    );

    read_part #(
        .WIDTH_A(WIDTH_A)
    ) read_control (
        .r_clk(r_clk),
        .r_rst(rst_n),
        .r_req(r_req),

        .w_gaddr(w_gaddr_syn),
        .r_empty(r_empty),
        .r_addr (r_addr),
        .r_gaddr(r_gaddr)
    );

endmodule
