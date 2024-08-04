module read_part #(
    parameter WIDTH_A = 8
) (
    input wire r_clk,
    input wire r_rst,
    input wire r_req,

    input wire [WIDTH_A:0] w_gaddr,

    output wire             r_empty,
    output reg  [WIDTH_A:0] r_addr,

    output wire [WIDTH_A:0] r_gaddr
);

    always @(posedge r_clk) begin
        if (!r_rst) begin
            r_addr <= 'h00;
        end else if (r_req && (!r_empty)) begin
            r_addr <= r_addr + 1'b1;
        end
    end

    bin_to_gray #(
        .WIDTH_D(WIDTH_A + 1)
    ) u_bin_to_gray (
        .bin_c (r_addr),
        .gray_c(r_gaddr)
    );

    assign r_empty = (w_gaddr == r_addr) ? 1'b1 : 1'b0;

endmodule  //read_part
