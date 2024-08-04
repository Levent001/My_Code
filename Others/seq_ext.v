module seq_ext (
    input clk,
    input rst_n,
    input din,
    output dout_vld,
    output dout
);
localparam S1 = 4'd1;
localparam S2 = 4'd2;
localparam S3 = 4'd3;
localparam S4 = 4'd4;
reg [3:0] current_state;
reg [3:0] next_state;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        current_state <= S1;
    end
    else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        S1:begin
            if(!din) begin
                next_state = S1;
            end
        end
        S2:begin
            if(din)begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S3:begin
            if(!din)begin
                next_state = S3;
            end else begin
                
            end
        end
    endcase
end
endmodule //seq_ext