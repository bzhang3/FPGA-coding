module inputMem(input [31:0] inToken, input wEn, input [5:0] wPtr, input clk,
				input rEn, input [5:0] rPtr, output [31:0] outToken);
		   
	reg [31:0] memory[63:0];
	reg [6:0] i;
	reg [31:0] x_outToken;
	
	assign outToken = x_outToken;
	
	initial begin
		for(i = 0; i<64; i=i+1'b1) begin
			memory[i] <= 32'b0;
		end
//		x_outToken <= 0;
	end
	
	always @(posedge clk)
	begin
		if(wEn == 1)
			memory[wPtr] <= inToken;
	end
	
	always @(posedge clk)
	begin
		if(rEn == 1)
			x_outToken <= memory[rPtr];
	end
endmodule

	