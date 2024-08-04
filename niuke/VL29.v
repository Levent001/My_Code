//VL29 信号发生器
`timescale 1ns/1ns
// module signal_generator(
	// input clk,
	// input rst_n,
	// input [1:0] wave_choise,
	// output reg [4:0]wave
	// );

    // reg [4:0] cnt;
    // reg flag;
    
  	// 方波模式下，计数器控制
    // always@(posedge clk or negedge rst_n) begin
        // if(~rst_n)
            // cnt <= 0;
        // else
            // cnt <= wave_choise!=0 ? 0:
                   // cnt        ==19? 0:
                   // cnt + 1;
    // end
    
  	// 三角波模式下，标志位控制
    // always@(posedge clk or negedge rst_n) begin
        // if(~rst_n)
            // flag <= 0;
        // else
            // flag <= wave_choise!=2 ? 0:
                    // wave       ==1 ? 1:
                    // wave       ==19? 0:
                    // flag;
    // end
    
  
  	// 更新wave信号
    // always@(posedge clk or negedge rst_n) begin
        // if(~rst_n) 
            // wave <= 0;
        // else 
            // case(wave_choise)
                // 0      : wave <= cnt == 9? 20    : 
                                 // cnt ==19? 0     :
                                 // wave;
                // 1      : wave <= wave==20? 0     : wave+1;
                // 2      : wave <= flag==0 ? wave-1: wave+1;
                // default: wave <= 0;
            // endcase
    // end
// endmodule


`timescale 1ns/1ns
module signal_generator(
	input clk,
	input rst_n,
	input [1:0] wave_choise,
	output reg [4:0]wave
	);

    reg [4:0] cnt;
    reg up;
    
    always @ (posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cnt <= 'b0;
            wave <= 'b0;
            up <= 'b0;
        end
        else begin
            case(wave_choise)
                'd0: begin
                    if(cnt=='d19)begin
                        wave <= 'b0;
                        cnt  <= 'b0;
                    end
                    else if(cnt=='d9)begin
                        wave <= 'd20;
                        cnt  <= cnt+1;
                    end
                    else begin
                        wave <= wave;
                        cnt  <= cnt+1;
                    end
                end
                'd1: begin
                    if(wave=='d20)begin
                        wave <= 'd0;
                    end
                    else begin
                        wave <= wave+1;
                    end
                end                
                'd2: begin
                    if(up)begin
                        if(wave=='d20)begin
                            up <= 0;
                            wave <= wave-1;
                        end
                        else if(wave<'d20)begin
                            wave <= wave+1;
                            up <= up;
                        end
                    end
                    else begin
                        if(wave=='d0)begin
                            up <= 1;
                            wave <= wave+1;
                        end
                        else if(wave>'d0)begin
                            wave <= wave-1;
                            up <= up;
                        end
                    end
                end
                default: begin
                    wave <= 'b0;
                end
            endcase
        end
    end
    
    
    
endmodule