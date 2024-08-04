`timescale 1ns/1ns
/**********************************RAM************************************/
module dual_port_RAM #(parameter DEPTH = 16,
					   parameter WIDTH = 8)(
	 input wclk
	,input wenc
	,input [$clog2(DEPTH)-1:0] waddr  //深度对2取对数，得到地址的位宽。
	,input [WIDTH-1:0] wdata      	//数据写入
	,input rclk
	,input renc
	,input [$clog2(DEPTH)-1:0] raddr  //深度对2取对数，得到地址的位宽。
	,output reg [WIDTH-1:0] rdata 		//数据输出
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

always @(posedge wclk) begin
	if(wenc)
		RAM_MEM[waddr] <= wdata;
end 

always @(posedge rclk) begin
	if(renc)
		rdata <= RAM_MEM[raddr];
end 

endmodule  

/**********************************SFIFO************************************/
module sfifo#(
	parameter	WIDTH = 8,
	parameter 	DEPTH = 16
)(
	input 					clk		, 
	input 					rst_n	,
	input 					winc	,
	input 			 		rinc	,
	input 		[WIDTH-1:0]	wdata	,

	output reg				wfull	,
	output reg				rempty	,
	output wire [WIDTH-1:0]	rdata
);

    dual_port_RAM 
    #(
        .DEPTH (DEPTH ),
        .WIDTH (WIDTH )
    )
    u_dual_port_RAM(
    	.wclk  (clk  ),
        .wenc  (winc  ),
        .waddr (w_addr[$clog2(DEPTH)-1 : 0] ),
        .wdata (wdata ),
        .rclk  (clk  ),
        .renc  (rinc  ),
        .raddr (r_addr[$clog2(DEPTH)-1 : 0] ),
        .rdata (rdata )
    );
    
    reg [$clog2(DEPTH):0] w_addr;
    reg [$clog2(DEPTH):0] r_addr;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            w_addr <= 0;
        end
		else if(winc && (!wfull))begin
			w_addr <= w_addr + 1'b1;
		end
        else begin
            w_addr <= w_addr;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            r_addr <= 0;
        end
		else if(rinc && (!rempty))begin
			r_addr <= r_addr + 1'b1;
		end
        else begin
            r_addr <= r_addr;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            wfull <= 0;
            rempty <= 0;
        end  
        else begin
            wfull <= ({~w_addr[$clog2(DEPTH)],w_addr[$clog2(DEPTH)-1 : 0]} == r_addr) ? 1'b1 : 1'b0;
            rempty <= (w_addr == r_addr) ? 1'b1 : 1'b0;            
        end      
    end

endmodule