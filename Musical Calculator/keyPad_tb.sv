module keyPad_tb();

	logic [7:0] inputTokens [15:0] = {8'b10001000, 8'b01001000, 8'b00101000, 8'b00011000, 8'b10000100, 8'b01000100, 8'b00100100, 8'b00010100,
									  8'b10000010, 8'b01000010, 8'b00100010, 8'b00010010, 8'b10000001, 8'b01000001, 8'b00100001, 8'b00010001};

	logic [7:0] tokenSequence1 [0:9] = {8'b00101000, 8'b10000100, 8'b00011000, 8'b01000100, 8'b00100100, 8'b00010100, 8'b00101000, 8'b10000100, 8'b01000100, 8'b00100001}; //34 + 56 - 345E: 
	logic [7:0] equation1 [0:9] = {8'b00101000, 8'b00011000, 8'b11111111, 8'b01000100, 8'b00010100, 8'b01001000, 8'b10111111, 8'b00010010, 8'b10000010, 8'b00100001};//3 + (5 - 2) x 7 E:
	//DUT Signals
	logic [7:0] dataIn;
	logic leftParen = 0;
	logic rightParen = 0;
	
	//Verification Signals
	logic [31:0] token;
	logic wEn;
	logic [5:0] oldWritePtr = 0;
	logic [5:0] wPtr;
	
	logic [4:0] i = 0;

	logic enterKey;
	
	//Clock Signals
	logic clk = 1'b0;
	always #50 clk = ~clk;
	
	keyPadCtrl keyPadCtrlDUT(.keyPadInput(dataIn), .parenthesesLeft(leftParen), .clk(clk),
				.parenthesesRight(rightParen), .tokenToWrite(token), .wEn(wEn), .wPtr(wPtr), .enterKey(enterKey));
				
	initial begin
		$monitor("Token: %d, wPtr: %d", token, wPtr);
		/**repeat(100) begin
			pushRandomButton();
		end*/
		putSequence();
	end
	
	task putSequence();
		for(i=0; i < 10; i++) begin
			@(negedge clk) begin
				if(equation1[i] == 8'b11111111) begin
					leftParen <= 1;
					rightParen <= 0;
					dataIn <= 0;
				end
				else if(equation1[i] == 8'b10111111) begin
						rightParen <= 1;
						leftParen <= 0;
						dataIn <= 0;
				end
				else begin
					rightParen <= 0;
					leftParen <= 0;
					dataIn <= equation1[i];
				end
				repeat(3) @(negedge clk);
			end
			@(negedge clk) begin
				rightParen <= 0;
				leftParen <= 0;
				dataIn <= 0;
			end
			repeat(10) @(negedge clk);
		end
	endtask
	
	task pushRandomButton();
		@(negedge clk) dataIn <= inputTokens[$urandom_range(15,0)];
		@(negedge clk) dataIn <= 0;
		verifyOutput();
		repeat(5) begin
			@(negedge clk) dataIn <= 0;
		end
	endtask
	
	task verifyOutput();
		@(posedge clk) begin
			//assert(wEn == 1);
			//#10 assert(wPtr == (oldWritePtr + 1));
		end
		@(posedge clk) begin
			oldWritePtr <= wPtr;
		end
	endtask
endmodule
