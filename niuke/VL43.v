//VL43 根据状态转移写状态机-三段式
`timescale 1ns/1ns

module fsm1(
	input wire clk  ,
	input wire rst  ,
	input wire data ,
	output reg flag
);
//*************code***********//
parameter s0 = 4'b0001;
parameter s1 = 4'b0010;
parameter s2 = 4'b0100;
parameter s3 = 4'b1000;

reg [3:0] current_state;
reg [3:0] next_state;

always @ (posedge clk or negedge rst) begin
    if(!rst) begin
        current_state <= s0;
        // next_state <= s0;
    end
    else begin
        current_state <= next_state;
    end
end

always @ (*) begin
    case(current_state)
        s0: next_state <= data ? s1:s0;
        s1: next_state <= data ? s2:s1;
        s2: next_state <= data ? s3:s2;
        s3: next_state <= data ? s0:s3;
    endcase
end

always @ (posedge clk or negedge rst) begin
    if(!rst) begin
        flag <= 0;
    end
    else begin
        if(current_state == s3 && data)
            flag <= 1;
        else
            flag <= 0;
    end
end
//*************code***********//
endmodule