//VL11 4位数值比较器电路
`timescale 1ns/1ns

module comparator_4(
	input	   [3:0]        A   	,
	input	   [3:0]		B   	,
 
 	output	 wire		 Y2    , //A>B
	output   wire        Y1    , //A=B
    output   wire        Y0      //A<B
);
wire [3:0] w_y2;
wire [3:0] w_y1;
wire [3:0] w_y0;

genvar i;
generate
	for(i=0;i<4;i=i+1) begin: All_compare
		compare_1 compare_1(
			.A(A[i]),
			.B(B[i]),
			.Y2(w_y2[i]),
			.Y1(w_y1[i]),
			.Y0(w_y0[i])
		);
	end
endgenerate

assign Y2 = w_y2[3]
			|((w_y1[3]) & (w_y2[2]))
			|((w_y1[3]) & (w_y1[2]) & (w_y2[1]))
			|((w_y1[3]) & (w_y1[2]) & (w_y1[1]) & (w_y2[0]));
assign Y1 =  ((w_y1[3]) & (w_y1[2]) & (w_y1[1]) & (w_y1[0]));
assign Y0 = w_y0[3]
			|((w_y1[3]) & (w_y0[2]))
			|((w_y1[3]) & (w_y1[2]) & (w_y0[1]))
			|((w_y1[3]) & (w_y1[2]) & (w_y1[1]) & (w_y0[0]));


endmodule

module compare_1 (
	input	  A   	,
	input	  B   	,

 	output	 wire		 Y2    , //A>B
	output   wire        Y1    , //A=B
    output   wire        Y0      //A<B
);

assign Y2 = A & (~B);
assign Y0 = (~A) & B;
assign Y1 = ~(Y2 | Y0);

endmodule 

// `timescale 1ns / 1ns

// module comparator_4 (
//     input [3:0] A,
//     input [3:0] B,

//     output wire Y2,  //A>B
//     output wire Y1,  //A=B
//     output wire Y0   //A<B
// );

// reg Y2_tmp;
// reg Y1_tmp;
// reg Y0_tmp;

// integer i;
// always @(*) begin
//     for(i=0;i<4;i=i+1)begin
//         if(A[3-i] > B[3-i])begin
//             Y2_tmp = 1;
//             Y1_tmp = 0;
//             Y0_tmp = 0;
//             i = 3;
//         end
//         else if(A[3-i] < B[3-i])begin
//             Y2_tmp = 0;
//             Y1_tmp = 0;
//             Y0_tmp = 1;
//             i = 3;
//         end
//         else if(A[0] == B[0]) begin
//             Y2_tmp = 0;
//             Y1_tmp = 1;
//             Y0_tmp = 0;
//         end
//     end
// end
// assign Y2 = Y2_tmp;
// assign Y1 = Y1_tmp;
// assign Y0 = Y0_tmp;

// endmodule
