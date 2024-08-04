//VL12 4bit超前进位加法器电路
`timescale 1ns / 1ns

module lca_4 (
    input [3:0] A_in,
    input [3:0] B_in,
    input       C_1,

    output wire       CO,
    output wire [3:0] S
);

    wire [4:0] cout_r;
    assign cout_r[0] = C_1;
    
    genvar i_add;
	generate
        for (i_add = 0; i_add < 4; i_add=i_add+1) begin:all_adder
            adder_full1 u_adder_full1(
            	.a    (A_in[i_add]    ),
                .b    (B_in[i_add]    ),
                .c    (cout_r[i_add]),
                .sum  (S[i_add]  ),
                .cout (cout_r[i_add+1] )
            );
            
        end
    endgenerate
    assign CO = cout_r[4];
endmodule

module adder_full1 (
    input  a,
    input  b,
    input  c,
    output sum,
    output cout
);

    assign sum  = a ^ b ^ c;
    assign cout = (a & b) | (a & c) | (b & c);

endmodule  //test1

// `timescale 1ns/1ns

// module lca_4(
// 	input		[3:0]       A_in  ,
// 	input	    [3:0]		B_in  ,
//     input                   C_1   ,
 
//  	output	 wire			CO    ,
// 	output   wire [3:0]	    S
// );

// wire [3:0] G,P;
// wire [4:0] C;

// genvar i;
// generate
// 	for(i=0;i<4;i=i+1)begin
// 		GP u_GP(
// 			.A_in(A_in[i]),
// 			.B_in(B_in[i]),
// 			.G_out(G[i]),
// 			.P_out(P[i])
// 		);
// 	end		
// endgenerate


// assign C[0] = C_1;
// assign C[1] = G[0] | (P[0]&C[0]);
// assign C[2] = G[1] | (P[1]&C[1]);
// assign C[3] = G[2] | (P[2]&C[2]);
// assign C[4] = G[3] | (P[3]&C[3]);
// assign CO   = C[4];

// generate
// 	for(i=0;i<4;i=i+1)begin
// 		assign S[i] = P[i] ^ C[i];
// 	end	
// endgenerate
// endmodule


// module GP (
// 	input		    A_in  ,
// 	input	   	   	B_in  ,

// 	output          G_out,
// 	output          P_out
// );
// assign G_out = A_in & B_in;
// assign P_out = A_in ^ B_in;
// endmodule

