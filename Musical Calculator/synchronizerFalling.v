module synchronizerFalling(input clk, input in, output fallingEdge);

	reg internal_in;
	reg sync_in;
	reg another_in;
	
	always @(posedge clk) begin
		internal_in <= in;
		sync_in <= internal_in;
		another_in <= sync_in;
	end
	
	assign fallingEdge = ((~sync_in) & another_in);

endmodule
