//VL32 非整数倍数据位宽转换24to128
`timescale 1ns/1ns

module width_24to128(
	input 				clk 		,   
	input 				rst_n		,
	input				valid_in	,
	input	[23:0]		data_in		,
 
 	output	reg			valid_out	,
	output  reg [127:0]	data_out
);

reg [127:0] data_tmp;
reg [3:0]   data_cnt;

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_cnt <= 0;
    end
    else begin
        data_cnt <= valid_in ? (data_cnt+1):data_cnt;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_tmp <= 0;
    end
    else begin
        data_tmp <= valid_in ? {data_tmp[103:0],data_in}:data_tmp;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        valid_out <= 0;
    end
    else begin
        valid_out <= (data_cnt==5 || data_cnt==10 || data_cnt==15)&&valid_in;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_out <= 'b0;
    end
    else if(data_cnt==5) begin
        data_out <= valid_in?{data_tmp[119:0],data_in[23:16]}:data_out;
    end
    else if(data_cnt==10) begin
        data_out <= valid_in?{data_tmp[111:0],data_in[23:8]}:data_out;
    end
    else if(data_cnt==15) begin
        data_out <= valid_in?{data_tmp[103:0],data_in[23:0]}:data_out;
    end
    else
        data_out <= data_out;
end

endmodule