`timescale 1ns / 1ps
`include "./VL5.v"
module test_module;

// sequence_detect Parameters
parameter PERIOD  = 10;


// sequence_detect Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   data                                 ;

// sequence_detect Outputs
wire  match                                ;
wire  not_match                            ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
    data = 0;
    #PERIOD data = 1;
    #PERIOD data = 1;
    #PERIOD data = 1;
    #PERIOD data = 0;
    #PERIOD data = 0;

    #PERIOD data = 0;
    #PERIOD data = 1;
    #PERIOD data = 1;
    #PERIOD data = 1;
    #PERIOD data = 0;
    #PERIOD data = 0;

    #PERIOD data = 1;
    #PERIOD data = 0;
    #PERIOD data = 0;
    #PERIOD data = 0;
    #PERIOD data = 0;
    #PERIOD data = 0;
end

reg [15:0] d;
reg [1:0] sel;
initial begin
    #(PERIOD*2) rst_n  =  1;
    d = 16'h1234;
    sel = 2'd0;
    #PERIOD sel = 2'd1;
    #PERIOD sel = 2'd2;
    #PERIOD d = 16'h2345;
    sel = 2'd0;
    #PERIOD sel = 2'd1;
end

data_cal u_data_cal(
    .clk      (clk      ),
    .rst      (rst_n      ),
    .d        (d        ),
    .sel      (sel      ),
    .out      (      ),
    .validout ( )
);

////////////////////////////////////////////////////////////
    initial begin
        $dumpfile("wave.vcd");  //生成的vcd文件名称
        $dumpvars(0, test_module);  //tb模块名称
        #20000 $finish;
    end
////////////////////////////////////////////////////////////
endmodule
