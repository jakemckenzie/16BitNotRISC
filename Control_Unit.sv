/* Authors:			Ammon Dodson & Jake McKenzie
 * Date:		    Jun 6, 2018
 * Description:     reads each instruction from instruction memory, and executes
 *                  that instruction using the datapath.
 *                  TODO: MAKE TEST BENCH
 */


module Control_Unit(
    IR,Clock,OpCode,
    PC_CLR,PR_ID,PC_IC,
    D_ADDR,D_WR,
    RF_S,RF_RA_ADDR,RB_ADDR,RF_W_EN,RF_W_ADDR,
    ALU_S
);
    input logic [15:0]IR;
    input logic Clock;
    input logic Reset;

    output logic PC_CLR;        //Program counter (PC) clear command
    output logic PR_ID;         //PC register load command
    output logic PC_IC;         //PC increment command
    
    output logic [7:0]D_ADDR;   //Data memory address 
    output logic D_WR;          //Data memory write enable

    output logic RF_S;          //Mux select line
    output logic RF_W_EN;       //Register file write enable
    output logic [3:0]RF_A_ADDR //Register file A-side read address
    output logic [3:0]RF_B_ADDR //Register file B-side read address
    output logic [3:0]RF_W_ADDR;//Register file write address 

    output logic [3:0]ALU_S;    //ALU function select
    
    assign [4:0]CurrentState = CU_INIT;

/********************************* OUR INTIAL STATES *********************************/

    localparam  CU_INIT     = 5'h0,     //set program counter to zero, and intialize variables
                CU_FETCH    = 5'h1,     //grabs next instruction from memory address that is stored
                CU_DECODE   = 5'h2,     //parses the first 4 bits of the messages
                CU_LOAD_A   = 5'h3,     //loads into the first register in the ALU
                CU_LOAD_B   = 5'h4,     //loads into the second register in the ALU
                CU_STORE    = 5'h5,     //stores registers into specified locations in memory
                CU_ADD      = 5'h6,     //configures the ALU for addition
                CU_SUB      = 5'h7,     //configures the ALU for subtraction
                CU_AND      = 5'h8,     //configures the ALU for and
                CU_OR       = 5'h9,     //configures the ALU for or
                CU_XOR      = 5'hA,     //configures the ALU for xor
                CU_NAND     = 5'hB,     //configures the ALU for nand
                CU_SHL      = 5'hC,     //configures the ALU for shift left
                CU_SHR      = 5'hD,     //configures the ALU for shift right
                CU_ROL      = 5'hF,     //configures the ALU for rotate left
                CU_ROR      = 5'h10,    //configures the ALU for rotate right
                // CU_BEQ      = 5'h11,    //configures the ALU for "branch if equal"
                // CU_BNE      = 5'h12,    //configures the ALU for "branch if not-equal"
                // CU_BLT      = 5'h13,    //configures the ALU for "branch if greater than"
                // CU_BGE      = 5'h14,    //configures the ALU for "branch if less than"
                // CU_JAL      = 5'h15,    //configures the ALU for "branch if less than"
                CU_HALT     = 5'h16,    //puts the CPU into a sleep mode
                CU_NOOP     = 5'h17;    //Stall for one cycle and then goes again

/**************************************************************************************/

