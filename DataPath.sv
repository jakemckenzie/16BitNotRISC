/*	Authors:			Ammon Dodson & Jake McKenzie
 *	Date:		    Jun 6, 2018
 *	Description:     Data path module
 *
 *	RF_s 0: ALU, 1: Datamemory
 *
 */


`include "instructions.vh"
`timescale 1 ps / 1 ps

module DataPath #(parameter WIDTH, D_ADDR_W, R_ADDR_W) (
	input[D_ADDR_W-1:0] D_addr,
	input[R_ADDR_W-1:0] RF_W_addr, RF_A_addr, RF_B_addr,
	input      D_wr, RF_s, RF_W_en, clk,
	input[3:0] ALU_sel,
	output[WIDTH-1:0] ALU_A, ALU_B, ALU_Out
);
	logic[WIDTH-1:0] A, B, RF_W;
	logic[WIDTH-1:0]muxIn[1:0];
	
	//Mem #(WIDTH, D_ADDR_W) mem(clk, D_wr, D_addr, A, muxIn[0]);
	
	dRAM	dRAM_inst (
		.address ( D_addr ),
		.clock ( clk ),
		.data ( A ),
		.wren ( D_wr ),
		.q ( muxIn[0] )
	);
	
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
	localparam WIDTH = 16, D_ADDR_W = 8, R_ADDR_W = 4;
	
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
		$monitor($time, ": %h %h, %h",
			DUT.registers.regfile[0],
			DUT.registers.regfile[1],
			DUT.muxIn[0]
		);
		
//		for(int i=0; i<256; i++) begin
//			D_addr = i;
//			
//			clk =0; #10; clk=1; #10;
//			$display("%h: %h", i, DUT.muxIn[0]);
//		end
		
		D_addr =0;
		D_wr   =0;
		RF_W_addr = 0;
		RF_A_addr = 0;
		RF_B_addr = 0;
		ALU_sel = `A_ADD;
		RF_s =1;
		RF_W_en =0;
		
		
		// load
		clk =0; #10; clk=1; #10;
		D_addr = 8'h0B;
		clk =0; #10; clk=1; #10;
		RF_W_en =1;
		clk =0; #10; clk=1; #10;
		RF_W_en =0;
		
		// load
		RF_W_addr = 1;
		D_addr = 8'h1B;
		clk =0; #10; clk=1; #10;
		RF_W_en =1;
		clk =0; #10; clk=1; #10;
		RF_W_en =0;
		
		// subtract
		RF_W_addr = 0;
		RF_A_addr = 0;
		RF_B_addr = 1;
		ALU_sel = `A_SUB;
		RF_s =0; // alu
		clk =0; #10; clk=1; #10;
		RF_W_en =1;
		clk =0; #10; clk=1; #10;
		RF_W_en =0;
		
		RF_A_addr = 0;
		
		D_addr = 8'hCD;
		clk =0; #10; clk=1; #10;
		D_wr =1;
		clk =0; #10; clk=1; #10;
		D_wr =0;
		
		// zero out the registers
//		for(int i=0; i<2**R_ADDR_W; i++) begin
//			RF_W_addr = i;
//			clk =0; #10; clk=1; #10;
//		end
//		RF_W_en =0;
//		
//		// zero out the memory
//		D_wr   =1;
//		for(int i=0; i<2**D_ADDR_W; i++) begin
//			D_addr = i;
//			clk =0; #10; clk=1; #10;
//		end
		
		
		
		
	end
endmodule


