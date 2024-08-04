//格雷码和8421码的最高位一样，其余位是相邻两位取异或
module bin_to_gray #(
    parameter WIDTH_D = 5
) (
    input  wire [WIDTH_D-1:0] bin_c,
    output wire [WIDTH_D-1:0] gray_c
);

    wire h_b;
    assign h_b = bin_c[WIDTH_D-1];

    reg     [WIDTH_D-2:0] gray_c_d;

    integer i;
    always @(*) begin
        for (i = 0; i < WIDTH_D - 1; i = i + 1) begin
            gray_c_d[i] = bin_c[i] ^ bin_c[i+1];
        end
    end

    assign gray_c = {h_b, gray_c_d};

endmodule  //bin_to_gray