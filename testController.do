# Create work library
vlib work

vlog "./Controller.sv"
vlog "./Control_Unit.sv"
vlog "./iROM.v"
#vlog "./Mem.sv"

vsim -t 1ps -L altera_mf_ver -lib work Controller_tb

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -hex /Controller_tb/*
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 200
configure wave -valuecolwidth 50
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
WaveRestoreZoom {0 ps} {1 ns}


# Run the simulation
run -all

# End
