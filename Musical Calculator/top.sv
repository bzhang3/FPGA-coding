module top/*(input logic [7:0] keyPadInput, input logic parenthesesLeft, output logic [3:0] outLED,
		   input logic parenthesesRight, input logic clk, output logic [6:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7);
*/
	(input logic [3:0] keyPadInput, input logic parenthesesLeft, output logic [3:0] outLED,
		   input logic parenthesesRight, input logic clk, output logic [3:0] keyPadOutput,
		   output logic [6:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7, output logic testLED,
			output logic lcd_enable, output logic lcd_rw, lcd_rs, output logic [7:0] lcd_data, output logic [7:0] testingLEDs,
			output logic TP1, TP2, TP3, input logic solved, input logic CLOCK_27, output logic AUD_ADCLRCK, input logic AUD_ADCDAT, 
			output logic AUD_DACLRCK, output logic AUD_DACDAT, input logic [3:0] KEY, inout AUD_BCLK, output logic AUD_XCK, inout I2C_SDAT, output I2C_SCLK);
		
	logic [7:0] keyPadDecoded;
	logic syncLeftParen;
	logic syncRightParen;
	
	
	//Infix FIFO: from input to shunting yard
	logic [31:0] inFixToken;
	logic inputWen;
	logic [5:0] inputWptr;
	logic [5:0] inputRptr;
	logic inputRen;
	logic [31:0] tokenFromInputtoSY;
	
	assign TP1 = inputRen;
	assign TP2 = enterKey;
	assign TP3 = doneSolving;
	
	logic clk4Hz;
	
	
	
	//Postfix FIFO: from shunting yard to solve
	logic [31:0] postFixToken;
	logic postFixWen;
	logic [5:0] postFixWptr;
	logic [5:0] postFixRptr;
	logic postFixRen;
	logic [31:0] tokenFromSYtoSolve;
	
	logic enterKey;
	logic solveSignal;
	logic doneSolving;
	
	logic [3:0] keyPadIn;
	
	logic [31:0] answer;
	logic [31:0] lcdToken;
	
	logic resetMem;
	
	assign testLED = solved;
	
	//assign testingLEDs[7:1] = lcdToken[7:1];
	
	keyPadSync keyPadUnit(.clock(clk4Hz), 
				.buttonIn(keyPadInput),
				.syncButtonOut(keyPadIn));
	
	clockdiv clock2Hz(.iclk(clk), .oclk(clk4Hz));
	
	testKeyPad keyPadDecoder(.clk(clk4Hz), .keyPadIn(keyPadIn), .keyPadOut(keyPadOutput), .outLED(outLED), .output8bit(keyPadDecoded));
	
	keyPadCtrl keyPadCtrlUnit(.keyPadInput(keyPadDecoded), .parenthesesLeft(syncLeftParen), .clk(clk4Hz), .doneSolving(doneSolving), .resetMem(resetMem),
				.parenthesesRight(syncRightParen), .tokenToWrite(inFixToken), .wEn(inputWen), .wPtr(inputWptr), .enterKey(enterKey), .LCD_TOKEN(lcdToken));
				
	Lcd_sys lcd_controller(.CLK(clk4Hz), .dataIn(lcdToken), .LCD_ENABLE(lcd_enable), .LCD_RW(lcd_rw), .LCD_RS(lcd_rs), .LCD_DATA(lcd_data), .testLED(testingLEDs[0]));
	
	synchronizerFalling leftParenSync(.clk(clk), .in(parenthesesLeft), .fallingEdge(syncLeftParen));
	synchronizerFalling rightParenSync(.clk(clk), .in(parenthesesRight), .fallingEdge(syncRightParen));
	
	
	inputMem infixFIFO(.inToken(inFixToken), .wEn(inputWen), .wPtr(inputWptr), .clk(clk),
							.rEn(inputRen), .rPtr(inputRptr), .outToken(tokenFromInputtoSY));
							
	shuntingYard eqProcessor(.inputToken(tokenFromInputtoSY), .inputPtr(inputRptr), .readInputEnable(inputRen),
							 .maxWritePtr(inputWptr), .enterKeyPushed(enterKey), .clk(clk), 
							 .outputWrEn(postFixWen), .outputPtr(postFixWptr), .outputToken(postFixToken), .solveSignal(solveSignal));
							 
	inputMem postFixFIFO(.inToken(postFixToken), .wEn(postFixWen), .wPtr(postFixWptr), .clk(clk),
								.rEn(postFixRen), .rPtr(postFixRptr), .outToken(tokenFromSYtoSolve));

	calculateNotation solveEq(.clk(clk), .readyGo(solveSignal), .fromShunt(postFixWptr), .inToken(tokenFromSYtoSolve), 
							  .rPtr(postFixRptr), .rEn(postFixRen), .done(doneSolving), .answer(answer));
	
	sevenSegment sevenSegUnit(.in(postFixRptr), .answer(answer), 
					.hex0(hex0), .hex1(hex1), .hex2(hex2), .hex3(hex3),
					.hex4(hex4), .hex5(hex5), .hex6(hex6), .hex7(hex7));
					
	music_top musicController(.solved(solved), .KEY(KEY), .CLOCK_50(clk), .CLOCK_27(CLOCK_27), .I2C_SDAT(I2C_SDAT), .I2C_SCLK(I2C_SCLK), .AUD_ADCLRCK(AUD_ADCLRCK), .AUD_ADCDAT(AUD_ADCDAT), .AUD_DACLRCK(AUD_DACLRCK),
							  .AUD_DACDAT(AUD_DACDAT), .AUD_BCLK(AUD_BCLK), .AUD_XCK(AUD_XCK));							 
endmodule
