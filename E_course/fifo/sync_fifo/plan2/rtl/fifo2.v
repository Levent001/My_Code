//同步fifo
`timescale 1ns / 10ps
// 方法2：地址位扩展一位，用最高位来判断空满。
module fifo2 (
    input        clk,
    input        rst_n,
    input        write_enable,
    input        read_enable,
    input  [7:0] write_data,
    output       empty,
    output       full,
    output reg [7:0] read_data
);
    reg     [7:0] mem       [15:0];  //16x8 RAM 
    wire    [3:0] w_addr_a, r_addr_a;  //accessing address 
    reg     [4:0] w_addr_e, r_addr_e;  //extended address 

    //extended address add one MSB bit than accessing address 
    //write addr e[4]read addr e[4]are used for empty/full flag generation
    assign w_addr_a = w_addr_e[3:0];
    assign r_addr_a = r_addr_e[3:0];

    //read operation
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            r_addr_e <= 5'b0;
        end 
        else begin
            if (empty == 0 && read_enable == 1) begin  //reading_condition:not empty_and_read_enable
                read_data <= mem[r_addr_a];
                r_addr_e  <= r_addr_e + 1;
            end
        end
    end  //read operation
    
    //write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            w_addr_e <= 5'b0;
        end 
        else begin
            if (full == 0 && write_enable == 1) begin  //reading_condition:not empty_and_read_enable
                mem[w_addr_a] <= write_data;
                w_addr_e  <= w_addr_e + 1;
            end
        end                
    end //write operation

    //empty and full status flag generation
    assign empty = (r_addr_e == w_addr_e) ? 1 : 0;
    assign full  = (r_addr_e[4] != w_addr_e[4] && r_addr_e[3:0] == w_addr_e[3:0]) ? 1 : 0;

endmodule
