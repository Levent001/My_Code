//VL15 优先编码器Ⅰ
`timescale 1ns/1ns

module encoder_83(
   input      [7:0]       I   ,
   input                  EI  ,
   
   output wire [2:0]      Y   ,
   output wire            GS  ,
   output wire            EO    
);

reg GS_tmp,EO_tmp;
reg [2:0] Y_tmp;

always @(*) begin
    if(EI==0)begin
        GS_tmp = 0;
        EO_tmp = 0;
        Y_tmp  = 0;
    end
    else begin
        GS_tmp = |I;
        EO_tmp = ~(|I);
        casex (I)
            8'b0000_0000: Y_tmp = 3'b000;
            8'b0000_0001: Y_tmp = 3'b000;
            8'b0000_001x: Y_tmp = 3'b001;
            8'b0000_01xx: Y_tmp = 3'b010;
            8'b0000_1xxx: Y_tmp = 3'b011;
            8'b0001_xxxx: Y_tmp = 3'b100;
            8'b001x_xxxx: Y_tmp = 3'b101;
            8'b01xx_xxxx: Y_tmp = 3'b110;
            8'b1xxx_xxxx: Y_tmp = 3'b111;
            default: Y_tmp = 3'b0;
        endcase
    end   
end

assign GS = GS_tmp;
assign EO = EO_tmp;
assign Y  = Y_tmp;
endmodule