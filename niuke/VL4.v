// VL4 移位运算与乘法
`timescale 1ns/1ns
module multi_sel(
input [7:0]d ,
input clk,
input rst, //牛客网中说明是低电平复位，但是没写成rst_n
output reg input_grant,
output reg [10:0]out
);
//*************code***********//
reg [1:0] cnt;
reg [7:0] din;
always @(posedge clk or negedge rst) begin
    if(!rst)begin
        out <= 0;
        input_grant <= 0;
    end
    else begin
        case(cnt)
        0:begin
            din <= d;//注意！！不能直接在后面对d进行移位
            input_grant <= 1;
            out <= d;
        end
        1:begin
            input_grant <= 0;
            out <= (din<<2)-din;
        end
        2:begin
            out <= (din<<3)-din;
        end
        3:begin
            out <= din<<3;
        end
        endcase
    end
end
always @(posedge clk or negedge rst) begin
    if(!rst)begin
        cnt <= 0;
    end
    else begin 
        cnt <= cnt+1;
        if(cnt>=3) begin
            cnt<=0;
        end
    end
end

//*************code***********//
endmodule