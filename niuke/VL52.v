`timescale 1ns/1ns

module count_module(
	input clk,
	input rst_n,
	input mode,
	output reg [3:0]number,
	output reg zero
	);

    reg [3:0] num;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            num <= 0;
        else if(mode)
            num <= (num == 4'd9) ?  0 : (num+1);
        else
            num <= (num == 4'd0) ? 4'd9 : (num-1);
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            number <= 0;
        else 
            number <= num;
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            zero <= 0;
        else
            zero <= (num==0) ? 1:0;
    end

endmodule