/* Authors:			Ammon Dodson & Jake McKenzie
 * Date:		    Jun 6, 2018
 * Description:     Control Unit testbench
 */
module Control_Unit_testbench();
    logic [15:0]IR;
    logic Clock;
    logic Reset;

    logic PC_CLR;
    logic PR_ID;
    logic PC_IC;
    
    logic [7:0]D_ADDR;
    logic D_WR;

    logic RF_S;
    logic RF_W_EN;
    logic [3:0]RF_A_ADDR;
    logic [3:0]RF_B_ADDR;
    logic [3:0]RF_W_ADDR;

    logic [3:0]ALU_S;

    Control_Unit DUT(IR,Clock,Reset,
    PC_CLR,PR_ID,PC_IC,
    D_ADDR,D_WR,
    RF_S,RF_A_ADDR,RF_B_ADDR,RF_W_EN,RF_W_ADDR,
    ALU_S);

    always begin
        Clock = 1'b0;       #10;
        Clock = !Clock;     #10;
    end
    initial begin
        $display("IR       |   State  |  PC_CLR  |   PR_ID  |   PC_IC  |  D_ADDR  |   D_WR   |   RF_S   |  RF_W_EN | RF_A_ADDR| RF_B_ADDR| RF_W_ADDR|   ALU_S  ");
        Reset = 1; #100;
        Reset = 0; #100;
        for (integer i = 0; i < 7; i++) IR <= 16'h0;
        #100;
        IR[11:8]    <= 4'b1010;
        IR[7:4]     <= 4'b1001;
        IR[3:0]     <= 4'b0101;
        #100;
        for (integer j = 0; j < 7; j++) begin 
            IR[15:12] <= j;#100;
            $monitor("%h            %h         %b         %b         %b         %h         %b         %b         %b          %h        %h         %h        %h",IR,DUT.CurrentState,PC_CLR, PR_ID,PC_IC,D_ADDR,D_WR,RF_S,RF_W_EN,RF_A_ADDR,RF_B_ADDR, RF_W_ADDR,ALU_S);
        end
        $stop;
    end
    
endmodule