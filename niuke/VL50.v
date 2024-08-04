`timescale 1ns/1ns

module count_module(
	input clk,
	input rst_n,

    output reg [5:0]second,
    output reg [5:0]minute
	);
	
	always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            second <= 1'b0;
        end
        else if(second == 6'd60)begin
            second <= 1'b1;
        end
        else if(minute == 6'd60) begin
            second <= second;
        end
        else begin
            second <= second + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            minute <= 0;
        end
        else if(second == 6'd60) begin
            minute <= minute + 1'b1;
        end
        else begin
            minute <= minute;
        end
    end

	
endmodule