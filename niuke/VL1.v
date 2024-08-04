// VL1 制作一个四选一的多路选择器，要求输出定义上为线网类型

// 状态转换：

// d0    11
// d1    10
// d2    01
// d3    00

`timescale 1ns/1ns
module mux4_1(
    input [1:0]d1,d2,d3,d0,
    input [1:0]sel,
    output[1:0]mux_out
);
//*************code***********//

    //method 1
    // assign mux_out = sel[0]?(sel[1]?d0:d2):(sel[1]?d1:d3); 
    
    //method 2
    reg [1:0]   mux_out_tmp;  
    always @(*) begin
        case(sel)
            2'b00: mux_out_tmp = d3;
            2'b01: mux_out_tmp = d2;
            2'b10: mux_out_tmp = d1;
            2'b11: mux_out_tmp = d0;
        endcase
    end
    assign mux_out = mux_out_tmp;
//*************code***********//
endmodule