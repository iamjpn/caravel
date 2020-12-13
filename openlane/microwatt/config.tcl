set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) "microwatt"

set ::env(DESIGN_IS_CORE) 0
set ::env(FP_PDN_CORE_RING) 0
set ::env(GLB_RT_MAXLAYER) 5

set ::env(VERILOG_FILES) "$script_dir/../../verilog/rtl/microwatt.v"
set ::env(SYNTH_READ_BLACKBOX_LIB) 1

set ::env(CLOCK_PORT) "ext_clk"
set ::env(CLOCK_PERIOD) "20.000"

set ::env(VERILOG_FILES_BLACKBOX) "\
        $script_dir/../../verilog/rtl/DFFRAM_4k.v"

set ::env(EXTRA_LEFS) "\
        $script_dir/../../lef/DFFRAM_4k.lef"

set ::env(EXTRA_GDS_FILES) "\
        $script_dir/../../gds/DFFRAM_4k.gds"
