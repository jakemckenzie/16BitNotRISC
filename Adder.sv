module Adder #(WIDTH) (
	input sub,
	input[WIDTH-1:0] A, B,
	output logic [WIDTH:0] Q,
	output logic OF
);
	always_comb begin
		if(sub) OF = (!A[WIDTH-1] &  B[WIDTH-1] &  Q[WIDTH-1]) |
		             ( A[WIDTH-1] & !B[WIDTH-1] & !Q[WIDTH-1]);
		else    OF = (!A[WIDTH-1] & !B[WIDTH-1] &  Q[WIDTH-1]) |
		             ( A[WIDTH-1] &  B[WIDTH-1] & !Q[WIDTH-1]);
	end
	
	always_comb case(sub)
		0: Q = A+B; // add
		1: Q = A-B; // sub
	endcase
endmodule


module Adder_tb;
	localparam WIDTH=2;
	localparam WIDER= WIDTH+1;
	
	logic sub;
	logic[WIDTH-1:0] A, B;
	logic[WIDTH:0] Q;
	logic of;
	
	Adder #(WIDTH) DUT(sub, A, B, Q, of);
	
	initial begin
		
		// addition
		for(int i=0; i<2**WIDTH; i++) for(int j=0; j<2**WIDTH; j++) begin
			A=i; B=j;
			sub=0; // add
			#10;
			assert(       i+j  ==         Q );
			assert(WIDTH'(i+j) ==  WIDTH'(Q));
			
			if(of) begin
				assert(WIDER'(signed'(A)) + WIDER'(signed'(B)) !=
					signed'(WIDTH'(Q)));
				$display("%d+%d!=%d\t%d!=%d",
					signed'(A), signed'(B), signed'(Q),
					signed'(WIDER'(A)+WIDER'(B)), signed'(WIDTH'(Q)),
				);
			end
			
			
			if(WIDER'(signed'(A)) + WIDER'(signed'(B)) != signed'(WIDTH'(Q))) begin
				assert(of);
				$display("%d+%d!=%d\t%d!=%d",
					signed'(A), signed'(B), signed'(Q),
					signed'(WIDER'(A)+WIDER'(B)), signed'(WIDTH'(Q)),
				);
			end
		end
		
		// subtract
		for(int i=0; i<2**WIDTH; i++) for(int j=0; j<2**WIDTH; j++) begin
			A=i; B=j;
			sub=1; // sub
			#10;
			assert( signed'(i)- signed'(j)  == signed'(Q));
			assert(WIDTH'(i-j) ==  WIDTH'(Q));
			
			if(of) begin
				assert(WIDER'(signed'(A)) - WIDER'(signed'(B)) !=
					signed'(WIDTH'(Q)));
				$display("%d-%d!=%d\t%d!=%d",
					signed'(A), signed'(B), signed'(Q),
					signed'(WIDER'(A)-WIDER'(B)), signed'(WIDTH'(Q)),
				);
			end
			
			
			if(WIDER'(signed'(A)) - WIDER'(signed'(B)) != signed'(WIDTH'(Q))) begin
				assert(of);
				$display("%d-%d!=%d\t%d!=%d",
					signed'(A), signed'(B), signed'(Q),
					signed'(WIDER'(A)-WIDER'(B)), signed'(WIDTH'(Q)),
				);
			end
		end
	end
endmodule



