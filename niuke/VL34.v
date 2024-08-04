//VL34 整数倍数据位宽转换8to16
`timescale 1ns/1ns

module width_8to16(
	input 				   clk 		,   
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,
 
 	output	reg			valid_out,
	output   reg [15:0]	data_out
);

reg [7:0] data_tmp;
reg cnt;

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt <= 0;
    end
    else if(valid_in) begin
        cnt <= cnt + 1;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_tmp <= 0;
    end
    else if(valid_in) begin
        data_tmp <= data_in;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_out <= 0;
        valid_out <= 0;
    end
    else if(valid_in && cnt ==1) begin
        data_out <= {data_tmp,data_in};
        valid_out <= 1;
    end
    else begin
        valid_out <= 0;
    end
end

endmodule