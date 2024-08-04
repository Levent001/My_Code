// `timescale 1ns/1ns
 
// module JC_counter(
//    input                clk ,
//    input                rst_n,
  
//    output reg [3:0]     Q 
// );
//     always@(posedge clk or negedge rst_n)begin
//         if(!rst_n) Q <= 'd0;
//         else Q <= {~Q[0], Q[3 : 1]};
//     end
// endmodule

`timescale 1ns/1ns

module JC_counter(
   input                clk ,
   input                rst_n,
 
   output reg [3:0]     Q  
);
    localparam s0 = 8'b0000_0001;
    localparam s1 = 8'b0000_0010;
    localparam s2 = 8'b0000_0100;
    localparam s3 = 8'b0000_1000;
    localparam s4 = 8'b0001_0000;
    localparam s5 = 8'b0010_0000;
    localparam s6 = 8'b0100_0000;
    localparam s7 = 8'b1000_0000;

    reg [7:0] current_state;
    reg [7:0] next_state;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            current_state <= s0;
            next_state <= s0;
        end
        else begin
            current_state <= next_state;
        end
    end

  always @(*) begin
    if (!rst_n) begin
        Q <= 0;
    end
    else begin
        case (current_state)
            s0: begin Q <= 4'b0000; next_state <= s1; end
            s1: begin Q <= 4'b1000; next_state <= s2; end
            s2: begin Q <= 4'b1100; next_state <= s3; end
            s3: begin Q <= 4'b1110; next_state <= s4; end
            s4: begin Q <= 4'b1111; next_state <= s5; end
            s5: begin Q <= 4'b0111; next_state <= s6; end
            s6: begin Q <= 4'b0011; next_state <= s7; end
            s7: begin Q <= 4'b0001; next_state <= s0; end
       default: begin Q <= 4'b0000; next_state <= s0; end
        endcase
    end
  end

endmodule