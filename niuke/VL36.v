//VL36 状态机-重叠序列检测
`timescale 1ns/1ns

module sequence_test2(
	input wire clk  ,
	input wire rst  ,
	input wire data ,
	output reg flag
);
//*************code***********//
reg [4:0] state;
parameter s0 = 5'b00001;
parameter s1 = 5'b00010;
parameter s2 = 5'b00100;
parameter s3 = 5'b01000;
parameter s4 = 5'b10000;

always @ (posedge clk or negedge rst) begin
    if(!rst) begin
        flag <= 0;
    end
    else begin
        if(state == s4)
            flag <= 1;
        else
            flag <= 0;
    end
end



always @ (posedge clk or negedge rst) begin
    if(!rst) begin
        state <= s0;
    end
    else begin
        case(state)
            s0: begin
                if(data == 1) begin
                    state <= s1;
                end
                else begin
                    state <= s0;
                end
            end
            s1: begin
                if(data == 0) begin
                    state <= s2;
                end
                else begin
                    state <= s0;
                end
            end
            s2: begin
                if(data == 1) begin
                    state <= s3;
                end
                else begin
                    state <= s0;
                end
            end
            s3: begin
                if(data == 1) begin
                    state <= s4;
                end
                else begin
                    state <= s0;
                end
            end
            s4: begin
                if(data == 1) begin
                    state <= s1;
                end
                else begin
                    state <= s2;
                end
            end
            default: begin
                state <= s0;
            end
        endcase        
    end
end

//*************code***********//
endmodule