module testKeyPad(input clk, input [3:0] keyPadIn, output[3:0] keyPadOut, output[3:0] outLED, output [7:0] output8bit);
	
	reg [3:0] outSeq = 4'b0111;
	reg [3:0] nextOut = 4'b0000;
	reg [3:0] x_outLED;
	reg x_testLED;
	reg [7:0] x_output8bit;

	assign keyPadOut = outSeq;
	
	assign outLED = x_outLED;
	assign output8bit = x_output8bit;

	always @(posedge clk) begin
		outSeq <= nextOut;
	end
	
	always @(posedge clk) begin
		if(outSeq == 4'b0111) nextOut <= 4'b1011;
		else if (outSeq == 4'b1011) nextOut <= 4'b1101;
		else if (outSeq == 4'b1101) nextOut <= 4'b1110;
		else if (outSeq == 4'b1110) nextOut <= 4'b0111;
		else nextOut <= 4'b0111;
	end
	
	always @(posedge clk) begin
		x_testLED <= ~x_testLED;
	end
	
	

	always @(*)
	begin
		case(outSeq)
			4'b0111: begin //1st row (1 2 3 A)
				if(keyPadIn == 4'b0111) begin
					x_outLED = 4'd1; //1
					x_output8bit = 8'b10001000;
				end
				else if (keyPadIn == 4'b1011) begin
					x_outLED = 4'd2; //2
					x_output8bit = 8'b01001000;
				end
				else if (keyPadIn == 4'b1101) begin
					x_outLED = 4'd3; //3
					x_output8bit = 8'b00101000;
				end
				else if (keyPadIn == 4'b1110) begin
					x_outLED = 4'd4; //A
					x_output8bit = 8'b00011000;
				end
				else begin
					x_outLED = 0; //NOTHING
					x_output8bit = 8'b11111111;
				end
			end
			4'b1011: begin //2nd row (4 5 6 B)
				if(keyPadIn == 4'b0111) begin
					x_outLED = 4'd5; //4
					x_output8bit = 8'b10000100;
				end
				else if (keyPadIn == 4'b1011) begin
					x_outLED = 4'd6; //5
					x_output8bit = 8'b01000100;
				end
				else if (keyPadIn == 4'b1101) begin
					x_outLED = 4'd7; //6
					x_output8bit = 8'b00100100;
				end
				else if (keyPadIn == 4'b1110) begin
					x_outLED = 4'd8; //B
					x_output8bit = 8'b00010100;
				end
				else begin
					x_outLED = 0; //NOTHING
					x_output8bit = 8'b11111111;
				end
			end
			4'b1101: begin //3rd row (7 8 9 C)
				if(keyPadIn == 4'b0111) begin
					x_outLED = 4'd9; //7
					x_output8bit = 8'b10000010;
				end
				else if (keyPadIn == 4'b1011) begin
					x_outLED = 4'd10; //8
					x_output8bit = 8'b01000010;
				end
				else if (keyPadIn == 4'b1101) begin
					x_outLED = 4'd11; //9
					x_output8bit = 8'b00100010;
				end
				else if (keyPadIn == 4'b1110) begin
					x_outLED = 4'd12; //C
					x_output8bit = 8'b00010010;
				end
				else begin
					x_outLED = 0; //NOTHING
					x_output8bit = 8'b11111111;
				end
			end
			4'b1110: begin //4th row (0 F E D)
				if(keyPadIn == 4'b0111) begin
					x_outLED = 4'd13; //0
					x_output8bit = 8'b10000001;
				end
				else if (keyPadIn == 4'b1011) begin
					x_outLED = 4'd14; //F
					x_output8bit = 8'b01000001;
				end
				else if (keyPadIn == 4'b1101) begin
					x_outLED = 4'd15; //E
					x_output8bit = 8'b00100001;
				end
				else if (keyPadIn == 4'b1110) begin
					x_outLED = 4'd16; //D
					x_output8bit = 8'b00010001;
				end
				else begin
					x_outLED = 0; //NOTHING
					x_output8bit = 8'b11111111;
				end
			end
			default: begin
				x_outLED = 0;
				x_output8bit = 8'b11111111;
			end
		endcase 
	end
	



endmodule
