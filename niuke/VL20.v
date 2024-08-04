//VL20 数据选择器实现逻辑电路
`timescale 1ns/1ns

module data_sel(
   input             S0     ,
   input             S1     ,
   input             D0     ,
   input             D1     ,
   input             D2     ,
   input             D3     ,
   
   output wire        Y    
);

assign Y = ~S1 & (~S0&D0 | S0&D1) | S1&(~S0&D2 | S0&D3);
     
endmodule

module sel_exp(
   input             A     ,
   input             B     ,
   input             C     ,
   
   output wire       L            
);

data_sel U0(
   .S0     (B),
   .S1     (A),
   .D0     (0),
   .D1     (C),
   .D2     (~C),
   .D3     (1),
  
   .Y      (L)
);

endmodule