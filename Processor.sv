module Processor(
	Clk, Reset, IR_Out, PC_Out, StateO, NextState, ALU_A, ALU_B, ALU_Out
);
	input Clk;              // processor clock
	input Reset;            // system reset
	output [15:0] IR_Out;   // Instruction register
	output [6:0] PC_Out;    // Program counter
	output [7:0] StateO;     // FSM current state
	output [7:0] NextState; // FSM next state (or 0 if you don’t use one)
	output [15:0] ALU_A;    // ALU A-Side Input
	output [15:0] ALU_B;    // ALU B-Side Input
	output [15:0] ALU_Out;  // ALU current output
	
	
	localparam WIDTH=16, D_ADDR_W=8, R_ADDR_W=4, I_ADDR_W=7;
	
	logic[R_ADDR_W-1:0] RF_W_addr, RF_A_addr, RF_B_addr;
	logic[D_ADDR_W-1:0] D_addr;
	logic[3:0] ALU_sel;
	logic D_wr, RF_s, RF_W_en;
	
	
	
	Controller #(WIDTH, D_ADDR_W, I_ADDR_W, R_ADDR_W) controller(
		.clk(Clk), .reset(Reset),
		.D_wr(D_wr), .RF_s(RF_s), .RF_W_en(RF_W_en),
		.D_addr(D_addr),
		.RF_W_addr(RF_W_addr), .RF_A_addr(RF_A_addr), .RF_B_addr(RF_B_addr),
		.ALU_sel(ALU_sel),
		.IR_Out(IR_Out), .PC_Out(PC_Out),
		.State_Out(StateO), .NextState_Out(NextState)
	);
	
	DataPath #(WIDTH, D_ADDR_W, R_ADDR_W) datapath(
		.D_addr(D_addr),
		.D_wr(D_wr), .RF_s(RF_s), .RF_W_en(RF_W_en), .clk(Clk),
		.RF_W_addr(RF_W_addr), .RF_A_addr(RF_A_addr), .RF_B_addr(RF_B_addr),
		.ALU_sel(ALU_sel),
		.ALU_A(ALU_A), .ALU_B(ALU_B), .ALU_Out(ALU_Out)
	);
	
endmodule
