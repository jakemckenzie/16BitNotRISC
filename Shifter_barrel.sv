module Shifter_barrel #(parameter WIDTH) (RotRight, Shift, In, Out);
	localparam MAX_IDX = WIDTH-1;
	localparam IDX_SEL = $clog2(WIDTH);
	localparam MAX_SEL = IDX_SEL-1;
	
	input  logic            RotRight;
	input  logic[MAX_SEL:0] Shift;
	input  logic[MAX_IDX:0] In;
	output logic[MAX_IDX:0] Out;
	
	
	
	// reverse barrel shifter
	logic[MAX_SEL:0] barrel_shift;
	always_comb begin
		if(!RotRight && Shift>0) barrel_shift <= IDX_SEL'(WIDTH - Shift);
		else barrel_shift <= Shift;
	end
	
	
	genvar i;
	Mux #(IDX_SEL,1) barrel_shifter0(
		barrel_shift,
		In,
		Out[0]
	);
	generate
		for(i=1; i<WIDTH; i++) begin: muxArray
			Mux #(IDX_SEL,1) barrel_shifter(
				barrel_shift,
				{In[i-1:0],In[WIDTH-1:i]},
				Out[i]
			);
		end
	endgenerate
	
	
	
endmodule


module Shifter_barrel_tb;
	localparam WIDTH   = 4;
	localparam MAX_IDX = WIDTH-1;
	localparam IDX_SEL = $clog2(WIDTH);
	localparam MAX_SEL = IDX_SEL-1;
	
	logic [MAX_IDX:0] in;
	logic [MAX_SEL:0] shift;
	logic             rotright;
	logic [MAX_IDX:0] out;
	
	Shifter_barrel #(WIDTH) DUT(rotright, shift, in, out);
	
	initial for(int i=0; i<2**WIDTH; i++) for(int j=0; j<WIDTH; j++) begin
		in = i;
		shift = j;
		
		rotright = 1'b1;
		#10;
		assert(out == (i >> j) | (i << (WIDTH-j)) );
		
		rotright = 1'b0;
		#10;
		assert(out == (i << j) | (i >> (WIDTH-j)) ) else
			$display("%04b << %0d == %04b",
				i,j,out);
		
	end
	
endmodule
