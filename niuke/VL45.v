//VL45 异步FIFO
`timescale 1ns / 1ns

/***************************************RAM*****************************************/
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
) (
    input                          wclk,
    input                          wenc,
    input      [$clog2(DEPTH)-1:0] waddr,  //深度对2取对数，得到地址的位宽。
    input      [        WIDTH-1:0] wdata,  //数据写入
    input                          rclk,
    input                          renc,
    input      [$clog2(DEPTH)-1:0] raddr,  //深度对2取对数，得到地址的位宽。
    output reg [        WIDTH-1:0] rdata   //数据输出
);

    reg [WIDTH-1:0] RAM_MEM[0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc) RAM_MEM[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc) rdata <= RAM_MEM[raddr];
    end

endmodule

/***************************************AFIFO*****************************************/
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input             wclk,
    input             rclk,
    input             wrstn,
    input             rrstn,
    input             winc,
    input             rinc,
    input [WIDTH-1:0] wdata,

    output wire             wfull,
    output wire             rempty,
    output wire [WIDTH-1:0] rdata
);
	wire [$clog2(DEPTH):0] waddr;
	wire [$clog2(DEPTH):0] raddr;
	dual_port_RAM 
	#(
		.DEPTH (DEPTH ),
		.WIDTH (WIDTH )
	)
	u_dual_port_RAM(
		.wclk  (wclk  ),
		.wenc  (winc  ),
		.waddr (w_addr[$clog2(DEPTH)-1:0] ),
		.wdata (wdata ),
		.rclk  (rclk  ),
		.renc  (rinc  ),
		.raddr (r_addr[$clog2(DEPTH)-1:0] ),
		.rdata (rdata )
	);
	
/***************************************Write_control*****************************************/
	reg [$clog2(DEPTH):0] w_addr;
	always @(posedge wclk or negedge wrstn) begin
		if(!wrstn)begin
			w_addr <= 0;
		end
		else if(winc && (!wfull))begin
			w_addr <= w_addr + 1'b1;
		end
		else begin
			w_addr <= w_addr;
		end
	end
/***************************************Bin_to_gray1*****************************************/
	reg [$clog2(DEPTH)-1:0] w_addr_tmp;
	wire [$clog2(DEPTH):0] w_addr_gray;
	reg [$clog2(DEPTH):0] w_addr_gray_ff1;

	integer i;
	always @(*) begin
		for (i = 0; i< $clog2(DEPTH);i = i + 1) begin
			w_addr_tmp[i] = w_addr[i] ^ w_addr[i+1];
		end
	end
	always @(posedge wclk or negedge wrstn) begin//按理来说不用打这一拍的
		if(!wrstn)begin
			w_addr_gray_ff1 <= 0;
		end
		else begin
			w_addr_gray_ff1 <= w_addr_gray;
		end		
	end
	assign w_addr_gray = {w_addr[$clog2(DEPTH)],w_addr_tmp};
/***************************************write_to_read_syn*****************************************/
	reg [$clog2(DEPTH):0] w_addr_ff1;
	reg [$clog2(DEPTH):0] w_addr_in_read;
	always @(posedge rclk or negedge wrstn) begin
		if(!wrstn)begin
			w_addr_ff1 <= 0;
			w_addr_in_read <= 0;
		end
		else begin
			w_addr_ff1 <= w_addr_gray_ff1;
			w_addr_in_read <= w_addr_ff1;
		end
	end
/***************************************Read_control*****************************************/
	reg [$clog2(DEPTH):0] r_addr;
	always @(posedge rclk or negedge rrstn) begin
		if(!rrstn)begin
			r_addr <= 0;
		end
		else if(rinc && (!rempty))begin
			r_addr <= r_addr + 1;
		end
		else begin
			r_addr <= r_addr;
		end
	end
/***************************************Bin_to_gray2*****************************************/
	reg [$clog2(DEPTH)-1:0] r_addr_tmp;
	wire [$clog2(DEPTH):0] r_addr_gray;
	reg [$clog2(DEPTH):0] r_addr_gray_ff1;
	always @(*) begin
		for (i = 0; i< $clog2(DEPTH);i = i + 1) begin
			r_addr_tmp[i] = r_addr[i] ^ r_addr[i+1];
		end
	end
	always @(posedge rclk or negedge rrstn) begin
		if(!rrstn)begin
			r_addr_gray_ff1 <= 0;
		end
		else begin
			r_addr_gray_ff1 <= r_addr_gray_ff1;
		end
	end	
	assign r_addr_gray = {r_addr[$clog2(DEPTH)],r_addr_tmp};
/***************************************read_to_write_syn*****************************************/
	reg [$clog2(DEPTH):0] r_addr_ff1;
	reg [$clog2(DEPTH):0] r_addr_in_write;
	always @(posedge wclk or negedge rrstn) begin
		if(!rrstn)begin
			r_addr_ff1 <= 0;
			r_addr_in_write <= 0;
		end		
		else begin
			r_addr_ff1 <= r_addr_gray;
			r_addr_in_write <= r_addr_ff1;
		end
	end
///////////////////////////////////////////////////////////////////////////////////
	assign rempty = (w_addr_in_read == r_addr) ? 1'b1 : 1'b0;
	assign wfull = ({~w_addr_gray[$clog2(DEPTH)],~w_addr_gray[$clog2(DEPTH)-1],w_addr_gray[$clog2(DEPTH)-2:0]} 
						== r_addr_in_write) ? 1'b1 : 1'b0;
endmodule
