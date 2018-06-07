/* Authors:			Ammon Dodson & Jake McKenzie
 * Date:		    Jun 6, 2018
 * Description:     reads each instruction from instruction memory, and executes
 *                  that instruction using the datapath.
 cd Users/Epimetheus/Documents/GitHub/16BitRISC
 */

`include "instructions.vh"
module Control_Unit(
    IR,Clock,Reset,
    PC_CLR,PC_IC, IR_LD,
    D_ADDR,D_WR,
    RF_S,RF_A_ADDR,RF_B_ADDR,RF_W_EN,RF_W_ADDR,
    ALU_S, CurrentState_Out, NextState_Out
);
    input logic [15:0]IR;
    input logic Clock;
    input logic Reset;

    output logic PC_CLR;        //Program counter (PC) clear command
    output logic PC_IC;         //PC increment command
    
    output logic IR_LD;         //Instruction Register (IR) load command
    
    output logic [7:0]D_ADDR;   //Data memory address 
    output logic D_WR;          //Data memory write enable

    output logic RF_S;          //Mux select line
    output logic RF_W_EN;       //Register file write enable
    output logic [3:0]RF_A_ADDR;//Register file A-side read address
    output logic [3:0]RF_B_ADDR;//Register file B-side read address
    output logic [3:0]RF_W_ADDR;//Register file write address 

    output logic [3:0]ALU_S;    //ALU function select
    output logic [3:0]CurrentState_Out, NextState_Out;

    //logic PC_UPDATE;
    logic [3:0]CurrentState, nextState;
    
    assign CurrentState_Out = CurrentState;
    assign NextState_Out    = nextState;

/***************************** OUR INTIAL STATES ******************************/

    localparam  CU_INIT     = 5'h0,     //set program counter to zero, and intialize variables
                CU_FETCH    = 5'h1,     //grabs next instruction from memory address that is stored
                CU_DECODE   = 5'h2,     //parses the first 4 bits of the messages
                CU_LOAD_A   = 5'h3,     //loads into the first register in the ALU
                CU_LOAD_B   = 5'h4,     //loads into the second register in the ALU
                CU_STORE    = 5'h5,     //stores registers into specified locations in memory
                CU_ADD      = 5'h6,     //configures the ALU for addition
                CU_SUB      = 5'h7,     //configures the ALU for subtraction
          //    CU_JMP      = 5'h8,     //configures the ALU for jump
                CU_HALT     = 5'h9,     //puts the CPU into a sleep mode
                CU_NOOP     = 5'hA;     //Stall for one cycle and then goes again

/******************************************************************************/


always_ff @(posedge Clock) begin
	if(Reset) CurrentState = CU_INIT;
	else      CurrentState = nextState;
end


always_comb begin
    //Initialize all outputs to zero
    //CurrentState[4:0]   <= CU_INIT;

    // only reset the things that must be reset
    PC_CLR              <= 1'h0;
    PC_IC               <= 1'h0;
    IR_LD               <= 1'h0;
    //D_ADDR              <= 8'h0;
    D_WR                <= 1'h0;
    //RF_S                <= 1'h0;
    RF_W_EN             <= 1'h0;
//    RF_A_ADDR           <= 4'h0;
//    RF_B_ADDR           <= 4'h0;
//    RF_W_ADDR           <= 4'h0;
    //ALU_S               <= 3'h0;
    //if (!Reset) begin
        case(CurrentState)
            CU_INIT: begin
                PC_CLR          <= 1'h1;
                nextState    <= CU_FETCH;
            end
            CU_FETCH: begin
                IR_LD           <= 1'h1;
                //PC_IC           <= 1'h1;
                nextState    <= CU_DECODE;
            end
            CU_DECODE: begin
                PC_IC           <= 1'h1;
                case(IR[15:12]) 
                    `P_NOOP:    nextState <= CU_NOOP;
                    `P_STORE:   nextState <= CU_STORE;
                    `P_LOAD:    nextState <= CU_LOAD_A;
                    `P_ADD:     nextState <= CU_ADD;
                    `P_SUB:     nextState <= CU_SUB;
                    `P_HALT:    nextState <= CU_HALT;
               //     `P_JMP:     nextState <= CU_JMP;
                    default:    nextState <= CU_INIT;
                endcase
            end
            CU_LOAD_A: begin
                D_ADDR          <= IR[11:4];
                RF_S            <= 1'h1;
                RF_W_ADDR       <= IR[3:0];
                nextState    <= CU_LOAD_B;
            end
            CU_LOAD_B: begin
                //D_ADDR          <= IR[11:4];
                //RF_S            <= 1'h1;
                RF_W_EN         <= 1'h1;
                //RF_W_ADDR       <= IR[3:0];
                nextState    <= CU_FETCH;
            end
            CU_STORE: begin
                D_ADDR          <= IR[7:0];
                RF_A_ADDR       <= IR[11:8];
                D_WR            <= 1'h1;
                nextState    <= CU_FETCH;
            end
            CU_ADD: begin
                RF_A_ADDR       <= IR[11:8];
                RF_B_ADDR       <= IR[7:4];
                RF_W_ADDR       <= IR[3:0];
                RF_W_EN         <= 1'h1;
                ALU_S           <= `A_ADD;
                RF_S            <= 1'h0;
                nextState    <= CU_FETCH;
            end
            CU_SUB: begin
                RF_A_ADDR       <= IR[11:8];
                RF_B_ADDR       <= IR[7:4];
                RF_W_ADDR       <= IR[3:0];
                RF_W_EN         <= 1'h1;
                ALU_S           <= `A_SUB;
                RF_S            <= 1'h0;
                nextState    <= CU_FETCH;
            end
