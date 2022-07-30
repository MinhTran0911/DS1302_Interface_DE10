onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /CLK_div_50_tb/clk_in
add wave -noupdate /CLK_div_50_tb/clk_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {530000 ps} 0} {{Cursor 2} {550001 ps} 0} {{Cursor 3} {1570000 ps} 0}
quietly wave cursor active 3
configure wave -namecolwidth 583
configure wave -valuecolwidth 259
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
configure wave -timelineunits ps
update
WaveRestoreZoom {189 ns} {1748846 ps}
