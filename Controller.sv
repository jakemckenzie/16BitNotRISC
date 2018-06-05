/* Authors:			Ammon Dodson & Jake McKenzie
 * Date:		    Jun 6, 2018
 * Description:     Controller module
 */
module Controller  #(parameter WIDTH, D_ADDR_W, I_ADDR_W, R_ADDR_W) (
	input clk, reset,
	output D_wr, RF_s, RF_W_en,
	
	output[D_ADDR_W-1:0] D_addr,
	output[R_ADDR_W-1:0] RF_W_addr, RF_A_addr, RF_B_addr,
	output[3:0] ALU_sel,
	
	output[WIDTH-1:0] IR_Out,
	output[I_ADDR_W-1:0] PC_Out
);
	logic[WIDTH-1:0] currentInst, instMemOut;
	logic ir_ld, ip_clr, ip_inc;
	
	// The instruction register
	logic[WIDTH-1:0] ir;
	always_ff @(posedge clk) if(ir_ld) ir = instMemOut;
	
	// The instruction pointer
	logic[I_ADDR_W-1:0] ip;
	always_ff @(posedge clk) if (ip_clr) ip = 0;
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
		.ALU_S(ALU_sel)
	);
	
	assign IR_Out = ir;
	assign PC_Out = ip;
	
endmodule
