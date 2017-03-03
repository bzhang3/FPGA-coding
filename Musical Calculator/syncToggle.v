module syncToggle(input clk, input signalIn, output signalOut);

	reg internal_in;
	
	always @(posedge clk) begin
		internal_in <= signalIn;
	end
	
	assign signalOut = (internal_in != signalIn);

endmodule
