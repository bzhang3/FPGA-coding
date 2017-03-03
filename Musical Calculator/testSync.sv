module testSync();
	logic clock = 1'b0;
	logic [7:0] Button;
	logic Push;

	Synchronization dutSynchronization(.clock(clock),.Button(Button),.Push(Push));
	
	always #50 clock = ~clock;
	
	initial
	begin
		test(8'b10001000);
		repeat(10) @(negedge clock);
		test(8'b01001000);
		
		test(8'b00101000);
		test(8'b00011000);
		test(8'b10000100);
		test(8'b01000100);
	end
	
	task test(input logic [7:0] a);
		Button <= a;
		repeat(10) @(negedge clock);
	endtask
	
endmodule
