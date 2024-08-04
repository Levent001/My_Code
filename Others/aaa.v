module aaa(
    input clk,
    input rst,
    input win_last,
    output wr_en
);

localparam s0 = 3'b001;
localparam s1 = 3'b010;
localparam s2 = 3'b100;

reg [2:0] curr_state;
reg fifo_wr_en;
reg [7:0] cnt;

always @(posedge clk) begin
    if(rst)begin
        curr_state <= s0;
        fifo_wr_en <= 0;
        cnt <= 0;
    end
    case(curr_state)
        s0:begin
            if(win_last) curr_state <= s1;
        end
        s1:begin
            cnt <= cnt + 1;
            fifo_wr_en <= 1;
            if(cnt == 8'd35) begin
                curr_state <= s2;
            end
        end
        s2:begin
            fifo_wr_en <= 0;
            curr_state <= s2;
        end
        default: curr_state <= s0;
    endcase
end

assign wr_en = fifo_wr_en;
endmodule