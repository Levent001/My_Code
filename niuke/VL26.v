//VL26 含有无关项的序列检测
`timescale 1ns/1ns
module sequence_detect(
	input clk,
	input rst_n,
	input a,
	output reg match
	);
    
// reg [8:0] a_tmp;

// always @ (posedge clk or negedge rst_n) begin
    // if(!rst_n) begin
        // a_tmp <= 0;
    // end
    // else begin
        // a_tmp <= {a_tmp[7:0],a};
    // end
// end

reg [9-1:0] a_sreg;       //shift reg

always @ (posedge clk) begin
    if(!rst_n) begin
        a_sreg <= 0;
    end
    else begin
        a_sreg <= a_sreg << 1 | a;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        match <= 0;
    end
    else begin
        casex(a_sreg)
            9'b0_11xx_x110: begin
                match <= 1'b1;
            end
            default: begin
                match <= 0;
            end
        endcase
    end
end  
endmodule