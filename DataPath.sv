/* Authors:			Ammon Dodson & Jake McKenzie
 * Date:		    Jun 6, 2018
 * Description:     Data path module
 */


`include "instructions.vh"


module DataPath #(parameter WIDTH, D_ADDR_W, R_ADDR_W) (
	input[D_ADDR_W-1:0] D_addr,
	input[R_ADDR_W-1:0] RF_W_addr, RF_A_addr, RF_B_addr,
	input      D_wr, RF_s, RF_W_en, clk,
	input[3:0] ALU_sel,
	output[WIDTH-1:0] ALU_A, ALU_B, ALU_Out
);
	logic[WIDTH-1:0] A, B, RF_W;
	logic[WIDTH-1:0]muxIn[1:0];
	
	Mem #(WIDTH, D_ADDR_W) mem(clk, D_wr, D_addr, A, muxIn[0]);
	
	
	Multiplexer #(WIDTH,1) RF_writeSelect(muxIn, RF_s, RF_W);
	
	
	Register_file #(WIDTH,R_ADDR_W) registers(
		clk, RF_W_en,
		RF_W_addr, RF_A_addr, RF_B_addr,
		RF_W, A, B
	);
	
	ALU #(WIDTH) alu(
		.OpCode(ALU_sel), .A(A), .B(B), .Q(muxIn[1]), 
		.Cout(), .Oflow(), .Err(), .Eq()
	);
	
	assign ALU_A   = A;
	assign ALU_B   = B;
	assign ALU_Out = muxIn[1];
	
endmodule


module DataPath_tb;
	localparam WIDTH = 4, D_ADDR_W = 5, R_ADDR_W = 2;
	
	logic[D_ADDR_W-1:0] D_addr;
	logic[R_ADDR_W-1:0] RF_W_addr, RF_A_addr, RF_B_addr;
	logic      D_wr, RF_s, RF_W_en, clk;
	logic[3:0] ALU_sel;
	logic[WIDTH-1:0] ALU_A, ALU_B, ALU_Out;
	
	DataPath #(WIDTH, D_ADDR_W, R_ADDR_W) DUT(
		D_addr,
		RF_W_addr, RF_A_addr, RF_B_addr,
		D_wr, RF_s, RF_W_en, clk,
		ALU_sel,
		ALU_A, ALU_B, ALU_Out
	);
	
	initial begin
		D_addr =0;
		D_wr   =0;
		RF_W_addr = 0;
		RF_A_addr = 0;
		RF_B_addr = 0;
		ALU_sel = `A_ZERO;
		RF_s =0;
		RF_W_en =1;
		
		
		clk =0; #10; clk=1; #10;
		
		// zero out the registers
		for(int i=0; i<2**R_ADDR_W; i++) begin
			RF_W_addr = i;
			clk =0; #10; clk=1; #10;
		end
		RF_W_en =0;
		
		// zero out the memory
		D_wr   =1;
		for(int i=0; i<2**D_ADDR_W; i++) begin
			D_addr = i;
			clk =0; #10; clk=1; #10;
		end
		
		
		
		
	end
endmodule


