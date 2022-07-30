onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned -radixshowbase 1 /Dec_2_BCD_Decoder_tb/hr_in
add wave -noupdate -radix unsigned -radixshowbase 1 /Dec_2_BCD_Decoder_tb/min_in
add wave -noupdate -radix unsigned -radixshowbase 1 /Dec_2_BCD_Decoder_tb/sec_in
add wave -noupdate /Dec_2_BCD_Decoder_tb/hr_out
add wave -noupdate /Dec_2_BCD_Decoder_tb/min_out
add wave -noupdate /Dec_2_BCD_Decoder_tb/sec_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50825 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 370
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
configure wave -timelineunits ps
update
WaveRestoreZoom {4793 ps} {69053 ps}
