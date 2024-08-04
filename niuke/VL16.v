//VL16 使用8线-3线优先编码器Ⅰ实现16线-4线优先编码器
`timescale 1ns/1ns
module encoder_83(
   input      [7:0]       I   ,
   input                  EI  ,
   
   output wire [2:0]      Y   ,
   output wire            GS  ,
   output wire            EO    
);
assign Y[2] = EI & (I[7] | I[6] | I[5] | I[4]);
assign Y[1] = EI & (I[7] | I[6] | ~I[5]&~I[4]&I[3] | ~I[5]&~I[4]&I[2]);
assign Y[0] = EI & (I[7] | ~I[6]&I[5] | ~I[6]&~I[4]&I[3] | ~I[6]&~I[4]&~I[2]&I[1]);

assign EO = EI&~I[7]&~I[6]&~I[5]&~I[4]&~I[3]&~I[2]&~I[1]&~I[0];

assign GS = EI&(I[7] | I[6] | I[5] | I[4] | I[3] | I[2] | I[1] | I[0]);
//assign GS = EI&(| I);
         
endmodule

module encoder_164(
   input      [15:0]      A   ,
   input                  EI  ,
   
   output wire [3:0]      L   ,
   output wire            GS  ,
   output wire            EO    
);

wire [2:0] Y1,Y2;
wire  GS1,GS2,EO1,EO2;

encoder_83 u_encoder_83_1(
    .I (A[7:0]),
    .EI(EI),
    .Y (Y1),
    .GS(GS1),
    .EO(EO1)
);
encoder_83 u_encoder_83_2(
    .I (A[15:8]),
    .EI(EI),
    .Y (Y2),
    .GS(GS2),
    .EO(EO2)
);

assign GS = GS1 | GS2;
assign EO = EO1 & EO2;
assign L  = GS2?{GS2,Y2}:{GS2,Y1};
endmodule