//VL30 数据串转并电路
`timescale 1ns/1ns

module s_to_p(
	input 				clk 		,   
	input 				rst_n		,
	input				valid_a		,
	input	 			data_a		,
 
 	output	reg 		ready_a		,
 	output	reg			valid_b		,
	output  reg [5:0] 	data_b
);

reg [5:0] data_a_tmp;
reg [2:0] cnt;

always @(posedge clk or negedge rst_n ) begin
    if(!rst_n) 
        ready_a <= 'd0;
    else 
        ready_a <= 1'd1;
end

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt <= 0;
    end
    else if (valid_a && ready_a && cnt == 5)begin
        cnt <= 0;
    end
    else if (valid_a && ready_a && cnt < 5) begin
        cnt <= cnt+1;
    end
    else
        cnt <= cnt;
end


always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_a_tmp <= 0;
    end
    else if(valid_a) begin
        data_a_tmp <= {data_a,data_a_tmp[5:1]};
    end
end

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        valid_b <= 0;
        data_b <= 0;
    end
    else if(valid_a && ready_a && cnt==5) begin
        valid_b <= 1'd1;
        data_b <= {data_a, data_a_tmp[5:1]};
    end
    else if(!valid_a && ready_a && cnt==5) begin
        valid_b <= 1'd1;
        data_b <= data_a_tmp;
    end
    else
        valid_b <= 0;
end




endmodule