onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Clock_w_DS1302_tb/clk50
add wave -noupdate /Clock_w_DS1302_tb/clk1
add wave -noupdate /Clock_w_DS1302_tb/rstn
add wave -noupdate /Clock_w_DS1302_tb/rd_btn
add wave -noupdate /Clock_w_DS1302_tb/wr_btn
add wave -noupdate /Clock_w_DS1302_tb/set_btn
add wave -noupdate /Clock_w_DS1302_tb/CE
add wave -noupdate /Clock_w_DS1302_tb/SCLK
add wave -noupdate /Clock_w_DS1302_tb/IO
add wave -noupdate /Clock_w_DS1302_tb/ext_input
add wave -noupdate /Clock_w_DS1302_tb/hr_en
add wave -noupdate /Clock_w_DS1302_tb/min_en
add wave -noupdate /Clock_w_DS1302_tb/sec_en
add wave -noupdate /Clock_w_DS1302_tb/hr_out
add wave -noupdate /Clock_w_DS1302_tb/min_out
add wave -noupdate /Clock_w_DS1302_tb/sec_out
add wave -noupdate {/Clock_w_DS1302_tb/HEX[5]}
add wave -noupdate {/Clock_w_DS1302_tb/HEX[4]}
add wave -noupdate {/Clock_w_DS1302_tb/HEX[3]}
add wave -noupdate {/Clock_w_DS1302_tb/HEX[2]}
add wave -noupdate {/Clock_w_DS1302_tb/HEX[1]}
add wave -noupdate {/Clock_w_DS1302_tb/HEX[0]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {164970000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 428
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
WaveRestoreZoom {0 ps} {472500 ns}
