
set ProjectName bcu1525_sdaccel
set ProjectFolder ./$ProjectName


#Remove unnecessary files.
set file_list [glob -nocomplain webtalk*.*]
foreach name $file_list {
    file delete $name
}

#Delete old project if folder already exists.
if {[file exists .Xil]} { 
    file delete -force .Xil
}

#Delete old project if folder already exists.
if {[file exists "$ProjectFolder"]} { 
    file delete -force $ProjectFolder
}

set scriptPath [file dirname [file normalize [info script]]]

create_project $ProjectName $ProjectFolder -part xcvu9p-fsgd2104-2L-e

create_bd_design "bd"

import_files -norecurse $scriptPath/BLS4G4D240FSB.csv
add_files -fileset constrs_1 -norecurse {D:/Projects/_github/BCU1525_SDAccel/scripts/VCU1525_DIMM0.xdc}
add_files -fileset constrs_1 -norecurse {D:/Projects/_github/BCU1525_SDAccel/scripts/VCU1525_pblocks.xdc}
set_property used_in_synthesis false [get_files  D:/Projects/_github/BCU1525_SDAccel/scripts/VCU1525_pblocks.xdc]

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_0
set_property -dict [list CONFIG.pcie_blk_locn {X1Y2} CONFIG.select_quad {GTY_Quad_227}] [get_bd_cells xdma_0]
endgroup

startgroup
make_bd_intf_pins_external  [get_bd_intf_pins xdma_0/pcie_mgt]
set_property name pci_express_x1 [get_bd_intf_ports pcie_mgt_0]
make_bd_pins_external  [get_bd_pins xdma_0/sys_rst_n]
set_property name pcie_perstn [get_bd_ports sys_rst_n_0]
endgroup

startgroup
set_property -dict [list CONFIG.mode_selection {Basic}] [get_bd_cells xdma_0]
set_property -dict [list CONFIG.xdma_pcie_64bit_en {true} CONFIG.pf0_msix_cap_table_bir {BAR_1:0} CONFIG.pf0_msix_cap_pba_bir {BAR_1:0}] [get_bd_cells xdma_0]
endgroup

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_0
endgroup

