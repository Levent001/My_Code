module syn #(
    parameter WIDTH_D = 5
) (
    input wire             syn_clk,
    input wire             syn_rstn,
    input wire [WIDTH_D:0] data_in,

    output wire [WIDTH_D:0] syn_data
);

    reg [WIDTH_D:0] syn_reg_1, syn_reg_2;

    always @(posedge syn_clk) begin
        if (!syn_rstn) begin
            syn_reg_1 <= 'h00;
            syn_reg_2 <= 'h00;
        end else begin
            syn_reg_1 <= data_in;
            syn_reg_2 <= syn_reg_1;
        end
    end

    assign syn_data = syn_reg_2;

endmodule
