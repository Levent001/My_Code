`timescale 1ns/1ns

module comparator_4(
	input		[3:0]       A   	,
	input	   [3:0]		B   	,
 
 	output	 wire		Y2    , //A>B
	output   wire        Y1    , //A=B
    output   wire        Y0      //A<B
);

reg Y2_tmp;
reg Y1_tmp;
reg Y0_tmp;

integer i;

always @(*) begin
    for(i=0;i<4;i=i+1)begin
        if(A[3-i] > B[3-i])begin

        end
    end
end

endmodule