startgroup
set_property -dict [list CONFIG.C_BUF_TYPE {IBUFDSGTE}] [get_bd_cells util_ds_buf_0]
#set_property -dict [list CONFIG.DIFF_CLK_IN_BOARD_INTERFACE {pcie_refclk}] [get_bd_cells util_ds_buf_0]
make_bd_intf_pins_external [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
set_property name pcie_refclk [get_bd_intf_ports CLK_IN_D_0]
connect_bd_net [get_bd_pins util_ds_buf_0/IBUF_DS_ODIV2] [get_bd_pins xdma_0/sys_clk]
connect_bd_net [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins xdma_0/sys_clk_gt]
endgroup

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_0
#create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_1
#create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_2
#create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_3

make_bd_intf_pins_external  [get_bd_intf_pins ddr4_0/C0_DDR4]
#make_bd_intf_pins_external  [get_bd_intf_pins ddr4_1/C0_DDR4]
#make_bd_intf_pins_external  [get_bd_intf_pins ddr4_2/C0_DDR4]
#make_bd_intf_pins_external  [get_bd_intf_pins ddr4_3/C0_DDR4]

#set_property name C1_DDR4_0 [get_bd_intf_ports C0_DDR4_1]
#set_property name C2_DDR4_0 [get_bd_intf_ports C0_DDR4_2]
#set_property name C3_DDR4_0 [get_bd_intf_ports C0_DDR4_3]
endgroup

startgroup
set_property -dict [list CONFIG.C0.DDR4_TimePeriod {833} CONFIG.C0.DDR4_InputClockPeriod {3332} CONFIG.C0.DDR4_CLKOUT0_DIVIDE {5}] [get_bd_cells ddr4_0]
#set_property -dict [list CONFIG.C0.DDR4_TimePeriod {833} CONFIG.C0.DDR4_InputClockPeriod {3332} CONFIG.C0.DDR4_CLKOUT0_DIVIDE {5}] [get_bd_cells ddr4_1]
#set_property -dict [list CONFIG.C0.DDR4_TimePeriod {833} CONFIG.C0.DDR4_InputClockPeriod {3332} CONFIG.C0.DDR4_CLKOUT0_DIVIDE {5}] [get_bd_cells ddr4_2]
#set_property -dict [list CONFIG.C0.DDR4_TimePeriod {833} CONFIG.C0.DDR4_InputClockPeriod {3332} CONFIG.C0.DDR4_CLKOUT0_DIVIDE {5}] [get_bd_cells ddr4_3]

set_property -dict [list CONFIG.C0.DDR4_CustomParts [lindex [get_files */BLS4G4D240FSB.csv] 0] CONFIG.C0.DDR4_isCustom {true}] [get_bd_cells ddr4_0]
#set_property -dict [list CONFIG.C0.DDR4_CustomParts [lindex [get_files */BLS4G4D240FSB.csv] 0] CONFIG.C0.DDR4_isCustom {true}] [get_bd_cells ddr4_1]
#set_property -dict [list CONFIG.C0.DDR4_CustomParts [lindex [get_files */BLS4G4D240FSB.csv] 0] CONFIG.C0.DDR4_isCustom {true}] [get_bd_cells ddr4_2]
#set_property -dict [list CONFIG.C0.DDR4_CustomParts [lindex [get_files */BLS4G4D240FSB.csv] 0] CONFIG.C0.DDR4_isCustom {true}] [get_bd_cells ddr4_3]

set_property -dict [list CONFIG.C0.DDR4_MemoryType {UDIMMs} CONFIG.C0.DDR4_MemoryPart {BLS4G4D240FSB-2400} CONFIG.C0.DDR4_DataWidth {64}] [get_bd_cells ddr4_0]
#set_property -dict [list CONFIG.C0.DDR4_MemoryType {UDIMMs} CONFIG.C0.DDR4_MemoryPart {BLS4G4D240FSB-2400} CONFIG.C0.DDR4_DataWidth {64}] [get_bd_cells ddr4_1]
#set_property -dict [list CONFIG.C0.DDR4_MemoryType {UDIMMs} CONFIG.C0.DDR4_MemoryPart {BLS4G4D240FSB-2400} CONFIG.C0.DDR4_DataWidth {64}] [get_bd_cells ddr4_2]
#set_property -dict [list CONFIG.C0.DDR4_MemoryType {UDIMMs} CONFIG.C0.DDR4_MemoryPart {BLS4G4D240FSB-2400} CONFIG.C0.DDR4_DataWidth {64}] [get_bd_cells ddr4_3]

set_property -dict [list CONFIG.ADDN_UI_CLKOUT1_FREQ_HZ {100}] [get_bd_cells ddr4_0]
#set_property -dict [list CONFIG.ADDN_UI_CLKOUT1_FREQ_HZ {100}] [get_bd_cells ddr4_1]
#set_property -dict [list CONFIG.ADDN_UI_CLKOUT1_FREQ_HZ {100}] [get_bd_cells ddr4_2]
#set_property -dict [list CONFIG.ADDN_UI_CLKOUT1_FREQ_HZ {100}] [get_bd_cells ddr4_3]
endgroup

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0
set_property -dict [list CONFIG.C_SIZE {1} CONFIG.C_OPERATION {not} CONFIG.LOGO_FILE {data/sym_notgate.png}] [get_bd_cells util_vector_logic_0]
connect_bd_net [get_bd_ports pcie_perstn] [get_bd_pins util_vector_logic_0/Op1]
connect_bd_net [get_bd_pins util_vector_logic_0/Res] [get_bd_pins ddr4_0/sys_rst]
#connect_bd_net [get_bd_pins util_vector_logic_0/Res] [get_bd_pins ddr4_1/sys_rst]
#connect_bd_net [get_bd_pins util_vector_logic_0/Res] [get_bd_pins ddr4_2/sys_rst]
#connect_bd_net [get_bd_pins util_vector_logic_0/Res] [get_bd_pins ddr4_3/sys_rst]
endgroup

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ddr4_c0_reset
#create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ddr4_c1_reset
#create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ddr4_c2_reset
#create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ddr4_c3_reset
endgroup

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi2pr
set_property -dict [list CONFIG.NUM_MI {2} CONFIG.NUM_SI {1} CONFIG.NUM_CLKS {2}] [get_bd_cells axi2pr]
connect_bd_intf_net [get_bd_intf_pins xdma_0/M_AXI] [get_bd_intf_pins axi2pr/S00_AXI]
connect_bd_net [get_bd_pins xdma_0/axi_aclk] [get_bd_pins axi2pr/aclk]
connect_bd_net [get_bd_pins xdma_0/axi_aresetn] [get_bd_pins axi2pr/aresetn]
endgroup


startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 pr2axi
connect_bd_net [get_bd_pins ddr4_0/c0_ddr4_ui_clk] [get_bd_pins pr2axi/aclk]
connect_bd_net [get_bd_pins ddr4_c0_reset/peripheral_aresetn] [get_bd_pins pr2axi/aresetn]
connect_bd_intf_net [get_bd_intf_pins pr2axi/M00_AXI] [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI]
connect_bd_intf_net [get_bd_intf_pins pr2axi/S00_AXI] [get_bd_intf_pins axi2pr/M00_AXI]
endgroup


startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:ocl_block:1.0 ocl_block_0
set_property CONFIG.ENABLE_ADVANCED_OPTIONS 1 [get_bd_cells /ocl_block_0]
set_property -dict [list CONFIG.M_DATA_WIDTH {64} CONFIG.S_DATA_WIDTH {64} CONFIG.S_ADDR_WIDTH {32} CONFIG.NUM_KERNELS {8}] [get_bd_cells ocl_block_0]
set_property -dict [list CONFIG.USE_PR {true} CONFIG.USE_SYNTH {false} CONFIG.HAS_S_MEM {false} CONFIG.NUM_M_AXIS_RX {0} CONFIG.S_HAS_REGSLICE {4}] [get_bd_cells ocl_block_0]
connect_bd_intf_net [get_bd_intf_pins ocl_block_0/M_AXI] [get_bd_intf_pins pr2axi/S01_AXI]
connect_bd_intf_net [get_bd_intf_pins ocl_block_0/S_AXI] [get_bd_intf_pins axi2pr/M01_AXI]
connect_bd_net [get_bd_pins ocl_block_0/ACLK] [get_bd_pins ddr4_0/c0_ddr4_ui_clk]
connect_bd_net [get_bd_pins ocl_block_0/ARESET] [get_bd_pins ddr4_c0_reset/peripheral_aresetn]

endgroup

startgroup
set_property -dict [list CONFIG.C_AUX_RESET_HIGH.VALUE_SRC USER] [get_bd_cells ddr4_c0_reset]
set_property -dict [list CONFIG.C_AUX_RESET_HIGH {0}] [get_bd_cells ddr4_c0_reset]

#set_property -dict [list CONFIG.C_AUX_RESET_HIGH.VALUE_SRC USER] [get_bd_cells ddr4_c1_reset]
#set_property -dict [list CONFIG.C_AUX_RESET_HIGH {0}] [get_bd_cells ddr4_c1_reset]

#set_property -dict [list CONFIG.C_AUX_RESET_HIGH.VALUE_SRC USER] [get_bd_cells ddr4_c2_reset]
#set_property -dict [list CONFIG.C_AUX_RESET_HIGH {0}] [get_bd_cells ddr4_c2_reset]

#set_property -dict [list CONFIG.C_AUX_RESET_HIGH.VALUE_SRC USER] [get_bd_cells ddr4_c3_reset]
#set_property -dict [list CONFIG.C_AUX_RESET_HIGH {0}] [get_bd_cells ddr4_c3_reset]

connect_bd_net [get_bd_pins ddr4_0/c0_ddr4_ui_clk] [get_bd_pins ddr4_c0_reset/slowest_sync_clk]
connect_bd_net [get_bd_pins ddr4_0/c0_ddr4_ui_clk_sync_rst] [get_bd_pins ddr4_c0_reset/ext_reset_in]
connect_bd_net [get_bd_pins ddr4_c0_reset/peripheral_aresetn] [get_bd_pins ddr4_0/c0_ddr4_aresetn]

#connect_bd_net [get_bd_pins ddr4_1/c0_ddr4_ui_clk] [get_bd_pins ddr4_c1_reset/slowest_sync_clk]
#connect_bd_net [get_bd_pins ddr4_1/c0_ddr4_ui_clk_sync_rst] [get_bd_pins ddr4_c1_reset/ext_reset_in]
#connect_bd_net [get_bd_pins ddr4_c1_reset/peripheral_aresetn] [get_bd_pins ddr4_1/c0_ddr4_aresetn]

#connect_bd_net [get_bd_pins ddr4_2/c0_ddr4_ui_clk] [get_bd_pins ddr4_c2_reset/slowest_sync_clk]
#connect_bd_net [get_bd_pins ddr4_2/c0_ddr4_ui_clk_sync_rst] [get_bd_pins ddr4_c2_reset/ext_reset_in]
#connect_bd_net [get_bd_pins ddr4_c2_reset/peripheral_aresetn] [get_bd_pins ddr4_2/c0_ddr4_aresetn]

#connect_bd_net [get_bd_pins ddr4_3/c0_ddr4_ui_clk] [get_bd_pins ddr4_c3_reset/slowest_sync_clk]
#connect_bd_net [get_bd_pins ddr4_3/c0_ddr4_ui_clk_sync_rst] [get_bd_pins ddr4_c3_reset/ext_reset_in]
#connect_bd_net [get_bd_pins ddr4_c3_reset/peripheral_aresetn] [get_bd_pins ddr4_3/c0_ddr4_aresetn]
endgroup

startgroup
connect_bd_net [get_bd_pins ddr4_0/c0_ddr4_ui_clk] [get_bd_pins axi2pr/aclk1]
#connect_bd_net [get_bd_pins ddr4_1/c0_ddr4_ui_clk] [get_bd_pins axi_smc/aclk2]
#connect_bd_net [get_bd_pins ddr4_2/c0_ddr4_ui_clk] [get_bd_pins axi_smc/aclk3]
#connect_bd_net [get_bd_pins ddr4_3/c0_ddr4_ui_clk] [get_bd_pins axi_smc/aclk4]
#connect_bd_intf_net [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI]
#connect_bd_intf_net [get_bd_intf_pins axi_smc/M01_AXI] [get_bd_intf_pins ddr4_1/C0_DDR4_S_AXI]
#connect_bd_intf_net [get_bd_intf_pins axi_smc/M02_AXI] [get_bd_intf_pins ddr4_2/C0_DDR4_S_AXI]
#connect_bd_intf_net [get_bd_intf_pins axi_smc/M03_AXI] [get_bd_intf_pins ddr4_3/C0_DDR4_S_AXI]

make_bd_intf_pins_external  [get_bd_intf_pins ddr4_0/C0_SYS_CLK]
#make_bd_intf_pins_external  [get_bd_intf_pins ddr4_1/C0_SYS_CLK]
#make_bd_intf_pins_external  [get_bd_intf_pins ddr4_2/C0_SYS_CLK]
#make_bd_intf_pins_external  [get_bd_intf_pins ddr4_3/C0_SYS_CLK]


set_property name dimm0_refclk [get_bd_intf_ports C0_SYS_CLK_0]
#set_property name dimm1_refclk [get_bd_intf_ports C0_SYS_CLK_1]
#set_property name dimm2_refclk [get_bd_intf_ports C0_SYS_CLK_2]
#set_property name dimm3_refclk [get_bd_intf_ports C0_SYS_CLK_3]

set_property CONFIG.FREQ_HZ 300000000 [get_bd_intf_ports /dimm0_refclk]
#set_property CONFIG.FREQ_HZ 300000000 [get_bd_intf_ports /dimm1_refclk]
#set_property CONFIG.FREQ_HZ 300000000 [get_bd_intf_ports /dimm2_refclk]
#set_property CONFIG.FREQ_HZ 300000000 [get_bd_intf_ports /dimm3_refclk]
endgroup


assign_bd_address [get_bd_addr_segs {ocl_block_0/S_AXI/Reg0 }]
assign_bd_address [get_bd_addr_segs {ocl_block_0/S_AXI/Reg1 }]
assign_bd_address [get_bd_addr_segs {ocl_block_0/S_AXI/Reg2 }]
assign_bd_address [get_bd_addr_segs {ocl_block_0/S_AXI/Reg3 }]
assign_bd_address [get_bd_addr_segs {ocl_block_0/S_AXI/Reg4 }]
assign_bd_address [get_bd_addr_segs {ocl_block_0/S_AXI/Reg5 }]
assign_bd_address [get_bd_addr_segs {ocl_block_0/S_AXI/Reg6 }]
assign_bd_address [get_bd_addr_segs {ocl_block_0/S_AXI/Reg7 }]

set_property offset 0x0000000100000000 [get_bd_addr_segs {xdma_0/M_AXI/SEG_ocl_block_0_Reg0}]
set_property offset 0x0000000120000000 [get_bd_addr_segs {xdma_0/M_AXI/SEG_ocl_block_0_Reg1}]
set_property offset 0x0000000140000000 [get_bd_addr_segs {xdma_0/M_AXI/SEG_ocl_block_0_Reg2}]
set_property offset 0x0000000160000000 [get_bd_addr_segs {xdma_0/M_AXI/SEG_ocl_block_0_Reg3}]
set_property offset 0x0000000180000000 [get_bd_addr_segs {xdma_0/M_AXI/SEG_ocl_block_0_Reg4}]
set_property offset 0x00000001A0000000 [get_bd_addr_segs {xdma_0/M_AXI/SEG_ocl_block_0_Reg5}]
set_property offset 0x00000001C0000000 [get_bd_addr_segs {xdma_0/M_AXI/SEG_ocl_block_0_Reg6}]
set_property offset 0x00000001E0000000 [get_bd_addr_segs {xdma_0/M_AXI/SEG_ocl_block_0_Reg7}]

assign_bd_address [get_bd_addr_segs {ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK }]


make_wrapper -files [get_files ./$ProjectName/$ProjectName.srcs/sources_1/bd/bd/bd.bd] -top
add_files -norecurse ./$ProjectName/$ProjectName.srcs/sources_1/bd/bd/hdl/bd_wrapper.v

set_property strategy Performance_RefinePlacement [get_runs impl_1]
