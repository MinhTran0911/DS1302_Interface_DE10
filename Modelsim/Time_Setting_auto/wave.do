onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 50 /Time_Setting_tb/in_clk
add wave -noupdate -height 50 /Time_Setting_tb/in_rstn
add wave -noupdate -height 50 /Time_Setting_tb/in_set
add wave -noupdate -height 50 /Time_Setting_tb/out_hr_en
add wave -noupdate -height 50 /Time_Setting_tb/out_min_en
add wave -noupdate -height 50 /Time_Setting_tb/out_sec_en
add wave -noupdate -height 50 -radix unsigned -radixshowbase 1 /Time_Setting_tb/in_ext_input
add wave -noupdate -height 50 -radix unsigned -radixshowbase 1 /Time_Setting_tb/out_hr
add wave -noupdate -height 50 -radix unsigned -radixshowbase 1 /Time_Setting_tb/out_min
add wave -noupdate -height 50 -radix unsigned -radixshowbase 1 /Time_Setting_tb/out_sec
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {897871 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 392
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {945 ns}
