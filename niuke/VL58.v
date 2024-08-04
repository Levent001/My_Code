`timescale 1ns / 1ns

module game_count (
    input            rst_n,   //异位复位信号，低电平有效
    input            clk,     //时钟信号
    input      [9:0] money,
    input            set,
    input            boost,
    output reg [9:0] remain,
    output reg       yellow,
    output reg       red
);


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) remain <= 0;
        else if (set) remain <= remain + money;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            yellow <= 0;
            red    <= 0;
        end else
            case (boost)
                1'b1: begin
                    if (remain == 0 | remain == 10'd1) begin
                        red <= 1;
                        yellow <= 0;
                    end
                    else if(remain == 10'd2 | remain == 10'd3) begin
                        red <= 1;
                        yellow <= 0;
                        remain <= remain - 10'd2;
                    end
                    else if (remain == 10'd11 | remain == 10'd10) begin
                        yellow <= 1;
                        red    <= 0;
                        remain <= remain - 10'd2;
                    end
                    else begin
                        yellow <= 0;
                        red    <= 0;
                        remain <= remain - 10'd2;
                    end
                end
                1'b0: begin
                    if (remain == 0)begin
                        red <= 1;
                        yellow <= 0;
                    end
                    else if (remain == 10'd1) begin
                        red <= 1;
                        yellow <= 0;
                        remain <= remain - 10'd1;
                    end
                    else if (remain == 10'd10) begin
                        yellow <= 1;
                        red    <= 0;
                        remain <= remain - 10'd1;
                    end
                    else begin
                        yellow <= 0;
                        red    <= 0;
                        remain <= remain - 10'd1;
                    end
                end
            endcase
    end
endmodule
