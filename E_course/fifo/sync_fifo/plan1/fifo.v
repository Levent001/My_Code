//同步fifo
`timescale 1ns/10ps
/*方法1：用长度计数器Fcounter。执行一次写操作，
   Fcounter加1，执行一次读操作，Fcounter减1。*/
module fifo(
    Fifo_rst,   //asyne reset
    Clock,      //write and read clock
    Read_enable,
    Write_enable,
    Write_data,
    Read_data,
    Full,       //full flag
    Empty,      //empty flag
    Fcounter    //count the number of data in FIFO
);

    parameter                   DATA_WIDTH=8;
    parameter                   ADDR_WIDTH=9;
    input                       Fifo_rst;
    input                       Clock;
    input                       Read_enable;
    input                       Write_enable;
    input   [DATA_WIDTH-1:0]    Write_data;
    output  [DATA_WIDTH-1:0]    Read_data;
    output                      Full;
    output                      Empty;
    output  [ADDR_WIDTH-1:0]    Fcounter;
    
    reg     [DATA_WIDTH-1:0]    Read_data;
    reg                         Full;
    reg                         Empty;
    reg     [ADDR_WIDTH-1:0]    Fcounter;

    reg     [ADDR_WIDTH-1:0]    Read_addr; //read address 
    reg     [ADDR_WIDTH-1:0]    Write_addr; //write address

    wire    Read_allow  =(Read_enable  && !Empty); 
    wire    Write_allow =(Write_enable && !Full);

/*******************************************************************\
    BLOCK RAM instantiation for FIFO.Module is 512x8,of which one
    address location is sacrificed for the overall speed of the design
\*******************************************************************/
    DUALRAM U_RAM(
        .Read_clock     (Clock),
        .Write_clock    (Clock),
        .Read_allow     (Read_allow),
        .Write_allow    (Write_allow),
        .Read_addr      (Read_addr),
        .Write_addr     (Write_addr),
        .Write_data     (Write_data),
        .Read_data      (Read_data)
        );
    /*******************************************************************\
        Empty flag is set on Fifo rst (initial),or when on the
        next clock cycle,Write Enable is low,and either the
        FIFOcount is equal to 0,or it is equal to 1 and Read
        Enable is high (about to go Empty).
    \*******************************************************************/
    always @ (posedge Clock or negedge Fifo_rst) begin
        if(Fifo_rst) begin
            Empty <= 1'b1;
        end
        else begin
            Empty <= (!Write_enable && (Fcounter[8:1] == 8'h0) &&
                     ((Fcounter[0] == 0)|| Read_enable));
        end
    end
    /*******************************************************************\
        Full flag is set on Fifo rst (but it is cleared on the
        first valid clock edge after Fifo rst is removed).or
        when on the next clock cycle,Read Enable is low,and
        either the FIFOcount is equal to 1FF (hex),or it is
        equal to 1FE and the Write Enable is high (about to go Full).
    \*******************************************************************/
    always @ (posedge Clock or negedge Fifo_rst) begin
        if(Fifo_rst) begin
            Full <= 1'b0;
        end
        else begin
            Full <= (!Read_enable && (Fcounter[8:1] == 8'hFF) &&
                    ((Fcounter[0] == 1)|| Write_enable));
        end
    end
    /*******************************************************************\
        Generation of Read and Write address pointers.  
    \*******************************************************************/
    always @ (posedge Clock or negedge Fifo_rst) begin
        if(Fifo_rst) begin
            Read_addr <= 'b0;
        end
        else if(Read_allow) begin
            Read_addr <= Read_addr + 'b1;
        end
    end
    always @ (posedge Clock or negedge Fifo_rst) begin
        if(Fifo_rst) begin
            Write_addr <= 'b0;
        end
        else if(Write_allow) begin
            Write_addr <= Write_addr + 'b1;
        end
    end
    /*******************************************************************\
        Generation of FIFOcount outputs.Used to determine how
        Full FIFO is,based on a counter that keeps track of how
        many words are in the FIFO.Also used to generate Full
        and Empty flags.Only the upper four bits of the counter
        are sent outside the module
    \*******************************************************************/
    always @ (posedge Clock or negedge Fifo_rst) begin
        if(Fifo_rst) begin
            Fcounter <= 'b0;
        end
        else if((!Read_allow && Write_allow)||(!Write_allow && Read_allow)) begin
            if(Write_allow)
                Fcounter <= Fcounter + 'b1;
            else
                Fcounter <= Fcounter - 'b1;
        end
    end

endmodule