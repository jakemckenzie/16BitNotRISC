



module #(parameter WIDTH, D_ADDR_WIDTH) DataPath(
	input[D_ADDR_WIDTH-1:0] D_addr,
	input      D_wr, RF_s, RF_W_en, clk,
	input[3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr,
	input[3:0] ALU_sel
);
	
	[WIDTH-1:0] DataMem[2**D_ADDR_WIDTH-1:0];
	
	logic[WIDTH-1:0] memIn, memOut, A, B, RF_W, ALU_Q;
	
	always_ff @(posedge clk) D_wr? DataMem[D_addr] = A;
	
	logic[WIDTH-1:0]muxIn[1:0]
	assign muxIn[1] = DataMem[D_addr];
	Multiplexer #(WIDTH,1) RF_writeSelect(muxIn, RF_s, RF_W);
	
	
	Register_file #(WIDTH,4) registers(
		clk, D_wr,
		RF_W_addr, RF_Ra_addr, RF_Rb_addr,
		RF_W, A, B
	);
	
	ALU #(WIDTH) alu(ALU_sel, A, B, muxIn[0],  ,);
	
endmodule
