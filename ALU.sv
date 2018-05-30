
`include "instructions.vh"

module ALU #(parameter WIDTH)(
	input[3:0] OpCode,
	input[WIDTH-1:0] A, B,
	output logic [WIDTH-1:0] Q,
	output logic Cout, Err
);
	localparam MAX_IDX = WIDTH-1;
	localparam IDX_SEL = $clog2(WIDTH);
	localparam MAX_SEL = IDX_SEL-1;
	
	logic[MAX_SEL:0] shift;
	
	// shift bits
	assign shift = B[MAX_SEL:0];
	
	
	/** BARREL SHIFTER **/
	logic[MAX_IDX:0] bs_out;
	logic            bs_right;
	Shifter_barrel #(WIDTH) bshift(bs_right, shift, A, bs_out);
	
	
	// operations
	always_comb begin
		Err <= 1'b0;
		Cout <= 0;
		bs_right <=1'b0;
		
		case(OpCode)
		`A_ADD: begin // add
			{Cout,Q} <= A + B;
			end
		`A_SUB: begin // sub
			Q <= A - B;
			end
		
		`A_AND: begin // and
			Q <= A & B;
			end
		
		`A_OR: begin // or
			Q <= A | B;
			end
		
		`A_XOR: begin // xor
			Q <= A ^ B;
			end
		
		`A_NAND: begin // nand
				Q <= ~(A & B);
			end
		
		`A_SHL: begin // shl
			Q <= A<<shift;
			if(B >= WIDTH) Err <=1'b1;
			end
		
		`A_SHR: begin // shr
			Q <= A>>shift;
			if(B >= WIDTH) Err <=1'b1;
			end
		
		
//		4'b0111: ;// shrs
		`A_ROL: begin // rol
				bs_right <= 1'b0;
				Q <= bs_out;
				if(B >= WIDTH) Err <=1'b1;
			end
		
		`A_ROR: begin // ror
				bs_right <= 1'b1;
				Q <= bs_out;
				if(B >= WIDTH) Err <=1'b1;
			end
		
//		
//		
//		4'b1000: ;// nor
//		
//		
//		4'b1110: ;// muls
//		4'b1111: ;// mulu
//		4'b0000: ;// divs
//		4'b0001: ;// divu
		default: begin
			$display("ALU: bad code");
			Err <= 1'b1;
			Q <= 0;
			end
		endcase
	end
endmodule




module ALU_tb;
	parameter WIDTH = 4;
	
	
	logic[3:0] opcode;
	logic[WIDTH-1:0] left, right, result;
	//logic[1:0] bshift;
	logic cout, err;
	
	ALU #(WIDTH) DUT(opcode, left, right, result, cout, err);
	
	initial begin
		
		
		for(int i=0; i<2**WIDTH; i++) for(int j=0; j<2**WIDTH; j++) begin
			left = i;
			right = j;
			
			
			opcode = `A_ADD; // test adder
			#10 assert({cout,result} == j+i );
			
			opcode = `A_SUB; // test subtracter
			#10;
			if(i-j>=0) assert(result == i-j);
			// TODO else
			
			opcode = `A_AND; // and
			#10;
			assert(result == 4'(i&j))else begin
				$display("");
				$display(i);
				$display(j);
				$display("----");
				$display(i&j);
				$display(result);
			end
			
			opcode = `A_OR;
			#10 assert(result == i|j);
			
			opcode = `A_XOR;
			#10;
			assert(result == i^j);
		end
		
		
		// shifter tests
		for(int i=0; i<2**WIDTH; i++) for(int j=0; j<WIDTH; j++) begin
			left = i;
			right = j;
			
			opcode = `A_SHL;
			#10;
			if(!err) begin
				assert(result == 4'(i<<j));
				assert(cout ~^ ((i<<j) & (1<<WIDTH) ));
			end
			
			
			opcode = `A_SHR;
			#10;
			if(!err) assert(result == 4'(i>>j));
			
			
			opcode = `A_ROR;
			#10;
			if(!err) assert(result == (i >> j) | (i << (WIDTH-j)) );
			
			opcode = `A_ROL;
			#10;
			if(!err)
				assert(result == (i << j) | (i >> (WIDTH-j)) ) else
					$display("%04b << %0d  == %04b",
						i,j,result);
			
		end
	end
endmodule


