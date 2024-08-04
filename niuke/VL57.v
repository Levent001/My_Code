`timescale 1ns / 1ns

module triffic_light (
    input            rst_n,         //异位复位信号，低电平有效
    input            clk,           //时钟信号
    input            pass_request,
    output     [7:0] clock,
    output reg       red,
    output reg       yellow,
    output reg       green
);

    parameter idle = 3'd000;
    parameter green_sel = 3'b001;
    parameter yellow_sel = 3'b010;
    parameter red_sel = 3'b100;

    reg       p_green;
    reg       p_yellow;
    reg       p_red;

    reg [2:0] led_sel;
    reg [7:0] cnt;
    reg [7:0] cnt_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            led_sel  <= idle;
            p_green  <= 0;
            p_yellow <= 0;
            p_red    <= 0;
        end else
            case (led_sel)
                idle: begin
                    p_green  <= 0;
                    p_yellow <= 0;
                    p_red    <= 0;
                    led_sel  <= red_sel;
                end
                green_sel: begin
                    p_green  <= 1;
                    p_yellow <= 0;
                    p_red    <= 0;
                    if(cnt == 8'd3) led_sel  <= red_sel;
                end
                yellow_sel: begin
                    p_green  <= 0;
                    p_yellow <= 1;
                    p_red    <= 0;
                    if(cnt == 8'd3) led_sel  <= green_sel;
                end
                red_sel: begin
                    p_green  <= 0;
                    p_yellow <= 0;
                    p_red    <= 1;
                    if(cnt == 8'd3) led_sel  <= yellow_sel;
                end
                default: begin
                    led_sel <= idle;
                end
            endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 8'd10;
        end else begin
            if (pass_request && green && (cnt > 10)) cnt <= 8'd10;
            else if (!green && p_green) cnt <= 8'd60;
            else if (!yellow && p_yellow) cnt <= 8'd5;
            else if (!red && p_red) cnt <= 8'd10;
            else cnt <= cnt - 1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            green  <= 0;
            yellow <= 0;
            red    <= 0;
        end else begin
            green  <= p_green;
            yellow <= p_yellow;
            red    <= p_red;
        end
    end

    assign clock = cnt;

endmodule
