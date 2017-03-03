module sevenSegment(input[7:0] in, input[31:0] answer, 
					output [6:0] hex0, output [6:0] hex1, output [6:0] hex2, output [6:0] hex3,
					output [6:0] hex4, output [6:0] hex5, output [6:0] hex6, output [6:0] hex7);
	
	
	wire [3:0] in1;
	wire [3:0] in10;
	
	wire [3:0] ans1;
	wire [3:0] ans10;
	wire [3:0] ans100;
	wire [3:0] ans1000;
	wire [3:0] ans10000;
	wire [3:0] ans100000;

	assign in1 = in%10;
	assign in10 = (in/10)%10;
	
	assign ans1 = answer%10;
	assign ans10 = (answer/10)%10;
	assign ans100 = (answer/100)%10;
	assign ans1000 = (answer/1000)%10;
	assign ans10000 = (answer/10000)%10;
	assign ans100000 = (answer/100000)%10;
	
	createHex outHex6 (.in(in1), .hexValueOut(hex6)); 
	createHex outHex7 (.in(in10), .hexValueOut(hex7));
	
	createHex outHex0 (.in(ans1), .hexValueOut(hex0)); 
	createHex outHex1 (.in(ans10), .hexValueOut(hex1));
	createHex outHex2 (.in(ans100), .hexValueOut(hex2));
	createHex outHex3 (.in(ans1000), .hexValueOut(hex3));
	createHex outHex4 (.in(ans10000), .hexValueOut(hex4));
	createHex outHex5 (.in(ans100000), .hexValueOut(hex5));
	
endmodule
