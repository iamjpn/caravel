set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) "microwatt"

set ::env(DESIGN_IS_CORE) 0
set ::env(FP_PDN_CORE_RING) 0
set ::env(GLB_RT_MAXLAYER) 5

set ::env(VERILOG_FILES) "$script_dir/../../verilog/rtl/microwatt.v"

set ::env(CLOCK_PORT) "ext_clk"
set ::env(CLOCK_PERIOD) "20.000"
