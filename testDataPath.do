# Create work library
vlib work

vlog "./DataPath.sv"
vlog "./ALU.sv"
#vlog "./Mem.sv"
vlog "./Multiplexer.sv"
vlog "./Register_file.sv"
vlog "./Mux.sv"
vlog "./Adder.sv"
vlog "./Shifter_barrel.sv"
vlog "dRAM.v"


vsim -t 1ps -L altera_mf_ver -lib work DataPath_tb

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DataPath_tb/*
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
