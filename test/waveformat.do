
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk1
add wave -noupdate /testbench/clk2
add wave -noupdate -radix signed /testbench/Output
add wave -noupdate -radix signed /testbench/py_output
add wave -noupdate -radix signed /Core/read_count_buffer_1
add wave -noupdate -radix binary /Core/fifo_out_reg
add wave -noupdate -radix signed /Core/sum_partial
add wave -noupdate -radix signed /Core/out_read_dataX
add wave -noupdate -radix signed /testbench/sum

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 223
configure wave -valuecolwidth 89
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {10 ns}
