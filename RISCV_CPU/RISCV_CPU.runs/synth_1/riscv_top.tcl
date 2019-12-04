# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param chipscope.maxJobs 3
set_param xicom.use_bs_reader 1
set_msg_config -id {Common 17-41} -limit 10000000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.cache/wt} [current_project]
set_property parent.project_path {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo {c:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_mem {
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/test/inst.data}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/test/forward_test1.data}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/test/arith_test1.data}
}
read_verilog -library xil_defaultlib {
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.srcs/sources_1/new/config.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/src/common/block_ram/block_ram.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/src/cpu.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.srcs/sources_1/new/ctrl.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.srcs/sources_1/new/ex.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.srcs/sources_1/new/ex_mem.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/src/common/fifo/fifo.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.srcs/sources_1/new/id.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.srcs/sources_1/new/id_ex.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.srcs/sources_1/new/if.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.srcs/sources_1/new/if_id.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.srcs/sources_1/new/mem.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.srcs/sources_1/new/mem_ctrl.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.srcs/sources_1/new/mem_wb.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.srcs/sources_1/new/pc_reg.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/src/ram.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.srcs/sources_1/new/register.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/src/riscv_top.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/src/hci.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/src/common/uart/uart.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/src/common/uart/uart_baud_clk.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/src/common/uart/uart_rx.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/src/common/uart/uart_tx.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.srcs/sources_1/new/cache.v}
  {C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.srcs/sources_1/new/bp.v}
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.srcs/constrs_1/imports/src/Basys-3-Master.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/zhang/Documents/Computer Architecture/ComputerArch2019/RISCV_CPU/RISCV_CPU.srcs/constrs_1/imports/src/Basys-3-Master.xdc}}]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top riscv_top -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef riscv_top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file riscv_top_utilization_synth.rpt -pb riscv_top_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
