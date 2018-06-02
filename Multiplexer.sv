/* Authors:			Ammon Dodson & Jake McKenzie
 * Date:		    Jun 6, 2018
 * Description:     Generalized multiplexer.
 */


module Multiplexer
    #(parameter WIDTH, SELECT_WIDTH)
    (input logic [WIDTH - 1 : 0]data_in[2**SELECT_WIDTH],
    input logic [SELECT_WIDTH - 1 : 0]index,
    output logic [WIDTH - 1 : 0]data_out
);
        
        assign data_out = data_in[index];

endmodule

module Multiplexer_testbench();
    
    parameter WIDTH = 8, SELECT_WIDTH = 5;
    
    logic [WIDTH - 1 : 0]data_in[2**SELECT_WIDTH];
    logic [SELECT_WIDTH - 1 : 0]index;
    logic [WIDTH - 1 : 0]data_out;

    Multiplexer #(WIDTH, SELECT_WIDTH) DUT(data_in, index, data_out);
    
    initial begin
    
        for (integer j = 0; j < 2**SELECT_WIDTH; j++) begin
            data_in[j] = j;
        end
        for (integer i = 0; i < 2 **SELECT_WIDTH; i++) begin
            index = i;#1000;
        end
    end
endmodule