set ::env(DESIGN_NAME) "register_file_16_1489f923c4dca729178b3e3233458550d8dddf29"

set ::env(VERILOG_FILES) "register_file_16_1489f923c4dca729178b3e3233458550d8dddf29/src/register_file_16_1489f923c4dca729178b3e3233458550d8dddf29.v"

set ::env(DESIGN_IS_CORE) 0
set ::env(FP_PDN_CORE_RING) 0
set ::env(GLB_RT_MAXLAYER) 5

set ::env(CLOCK_PERIOD) "20.000"
set ::env(CLOCK_PORT) "clk"

set ::env(CLOCK_NET) $::env(CLOCK_PORT)

set filename $::env(OPENLANE_ROOT)/designs/$::env(DESIGN_NAME)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
}
