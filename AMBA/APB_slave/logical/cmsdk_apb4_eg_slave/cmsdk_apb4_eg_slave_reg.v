module cmsdk_apb4_eg_slave_reg #(
    parameter ADDRWIDTH = 12
) (
    //IO declaration
    input wire pclk,
    input wire presetn,

    input  wire [ADDRWIDTH-1:0] addr,
    input  wire                 read_en,
    input  wire                 write_en,
    input  wire [          3:0] byte_strobe,
    input  wire [         31:0] wdata,
    input  wire [          3:0] ecorevnum,
    output reg  [         31:0] rdata
);

    localparam ARM_CMSDK_APB4_EG_SLAVE_PID4 = 32'h0000_0004;  //0xFD0 1111_1101_0000
    localparam ARM_CMSDK_APB4_EG_SLAVE_PID5 = 32'h0000_0000;  //0xFD4 1111_1101_0100
    localparam ARM_CMSDK_APB4_EG_SLAVE_PID6 = 32'h0000_0000;  //0xFD8 1111_1101_1000
    localparam ARM_CMSDK_APB4_EG_SLAVE_PID7 = 32'h0000_0000;  //0xFDC 1111_1101_1100
    localparam ARM_CMSDK_APB4_EG_SLAVE_PID0 = 32'h0000_0019;  //0xFE0 1111_1110_0000
    localparam ARM_CMSDK_APB4_EG_SLAVE_PID1 = 32'h0000_00B8;  //0xFE4 1111_1110_0100
    localparam ARM_CMSDK_APB4_EG_SLAVE_PID2 = 32'h0000_001B;  //0xFE8 1111_1110_1000
    localparam ARM_CMSDK_APB4_EG_SLAVE_PID3 = 32'h0000_0000;  //0xFEC 1111_1110_1100
    localparam ARM_CMSDK_APB4_EG_SLAVE_CID0 = 32'h0000_000D;  //0xFF0 1111_1111_0000
    localparam ARM_CMSDK_APB4_EG_SLAVE_CID1 = 32'h0000_00F0;  //0xFF4 1111_1111_0100
    localparam ARM_CMSDK_APB4_EG_SLAVE_CID2 = 32'h0000_0005;  //0xFF8 1111_1111_1000
    localparam ARM_CMSDK_APB4_EG_SLAVE_CID3 = 32'h0000_00B1;  //0xFFC 1111_1111_1100

    //-----------------------------------------------------------------
    // internal wires
    //-----------------------------------------------------------------

    reg  [31:0] data0;  //0x000 0000_0000_0000
    reg  [31:0] data1;  //0x004 0000_0000_0100
    reg  [31:0] data2;  //0x008 0000_0000_1000
    reg  [31:0] data3;  //0x00C 0000_0000_1100
    wire [ 3:0] wr_sel;

    //-----------------------------------------------------------------
    // module logic start
    //-----------------------------------------------------------------
    // Address decoding for write operations
    assign wr_sel[0] = ((addr[(ADDRWIDTH-1):2] == 10'b00_0000_0000) & (write_en)) ? 1'b1 : 1'b0;
    assign wr_sel[1] = ((addr[(ADDRWIDTH-1):2] == 10'b00_0000_0001) & (write_en)) ? 1'b1 : 1'b0;
    assign wr_sel[2] = ((addr[(ADDRWIDTH-1):2] == 10'b00_0000_0010) & (write_en)) ? 1'b1 : 1'b0;
    assign wr_sel[3] = ((addr[(ADDRWIDTH-1):2] == 10'b00_0000_0011) & (write_en)) ? 1'b1 : 1'b0;

    // register write, byte enable

    // Data register:data0
    always @(posedge pclk or negedge presetn) begin
        if (~presetn) begin
            data0 <= {32{1'b0}};
        end else if (wr_sel[0]) begin
            if (byte_strobe[0]) data0[7:0] <= wdata[7:0];
            if (byte_strobe[1]) data0[15:8] <= wdata[15:8];
            if (byte_strobe[2]) data0[23:16] <= wdata[23:16];
            if (byte_strobe[3]) data0[31:24] <= wdata[31:24];
        end
    end

    // Data register:data1
    always @(posedge pclk or negedge presetn) begin
        if (~presetn) begin
            data1 <= {32{1'b0}};
        end else if (wr_sel[1]) begin
            if (byte_strobe[0]) data1[7:0] <= wdata[7:0];
            if (byte_strobe[1]) data1[15:8] <= wdata[15:8];
            if (byte_strobe[2]) data1[23:16] <= wdata[23:16];
            if (byte_strobe[3]) data1[31:24] <= wdata[31:24];
        end
    end

    // Data register:data2
    always @(posedge pclk or negedge presetn) begin
        if (~presetn) begin
            data2 <= {32{1'b0}};
        end else if (wr_sel[2]) begin
            if (byte_strobe[0]) data2[7:0] <= wdata[7:0];
            if (byte_strobe[1]) data2[15:8] <= wdata[15:8];
            if (byte_strobe[2]) data2[23:16] <= wdata[23:16];
            if (byte_strobe[3]) data2[31:24] <= wdata[31:24];
        end
    end

    // Data register:data3
    always @(posedge pclk or negedge presetn) begin
        if (~presetn) begin
            data3 <= {32{1'b0}};
        end else if (wr_sel[3]) begin
            if (byte_strobe[0]) data3[7:0] <= wdata[7:0];
            if (byte_strobe[1]) data3[15:8] <= wdata[15:8];
            if (byte_strobe[2]) data3[23:16] <= wdata[23:16];
            if (byte_strobe[3]) data3[31:24] <= wdata[31:24];
        end
    end

    // register read
    always @(read_en or addr or data0 or data1 or data2 or data3 or ecorevnum) begin
        case (read_en)
            1'b1: begin
                if (addr[11:4] == 8'h00) begin
                    case (addr[3:2])
                        2'b00:   rdata = data0;
                        2'b01:   rdata = data1;
                        2'b10:   rdata = data2;
                        2'b11:   rdata = data3;
                        default: rdata = {32{1'bx}};
                    endcase
                end else if (addr[11:6] == 6'h3F) begin
                    case (addr[5:2])
                        4'b0100: rdata = ARM_CMSDK_APB4_EG_SLAVE_PID4;  //0xFD0
                        4'b0101: rdata = ARM_CMSDK_APB4_EG_SLAVE_PID5;  //0xFD4
                        4'b0110: rdata = ARM_CMSDK_APB4_EG_SLAVE_PID6;  //0xFD8
                        4'b0111: rdata = ARM_CMSDK_APB4_EG_SLAVE_PID7;  //0xFDC
                        4'b1000: rdata = ARM_CMSDK_APB4_EG_SLAVE_PID0;  //0xFE0
                        4'b1001: rdata = ARM_CMSDK_APB4_EG_SLAVE_PID1;  //0xFE4
                        4'b1010: rdata = ARM_CMSDK_APB4_EG_SLAVE_PID2;  //0xFE8
                        4'b1011: rdata = {ARM_CMSDK_APB4_EG_SLAVE_PID3[31:8], ecorevnum[3:0], 4'h0};  //0xFEC

                        4'b1100: rdata = ARM_CMSDK_APB4_EG_SLAVE_CID0;
                        4'b1101: rdata = ARM_CMSDK_APB4_EG_SLAVE_CID1;
                        4'b1110: rdata = ARM_CMSDK_APB4_EG_SLAVE_CID2;
                        4'b1111: rdata = ARM_CMSDK_APB4_EG_SLAVE_CID3;
                        4'b0000, 4'b0001, 4'b0010, 4'b0011: rdata = {32'h00000000};
                        default: rdata = {32{1'bx}};
                    endcase
                end else begin
                    rdata = {32'h00000000};
                end
            end
            1'b0: begin
                rdata = {32'h00000000};
            end
            default: begin
                rdata = {32{1'bx}};
            end
        endcase
    end
    //-----------------------------------------------------------------
    // module logic end
    //-----------------------------------------------------------------
endmodule  //cmsdk_apb4_eg_slave_reg
