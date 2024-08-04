//VL28 输入序列不连续的序列检测
//方法一：状态机
// `timescale 1ns/1ns
// module sequence_detect(
	// input clk,
	// input rst_n,
	// input data,
	// input data_valid,
	// output reg match
	// );

// reg [4:0] curr_state; 
// reg [4:0] next_state;

// parameter IDLE = 5'b00001;
// parameter S0 = 5'b00010;
// parameter S1 = 5'b00100;
// parameter S2 = 5'b01000;
// parameter S3 = 5'b10000;

 // always @(posedge clk or negedge rst_n)begin
    // if(~rst_n)
        // curr_state <= IDLE;
    // else
        // curr_state <= next_state;
// end

// always @(*)begin
     // case(curr_state)
        // IDLE: begin
            // if(data_valid == 1'b1)
                // next_state = (data == 1'b0) ? S0 : IDLE;
             // else
                // next_state = IDLE;
        // end
        // S0: begin  
            // if(data_valid == 1'b1)
                // next_state = (data == 1'b1) ? S1 : S0;
            // else
                // next_state = S0;
        // end
        // S1: begin  
            // if(data_valid == 1'b1)
                // next_state = (data == 1'b1) ? S2 : S0;
            // else
                // next_state = S1;
        // end
        // S2: begin  
           // if(data_valid == 1'b1)
                // next_state = (data == 1'b0) ? S3 : IDLE;
            // else
                // next_state = S2;
        // end
        // S3: begin  
             // if(data_valid == 1'b1)
                // next_state = (data == 1'b0) ? S0 : IDLE;
             // else
                // next_state = IDLE;
        // end
        // default: 
            // next_state = IDLE;
     // endcase
// end

// always @(posedge clk or negedge rst_n)begin
    // if(~rst_n)
      // match <= 1'b0;
    // else  if(next_state == S3)
            // match <= 1'b1; 
       // else
         // match <= 1'b0;
// end

// endmodule


//方法二：移位寄存器+上升沿检测电路（寄存器保持目标结果可能是好几个周期）
// `timescale 1ns/1ns
// module sequence_detect(
	// input clk,
	// input rst_n,
	// input data,
	// input data_valid,
	// output match
	// );
    
    // parameter N = 4;
    

    // reg [N - 1 : 0] SR;
    // wire match_0;
    // reg match_r;
    

    // always@(posedge clk or negedge rst_n)begin
        // if(!rst_n) 
            // SR <= 'd0;
        // else if(data_valid) 
            // SR <= {SR[2 : 0], data};
    // end

    // assign match_0 = (SR == 4'b0110);
    // always@(posedge clk or negedge rst_n)begin
        // if(!rst_n) 
            // match_r <= 'd0;
        // else 
        // match_r <= match_0;
    // end
    // assign match = match_0 && !match_r;
// endmodule


//方法三：简易版本
`timescale 1ns/1ns
module sequence_detect(
	input clk,
	input rst_n,
	input data,
	input data_valid,
	output reg match
	);
    //parameter 
    parameter N = 4;
    
    //defination
    reg [N - 1 : 0] SR;
    
    //output
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) 
            SR <= 'd0;
        else if(data_valid) 
            SR <= {SR[2 : 0], data};
    end

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) 
            match <= 'd0;
        else if(data_valid && SR[2 : 0] == 3'b011 && !data) 
            match <= 1'b1; 
        else 
            match <= 1'b0;
    end
endmodule
