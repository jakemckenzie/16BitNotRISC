module Adder #(WIDTH) (
	input sub,
	input[WIDTH-1:0] A, B,
	output logic [WIDTH-1:0] Q,
	output logic  CF, OF
);
	
	
	
	always_comb begin
		if(sub) OF = (!A[WIDTH-1] &  B[WIDTH-1] &  Q[WIDTH-1]) |
		             ( A[WIDTH-1] & !B[WIDTH-1] & !Q[WIDTH-1]);
		else    OF = (!A[WIDTH-1] & !B[WIDTH-1] &  Q[WIDTH-1]) |
		             ( A[WIDTH-1] &  B[WIDTH-1] & !Q[WIDTH-1]);
	end
	
	
	
	always_comb case(sub)
		0: {CF,Q} = A+B; // add
		1: {CF,Q} = A-B; // sub
	endcase
	
	
endmodule


module Adder_tb;
	localparam WIDTH=2;
	
	logic sub;
	logic[WIDTH-1:0] A, B;
	logic[WIDTH-1:0] Q;
	logic cf, of;
	
	Adder #(WIDTH) DUT(sub, A, B, Q, cf, of);
	
	initial begin
		for(int i=0; i<2**WIDTH; i++) for(int j=0; j<2**WIDTH; j++) begin
			A=i; B=j;
			sub=0; // add
			#10;
			assert(       i+j  == {cf,Q});
			assert(WIDTH'(i+j) ==     Q );
			
			if(of) begin
				assert(3'(signed'(A)) + 3'(signed'(B)) != signed'(Q));
				$display("%d+%d!=%d\t%d=%d",
					signed'(A), signed'(B), signed'(Q),
					signed'(3'(A)+3'(B)), signed'(Q),
				);
			end
			
			
			if(3'(signed'(A)) + 3'(signed'(B)) != signed'(Q)) begin
				assert(of);
				$display("%d+%d!=%d\t%d=%d",
					signed'(A), signed'(B), signed'(Q),
					signed'(3'(A)+3'(B)), signed'(Q),
				);
			end
		end
		
		for(int i=0; i<2**WIDTH; i++) for(int j=0; j<2**WIDTH; j++) begin
			A=i; B=j;
			sub=1; // add
			#10;
			assert( signed'(i)- signed'(j)  == signed'({cf,Q}));
			assert(WIDTH'(i-j) ==     Q );
			
			if(of) begin
				assert(3'(signed'(A)) - 3'(signed'(B)) != signed'(Q));
				$display("%d-%d!=%d\t%d=%d",
					signed'(A), signed'(B), signed'(Q),
					signed'(3'(A)-3'(B)), signed'(Q),
				);
			end
			
			
			if(3'(signed'(A)) - 3'(signed'(B)) != signed'(Q)) begin
				assert(of);
				$display("%d-%d!=%d\t%d=%d",
					signed'(A), signed'(B), signed'(Q),
					signed'(3'(A)-3'(B)), signed'(Q),
				);
			end
		end
		
	end
endmodule



