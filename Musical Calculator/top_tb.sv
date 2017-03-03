`timescale 1ns/1ns
module top_tb();

	logic [7:0] inputNumbers [0:9] /*0-9*/= {8'b10000001, 8'b10001000, 8'b01001000, 8'b00101000, 8'b10000100, 8'b01000100, 8'b00100100, 8'b10000010, 8'b01000010, 8'b00100010};
	logic [7:0] inputOperations[0:3] /* + - * / */= {8'b00011000, 8'b00010100, 8'b00010010, 8'b00010001};
	logic [4:0] tokens [15:0] = {5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7, 5'd8, 5'd9, 5'd10, 5'd11, 5'd12, 5'd13, 5'd14, 5'd15, 5'd16};
	//									3 			+ 			( 				     5			- 			2 			) 		 		  x 		 	1 			Enter
	logic [7:0] equation1 [0:7] = {8'b00101000, 8'b00011000, /*8'b11111111, */ 8'b01000100, 8'b00010100, 8'b01001000, /*8'b10111111, */8'b00010010, 8'b10001000, 8'b00100001};
	//logic [4:0] equation1Tokens [0:8] = {5'd3, 5'd4, 5'd17, 5'd6, 5'd8, 5'd2, 5'd18, 5'd12, 5'd9};
	
	
	
	//3+(5-2)x7
	//DUT Signals
	logic [7:0] dataIn;
	logic leftParen = 0; 
	logic rightParen = 0;
	
	//Testbench signals
	logic [4:0] i;
	
	logic [31:0] answer;
	
	logic [6:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7;
	
	logic [3:0] keyPadOut;
	
	//Clock Signals
	logic clk = 1'b0;
	always #50 clk = ~clk;
	
	/**top topDUT(.keyPadInput(dataIn), .parenthesesLeft(leftParen), .clk(clk), .parenthesesRight(rightParen), 
			   .hex0(hex0), .hex1(hex1), .hex2(hex2), .hex3(hex3), .hex4(hex4), .hex5(hex5), .hex6(hex6), .hex7(hex7));
	*/
	top topDUT(.keyPadInput(dataIn), .parenthesesLeft(leftParen), .clk(clk),
			   .keyPadOutput(keyPadOut), .parenthesesRight(rightParen), .hex0(hex0), .hex1(hex1),
			   .hex2(hex2), .hex3(hex3), .hex4(hex4), .hex5(hex5), .hex6(hex6), .hex7(hex7));			
				   
	initial begin
		$display("Test Starting");
		$monitor("dataIn: %b/tdataIn: %b", keyPadOut, dataIn);
		/*repeat(5) @(negedge clk);
		putSequence();
		*/repeat(20) @(negedge clk);
		pushButton(1);
		repeat(20) @(negedge clk);//		clearButton();
		pushButton(4);
		repeat(20) @(negedge clk);//		clearButton();
		pushButton(2);
		repeat(20) @(negedge clk);//		clearButton();
		pushButton(15);
		repeat(20) @(negedge clk);	 		clearButton();
		$display("\nLoading");
		
		/**
		repeat(100) begin
			pushRandomSequence();
			pressEnter();
		end
		*/
		$display("End Test");
		
	end

	task pushRandomSequence();
		repeat($urandom_range(3, 1)) begin
			@(negedge clk) dataIn <= inputNumbers[$urandom_range(9, 1)];
			@(negedge clk) dataIn <= 0;
			repeat(5) @(negedge clk);
			@(negedge clk) dataIn <= inputOperations[$urandom_range(3, 0)];
			@(negedge clk) dataIn <= 0;
			repeat(5) @(negedge clk);
		end
		@(negedge clk) dataIn <= inputNumbers[$urandom_range(9, 1)];
		@(negedge clk) dataIn <= 0;
		repeat(5) @(negedge clk);
	endtask
	
	task clearButton();
		dataIn <= 4'b0000;
	endtask
	
	task pushButton(input logic [5:0] button);
		if(button == 1) begin
			for(i = 0; i < 20; i++) begin
				@(posedge clk) begin
					if(keyPadOut == 4'b0111) begin
						dataIn <= 4'b0111;
						break;
					end
					else
						dataIn <= 4'b1111;
				end
			end
		end
		if(button == 4) begin
			for(i = 0; i < 20; i++) begin
				@(posedge clk) begin
					if(keyPadOut == 4'b0111) begin
						dataIn <= 4'b1110;
						break;
					end
					else
						dataIn <= 4'b1111;
				end
			end
		end
		if (button == 2) begin
			for(i = 0; i < 20; i++) begin
				@(posedge clk) begin
					if(keyPadOut == 4'b0111) begin
						dataIn <= 4'b1011;
						break;
					end
					else
						dataIn <= 4'b1111;
				end
			end
		end
		if( button == 15) begin
			for(i = 0; i < 20; i++) begin
				@(posedge clk) begin
					if(keyPadOut == 4'b1110) begin
						dataIn <= 4'b1101;
						break;
					end
					else
						dataIn <= 4'b1111;
				end
			end	
		end
	endtask
	
	task putSequence();
		for(i=0; i < 8; i++) begin
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
			end
			@(negedge clk) begin
				rightParen <= 0;
				leftParen <= 0;
				dataIn <= 0;
			end
			repeat(7) @(negedge clk);
		end
	endtask
	
	task pressEnter();
		repeat(10) @(negedge clk);
		@(negedge clk) dataIn <= 8'b00100001;//enter key code
		@(negedge clk) dataIn <= 0;
	endtask
	
	task verifyOutput(input logic [4:0] i);
		//@(posedge clk) test <= tokens[i];
		//@(posedge clk) begin
		//	assert (token == tokens[i]);
		//end
	endtask
endmodule
