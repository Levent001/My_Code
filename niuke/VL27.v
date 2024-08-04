//VL27 不重叠序列检测
//方法1 counter+RAM
// `timescale 1ns / 1ns
// module sequence_detect (
//     input      clk,
//     input      rst_n,
//     input      data,
//     output reg match,
//     output reg not_match
// );

//     reg [5:0] ram;
//     reg [2:0] cnt;

//     always @(posedge clk or negedge rst_n) begin
//         if (!rst_n) begin
//             cnt <= 0;
//         end else if (cnt == 3'd5) begin
//             cnt <= 0;
//         end else begin
//             cnt <= cnt + 1;
//         end
//     end

//     always @(posedge clk or negedge rst_n) begin
//         if (!rst_n) begin
//             ram <= 0;
//         end else begin
//             case (cnt)
//                 3'd0: ram <= {ram[5:1], data};
//                 3'd1: ram <= {ram[5:2], data, ram[0]};
//                 3'd2: ram <= {ram[5:3], data, ram[1:0]};
//                 3'd3: ram <= {ram[5:4], data, ram[2:0]};
//                 3'd4: ram <= {ram[5], data, ram[3:0]};
//                 3'd5: ram <= {data, ram[4:0]};
//             endcase
//         end
//     end

//     always @(posedge clk or negedge rst_n) begin
//         if (!rst_n) begin
//             match <= 0;
//         end else if (ram == 6'b001110 && cnt == 3'd5) begin
//             match <= 1'b1;
//         end else match <= 1'b0;
//     end

//     always @(posedge clk or negedge rst_n) begin
//         if (!rst_n) begin
//             not_match <= 0;
//         end else if (ram != 6'b001110 && cnt == 3'd5) begin
//             not_match <= 1'b1;
//         end else not_match <= 1'b0;
//     end
// endmodule

//方法2 数选器+reg
// `timescale 1ns/1ns
// module sequence_detect(
// 	input clk,
// 	input rst_n,
// 	input data,
// 	output reg match,
// 	output reg not_match
// 	);

//     reg [3-1:0] cnt;
//     reg cmp;
//     reg  detect_cmp;
//     parameter detect = 6'b011100;

//     always @ (posedge clk or negedge rst_n) begin
//         if(!rst_n) begin
//             cnt <= 0;
//         end
//         else if (cnt == 3'd5)begin
//             cnt <= 0;
//         end
//         else begin
//             cnt <= cnt+1;
//         end
//     end

//     always@(*)begin
//         case(cnt)
//         3'd0: cmp = 1'd0;
//         3'd1: cmp = 1'd1;
//         3'd2: cmp = 1'd1;
//         3'd3: cmp = 1'd1;
//         3'd4: cmp = 1'd0;
//         3'd5: cmp = 1'd0;
//         default: cmp = 1'd0;
//         endcase
//     end

//     always @ (posedge clk or negedge rst_n) begin
//         if(!rst_n) begin
//             detect_cmp <= 1'b1;
//         end
//         else if(cnt == 3'd5) begin
//             detect_cmp <= 1'b1;
//         end
//         else
//             detect_cmp <= detect_cmp && (~( cmp^ data));
//     end



//     always @ (posedge clk or negedge rst_n) begin
//         if(!rst_n) begin
//             match <= 0;
//         end
//         else if((detect_cmp)&&(cnt == 3'd5))
//             match <= 1'd1;
//         else
//             match <= 1'd0;
//     end

//      always@(posedge clk or negedge rst_n) begin
//         if(! rst_n)
//             not_match <= 1'd0;
//          else if((!detect_cmp)&&(cnt == 3'd5))
//             not_match <= 1'd1;
//         else
//             not_match <= 1'd0;
//     end


// endmodule

//方法3：状态机
`timescale 1ns / 1ns
module sequence_detect (
    input      clk,
    input      rst_n,
    input      data,
    output reg match,
    output reg not_match
);

    reg [3:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
        end else if (cnt == 4'd6) begin
            cnt <= 1;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

    reg [6:0] current_state;
    reg [6:0] next_state;

    // localparam s0 = 7'b000_0001;
    // localparam s1 = 7'b000_0010;
    // localparam s2 = 7'b000_0100;
    // localparam s3 = 7'b000_1000;
    // localparam s4 = 7'b001_0000;
    // localparam s5 = 7'b010_0000;
    // localparam err_state = 7'b100_0000;
    
    localparam s0 = 7'd0;
    localparam s1 = 7'd1;
    localparam s2 = 7'd2;
    localparam s3 = 7'd3;
    localparam s4 = 7'd4;
    localparam s5 = 7'd5;
    localparam err_state = 7'd6;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= s0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        if (!rst_n) begin
            next_state = s0;
        end else begin
            case (current_state)
                s0: next_state = data ? err_state : s1;  //0
                s1: next_state = data ? s2 : err_state;  //1
                s2: next_state = data ? s3 : err_state;  //1
                s3: next_state = data ? s4 : err_state;  //1
                s4: next_state = data ? err_state : s5;  //0
                s5: next_state = data ? err_state : s0;  //0
                err_state: begin
                    if (cnt == 6 && data == 0) next_state = s1;
                    else next_state = err_state;
                end
                default: next_state = s0;
            endcase
        end
    end

    always @(*) begin
        if (!rst_n) begin
            match     = 0;
            not_match = 0;
        end else begin
            match     = (current_state == s0 && cnt == 6);
            not_match = (current_state == err_state && cnt == 6);
        end
    end

endmodule
