//ICG：Verilog Behavior Model
//***************************************************
//FileName:cell clock gating.v
//Function:
// this is a clock gating cell which is used for low
// power design.it is only one simulation model which
// is used for funtional simulation.In fact,it will
// be took place with the library clock gating cell.
// ICG:Integrate Clock Gating
module cell_clock_gating (
    input  wire TE, //test enable which is used for test mode in DFT
    input  wire E,  //enable
    input  wire CP, //clock
    output wire Q   //output signal
);

    reg E_lat;      //internal signal

    assign E_or = E | TE;

    always @(CP or E_or) begin  //This is a  latch
        if (!CP) begin
            E_lat <= E_or;
        end
    end

    assign Q = E_lat & CP;

endmodule  //cell_clock_gating
