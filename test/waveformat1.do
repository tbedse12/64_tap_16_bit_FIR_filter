
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/clk_fifo
add wave -noupdate -radix signed /testbench/Y
add wave -noupdate -radix signed /testbench/matlabY
add wave -noupdate -radix signed /Core/out_read_dataX_buffer_1
add wave -noupdate -radix signed /Core/read_count_buffer_1
add wave -noupdate -radix binary /Core/x
add wave -noupdate -radix binary /Core/v
add wave -noupdate -radix binary /Core/Y_register
add wave -noupdate -radix signed /Core/Y_1
add wave -noupdate -radix signed /Core/Y_2
add wave -noupdate -radix signed /Core/Y_3
add wave -noupdate -radix signed /Core/Y_4
add wave -noupdate -radix signed /Core/sum_partial
add wave -noupdate -radix signed /Core/sum_out







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
