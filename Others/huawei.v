//单bit 010111
module huawei(
    input clk,
    input rstn,
    input d,
    output valid_out
);
    localparam s0 = 7'b0000001;
    localparam s1 = 7'b0000010;
    localparam s2 = 7'b0000100;
    localparam s3 = 7'b0001000;
    localparam s4 = 7'b0010000;
    localparam s5 = 7'b0100000;
    localparam s6 = 7'b1000000;

    reg [6:0] current_state;
    reg [6:0] next_state;
    reg valid_out_tmp;

    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            current_state <= s0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin//010 111
        case(current_state)
            s0: next_state = d ? s0 : s1;
            s1: next_state = d ? s2 : s1;
            s2: next_state = d ? s0 : s3;
            s3: next_state = d ? s4 : s1;
            s4: next_state = d ? s5 : s1;
            s5: next_state = d ? s6 : s1;
            s6: next_state = d ? s0 : s1;
            default: next_state = s0;
        endcase
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            valid_out_tmp <= 0;
        else if(current_state == s6)
            valid_out_tmp <= 1;
        else
            valid_out_tmp <= 0;
    end

    assign valid_out = valid_out_tmp;
endmodule