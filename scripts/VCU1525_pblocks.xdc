
create_pblock dynamic_pblock
add_cells_to_pblock [get_pblocks dynamic_pblock] [get_cells -quiet [list bd_i/ocl_block_0]]
resize_pblock [get_pblocks dynamic_pblock] -add {SLICE_X0Y302:SLICE_X140Y481}
resize_pblock [get_pblocks dynamic_pblock] -add {CMACE4_X0Y4:CMACE4_X0Y4}
resize_pblock [get_pblocks dynamic_pblock] -add {DSP48E2_X0Y122:DSP48E2_X15Y191}
resize_pblock [get_pblocks dynamic_pblock] -add {GTYE4_CHANNEL_X0Y24:GTYE4_CHANNEL_X0Y31}
resize_pblock [get_pblocks dynamic_pblock] -add {GTYE4_COMMON_X0Y6:GTYE4_COMMON_X0Y7}
resize_pblock [get_pblocks dynamic_pblock] -add {ILKNE4_X0Y3:ILKNE4_X0Y3}
resize_pblock [get_pblocks dynamic_pblock] -add {IOB_X0Y286:IOB_X1Y415}
resize_pblock [get_pblocks dynamic_pblock] -add {RAMB18_X0Y122:RAMB18_X9Y191}
resize_pblock [get_pblocks dynamic_pblock] -add {RAMB36_X0Y61:RAMB36_X9Y95}
resize_pblock [get_pblocks dynamic_pblock] -add {URAM288_X0Y84:URAM288_X3Y127}

set_property SNAPPING_MODE ON [get_pblocks dynamic_pblock]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
