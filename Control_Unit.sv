/* Authors:			Ammon Dodson & Jake McKenzie
 * Date:		    Jun 6, 2018
 * Description:     reads each instruction from instruction memory, and executes
 *                  that instruction using the datapath.
 *                  TODO: MAKE TEST BENCH
 */
module Control_Unit(
    IR,Clock,
    PC_CLR,PR_ID,PC_IC,
    D_ADDR,D_WR,
    RF_S,RF_RA_ADDR,RB_ADDR,RF_W_EN,RF_W_ADDR,
    ALU_S
);
    input logic [11:0]IR;
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

    output logic [2:0]ALU_S;    //ALU function select
    
    assign [3:0]CurrentState = CU_INIT;

/********************************* OUR INTIAL STATES *********************************/

    localparam  CU_INIT     = 4'h0,//set program counter to zero, and intialize variables
                CU_FETCH    = 4'h1,//grabs next instruction from memory address that is stored
                CU_DECODE   = 4'h2,//parses the first 4 bits of the messages
                CU_LOAD_A   = 4'h3,//loads into the first register in the ALU
                CU_LOAD_B   = 4'h4,//loads into the second register in the ALU
                CU_STORE    = 4'h5,//stores registers into specified locations in memory
                CU_ADD      = 4'h6,//configures the ALU for addition
                CU_SUBTRACT = 4'h7,//configures the ALU for subtraction
                CU_HALT     = 4'h8;//puts the CPU into a sleep mode

/**************************************************************************************/

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
                RF_A_ADDR <= [11:8]IR;
                RF_B_ADDR <= [7:4]IR;
                RF_W_ADDR <= [3:0]IR;
                RF_W_EN <= 1'h1;
                ALU_S <= 3'h1;
                RF_S <= 1'h0;
            end
            CU_SUBTRACT: begin
                RF_A_ADDR <= [11:8]IR;
                RF_B_ADDR <= [7:4]IR;
                RF_W_ADDR <= [3:0]IR;
                RF_W_EN <= 1'h1;
                ALU_S <= 3'h2;
                RF_S <= 1'h0;
            end
            CU_HALT: CurrentState <= CU_INIT;
    end else CurrentState <= CU_INIT;
end                


endmodule