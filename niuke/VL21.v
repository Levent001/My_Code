//VL21 根据状态转移表实现时序电路
`timescale 1ns/1ns

module seq_circuit(
      input                A   ,
      input                clk ,
      input                rst_n,
 
      output   wire        Y   
);

// reg q0, q1;
    
// always@(posedge clk or negedge rst_n) begin
//     if(~rst_n) begin
//         q1 <= 0;
//     end
//     else begin
//         q1 <= A ^ q0 ^ q1;
//     end
// end
    
// always@(posedge clk or negedge rst_n) begin
//     if(~rst_n) begin
//         q0 <= 0;
//     end
//     else begin
//         q0 <= ~q0;
//     end
// end
// assign Y = q0 & q1;

//状态机实现
reg [1:0] curr_state,next_state;

always @(*) begin
    if (~rst_n) begin
        curr_state <= 0;
        next_state <= 0;
    end
    else begin
        next_state <= curr_state;
    end 
end

always @(posedge clk or negedge rst_n) begin
    if(A==0)begin
        case(next_state)
            2'b00: curr_state = 2'b01;
            2'b01: curr_state = 2'b10;
            2'b10: curr_state = 2'b11;
            2'b11: curr_state = 2'b00;            
        endcase
    end
    else begin
        case(next_state)
            2'b00: curr_state = 2'b11;
            2'b01: curr_state = 2'b00;
            2'b10: curr_state = 2'b01;
            2'b11: curr_state = 2'b10;            
        endcase
    end  
end

reg Y_tmp ;
always @(*) begin
    Y_tmp = &next_state;
end

assign Y = Y_tmp;


endmodule