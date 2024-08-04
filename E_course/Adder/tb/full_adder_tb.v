module full_adder_tb ();

    reg a_in,b_in,c_in;
    wire sumout,cout;

    top u_full_adder(
    	.a_in    (a_in    ),
        .b_in    (b_in    ),
        .c_in    (c_in    ),
        .sum_out (sumout ),
        .c_out   (cout   )
    );

    parameter CLK_PERIOD = 20;
    reg clk,reset_n;

    initial begin
        clk = 0;
        forever begin
            #(CLK_PERIOD/2)
            clk = ~clk;
        end
    end

    initial begin
        reset_n = 0;
        #100
        reset_n = 1;
    end

    initial begin
        #110 a_in = 0; b_in = 0; c_in = 0; //00
        #20  a_in = 0; b_in = 1; c_in = 0; //01
        #20  a_in = 1; b_in = 0; c_in = 0; //01
        #20  a_in = 1; b_in = 1; c_in = 0; //10

        #20  a_in = 0; b_in = 0; c_in = 1; //01
        #20  a_in = 0; b_in = 1; c_in = 1; //10
        #20  a_in = 1; b_in = 0; c_in = 1; //10
        #20  a_in = 1; b_in = 1; c_in = 1; //11
        #50 $finish;
    end
    
    initial begin
        $vcdpluson;
    end

endmodule //full_adder_tb
