//VL9 使用子模块实现三输入数的大小比较

`timescale 1ns / 1ns
module main_mod (
    input       clk,
    input       rst_n,
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,

    output [7:0] d
);
    wire [7:0] m;
    reg [7:0] c_ff1;

    sub_mod mod_ab (
        .clk   (clk),
        .rst_n (rst_n),
        .data_a(a),
        .data_b(b),
        .data_c(m)
    );
    always @(posedge clk or negedge rst_n) begin
        c_ff1 <= c;
    end

    sub_mod mod_abc (
        .clk   (clk),
        .rst_n (rst_n),
        .data_a(m),
        .data_b(c_ff1),
        .data_c(d)
    );


endmodule

module sub_mod (
    input       clk,
    input       rst_n,
    input [7:0] data_a,
    input [7:0] data_b,

    output reg [7:0] data_c
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_c <= 0;
        end else if (data_a < data_b) begin
            data_c <= data_a;
        end else begin
            data_c <= data_b;
        end
    end
endmodule


// `timescale 1ns/1ns
// module main_mod(
// 	input clk,
// 	input rst_n,
// 	input [7:0]a,
// 	input [7:0]b,
// 	input [7:0]c,
	
// 	output [7:0]d
// );
// wire [7:0] m,n;

// sub_mod mod_ab(
//     .clk(clk),
//     .rst_n(rst_n),
//     .data_a(a),
//     .data_b(b),
//     .data_c(m)
// );
// sub_mod mod_ac(
//     .clk(clk),
//     .rst_n(rst_n),
//     .data_a(a),
//     .data_b(c),
//     .data_c(n)
// );
// sub_mod min(
//     .clk(clk),
//     .rst_n(rst_n),
//     .data_a(m),
//     .data_b(n),
//     .data_c(d)
// );
// endmodule

// module sub_mod(
//     input clk,
//     input rst_n,
// 	input [7:0]data_a,
// 	input [7:0]data_b,

//     output reg [7:0]data_c
// );
// always @(posedge clk or negedge rst_n) begin
//     if(!rst_n)begin
//         data_c <= 0;
//     end
//     else if(data_a < data_b) begin
//         data_c <= data_a;
//     end
//     else begin
//         data_c <= data_b;
//     end
// end
// endmodule