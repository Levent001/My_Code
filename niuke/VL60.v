`timescale 1ns / 1ns
module data_driver (
    input            clk_a,
    input            rst_n,
    input            data_ack,
    output reg [3:0] data,
    output reg       data_req
);

    reg       data_ack_reg1;
    reg       data_ack_reg2;
    reg [3:0] cnt;
    always @(posedge clk_a or negedge rst_n) begin
        if (!rst_n) begin
            data_ack_reg1 <= 0;
            data_ack_reg2 <= 0;
        end else begin
            data_ack_reg1 <= data_ack;
            data_ack_reg2 <= data_ack_reg1;
        end
    end

    always @(posedge clk_a or negedge rst_n) begin
        if (!rst_n) begin
            data <= 0;
        end else if (data_ack_reg1 && !data_ack_reg2) begin
            data <= data + 1;
        end else begin
            data <= data;
        end
    end

    always @(posedge clk_a or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
        end else if (data_ack_reg1 && !data_ack_reg2) begin
            cnt <= 0;
        end else if (data_req) cnt <= cnt;
        else begin
            cnt <= cnt + 1;
        end
    end

    always @(posedge clk_a or negedge rst_n) begin
        if (!rst_n) 
            data_req <= 0;
        else if (cnt == 3'd4) 
            data_req <= 1'b1;
        else if (data_ack_reg1 && !data_ack_reg2) 
            data_req <= 1'b0;
        else 
            data_req <= data_req;
    end
endmodule

module data_receiver (
    input        clk_b,
    input        rst_n,
    output reg   data_ack,
    input  [3:0] data,
    input        data_req
);
    reg data_req_reg1;
    reg data_req_reg2;
    reg [3:0]data_in_reg;
    
    always @(posedge clk_b or negedge rst_n) begin
        if(!rst_n)begin
            data_req_reg1 <= 0;
            data_req_reg2 <= 0;
        end
        else begin
            data_req_reg1 <= data_req;
            data_req_reg2 <= data_req_reg1;            
        end
    end

    always @ (posedge clk_b or negedge rst_n)
        if (!rst_n)
            data_ack <= 0;
        else if (data_req_reg1 && !data_req_reg2)
            data_ack <= 1;
        else  data_ack <=0 ;
     
    always @ (posedge clk_b or negedge rst_n)
        if (!rst_n)
            data_in_reg <= 0;
        else if (data_req_reg1 && !data_req_reg2)
            data_in_reg <= data;
        else  data_in_reg <= data_in_reg ; 
endmodule
