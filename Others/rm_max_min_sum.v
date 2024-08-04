module rm_max_min_sum (
    input         clk,
    input         rst_n,
    input  [ 7:0] data_in,
    input         vld_in,
    output [15:0] sum_out,
    output        vld_out
);

    reg [ 7:0] max;
    reg [ 7:0] min;
    reg [15:0] sum;
    reg flag;
    reg [15:0] sum_out_tmp;
    reg [ 7:0] cnt;
    reg        vld_out_tmp;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            max <= 0;
            min <= 8'hFF;
        end else if (vld_in == 1) begin
            if (data_in > max) begin
                max <= data_in;
                min <= 0;
            end else if (data_in < min) begin
                max <= 0;
                min <= data_in;
            end else begin
                max <= 0;
                min <= 0;
            end
        end else begin
            max <= 0;
            min <= 0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            flag <= 0;
        end else if (vld_in == 1) begin
            cnt <= cnt + 1;
            flag <= 1;
        end else begin
            cnt <= cnt;
            flag <= flag;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum <= 0;
        end else if (vld_in == 1 && cnt > 0) begin
            sum <= sum + data_in;
        end else if (cnt == 0) begin
            sum <= vld_in ? data_in : 0;
        end else begin
            sum <= sum;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            sum_out_tmp <= 0;
        end else begin
            if (cnt == 0 && flag == 1) begin
                sum_out_tmp <= sum - max - min;
                vld_out_tmp <= 1;
            end else begin
                sum_out_tmp <= 0;
                vld_out_tmp <= 0;
            end
        end
    end     

    assign sum_out = sum_out_tmp;
    assign vld_out = vld_out_tmp;




endmodule  //rm_max_min_sum
