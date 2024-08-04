//VL31 数据累加输出
`timescale 1ns/1ns

module valid_ready(
	input 				clk 		,   
	input 				rst_n		,
	input		[7:0]	data_in		,
	input				valid_a		,
	input	 			ready_b		,
 
 	output		 		ready_a		,
 	output	reg			valid_b		,
	output  reg [9:0] 	data_out
);

reg    [1:0]       data_cnt;
 
assign ready_a = !valid_b | ready_b;

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_cnt <= 0;
    end
    else if(valid_a && ready_a) begin
        data_cnt <= (data_cnt=='d3) ? ('d0):(data_cnt+1);
    end
end

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        valid_b <= 0;
    end
    else if(data_cnt == 2'd3 && valid_a && ready_a)
        valid_b <= 1'd1;
    else if(valid_b && ready_b)
        valid_b <= 1'd0;
end

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_out <= 'b0;
    end
    else if(valid_a && ready_a && (data_cnt != 0)) begin
        data_out <= data_out + data_in;
    end
    else if(valid_a && ready_a && (data_cnt == 0))
        data_out <= data_in;    
end

endmodule