`timescale 1ns/1ns
module ram_mod(
	input clk,
	input rst_n,
	
	input write_en,
	input [7:0]write_addr,
	input [3:0]write_data,
	
	input read_en,
	input [7:0]read_addr,
	output reg [3:0]read_data
);

	reg [3:0] mem [7:0];

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            for (i = 0;i < 8'd128;i = i+1) begin
                mem[i] <= 4'b0;
            end
        end
        else if(write_en) begin
            mem[write_addr] <= write_data;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            read_data <= 0;
        end
        else if(read_en) begin
            read_data <= mem[read_addr];
        end
    end
endmodule