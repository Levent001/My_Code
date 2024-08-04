module cmsdk_apb4_eg_slave #(
    parameter ADDRWIDTH = 12
) (
    //IO declaration
    input wire PCLK,
    input wire PRESETn,

    //apb interface inputs
    input wire                 PSEL,
    input wire [ADDRWIDTH-1:0] PADDR,
    input wire                 PENABLE,
    input wire                 PWRITE,
    input wire [         31:0] PWDATA,
    input wire [          3:0] PSTRB,

    input wire [3:0] ECOREVNUM,

    //apb interface outputs
    output wire [31:0] PRDATA,
    output wire        PREADY,
    output wire        PSLVERR
);

    //-----------------------------------------------------------------
    // internal wires
    //-----------------------------------------------------------------
    //Register module interface signals
    wire [ADDRWIDTH-1:0] reg_addr;
    wire                 reg_read_en;
    wire                 reg_write_en;
    wire [          3:0] reg_byte_strobe;
    wire [         31:0] reg_wdata;
    wire [         31:0] reg_rdata;

    //-----------------------------------------------------------------
    // module logic start
    //-----------------------------------------------------------------
    // Interface to convert APB signals to simple read and write controls
    cmsdk_apb4_eg_slave_interface #(
        .ADDRWIDTH(ADDRWIDTH)
    ) u_cmsdk_apb4_eg_slave_interface (
        .pclk   (PCLK),
        .presetn(PRESETn),

        .psel   (PSEL),     // apb interface inputs
        .paddr  (PADDR),
        .penable(PENABLE),
        .pwrite (PWRITE),
        .pwdata (PWDATA),
        .pstrb  (PSTRB),

        .prdata (PRDATA),  // apb interface outputs
        .pready (PREADY),
        .pslverr(PSLVERR),

        // Register interface
        .addr       (reg_addr),
        .read_en    (reg_read_en),
        .write_en   (reg_write_en),
        .byte_strobe(reg_byte_strobe),
        .wdata      (reg_wdata),
        .rdata      (reg_rdata)
    );

    cmsdk_apb4_eg_slave_reg #(
        .ADDRWIDTH(ADDRWIDTH)
    ) u_cmsdk_apb4_eg_slave_reg (
        .pclk   (PCLK),
        .presetn(PRESETn),

        // Register interface
        .addr       (reg_addr),
        .read_en    (reg_read_en),
        .write_en   (reg_write_en),
        .byte_strobe(reg_byte_strobe),
        .wdata      (reg_wdata),
        .ecorevnum  (ECOREVNUM),
        .rdata      (reg_rdata)
    );
    //-----------------------------------------------------------------
    // module logic end
    //-----------------------------------------------------------------

`ifdef ARM_APB_ASSERT_ON
    `include "std_ovl_defines.h"
    //-----------------------------------------------------------------
    // Assertions
    //-----------------------------------------------------------------

    // check the reg_write_en signal generated
    assert_implication #(`OVL_ERROR, `OVL_ASSERT, "Error ! register write signal was not generated!") u_ovl_apb4_eg_slave_reg_write (
        //OVL_ERROR是严重级别，当该事件发生时，报error
        //OVL_ASSERT 类型是OVL断言
        //报错信息
        .clk      (PCLK),
        .reset_n  (PRESETn),
        .antecedent_expr((PSEL & (~PENABLE) & PWRITE)),
        .consequent_expr(reg_write_en == 1'b1)
    );

    assert_implication #(`OVL_ERROR, `OVL_ASSERT, "Error ! register read signal was not generated!") u_ovl_apb4_eg_slave_reg_read (
        .clk      (PCLK),
        .reset_n  (PRESETn),
        .antecedent_expr((PSEL & (~PENABLE) & (~PWRITE))),
        .consequent_expr(reg_read_en == 1'b1)
    );

    assert_never #(`OVL_ERROR, `OVL_ASSERT, "Error ! register read and write active at the same cycle!") u_cmsdk_apb4_eg_slave_rd_wr_illegal(
        .clk      (PCLK),
        .reset_n  (PRESETn),
        .test_expr((reg_write_en & reg_read_en));
`endif
endmodule  //cmsdk_apb4_eg_slave
