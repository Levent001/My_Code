// 0101 1010
module detect(
    input clk,
    input rstn,
    input d,
    output valid_out
);
    localparam s0 = 9'b0_0000_0001;
    localparam s1 = 9'b0_0000_0010;
    localparam s2 = 9'b0_0000_0100;
    localparam s3 = 9'b0_0000_1000;
    localparam s4 = 9'b0_0001_0000;
    localparam s5 = 9'b0_0010_0000;
    localparam s6 = 9'b0_0100_0000;
    localparam s7 = 9'b0_1000_0000;
    localparam s8 = 9'b1_0000_0000;

    reg [8:0] current_state;
    reg [8:0] next_state;
    reg valid_out_tmp;



    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            current_state <= s0;
        end else begin
            current_state <= next_state;
        end
    end

    // always @(*) begin // 0101 1010
    //     case(current_state)
    //         s0: next_state = d ? s0 : s1;
    //         s1: next_state = d ? s2 : s1;
    //         s2: next_state = d ? s0 : s3;
    //         s3: next_state = d ? s4 : s1;
    //         s4: next_state = d ? s5 : s3;
    //         s5: next_state = d ? s0 : s6;
    //         s6: next_state = d ? s7 : s1;
    //         s7: next_state = d ? s0 : s8;
    //         s8: next_state = d ? s0 : s1;
    //         default: next_state = s0;
    //     endcase
    // end
    always @(*) begin // 101 1010
        case(current_state)
            s1: next_state = d ? s2 : s1;
            s2: next_state = d ? s2 : s3;
            s3: next_state = d ? s4 : s1;
            s4: next_state = d ? s5 : s3;
            s5: next_state = d ? s2 : s6;
            s6: next_state = d ? s7 : s1;
            s7: next_state = d ? s2 : s8;
            s8: next_state = d ? s2 : s1;
            default: next_state = s0;
        endcase
    end
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            valid_out_tmp <= 0;
        else if(current_state == s8)
            valid_out_tmp <= 1;
        else
            valid_out_tmp <= 0;
    end

    assign valid_out = valid_out_tmp;
endmodule