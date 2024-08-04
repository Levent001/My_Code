//VL39 自动贩售机2
`timescale 1ns/1ns

module seller2(
	input wire clk  ,
	input wire rst  ,
	input wire d1 ,
	input wire d2 ,
	input wire sel ,
	
	output reg out1,
	output reg out2,
	output reg out3
);
//*************code***********//
reg [3:0] money_cnt;

always @ (posedge clk or negedge rst) begin
    if(!rst) begin
        money_cnt <= 0;
    end
    else begin
        if(d1) begin
            money_cnt <= money_cnt + 1;
        end
        else if(d2)begin
            money_cnt <= money_cnt + 2;
        end
        else begin
            money_cnt <= money_cnt;
        end
    end
end

always @ (posedge clk or negedge rst) begin
    if(!rst) begin
        out1 <= 0;
        out2 <= 0;
        out3 <= 0;
    end
    else begin
        case(sel)
            1'b0: begin
                if(money_cnt >= 3) begin
                    out1 <= 1;
                    out3 <= money_cnt - 3;
                    money_cnt <= 0;
                end
                else begin
                    out1 <= 0;
                    out3 <= 0;
                end
            end
            1'b1: begin
                if(money_cnt >= 5) begin
                    out2 <= 1;
                    out3 <= money_cnt - 5;
                    money_cnt <= 0;
                end
                else begin
                    out2 <= 0;
                    out3 <= 0;
                end
            end
            default: begin
                out1 <= 0;
                out2 <= 0;
                out3 <= 0;
            end
        endcase
    end
end





//*************code***********//
endmodule