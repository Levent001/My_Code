
module sramc_top (
    //input signals
    hclk,
    sram_clk,
    hresetn,
    hsel,
    hwrite,
    hready,
    hsize,
    htrans,
    hburst,
    hwdata,
    haddr,

    dft_en,
    bist_en,

    //output signals
    hready_resp,
    hresp,
    hrdata,

    bist_done,
    bist_fail
);

    //*********************//
    // list of AHB signals //
    //*********************//
    //Signals used during normal operation
    input hclk;
    input sram_clk;
    input hresetn;

    //---------------------------------------------------
    //Signals from AMBA bus used during normal operation
    //---------------------------------------------------
    input hsel;
    input hwrite;
    input hready;
    input [2:0] hsize;
    input [2:0] hburst;
    input [1:0] htrans;
    input [31:0] hwdata;
    input [31:0] haddr;

    //--------------------------------------------------
    //Signals to AMBA bus used during normal operation
    //--------------------------------------------------
    output hready_resp;
    output [1:0] hresp;
    output [31:0] hrdata;

    //-------------------------------------------------
    //Signals for BIST and DFT test mode 
    //-------------------------------------------------
    //When signal"dft_en" or "bist_en" is high, sram
    //controller enters into test mode. 
    input dft_en;
    input bist_en;

    //When "bist_done" is high, it shows BIST test is over.
    output bist_done;

    //"bist_fail" shows the results of each sram funtions.
    //There are 8 srams in this controller.
    output [7:0] bist_fail;

    //Select one of the two sram blocks according to the value of sram_csn
    wire [ 3:0] bank0_csn;
    wire [ 3:0] bank1_csn;

    //Sram read or write signals: When it is high, read sram; low, write
    //sram.
    wire        sram_w_en;

    //Each of 8 srams is 8kx8, the depth is 2^13, so the sram's address width
    //is 13 bits. 
    wire [12:0] sram_addr;

    //AHB bus data write into srams
    wire [31:0] sram_wdata;

    //--------------------------------------------------------------
    //sram data output data which selected and read by AHB bus
    //--------------------------------------------------------------
    wire [ 7:0] sram_q0;
    wire [ 7:0] sram_q1;
    wire [ 7:0] sram_q2;
    wire [ 7:0] sram_q3;
    wire [ 7:0] sram_q4;
    wire [ 7:0] sram_q5;
    wire [ 7:0] sram_q6;
    wire [ 7:0] sram_q7;


    //*************************************//
    // Instance the two modules:           //
    // ahb_slave_if.v and sram_core.v      //
    //*************************************//

    ahb_slave_if U_ahb_slave_if (
        //-----------------------------------------
        // AHB input signals into sram controller
        //-----------------------------------------
        .hclk   (hclk),
        .hresetn(hresetn),
        .hsel   (hsel),
        .hwrite (hwrite),
        .hready (hready),
        .hsize  (hsize),
        .htrans (htrans),
        .hburst (hburst),
        .hwdata (hwdata),
        .haddr  (haddr),

        //-----------------------------------------
        //8 sram blcoks data output into ahb slave
        //interface
        //-----------------------------------------
        .sram_q0(sram_q0),
        .sram_q1(sram_q1),
        .sram_q2(sram_q2),
        .sram_q3(sram_q3),
        .sram_q4(sram_q4),
        .sram_q5(sram_q5),
        .sram_q6(sram_q6),
        .sram_q7(sram_q7),

        //---------------------------------------------
        //AHB slave(sram controller) output signals 
        //---------------------------------------------
        .hready_resp(hready_resp),
        .hresp      (hresp),
        .hrdata     (hrdata),

        //---------------------------------------------
        //sram control signals and sram address  
        //---------------------------------------------
        .sram_w_en    (sram_w_en),
        .sram_addr_out(sram_addr),
        //data write into sram
        .sram_wdata   (sram_wdata),
        //choose the corresponding sram in a bank, active low
        .bank0_csn    (bank0_csn),
        .bank1_csn    (bank1_csn)
    );


    sram_core U_sram_core (
        //AHB bus signals
        .hclk    (hclk),
        .sram_clk(sram_clk),
        .hresetn (hresetn),

        //-------------------------------------------
        //sram control singals from ahb_slave_if.v
        //-------------------------------------------
        .sram_addr    (sram_addr),
        .sram_wdata_in(sram_wdata),
        .sram_wen     (sram_w_en),
        .bank0_csn    (bank0_csn),
        .bank1_csn    (bank1_csn),

        //test mode enable signals
        .bist_en(bist_en),
        .dft_en (dft_en),

        //-------------------------------------------
        //8 srams data output into AHB bus
        //-------------------------------------------
        .sram_q0(sram_q0),
        .sram_q1(sram_q1),
        .sram_q2(sram_q2),
        .sram_q3(sram_q3),
        .sram_q4(sram_q4),
        .sram_q5(sram_q5),
        .sram_q6(sram_q6),
        .sram_q7(sram_q7),

        //test results output when in test mode
        .bist_done(bist_done),
        .bist_fail(bist_fail)
    );

endmodule
