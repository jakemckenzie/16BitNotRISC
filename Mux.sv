
// A generic multiplexer
module Mux #(parameter SELECT_BITS, WIDTH) (
	input [SELECT_BITS-1:0]                 select,
	input [(2**SELECT_BITS)-1:0][WIDTH-1:0] in,
	output[WIDTH-1:0]                       out
);
	assign out = in[select];
endmodule


module Mux_tb;
	parameter SELECT_BITS = 2;
	parameter WIDTH = 3;
	
	logic[SELECT_BITS-1:0]                 select;
	logic[(2**SELECT_BITS)-1:0][WIDTH-1:0] in;
	logic[WIDTH-1:0]                       out;
	
	
	Mux #(SELECT_BITS,WIDTH) DUT(select, in, out);
	
	initial begin
		for(int i=0; i<(2**SELECT_BITS); i++) begin // for each selector
			select = i;
			
			in = 0;
			
			for(int j=0; j<(2**SELECT_BITS); j++) begin // for each input
				in[j] =j; #10;
				assert(in[i] == out);
			end
		end
	end
endmodule

