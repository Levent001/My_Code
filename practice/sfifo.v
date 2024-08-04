module sfifo (
    input            clk,
    input            rst_n,
    input            write_enable,
    input            read_enable,
    input      [7:0] write_data,
    output reg [7:0] read_data,
    output           empty,
    output           full
);

    reg [7:0] mem[15:0];
    wire [3:0] w_addr_a, r_addr_a;
    reg [4:0] w_addr_e, r_addr_e;

    assign w_addr_a = w_addr_e[3:0];
    assign r_addr_a = r_addr_e[3:0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            w_addr_e <= 0;
        end else begin
            if (write_enable == 1 && full == 0) begin
                w_addr_e      <= w_addr_e + 1;
                mem[w_addr_a] <= write_data;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_addr_e <= 0;
        end else begin
            if (write_enable == 1 && full == 0) begin
                r_addr_e  <= r_addr_e + 1;
                read_data <= mem[r_addr_a];
            end
        end
    end

    assign empty = (r_addr_e == w_addr_e) ? 1 : 0;
    assign full  = ((r_addr_e[4] == w_addr_e[4]) && (r_addr_a == w_addr_a)) ? 1 : 0;
endmodule  //sfifo
