set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) user_proj_example

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/user_proj_example.v"

set ::env(CLOCK_PORT) ""
set ::env(CLOCK_NET) "counter.clk"
set ::env(CLOCK_PERIOD) "10"

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 2500 3000"
set ::env(DESIGN_IS_CORE) 0

set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg
# set ::env(FP_CONTEXT_DEF) $script_dir/../user_project_wrapper/runs/user_project_wrapper/tmp/floorplan/ioPlacer.def.macro_placement.def
# set ::env(FP_CONTEXT_LEF) $script_dir/../user_project_wrapper/runs/user_project_wrapper/tmp/merged_unpadded.lef

set ::env(SYNTH_READ_BLACKBOX_LIB) 1

set ::env(PL_BASIC_PLACEMENT) 1
set ::env(PL_TARGET_DENSITY) 0.5

set ::env(VERILOG_FILES_BLACKBOX) "\
        $script_dir/../../verilog/rtl/DFFRAM_4k.v"

set ::env(EXTRA_LEFS) "\
        $script_dir/../../lef/DFFRAM_4k.lef"

set ::env(EXTRA_GDS_FILES) "\
        $script_dir/../../gds/DFFRAM_4k.gds"

