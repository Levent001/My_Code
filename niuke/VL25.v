//VL25 输入序列连续的序列检测
`timescale 1ns/1ns
module sequence_detect(
	input clk,
	input rst_n,
	input a,
	output reg match
	);

reg [7:0] a_tmp;

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        a_tmp <= 0;
    end
    else begin
        a_tmp <= {a_tmp[6:0],a};
    end
end

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        match <= 0;
    end
    else if (a_tmp == 8'b0111_0001) begin
        match <= 1'b1;
    end
    else match <= 0; 
end


  
endmodule