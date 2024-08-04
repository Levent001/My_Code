`timescale 1ns / 1ps
module test_module;
reg clk = 1;
reg rst = 1;
reg data_in;
reg data_in_valid;
parameter PERIOD  = 10;

initial begin
    forever #(PERIOD/2)  clk=~clk;
end

initial begin
    #7 rst = 0;
    #PERIOD
    rst = 1;
    data_in = 1;
    data_in_valid =1;
    #PERIOD data_in = 1;
    #PERIOD data_in = 1;
    #PERIOD data_in = 0;
    #PERIOD data_in = 1;
    #PERIOD data_in = 1;
    #PERIOD data_in = 0;
    #PERIOD data_in = 1;
end
det_moore u_det_moore(
    .clk   (clk   ),
    .rst_n (rst ),
    .din   (data_in   ),
    .Y     (     )
);



////////////////////////////////////////////////////////////
    initial begin
        $dumpfile("wave.vcd");  //生成的vcd文件名称
        $dumpvars(0, test_module);  //tb模块名称
        #2000 $finish;
    end
////////////////////////////////////////////////////////////

endmodule

module det_moore(
   input                clk   ,
   input                rst_n ,
   input                din   ,
 
   output	reg         Y   
);
    reg [4:0] state, next_state;
    parameter S0 = 5'd0,
              S1 = 5'd1,
              S2 = 5'd2,
              S3 = 5'd3,
              S4 = 5'd4;
    
    always@(posedge clk or negedge rst_n)
        if(!rst_n)
            state <= S0;
        else
            state <= next_state;
    
    always@(*)
        case(state)
            S0: next_state =  din ? S1 : S0;
            S1: next_state =  din ? S2 : S0;
            S2: next_state = ~din ? S3 : S2;
            S3: next_state =  din ? S4 : S0;
            S4: next_state =  din ? S1 : S0;
            default: next_state <= S0;
        endcase
    
    always@(posedge clk or negedge rst_n)
        if(!rst_n)
            Y <= 1'b0;
        else if(state == S4)
            Y <= 1'b1;
        else
            Y <= 1'b0;

endmodule     
