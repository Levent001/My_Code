###############################################################
## Some design environment variables:
##source syn.sdc
set_app_var search_path ". $search_path ../libs"
#
set_app_var target_library typical.db
set_app_var link_library "* typical.db"
#
set symbol_library tsmc090.sdb
################################################################
## Set up a work library for this design in a subdirectory 
define_design_lib syn_ws -path ./syn_ws
################################################################
## read our rtl code
##read_verilog ../rtl/top.v
## 下面两句为第二种读入方式
analyze -work syn_ws -format verilog ../rtl/top.v 
elaborate -work syn_ws top
################################################################
## operating conditions；wire load
set_operating_conditions typical
set_wire_load_model -name "tsmc090_wl10" [all_designs]
################################################################
## 一般做后端的会加，固定的多端口加一些buffer
set_fix_multiple_port_nets -all -buffer_constants
################################################################
## Some netlist-level design rules
set_drive       5.0 [all_inputs]
set_load        1.0 [all_outputs]
## 最大扇出能力，一个输入信号进来之后会送到多少个信号去
set_max_fanout  5   [all_inputs]  
################################################################
set_max_area    200
set_max_delay   0.5 -to [all_outputs]
################################################################
compile
##compile_ultra
report_design
report_timing
report_area
#
write -hierarchy -format ddc
write -hierarchy -format verilog -output top_netlist.v
write_sdf top.sdf
#
exit
##report_qor > ../reports/syn.rpt
##write_sdc ../outputs/syn.sdc
##write -f verilog -output ../outputs/syn.gv
##write -f ddc -output ../outputs/syn.ddc"
