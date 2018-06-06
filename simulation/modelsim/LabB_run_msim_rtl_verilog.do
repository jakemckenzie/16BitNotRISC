transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC {C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC/instROM.v}
vlog -sv -work work +incdir+C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC {C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC/ButtonSync.sv}
vlog -sv -work work +incdir+C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC {C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC/Decoder_hex.sv}
vlog -sv -work work +incdir+C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC {C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC/Shifter_barrel.sv}
vlog -sv -work work +incdir+C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC {C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC/Controller.sv}
vlog -sv -work work +incdir+C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC {C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC/Mem.sv}
vlog -sv -work work +incdir+C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC {C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC/KeyFilter.sv}
vlog -sv -work work +incdir+C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC {C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC/Multiplexer.sv}
vlog -sv -work work +incdir+C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC {C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC/Adder.sv}
vlog -sv -work work +incdir+C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC {C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC/Mux.sv}
vlog -sv -work work +incdir+C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC {C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC/Processor.sv}
vlog -sv -work work +incdir+C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC {C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC/Register_file.sv}
vlog -sv -work work +incdir+C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC {C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC/DataPath.sv}
vlog -sv -work work +incdir+C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC {C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC/LabB.sv}
vlog -sv -work work +incdir+C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC {C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC/Control_Unit.sv}
vlog -sv -work work +incdir+C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC {C:/Users/Epimetheus/Documents/GitHub/16BitNotRISC/ALU.sv}

