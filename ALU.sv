/* Authors:			Ammon Dodson & Jake McKenzie
 * Date:		    Jun 6, 2018
 * Description:     Generalized multiplexer.
 */


`include "instructions.vh"

module ALU #(parameter WIDTH)(
	input[3:0] OpCode,
	input[WIDTH-1:0] A, B,
	output logic [WIDTH-1:0] Q,
	output logic Cout, Oflow, Err, Eq
);
	localparam MAX_IDX = WIDTH-1;
	localparam IDX_SEL = $clog2(WIDTH);
	localparam MAX_SEL = IDX_SEL-1;
	
	
	assign Eq = (A == B);
	
	logic shiftErr, codeErr;
	assign Err = codeErr | shiftErr;
	
	/******************** BARREL SHIFTER *******************/
	
	
	logic[MAX_SEL:0] shift;
	logic[MAX_IDX:0] bs_out;
	logic            bs_right;
	Shifter_barrel #(WIDTH) bshift(bs_right, shift, A, bs_out);
	
	// shift bits
	assign shift = B[MAX_SEL:0];
	
	always_comb case(OpCode) // shiftErr
		`A_SHL : if(B >= WIDTH) shiftErr = 1'b1; else shiftErr = 1'b0;
		`A_SHR : if(B >= WIDTH) shiftErr = 1'b1; else shiftErr = 1'b0;
		`A_ROR : if(B >= WIDTH) shiftErr = 1'b1; else shiftErr = 1'b0;
		`A_ROL : if(B >= WIDTH) shiftErr = 1'b1; else shiftErr = 1'b0;
		default:                shiftErr = 1'b0;
	endcase
	
	always_comb case(OpCode) // bs_right
		`A_ROR : bs_right = 1'b1;
		`A_ROL : bs_right = 1'b0;
		default: bs_right = 1'b0;
	endcase
	
	
	/************************* ADDER ***********************/
	
	
	logic[MAX_IDX+1:0] add_out;
	logic              add_sub;
	Adder #(WIDTH) adder(add_sub, A, B, add_out, Oflow);
	
	always_comb case(OpCode)
		`A_ADD : add_sub = 1'b0;
		`A_SUB : add_sub = 1'b1;
		default: add_sub = 1'b0;
	endcase
	
	
	/************************ OPCODES ***********************/
	
	
	always_comb begin
		codeErr =1'b0;
		Cout = 0;
		
		case(OpCode)
		`A_AND :       Q  =   A & B ;
		`A_OR  :       Q  =   A | B ;
		`A_XOR :       Q  =   A ^ B ;
		`A_NAND:       Q  = ~(A & B);
		`A_ADD : {Cout,Q} = add_out;
		`A_SUB : {Cout,Q} = add_out;
		`A_SHL : {Cout,Q} = A<<shift;
		`A_SHR :       Q  = A>>shift;
		`A_ROL :       Q  = bs_out;
		`A_ROR :       Q  = bs_out;
		
		default: begin
			$display("ALU: bad code");
			codeErr = 1'b1;
			Q = 0;
			end
		endcase
	end
endmodule




module ALU_tb;
	localparam WIDTH = 2;
	localparam WIDER = WIDTH+1;
	
	logic[3:0] opcode;
	logic[WIDTH-1:0] A, B, Q;
	logic cf, of, err, eq;
	
	ALU #(WIDTH) DUT(opcode, A, B, Q, cf, of, err, eq);
	
	always_comb if(eq) assert(A == B);
	
	
	
	initial begin
		for(int i=0; i<2**WIDTH; i++) for(int j=0; j<2**WIDTH; j++) begin
			A = i;
			B = j;
			
			
			opcode = `A_ADD; #10; // test adder
			assert(       i+j  == {cf,Q});
			assert(WIDTH'(i+j) ==     Q );
			if(of) assert(WIDER'(signed'(A)) + WIDER'(signed'(B)) != signed'(Q));
			if(WIDER'(signed'(A)) + WIDER'(signed'(B)) != signed'(Q)) assert(of);
			
			
			opcode = `A_SUB; #10; // test subtracter
			assert( signed'(i)- signed'(j)  == signed'({cf,Q}));
			assert(WIDTH'(i-j) ==     Q );
			if(of) assert(WIDER'(signed'(A)) - WIDER'(signed'(B)) != signed'(Q));
			if(WIDER'(signed'(A)) - WIDER'(signed'(B)) != signed'(Q)) assert(of);
			
			
			opcode = `A_AND; #10; // and
			assert(Q == WIDTH'(i&j))else begin
				$display("");
				$display(i);
				$display(j);
				$display("----");
				$display(i&j);
				$display(Q);
			end
			
			
			opcode = `A_OR; #10;
			assert(WIDTH'(Q) == i|j);
			
			
			opcode = `A_XOR; #10;
			assert(Q == i^j);
		end
		
		
		// shifter tests
		for(int i=0; i<2**WIDTH; i++) for(int j=0; j<WIDTH; j++) begin
			A = i;
			B = j;
			
			opcode = `A_SHL; #10;
			if(!err) begin
				assert(Q == WIDTH'(i<<j)) else begin
					$display($time, ": %04b << %d == %04b", A, B, Q);
				end
				assert(cf ~^ ((i<<j) & (1<<WIDTH) ));
			end
			
			
			opcode = `A_SHR; #10;
			if(!err) assert(Q == WIDTH'(i>>j));
			
			
			opcode = `A_ROR; #10;
			if(!err) assert(Q == (i >> j) | (i << (WIDTH-j)) );
			
			opcode = `A_ROL; #10;
			if(!err) assert(Q == (i << j) | (i >> (WIDTH-j)) ) else
				$display("%04b << %d == %04b", i,j,Q);
			
		end
	end
endmodule


