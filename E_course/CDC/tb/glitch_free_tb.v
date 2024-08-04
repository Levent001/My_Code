module glitch_free_tb ();

    reg       clk_in0;
    reg       clk_in1;
    reg       clk_in2;

    reg       clk_scan;
    reg       scan_dc_mode;
    reg       icg_scan_mode;
    reg       rst_clk_n;
    reg [1:0] cgm_sel;

    initial begin
        clk_in0       = 0;
        clk_in1       = 0;
        clk_in2       = 0;

        rst_clk_n     = 0;
        clk_scan      = 0;
        icg_scan_mode = 0;

        //bug:test mode is enable
        scan_dc_mode  = 1;
        //solution:test mode is disable
        //scan_dc_mode = 0;

        #200 rst_clk_n = 1;
        cgm_sel = 0;
        repeat (50) @(posedge clk_in2) cgm_sel = 1;

        repeat (50) @(posedge clk_in2);
        cgm_sel = 2;
        repeat (50) @(posedge clk_in2);
        icg_scan_mode = 1;
        scan_dc_mode  = 0;
        cgm_sel       = 0;
        repeat (1000) @(posedge clk_in0);

        icg_scan_mode = 0;
        scan_dc_mode  = 1;
        cgm_sel       = 2;
        repeat (1000) @(posedge clk_in0);
        $finish;  //finish the simulation
    end
    //dump the wave which is used for verd
    initial begin
        //$vcdpluson();//生成vpd文件
        $fsdbDumpfile("glitch_free_tb.fsdb");//生成波形文件
        $fsdbDumpvars;                       //导出内部变量
    end

    always #20 clk_in0 = ~clk_in0;
    always #70 clk_in1 = ~clk_in1;
    always #110 clk_in2 = ~clk_in2;
    always #1000 clk_scan = ~clk_scan;

    glitch_free u_glitch_free(
    	.clk_out       (clk_out       ),
        .cgm_sel       (cgm_sel       ),
        .clk_in0       (clk_in0       ),
        .clk_in1       (clk_in1       ),
        .clk_in2       (clk_in2       ),
        .rst_clk_n     (rst_clk_n     ),
        .icg_scan_mode (icg_scan_mode ),
        .scan_dc_mode  (scan_dc_mode  ),
        .clk_scan      (clk_scan      )
    );

endmodule  //glitch_free_tb
