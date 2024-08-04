//单bit 1001
module huawei(
    input clk,
    input rstn,
    input d,
    output valid_out
);
    localparam s0 = 5'b00001;
    localparam s1 = 5'b00010;
    localparam s2 = 5'b00100;
    localparam s3 = 5'b01000;
    localparam s4 = 5'b10000;

    reg [4:0] current_state;
    reg [4:0] next_state;
    reg valid_out_tmp;

    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            current_state <= s0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin//1001
        case(current_state)
            s0: next_state = d ? s1 : s0;
            s1: next_state = d ? s1 : s2;
            s2: next_state = d ? s1 : s3;
            s3: next_state = d ? s4 : s0;
            s4: next_state = d ? s1 : s0;
            default: next_state = s0;
        endcase
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            valid_out_tmp <= 0;
        else if(current_state == s4)
            valid_out_tmp <= 1;
        else
            valid_out_tmp <= 0;
    end

    assign valid_out = valid_out_tmp;
endmodule