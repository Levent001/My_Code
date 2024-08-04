//双端口RAM
`timescale 1ns / 10ps

module DUALRAM (
    Read_clock,
    Write_clock,
    Read_allow,
    Write_allow,
    Read_addr,
    Write_addr,
    Write_data,
    Read_data
);

    // clock to output delay
    // zero time delays can be confusing and sometimes cause problems

    parameter DLY = 1;
    parameter RAM_WIDTH = 8;  //width of RAM (number of bits) 
    parameter RAM_DEPTH = 16;  //depth of RAM (number of bytes) 
    parameter ADDR_WIDTH = 4;  //number of bits required to represent the RAM address

    input Read_clock;
    input Write_clock;
    input Read_allow;
    input Write_allow;
    input [ADDR_WIDTH-1:0] Read_addr;
    input [ADDR_WIDTH-1:0] Write_addr;
    input [RAM_WIDTH-1:0] Write_data;
    output  reg [RAM_WIDTH-1:0] Read_data;

    reg [RAM_WIDTH-1:0] memory[RAM_DEPTH-1:0];

    always @(posedge Write_clock) begin
        if (Write_allow) begin
            memory[Write_addr] <= #DLY Write_data;
        end
    end

    always @(posedge Read_clock) begin
        if (Read_allow) begin
            memory[Read_addr] <= #DLY Read_data;
        end
    end

endmodule
