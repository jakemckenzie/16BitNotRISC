/*
 *	reset is active high
 */

module Controller  #(parameter WIDTH, D_ADDR_W, I_ADDR_W, R_ADDR_W) (
	input clk, reset,
	output D_wr, RF_s, RF_W_en,
	
	output[D_ADDR_W-1:0] D_addr,
	output[R_ADDR_W-1:0] RF_W_addr, RF_A_addr, RF_B_addr,
	output[3:0] ALU_sel,
	
	output[WIDTH-1:0] IR_Out,
	output[I_ADDR_W-1:0] PC_Out,
	output[7:0] State_Out
);
	logic[WIDTH-1:0] currentInst, instMemOut;
	logic ir_ld, ip_clr, ip_inc;
	
	// The instruction register
	logic[WIDTH-1:0] ir;
	always_ff @(posedge clk) if(reset) ir=0;
	else if(ir_ld) ir = instMemOut;
	
	// The instruction pointer
	logic[I_ADDR_W-1:0] ip;
	always_ff @(posedge clk) if (ip_clr || reset) ip = 0;
	else if(ip_inc) ip++;
	
	// Instruction memory
	Mem #(WIDTH,I_ADDR_W) instructionMem(
		.clk(clk), .write(1'b0),
		.addr(ip), .dataWrite(16'b0), .dataRead(instMemOut)
	);
	
	
	
	Control_Unit c(
		.IR(ir), .Clock(clk), .Reset(reset),
		.PC_CLR(ip_clr), .PC_IC(ip_inc), .IR_LD(ir_ld),
		.D_WR(D_wr), .RF_S(RF_s), .RF_W_EN(RF_W_en),
		.D_ADDR(D_addr),
		.RF_A_ADDR(RF_A_addr), .RF_B_ADDR(RF_B_addr), .RF_W_ADDR(RF_W_addr),
		.ALU_S(ALU_sel), .state(State_Out[4:0])
	);
	
	assign IR_Out = ir;
	assign PC_Out = ip;
	assign State_Out[7:5] =0;
	
endmodule



module Controller_tb;
	localparam WIDTH=16, D_ADDR_W=8, I_ADDR_W=7, R_ADDR_W=4;
	
	logic clk, reset;
	logic D_wr, RF_s, RF_W_en;
	
	logic[D_ADDR_W-1:0] D_addr;
	logic[R_ADDR_W-1:0] RF_W_addr, RF_A_addr, RF_B_addr;
	logic[3:0] ALU_sel;
	
	logic[WIDTH-1:0] IR_Out;
	logic[I_ADDR_W-1:0] PC_Out;
	logic[7:0] state;
	
	Controller #(WIDTH, D_ADDR_W, I_ADDR_W, R_ADDR_W) DUT(
		clk, reset,
		D_wr, RF_s, RF_W_en,
	
		D_addr,
		RF_W_addr, RF_A_addr, RF_B_addr,
		ALU_sel,
	
		IR_Out,
		PC_Out,
		state
	);
	
	logic ip_clr;
	assign ip_clr = DUT.ip_clr;
	
	initial begin
		clk =0; reset =0;
		
		$monitor($time, ": %d", DUT.ip_clr);
		
		for(int i=0; i<2**I_ADDR_W; i++) DUT.instructionMem.mem[i] = i;
		DUT.instructionMem.mem[1] = 16'h3000;
		DUT.instructionMem.mem[2] = 16'h4000;
		
		#10; clk=0; #10; clk=1;
		reset =1;
		#10; clk=0; #10; clk=1;
		reset =0;
		
		
		
		for(int i=0; i<15; i++) begin #10; clk=0; #10; clk=1; end
		
		
	end
endmodule


