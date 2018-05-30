module #(WIDTH, SELECT_WIDTH) Register_file(
	input clk, write,
	input [SELECT_WIDTH-1:0] Waddr, Aaddr, Baddr,
	input [WIDTH-1:0] W,
	output[WIDTH-1:0] A, B
);
	logic[2**SELECT_WIDTH-1:0][WIDTH-1:0] regfile;
	
	assign A = regfile[Aaddr];
	assign B = regfile[Baddr];
	
	always_ff @(posedge clk) write? regfile[Waddr] = W;
	
endmodule




