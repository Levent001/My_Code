//VL14 用优先编码器①实现键盘编码电路
`timescale 1ns/1ns
module encoder_0(
   input      [8:0]         I_n   ,
   
   output reg [3:0]         Y_n   
);

always @(*)begin
   casex(I_n)//需要对所有的结果取反
      9'b111111111 : Y_n = 4'b1111;//没有按键按下
      9'b0xxxxxxxx : Y_n = 4'b0110;//9 1001
      9'b10xxxxxxx : Y_n = 4'b0111;//8 1000
      9'b110xxxxxx : Y_n = 4'b1000;//7 0111
      9'b1110xxxxx : Y_n = 4'b1001;//6 0110
      9'b11110xxxx : Y_n = 4'b1010;//5 0101
      9'b111110xxx : Y_n = 4'b1011;//4 0100
      9'b1111110xx : Y_n = 4'b1100;//3 0011
      9'b11111110x : Y_n = 4'b1101;//2 0010
      9'b111111110 : Y_n = 4'b1110;//1 0001
      default      : Y_n = 4'b1111;//0 0000
   endcase    
end 
     
endmodule

module key_encoder(
      input      [9:0]         S_n   ,         
 
      output wire[3:0]         L     ,
      output wire              GS
);

wire [3:0] Y_n;
encoder_0 encoder(
    .I_n(S_n[9:1]),
    .Y_n(Y_n)
);

assign GS = ~(S_n[0] & Y_n[0] & Y_n[1] & Y_n[2] & Y_n[3]);
assign L = ~Y_n;


endmodule