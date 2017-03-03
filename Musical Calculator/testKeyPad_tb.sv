module top_tb();

	logic clk = 1'b0;
	always #50 clk = ~clk;
	
	logic [3:0] keyPadIn;
	logic [3:0] keyPadOut;
	logic [3:0] ledOut;
	
	logic [31:0] i;
	
	testKeyPad DUT(.clk(clk), .keyPadIn(keyPadIn), .keyPadOut(keyPadOut), .outLED(ledOut));				
	
	initial begin
		pushButton(2);
		repeat(5) @(negedge clk);
		pushButton(1);
	end
	
	task pushButton(input logic [5:0] button);
		if(button == 1) begin
			for(i = 0; i < 10; i++) begin
				@(posedge clk) begin
					if(keyPadOut == 4'b0111) begin
						keyPadIn <= 4'b0111;
						break;
					end
				end
			end
		end
		if (button == 2) begin
			for(i = 0; i < 10; i++) begin
				@(posedge clk) begin
					if(keyPadOut == 4'b0111) begin
						keyPadIn <= 4'b1011;
						break;
					end
				end
			end
		end
		@(negedge clk) begin
			keyPadIn <= 0;
		end
	endtask

endmodule
