module createHex(input [3:0] in, output [6:0] hexValueOut);
	
	reg [6:0] hexValue;

	assign hexValueOut = ~hexValue;
	
	always @ (in) begin

		case(in)
			0: hexValue <= 63; //7 segment value for 0
			1: hexValue <= 6; //7 segment value for 1
			2: hexValue <= 91; //7 segment value for 2
			3: hexValue <= 79; //7 segment value for 3
			4: hexValue <= 102; //7 segment value for 4
			5: hexValue <= 109; //7 segment value for 5
			6: hexValue <= 125; //7 segment value for 6
			7: hexValue <= 7; //7 segment value for 7
			8: hexValue <= 127; //7 segment value for 8
			9: hexValue <= 111; //7 segment value for 9
			default: hexValue <= 0; //7 segment value for off
		endcase
	end
	

endmodule
