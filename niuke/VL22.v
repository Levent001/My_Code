//VL22 根据状态转移图实现时序电路
`timescale 1ns/1ns

module seq_circuit(
   input                C   ,
   input                clk ,
   input                rst_n,
 
   output   wire        Y   
);
    parameter ST0 = 2'b00;
    parameter ST1 = 2'b01;
    parameter ST2 = 2'b10;
    parameter ST3 = 2'b11;
    
    reg[1:0] cur_state;
    reg[1:0] next_state;
    reg Y_r;

    always@(posedge clk or negedge rst_n)
        if(!rst_n)
            cur_state <= ST0;
        else
            cur_state <= next_state;

    always@(*)
        case (cur_state)
            ST0: begin
                if(C == 1'b0) begin
                    next_state = ST0;
                end else begin
                    next_state = ST1;
                end
            end
            ST1: begin
                if(C == 1'b0) begin
                    next_state = ST3;
                end else begin
                    next_state = ST1;
                end
            end
            ST2: begin
                if(C == 1'b0) begin
                    next_state = ST0;
                end else begin
                    next_state = ST2;
                end
            end
            ST3: begin
                if(C == 1'b0) begin
                   next_state = ST3;
                end else begin
                    next_state = ST2;
                end
            end
        endcase

    always@(*)
        case (cur_state)
            ST0: begin
               Y_r = 1'b0;
            end
            ST1: begin
               Y_r = 1'b0;
            end
            ST2: begin
                if(C == 1'b1)
                    Y_r = 1'b1;
                else
                    Y_r = 1'b0;
            end
            ST3: begin
                Y_r = 1'b1;
            end
        endcase
    assign Y = Y_r;
endmodule
