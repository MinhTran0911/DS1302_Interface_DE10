onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Sev_Seg_Display_tb/in_hr
add wave -noupdate /Sev_Seg_Display_tb/in_min
add wave -noupdate /Sev_Seg_Display_tb/in_sec
add wave -noupdate {/Sev_Seg_Display_tb/out_HEX[5]}
add wave -noupdate {/Sev_Seg_Display_tb/out_HEX[4]}
add wave -noupdate {/Sev_Seg_Display_tb/out_HEX[3]}
add wave -noupdate {/Sev_Seg_Display_tb/out_HEX[2]}
add wave -noupdate {/Sev_Seg_Display_tb/out_HEX[1]}
add wave -noupdate {/Sev_Seg_Display_tb/out_HEX[0]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {179179 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 451
configure wave -valuecolwidth 61
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
WaveRestoreZoom {4309 ps} {165013 ps}
