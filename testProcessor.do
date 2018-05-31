# Create work library
vlib work

vlog "./testProcessor.sv"
vlog "./Processor.sv"
vlog "./DataPath.sv"
vlog "./Controller.sv"
vlog "./Control_Unit.sv"
vlog "./Mem.sv"
vlog "./Multiplexer.sv"
vlog "./Register_file.sv"


vsim -voptargs="+acc" -t 1ps -lib work testProcessor

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testProcessor/*
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 200
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
WaveRestoreZoom {0 ps} {1 ns}


# Run the simulation
run -all

# End
