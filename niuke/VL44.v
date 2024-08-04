//VL44 根据状态转移写状态机-二段式
// `timescale 1ns/1ns

// module fsm2(
	// input wire clk  ,
	// input wire rst  ,
	// input wire data ,
	// output reg flag
// );

////*************code***********//
// parameter s0 = 5'b00001;
// parameter s1 = 5'b00010;
// parameter s2 = 5'b00100;
// parameter s3 = 5'b01000;
// parameter s4 = 5'b10000;

// reg [4:0] state;

// always @ (posedge clk or negedge rst) begin
    // if(!rst) begin
        // state <= s0;
    // end
    // else begin
        // case(state)
            // s0: state <= data ? s1:s0;
            // s1: state <= data ? s2:s1;
            // s2: state <= data ? s3:s2;
            // s3: state <= data ? s4:s3;
            // s4: state <= data ? s1:s0;
        // endcase
    // end
// end

// always @ (posedge clk or negedge rst) begin
    // if(!rst) begin
        // flag <= 0;
    // end
    // else if(state==s3 && data) begin //此处注意，如果是写state==s4会慢一拍
        // flag <= 1;
    // end
    // else
        // flag <= 0;
// end

////*************code***********//
// endmodule

module fsm2(
	input wire clk  ,
	input wire rst  ,
	input wire data ,
	output reg flag
);

//*************code***********//
parameter s0 = 5'b00001;
parameter s1 = 5'b00010;
parameter s2 = 5'b00100;
parameter s3 = 5'b01000;
parameter s4 = 5'b10000;

reg [4:0] current_state;
reg [4:0] next_state;

always @ (posedge clk or negedge rst) begin
    if(!rst) begin
        current_state <= s0;
    end
    else begin
        current_state <= next_state;
    end
end

always @ (*) begin
    case(current_state)
        s0: begin
            next_state <= data ? s1:s0;
            flag <=0;
        end
        s1: begin
            next_state <= data ? s2:s1;
            flag <=0;
        end
        s2: begin
            next_state <= data ? s3:s2;
            flag <=0;
        end
        s3: begin
            next_state <= data ? s4:s3;
            flag <=0;
        end
        s4: begin
            next_state <= data ? s1:s0;
            flag <=1;
        end
        default:begin
            next_state <= s0;
            flag <=0;
        end
    endcase
end
//*************code***********//
endmodule