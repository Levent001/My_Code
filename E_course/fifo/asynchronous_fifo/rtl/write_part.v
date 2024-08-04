module write_part #(
    parameter WIDTH_A = 8
) (
    input wire w_clk,
    input wire w_rst,
    input wire w_req,

    input wire [WIDTH_A:0] r_gaddr,

    output wire             w_full,
    output reg  [WIDTH_A:0] w_addr,
    output wire [WIDTH_A:0] w_gaddr
);

    always @(posedge w_clk) begin
        if (!w_rst) begin
            w_addr <= 'h00;
        end else if (w_req && (!w_full)) begin
            w_addr <= w_addr + 1'b1;
        end
    end

    bin_to_gray #(
        .WIDTH_D(WIDTH_A + 1)
    ) u_bin_to_gray (
        .bin_c (w_addr),
        .gray_c(w_gaddr)
    );

    assign w_full = ({~w_gaddr[WIDTH_A], ~w_gaddr[WIDTH_A-1],w_gaddr[WIDTH_A-2:0]} == r_gaddr) ? 1'b1 : 1'b0;
    //格雷码 高2bit相反，其余相等
    //在8421码中 最高bit相反，其余相等，结合格雷码转换的方式，这样来生成full信号
endmodule  //write_part
