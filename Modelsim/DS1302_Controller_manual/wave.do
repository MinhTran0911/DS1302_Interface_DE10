onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 50 /DS1302_Controller_tb/clk1
add wave -noupdate -height 50 /DS1302_Controller_tb/rstn
add wave -noupdate -height 50 /DS1302_Controller_tb/rd_btn
add wave -noupdate -height 50 /DS1302_Controller_tb/wr_btn
add wave -noupdate -height 50 /DS1302_Controller_tb/hr
add wave -noupdate -height 50 /DS1302_Controller_tb/min
add wave -noupdate -height 50 /DS1302_Controller_tb/sec
add wave -noupdate -height 50 /DS1302_Controller_tb/time_out
add wave -noupdate -height 50 /DS1302_Controller_tb/CE
add wave -noupdate -height 50 /DS1302_Controller_tb/SCLK
add wave -noupdate -height 50 /DS1302_Controller_tb/IO
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2916080857 ps} 0} {{Cursor 2} {3800000000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 354
configure wave -valuecolwidth 86
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
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {5250 us}
