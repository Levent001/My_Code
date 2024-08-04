//VL23 ROM的简单实现
`timescale 1ns/1ns
module rom(
	input clk,
	input rst_n,
	input [7:0]addr,
	
	output [3:0]data
);

reg [3:0] myROM [7:0];

//保持ROM中的数据不变
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        myROM[0] <= 0;
        myROM[1] <= 2;
        myROM[2] <= 4;
        myROM[3] <= 6;
        myROM[4] <= 8;
        myROM[5] <= 10;
        myROM[6] <= 12;
        myROM[7] <= 14;
    end
    else begin
        myROM[0] <= myROM[0];
        myROM[1] <= myROM[1];
        myROM[2] <= myROM[2];
        myROM[3] <= myROM[3];
        myROM[4] <= myROM[4];
        myROM[5] <= myROM[5];
        myROM[6] <= myROM[6];
        myROM[7] <= myROM[7];
    end
end

assign data = myROM[addr];

endmodule