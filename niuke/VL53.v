`timescale 1ns/1ns

module RAM_1port(
    input clk,
    input rst,
    input enb,
    input [6:0]addr,
    input [3:0]w_data,
    output wire [3:0]r_data
);
//*************code***********//
reg [3:0] mem [127:0];

integer i;
always @(posedge clk or negedge rst) begin
    if(!rst)begin
        for (i = 0;i < 8'd128;i = i+1) begin
            mem[i] <= 4'b0;
        end
    end
    else if(enb) begin
        mem[addr] <= w_data;
    end
end

assign r_data = (!enb) ? mem[addr] : 0;
//*************code***********//
endmodule