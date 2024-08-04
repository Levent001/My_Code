create_clock -period 3.3 [get_ports clk]
set_clock_uncertainty -setup 0.3 [get_ports clk]
set_clock_latency -max 0.3 [get_ports clk]
set_clock_transition 0.3 [get_ports clk]

set_input_delay -max [expr {3.3*0.85}] -clock clk [all_inputs]
remove_input_delay [get_ports clk]
set_output_delay -max [expr {3.3*0.8}] -clock clk [all_outputs]

set_driving_cell -lib_cell bufbd1 -library cb13fs120_tsmc_max \
                   [remove_from_collection [all_inputs] [get_ports clk]]
                   set_load [expr 2 * {[load_of cb13fs120_tsmc_max/bufbd7I]}] [all_outputs]

