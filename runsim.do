##################################################
#  Modelsim do file to run simuilation
#  MS 7/2015
##################################################

#Setup
 vlib work 
 vmap work work

#Include Netlist and Testbench
#vlog +acc -incr /courses/ee6321/share/ibm13rflpvt/verilog/ibm13rflpvt.v
 vlog +acc -incr asyn_fifo.v
 vlog +acc -incr Core.v
# vlog +acc -incr LUT_COE_1_16.v
# vlog +acc -incr LUT_COE_17_32.v
# vlog +acc -incr LUT_COE_33_49.v
# vlog +acc -incr LUT_COE_50_65.v
 vlog +acc -incr LUT_COE_1.v
 vlog +acc -incr LUT_COE_2.v
 vlog +acc -incr LUT_COE_3.v
 vlog +acc -incr LUT_COE_4.v
 vlog +acc -incr testbench.v 

#Run Simulator 

#vsim -voptargs=+acc -t ps -lib work -sdftyp fifo_0=../../dc/fifo/fifo1.syn.sdf testbench 
vsim -voptargs=+acc -t ps -lib work testbench

 do waveformat1.do    
 run -all

