# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

# Base Configurations. Don't Touch
# section begin
set script_dir [file dirname [file normalize [info script]]]
set ::env(DESIGN_NAME) user_project_wrapper
#section end


# User Configurations
set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg

set ::env(CLOCK_PORT) "user_clock2"
set ::env(CLOCK_NET) "mprj.clk"

set ::env(CLOCK_PERIOD) "10"

set ::env(VERILOG_FILES) "\
        $script_dir/../../verilog/rtl/defines.v \
        $script_dir/../../verilog/rtl/user_project_wrapper.v \
        $script_dir/../../verilog/rtl/user_proj_example.v"

set ::env(VERILOG_FILES_BLACKBOX) "\
        $script_dir/../../verilog/rtl/defines.v \
        $script_dir/../../verilog/rtl/DFFRAM.v \
        $script_dir/../../verilog/rtl/register_file.v"

set ::env(EXTRA_LEFS) "\
        $script_dir/../../lef/register_file_16_1489f923c4dca729178b3e3233458550d8dddf29.lef \
        $script_dir/../../lef/DFFRAM.lef"

set ::env(EXTRA_GDS_FILES) "\
        $script_dir/../../gds/register_file_16_1489f923c4dca729178b3e3233458550d8dddf29.gds"

# The following is because there are no std cells in the example wrapper project.
#set ::env(SYNTH_TOP_LEVEL) 1
#set ::env(PL_RANDOM_GLB_PLACEMENT) 1
#set ::env(PL_OPENPHYSYN_OPTIMIZATIONS) 0
#set ::env(DIODE_INSERTION_STRATEGY) 0
#set ::env(FILL_INSERTION) 0
#set ::env(TAP_DECAP_INSERTION) 0
#set ::env(CLOCK_TREE_SYNTH) 0

# Tune
set ::env(FP_CORE_UTIL) 34
# default 2
set ::env(CELL_PAD) 4
# default 0.15
set ::env(GLB_RT_ADJUSTMENT) 0.1
# default 4
set ::env(SYNTH_MAX_FANOUT) 5

set ::env(PL_TARGET_DENSITY) [ expr ($::env(FP_CORE_UTIL)+5) / 100.0 ]

# Area Configurations. DON'T TOUCH.
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 2920 3520"

# Power & Pin Configurations. DON'T TOUCH.
set ::env(FP_PDN_CORE_RING) 1

set ::env(VDD_NETS) [list {vccd1} {vccd2} {vdda1} {vdda2}]
set ::env(GND_NETS) [list {vssd1} {vssd2} {vssa1} {vssa2}]
#set ::env(PDN_CFG) $script_dir/pdn.tcl

set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg
set ::env(FP_DEF_TEMPLATE) $script_dir/../../def/user_project_wrapper_empty.def
set ::unit 2.4
set ::env(FP_IO_VEXTEND) [expr 2*$::unit]
set ::env(FP_IO_HEXTEND) [expr 2*$::unit]
set ::env(FP_IO_VLENGTH) $::unit
set ::env(FP_IO_HLENGTH) $::unit

set ::env(FP_IO_VTHICKNESS_MULT) 4
set ::env(FP_IO_HTHICKNESS_MULT) 4



# Need to fix a FastRoute bug for this to work, but it's good
# for a sense of "isolation"
set ::env(MAGIC_ZEROIZE_ORIGIN) 0
set ::env(MAGIC_WRITE_FULL_LEF) 1
