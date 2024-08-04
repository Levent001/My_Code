`timescale 1ns/1ns

module pulse_detect(
	input 				clk_fast	, 
	input 				clk_slow	,   
	input 				rst_n		,
	input				data_in		,

	output  		 	dataout
);
    reg data_level;
    reg [2:0] data_level_reg;
	always @(posedge clk_fast or negedge rst_n) begin
        if (!rst_n) begin
            data_level <= 0;
        end
        else begin
            data_level <= data_in ? ~data_level : data_level;
        end
    end

    always @(posedge clk_slow or negedge rst_n) begin
        if (!rst_n) begin
            data_level_reg <= 0;
        end
        else begin
            data_level_reg <= {data_level_reg[1:0] , data_level};
        end
    end

    assign dataout = data_level_reg[2] ^ data_level_reg[1];
endmodule


// `timescale 1ns/1ns

// module pulse_detect(
// 	input 				clk_fast	, 
// 	input 				clk_slow	,   
// 	input 				rst_n		,
// 	input				data_in		,

// 	output  		 	dataout
// );

//     //把脉冲信号变成边沿信号
//     reg data_level;
//     always @(posedge clk_fast or negedge rst_n) begin
//         if(!rst_n)
//             data_level <= 0;
//         else begin
//             data_level <= data_in ? ~data_level : data_level;
//         end
//     end

//     reg data_level_ff1,data_level_ff2,data_level_ff3;
//     always @(posedge clk_slow or negedge rst_n) begin
//         if (!rst_n) begin
//             data_level_ff1 <= 0;
//             data_level_ff2 <= 0;
//             data_level_ff3 <= 0;
//         end
//         else begin
//             data_level_ff1 <= data_level;
//             data_level_ff2 <= data_level_ff1;
//             data_level_ff3 <= data_level_ff2;
//         end
//     end

//     assign dataout = data_level_ff3 ^ data_level_ff2;

// endmodule