//            CU_JMP: begin
//                RF_A_ADDR       <= IR[11:8];
//                RF_B_ADDR       <= IR[7:4];
//                RF_W_ADDR       <= IR[3:0];
//                RF_W_EN         <= 1'h1;
//                ALU_S           <= 4'h3;
//                RF_S            <= 1'h0;
//            end
            // CU_AND: begin
            //     RF_A_ADDR <= IR[11:8];
            //     RF_B_ADDR <= IR[7:4];
            //     RF_W_ADDR <= IR[3:0];
            //     RF_W_EN <= 1'h1;
            //     ALU_S <= 4'h3;
            //     RF_S <= 1'h0;
            //     nextState <= CU_FETCH;
            // end
            // CU_OR: begin
            //     RF_A_ADDR <= IR[11:8];
            //     RF_B_ADDR <= IR[7:4];
            //     RF_W_ADDR <= IR[3:0];
            //     RF_W_EN <= 1'h1;
            //     ALU_S <= 4'h4;
            //     RF_S <= 1'h0;
            //     nextState <= CU_FETCH;
            // end
            // CU_XOR: begin
            //     RF_A_ADDR <= IR[11:8];
            //     RF_B_ADDR <= IR[7:4];
            //     RF_W_ADDR <= IR[3:0];
            //     RF_W_EN <= 1'h1;
            //     ALU_S <= 4'h5;
            //     RF_S <= 1'h0;
            //     nextState <= CU_FETCH;
            // end
            // CU_NAND: begin
            //     RF_A_ADDR <= IR[11:8];
            //     RF_B_ADDR <= IR[7:4];
            //     RF_W_ADDR <= IR[3:0];
            //     RF_W_EN <= 1'h1;
            //     ALU_S <= 4'h6;
            //     RF_S <= 1'h0;
            //     nextState <= CU_FETCH;
            // end
            // CU_SHL: begin
            //     RF_A_ADDR <= IR[11:8];
            //     RF_B_ADDR <= IR[7:4];
            //     RF_W_ADDR <= IR[3:0];
            //     RF_W_EN <= 1'h1;
            //     ALU_S <= 4'h7;
            //     RF_S <= 1'h0;
            //     nextState <= CU_FETCH;
            // end
            // CU_SHR: begin
            //     RF_A_ADDR <= IR[11:8];
            //     RF_B_ADDR <= IR[7:4];
            //     RF_W_ADDR <= IR[3:0];
            //     RF_W_EN <= 1'h1;
            //     ALU_S <= 4'h8;
            //     RF_S <= 1'h0;
            //     nextState <= CU_FETCH;
            // end
            // CU_ROL: begin
            //     RF_A_ADDR <= IR[11:8];
            //     RF_B_ADDR <= IR[7:4];
            //     RF_W_ADDR <= IR[3:0];
            //     RF_W_EN <= 1'h1;
            //     ALU_S <= 4'h9;
            //     RF_S <= 1'h0;
            //     nextState <= CU_FETCH;
            // end
            // CU_ROR: begin
            //     RF_A_ADDR <= IR[11:8];
            //     RF_B_ADDR <= IR[7:4];
            //     RF_W_ADDR <= IR[3:0];
            //     RF_W_EN <= 1'h1;
            //     ALU_S <= 4'hA;
            //     RF_S <= 1'h0;
            //     nextState <= CU_FETCH;
            // end
            
            // CU_BEQ: begin
            //     RF_A_ADDR <= IR[11:8];
            //     RF_B_ADDR <= IR[7:4];
            //     RF_W_ADDR <= IR[3:0];
            //     RF_W_EN <= 1'h1;
            //     ALU_S <= 4'hB;
            //     RF_S <= 1'h0;
            // end
            // CU_BNE: begin
            //     RF_A_ADDR <= IR[11:8];
            //     RF_B_ADDR <= IR[7:4];
            //     RF_W_ADDR <= IR[3:0];
            //     RF_W_EN <= 1'h1;
            //     ALU_S <= 4'hC;
            //     RF_S <= 1'h0;
            // end
            // CU_BLT: begin
            //     RF_A_ADDR <= IR[11:8];
            //     RF_B_ADDR <= IR[7:4];
            //     RF_W_ADDR <= IR[3:0];
            //     RF_W_EN <= 1'h1;
            //     ALU_S <= 4'hD;
            //     RF_S <= 1'h0;
            // end
            // CU_BGE: begin
            //     RF_A_ADDR <= IR[11:8];
            //     RF_B_ADDR <= IR[7:4];
            //     RF_W_ADDR <= IR[3:0];
            //     RF_W_EN <= 1'h1;
            //     ALU_S <= 4'hE;
            //     RF_S <= 1'h0;
            // end
            CU_NOOP: nextState <= CU_FETCH;
            CU_HALT: nextState <= CU_HALT;
            default: nextState <= CU_INIT;
        endcase
    //end else nextState <= CU_INIT;
end                


endmodule
