//input 输入时钟、异步复位，N=2^n
module test(
    clk,
    rst_n,
    N,
    n
);
input  clk;
input  rst_n;
input  [31:0] N;
output reg [7:0] n;

reg [3:0] cnt;
integer i;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        cnt <= 0;
        n<= 0;
    end
    else begin
        for (i=0;i<32;i=i+1)begin
            if(N[i])begin
                n = i;
            end
        end
    end
end

endmodule