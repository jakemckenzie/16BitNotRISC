/* Authors:			Ammon Dodson & Jake McKenzie
 * Date:		    Jun 6, 2018
 * Description:     Data path module
 */



module DataPath #(parameter WIDTH, D_ADDR_W, R_ADDR_W) (
	input[D_ADDR_W-1:0] D_addr,
	input[R_ADDR_W-1:0] RF_W_addr, RF_A_addr, RF_B_addr,
	input      D_wr, RF_s, RF_W_en, clk,
	input[3:0] ALU_sel
);
	logic[WIDTH-1:0] A, B, RF_W;
	logic[WIDTH-1:0]muxIn[1:0];
	
	Mem #(WIDTH, D_ADDR_W) mem(clk, D_wr, D_addr, A, muxIn[1]);
	
	
	Multiplexer #(WIDTH,1) RF_writeSelect(muxIn, RF_s, RF_W);
	
	
	Register_file #(WIDTH,R_ADDR_W) registers(
		clk, RF_W_en,
		RF_W_addr, RF_A_addr, RF_B_addr,
		RF_W, A, B
	);
	
	ALU #(WIDTH) alu(
		.OpCode(ALU_sel), .A(A), .B(B), .Q(muxIn[0]), 
		.Cout(), .Oflow(), .Err(), .Eq()
	);
	
endmodule


module DataPath_tb;
	
	
	
endmodule


