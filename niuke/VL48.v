`timescale 1ns / 1ns

module mux (
    input       clk_a,
    input       clk_b,
    input       arstn,
    input       brstn,
    input [3:0] data_in,
    input       data_en,

    output reg [3:0] dataout
);

    reg [3:0] data_tmp;
    always @(posedge clk_a or negedge arstn) begin
        if(!arstn)
            data_tmp <= 0;
        else begin
            data_tmp <= data_in;
        end
    end

    reg date_en_ff1,data_en_ff2;
    always @(posedge clk_b or negedge brstn) begin
        if(!brstn)begin
            date_en_ff1 <= 0;
            data_en_ff2 <= 0;
        end
        else begin
            date_en_ff1 <= data_en;
            data_en_ff2 <= date_en_ff1;
        end
    end

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 0;
        end
        else if(data_en_ff2)begin
            dataout <= data_tmp;
        end
    end

endmodule
