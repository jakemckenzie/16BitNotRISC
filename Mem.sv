/* Authors:			Ammon Dodson & Jake McKenzie
 * Date:		    Jun 6, 2018
 * Description:     Data memory module
 */
module Mem #(parameter WIDTH, D_ADDR_WIDTH) (
	input  clk, write,
	input  [D_ADDR_WIDTH-1:0] addr,
	input  [WIDTH-1:0] dataWrite,
	output [WIDTH-1:0] dataRead
);
	logic [WIDTH-1:0] mem[2**D_ADDR_WIDTH-1:0];
	
	always_ff @(posedge clk) if(write) mem[addr] = dataWrite;
	
	assign dataRead = mem[addr];
	
endmodule


module Mem_tb;
	localparam WIDTH=4, D_ADDR_WIDTH=3;
	logic  clk, write;
	logic  [D_ADDR_WIDTH-1:0] addr;
	logic  [WIDTH-1:0] dataWrite;
	logic  [WIDTH-1:0] dataRead;
	
	
	Mem #(WIDTH, D_ADDR_WIDTH) DUT(clk, write, addr, dataWrite, dataRead);
	
	initial begin
		write=0;
		addr =0;
		dataWrite=0;
		
		clk=0; #10; clk=1; #10;
		write=1;
		clk=0; #10; clk=1; #10;
		write=0;
		
	end
endmodule

