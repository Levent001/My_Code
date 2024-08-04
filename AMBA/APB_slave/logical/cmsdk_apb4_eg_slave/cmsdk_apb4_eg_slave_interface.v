module cmsdk_apb4_eg_slave_interface #(
    parameter ADDRWIDTH = 12
) (
    //IO declaration
    input wire pclk,
    input wire presetn,

    // apb interface inputs
    input wire                 psel,
    input wire [ADDRWIDTH-1:0] paddr,
    input wire                 penable,
    input wire                 pwrite,
    input wire [         31:0] pwdata,
    input wire [          3:0] pstrb,

    // apb interface outputs
    output wire [31:0] prdata,
    output wire        pready,
    output wire        pslverr,

    //Register interface
    output wire [ADDRWIDTH-1:0] addr,
    output wire                 read_en,
    output wire                 write_en,
    output wire [          3:0] byte_strobe,
    output wire [         31:0] wdata,
    input  wire [         31:0] rdata
);
    //-----------------------------------------------------------------
    // module logic start
    //-----------------------------------------------------------------

    // APB interface
    assign pready      = 1'b1;  //always ready
    assign pslverr     = 1'b0;  //always OKAY

    //register read and write signal
    assign addr        = paddr;
    assign read_en     = psel & (~pwrite);
    assign write_en    = psel & (~penable) & pwrite;

    assign byte_strobe = pstrb;
    assign wdata       = pwdata;
    assign prdata      = rdata;

`ifdef ARM_APB_ASSERT_ON
    `include "std_ovl_defines.h"
    //-----------------------------------------------------------------
    // Assertions
    //-----------------------------------------------------------------

    // check error response should not be generated if not selected
    assert_never #(`OVL_ERROR, `OVL_ASSERT, "Error ! Should not generate error response if not selected") u_ovl_apb4_eg_slave_response_illegal (
        .clk      (pclk),
        .reset_n  (presetn),
        .test_expr(pslverr & pready & (~psel))
    );
`endif
endmodule  //cmsdk_apb4_eg_slave_interface
