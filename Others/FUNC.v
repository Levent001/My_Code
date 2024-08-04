module test_FUNC;

    parameter PERIOD = 10;
    reg                       CLK = 1;
    reg                       CDN = 0;
    wire [4:0] Q;


    initial begin
        forever #(PERIOD / 2) CLK = ~CLK;
    end

    initial begin
        CDN = 1;
        #(PERIOD) CDN = 0;
        #(PERIOD) CDN = 1;
        // #(PERIOD * 200);
        // $finish;
    end

    FUNC u_FUNC(
    	.CLK (CLK ),
        .CDN (CDN ),
        .Q   (Q   )
    );

    initial begin
        $dumpfile("test_FUNC_wave.vcd");  //生成的vcd文件名称
        $dumpvars(0, test_FUNC);  //tb模块名称
        #20000 $finish;
    end
endmodule

module FUNC (CLK,CDN,Q);
    input CLK;
    input CDN;
    output [4:0] Q; 

    reg [4:0] Q_tmp;

    always @(posedge CLK or negedge CDN) begin
        if(!CDN)
            Q_tmp[0] <= 0;
        else begin
            Q_tmp[0] <= ~Q_tmp[0];
        end
    end

    always @(posedge CLK or negedge CDN) begin
        if(!CDN)
            Q_tmp[1] <= 0;
        else begin
            Q_tmp[1] <= Q_tmp[0] ^ Q_tmp[1];
        end
    end

    always @(posedge CLK or negedge CDN) begin
        if(!CDN)
            Q_tmp[2] <= 0;
        else begin
            Q_tmp[2] <= Q_tmp[2] ? (~(Q_tmp[0] & Q_tmp[1])) : (Q_tmp[0] & Q_tmp[1]);
        end
    end

    always @(posedge CLK or negedge CDN) begin
        if(!CDN)
            Q_tmp[3] <= 0;
        else begin
            Q_tmp[3] <= (Q_tmp[0] & Q_tmp[1] & Q_tmp[2]) ^ Q_tmp[3];
        end
    end

    always @(posedge CLK or negedge CDN) begin
        if(!CDN)
            Q_tmp[4] <= 0;
        else begin
            Q_tmp[4] <= Q_tmp[4] ^ (Q_tmp[0] & Q_tmp[1] & Q_tmp[2] & Q_tmp[3]);
        end
    end
    
    assign Q = Q_tmp;
endmodule //FUNC