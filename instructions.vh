/* Authors:			Ammon Dodson & Jake McKenzie
 * Date:		    Jun 6, 2018
 * Description:     Generalized multiplexer.
 */


// instruction header



`ifndef _instruction_vh
`define _instruction_vh


// ALU Selectors
`define  A_ADD 4'b0000
`define  A_SUB 4'b0001

`define  A_AND  4'b0100
`define  A_OR   4'b0101
`define  A_XOR  4'b0110
`define  A_NAND 4'b0111

`define  A_SHL 4'b1000
`define  A_SHR 4'b1001
`define  A_ROL 4'b1010
`define  A_ROR 4'b1011


// Processor Op Codes
`define P_NOOP  4'b0000
`define P_STORE 4'b0001
`define P_LOAD  4'b0010
`define P_ADD   4'b0011
`define P_SUB   4'b0100
`define P_HALT  4'b0101
`define P_JMP   4'b0101

`endif