//***CONFUSION: ASK AMMON WHAT HE THINKS ABOUT JUMP INSTRUCTION: 
always_ff @(posedge Clock) begin
    //Initialize all outputs to zero
    PC_CLR <= 1'h0;
    PR_ID <= 1'h0;
    PC_IC <= 1'h0;
    D_ADDR <= 8'h0;
    D_WR <= 1'h0;
    RF_S <= 1'h0;
    RF_W_EN <= 1'h0;
    RF_A_ADDR <= 4'h0;
    RF_B_ADDR <= 4'h0;
    RF_W_ADDR <= 4'h0;
    ALU_S <= 3'h0;
    if (Reset) begin
        case(CurrentState) 
            CU_INIT: begin
                PC_CLR <= 1'h1;
            end
            CU_FETCH: begin
                PR_ID <= 1'h1;
            end
            CU_DECODE: begin
                PC_IC <= 1'h1;
                case(IR[15:12]) 
                    `P_NOOP: CurrentState <= CU_NOOP;
                    `P_STORE: CurrentState <= CU_STORE;
                    `P_LOAD: CurrentState <= CU_LOAD;
                    `P_ADD: CurrentState <= CU_ADD;
                    `P_SUB: CurrentState <= CU_SUB;
                    `P_HALT: CurrentState <= CU_HALT;
            end
            CU_LOAD_A: begin
                D_ADDR <= IR[11:4];
                RF_S <= 1'h1;
                RF_W_ADDR <= IR[3:0];
            end
            CU_LOAD_B: begin
                D_ADDR <= IR[11:4];
                RF_W_EN <= 1'h1;
                RF_W_ADDR <= IR[3:0];
            end
            CU_STORE: begin
                D_ADDR <= IR[7:0];
                D_WR <= 1'h1;
                RF_W_EN <= 1'h1;
            end
            CU_ADD: begin
                RF_A_ADDR <= IR[11:8];
                RF_B_ADDR <= IR[7:4];
                RF_W_ADDR <= IR[3:0];
                RF_W_EN <= 1'h1;
                ALU_S <= 4'h1;
                RF_S <= 1'h0;
            end
            CU_SUBTRACT: begin
                RF_A_ADDR <= IR[11:8];
                RF_B_ADDR <= IR[7:4];
                RF_W_ADDR <= IR[3:0];
                RF_W_EN <= 1'h1;
                ALU_S <= 4'h2;
                RF_S <= 1'h0;
            end
            CU_AND: begin
                RF_A_ADDR <= IR[11:8];
                RF_B_ADDR <= IR[7:4];
                RF_W_ADDR <= IR[3:0];
                RF_W_EN <= 1'h1;
                ALU_S <= 4'h3;
                RF_S <= 1'h0;
            end
            CU_OR: begin
                RF_A_ADDR <= IR[11:8];
                RF_B_ADDR <= IR[7:4];
                RF_W_ADDR <= IR[3:0];
                RF_W_EN <= 1'h1;
                ALU_S <= 4'h4;
                RF_S <= 1'h0;
            end
            CU_XOR: begin
                RF_A_ADDR <= IR[11:8];
                RF_B_ADDR <= IR[7:4];
                RF_W_ADDR <= IR[3:0];
                RF_W_EN <= 1'h1;
                ALU_S <= 4'h5;
                RF_S <= 1'h0;
            end
            CU_NAND: begin
                RF_A_ADDR <= IR[11:8];
                RF_B_ADDR <= IR[7:4];
                RF_W_ADDR <= IR[3:0];
                RF_W_EN <= 1'h1;
                ALU_S <= 4'h6;
                RF_S <= 1'h0;
            end
            CU_SHL: begin
                RF_A_ADDR <= IR[11:8];
                RF_B_ADDR <= IR[7:4];
                RF_W_ADDR <= IR[3:0];
                RF_W_EN <= 1'h1;
                ALU_S <= 4'h7;
                RF_S <= 1'h0;
            end
            CU_SHR: begin
                RF_A_ADDR <= IR[11:8];
                RF_B_ADDR <= IR[7:4];
                RF_W_ADDR <= IR[3:0];
                RF_W_EN <= 1'h1;
                ALU_S <= 4'h8;
                RF_S <= 1'h0;
            end
            CU_ROL: begin
                RF_A_ADDR <= IR[11:8];
                RF_B_ADDR <= IR[7:4];
                RF_W_ADDR <= IR[3:0];
                RF_W_EN <= 1'h1;
                ALU_S <= 4'h9;
                RF_S <= 1'h0;
            end
            CU_ROR: begin
                RF_A_ADDR <= IR[11:8];
                RF_B_ADDR <= IR[7:4];
                RF_W_ADDR <= IR[3:0];
                RF_W_EN <= 1'h1;
                ALU_S <= 4'hA;
                RF_S <= 1'h0;
            end
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
            // CU_JAL: begin
            //     RF_A_ADDR <= IR[11:8];
            //     RF_B_ADDR <= IR[7:4];
            //     RF_W_ADDR <= IR[3:0];
            //     RF_W_EN <= 1'h1;
            //     ALU_S <= 4'hF;
            //     RF_S <= 1'h0;
            // end
            CU_NOOP: CurrentState <= CU_INIT;
            CU_HALT: CurrentState <= CU_HALT;
    end else CurrentState <= CU_INIT;
end                


endmodule