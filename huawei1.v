module dual_ram #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
) (
    input  wclk,
    input  wenc,
    input  [$clog2(DEPTH)-1 : 0] waddr,
    input  [WIDTH-1 : 0]    wdata,
    input   rclk,
    input   renc,
    input   [$clog2(DEPTH)-1 : 0] raddr,
    output  reg [WIDTH-1 : 0]    rdata
);
    reg [WIDTH-1 : 0]   RAM_MEM[0:DEPTH-1];

    always @(posedge wclk) begin
        if(wenc) RAM_MEM[waddr] <= wdata;
    end

    always @(posedge wclk) begin
        if(renc)  rdata <= RAM_MEM[raddr];
    end
endmodule

module afifo #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
) (
    input  wclk,
    input  rclk,
    input  wrstn,
    input  rrstn,
    input  winc,
    input  rinc,
    input [WIDTH-1 : 0] wdata,

    output wire wfull,
    output wire rempty,
    output wire [WIDTH-1 :0] rdata
);

localparam ADDR_WIDTH = $clog2(DEPTH);

reg [ADDR_WIDTH:0] waddr_bin;
reg [ADDR_WIDTH:0] raddr_bin;


always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
       waddr_bin <= 0;
    end else if(!wfull && winc) begin
        waddr_bin <= waddr_bin + 1;
    end 
end

//bin to gray
wire [ADDR_WIDTH:0] waddr_gray;
wire [ADDR_WIDTH:0] raddr_gray;
reg  [ADDR_WIDTH:0] wptr;
reg  [ADDR_WIDTH:0] rptr;

assign waddr_gray = waddr_bin ^ (waddr_bin >> 1);
assign raddr_gray = raddr_bin ^ (raddr_bin >> 1);

always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wptr <= 0;
    end else begin
        wptr <= waddr_gray;
    end
end

reg [ADDR_WIDTH:0] wptr_buff;
reg [ADDR_WIDTH:0] rptr_buff;
reg [ADDR_WIDTH:0] rptr_syn;
reg [ADDR_WIDTH:0] wptr_syn;

always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        rptr_buff <= 0;
        rptr_syn <= 0;
    end else begin
        rptr_buff <= rptr;
        rptr_syn <= rptr_buff;
    end
end

assign wfull = (wptr == {~rptr_syn[ADDR_WIDTH:ADDR_WIDTH-1], rptr_syn[ADDR_WIDTH-2 : 0]});
assign rempty = (rptr == wptr_syn);

wire wen;
wire ren;
assign wen = winc & !wfull;
assign ren = rinc & !rempty;

dual_ram #(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH)
) u_dual_ram(
    .wclk (wclk),
    .wenc (wen),
    .waddr (waddr_bin[ADDR_WIDTH-1:0]),
    .wdata(wdata),
    .rclk (rclk),
    .renc (ren),
    .raddr(raddr_bin[ADDR_WIDTH-1:0]),
    .rdata(rdata)

);


endmodule