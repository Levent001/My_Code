//VL33 非整数倍数据位宽转换8to12
`timescale 1ns/1ns

module width_8to12(
	input 				   clk 		,   
	input 			      rst_n		,
	input				      valid_in	,
	input	[7:0]			   data_in	,
 
 	output  reg			   valid_out,
	output  reg [11:0]   data_out
);

reg [7:0] data_tmp;
reg [1:0]  cnt;

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt <= 2'b0;
    end
    else if(valid_in) begin
        if(cnt == 2) begin
            cnt <= 0;
        end
        else begin
            cnt <= cnt + 1;
        end
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
    end
    else if(valid_in) begin
        if(cnt == 1) begin
            data_out <= {data_tmp,data_in[7:4]};
        end
        else if(cnt == 2)begin
            data_out <= {data_tmp[3:0],data_in};
        end
    end
end

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        valid_out <= 0;
    end
    else if(valid_in && (cnt == 1 || cnt == 2)) begin
        valid_out <= 1;
    end
    else begin
        valid_out <= 0;
    end
end
endmodule