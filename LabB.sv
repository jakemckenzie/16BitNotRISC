module LabB(
	input CLOCK_50, KEY[3:0], SW[17:0],
	output LEDG[3:0], LEDR[17:0],
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7
);
	localparam WIDTH =16;
	
	assign LEDR = SW;
	assign LEDG = KEY;
	
	logic buttonLink, procClock;
	ButtonSync BS(CLOCK_50, KEY[2], buttonLink);
	KeyFilter Filter(
		.Clock(CLOCK_50), .In(buttonLink), .Out(procClock), .Strobe()
	);
	
	logic[WIDTH-1:0] IR_Out, ALU_A, ALU_B, ALU_Out;
	logic[7:0]  PC_Out, State, NextState;
	Processor proc(procClock, ~KEY[0], 
		IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out
	);
	
	logic[WIDTH-1:0] debugDisplay;
	logic[2:0] selector;
	assign selector[2] = SW[17];
	assign selector[1] = SW[16];
	assign selector[0] = SW[15];
	Mux #(3,WIDTH) Mx(selector,
		{PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out},
		debugDisplay
	);
	
	
	
	// put segment displays in an array
	logic[6:0] HEX[7:0];
	logic[7:0][3:0] hexIn;
	assign HEX0 = HEX[0];
	assign HEX1 = HEX[1];
	assign HEX2 = HEX[2];
	assign HEX3 = HEX[3];
	assign HEX4 = HEX[4];
	assign HEX5 = HEX[5];
	assign HEX6 = HEX[6];
	assign HEX7 = HEX[7];
	
	assign hexIn[3:0] = IR_Out;
	assign hexIn[7:4] = debugDisplay;
	
	Decoder_hex decoders[7:0] (hexIn, HEX);
	
endmodule
