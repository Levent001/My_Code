//VL24 边沿检测
`timescale 1ns/1ns
module edge_detect(
	input clk,
	input rst_n,
	input a,
	
	output reg rise,
	output reg down
);

reg a_tmp;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        a_tmp <= 0;
    end
    else begin
        a_tmp <= a;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        rise <= 0;
        down <= 0;
    end
    else if (!a_tmp && a) begin
        rise <= 1'b1;
        down <= 1'b0;
    end
    else if(a_tmp && !a) begin
        rise <= 1'b0;
        down <= 1'b1;
    end
    else begin
        rise <= 1'b0;
        down <= 1'b0;
    end
end

endmodule