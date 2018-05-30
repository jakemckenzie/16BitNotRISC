module Control_Unit(
    PC_CLR,PR_ID,PC_IC,
    D_ADDR,D_WR,
    RF_S,RF_RA_ADDR,RB_ADDR,RF_W_EN,RF_W_ADDR,
    ALU_S
);

    output logic PC_CLR;        //Program counter (PC) clear command
    output logic PR_ID;         //PC register load command
    output logic PC_IC;         //PC increment command
    
    output logic [7:0]D_ADDR;   //Data memory address 
    output logic D_WR;          //Data memory write enable

    output logic RF_S;          //Mux select line
    output logic RF_W_EN;       //Register file write enable
    output logic [3:0]RF_RA_ADDR//Register file A-side read address
    output logic [3:0]RB_ADDR   //Register file B-side read address
    output logic [3:0]RF_W_ADDR;//Register file write address 

    output logic [2:0]ALU_S;    //ALU function select 

/********************************* OUR INTIAL STATES *********************************/

    localparam  CU_INIT     = 3'h0,//set program counter to zero, and intialize variables
                CU_FETCH    = 3'h1,//grabs next instruction from memory address that is stored
                CU_DECODE   = 3'h2,//parses the first 4 bits of the messages
                CU_LOADA    = 3'h3,//loads into the first register in the ALU
                CU_LOADB    = 3'h4,//loads into the second register in the ALU
                CU_STORE    = 3'h5,//stores registers into specified locations in memory
                CU_ADD      = 3'h6,//configures the ALU for addition
                CU_SUBTRACT = 3'h7,//configures the ALU for subtraction
                CU_HALT     = 3'h8;//puts the CPU into a sleep mode

/**************************************************************************************/


endmodule