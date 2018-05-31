/* Authors:			Ammon Dodson & Jake McKenzie
 * Date:		    Jun 6, 2018
 * Description:     Generalized multiplexer.
 */


module  Register_file #(parameter WIDTH, SELECT_WIDTH) (
	input clk, write,
	input [SELECT_WIDTH-1:0] Waddr, Aaddr, Baddr,
	input [WIDTH-1:0] W,
	output[WIDTH-1:0] A, B
);
	logic[2**SELECT_WIDTH-1:0][WIDTH-1:0] regfile;
	
	assign A = regfile[Aaddr];
	assign B = regfile[Baddr];
	
	always_ff @(posedge clk) if(write) regfile[Waddr] = W;
	
endmodule


module Register_file_tb;
	parameter WIDTH=4, SELECT_WIDTH=3;
	
	logic clk, write;
	logic [SELECT_WIDTH-1:0] Waddr, Aaddr, Baddr;
	logic [WIDTH-1:0] W;
	logic [WIDTH-1:0] A, B;
	
	logic [2**SELECT_WIDTH-1:0][WIDTH-1:0]regs;
	assign regs = DUT.regfile;
	
	
	Register_file #(WIDTH, SELECT_WIDTH)
		DUT(clk, write, Waddr, Aaddr, Baddr, W, A, B);
	
	
	int i;
	initial begin
		//$monitor(DUT.regfile);
		write=0;
		Aaddr=0; Baddr=0;
		
		for(i=0; i<(2**SELECT_WIDTH); i++) begin
			Waddr = i;
			W = 15 - i;
			clk=0; #10; clk=1; #10;
			write=1;
			clk=0; #10; clk=1; #10;
			write=0;
		end
		
		for(i=0; i<(2**SELECT_WIDTH); i++) begin
			Aaddr = i;
			W = i+1;
			clk=0; #10; clk=1; #10;
			assert(A == 15 - i);
			
		end
		
		
	end
	
endmodule


