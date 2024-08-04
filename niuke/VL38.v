//VL38 自动贩售机1
`timescale 1ns/1ns
module seller1(
	input wire clk  ,
	input wire rst  ,
	input wire d1 ,
	input wire d2 ,
	input wire d3 ,
	
	output reg out1,
	output reg [1:0]out2
);
//*************code***********//
reg [3:0] cnt;
    always@(posedge clk or negedge rst)begin
        if(!rst)begin
            cnt <= 0;
            out1 <= 0;
            out2 <= 0;
        end
        else begin
            if(d1) cnt <= cnt + 1;
            else if(d2) cnt <= cnt + 2;
            else if(d3) cnt <= cnt + 4;
            else if(cnt >= 3)begin
                out1 <= 1;
                out2 <= cnt - 3;
                cnt <= 0;
            end
            else begin
                out1 <= 0;
                out2 <= 0;
            end
        end
    end

//*************code***********//
endmodule

