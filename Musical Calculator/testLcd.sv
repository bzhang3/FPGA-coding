module testLcd();
	logic CLK=1'b0;
					//LCD Control Signals
	logic [7:0] dataIn;

	logic LCD_ENABLE;
	logic LCD_RW;
	logic LCD_RS;	
					//LCD Data Signals
	logic [7:0] LCD_DATA;
	
	Lcd_sys dutLcd_sys(.CLK(CLK),.dataIn(dataIn),.LCD_ENABLE(LCD_ENABLE),.LCD_RW(LCD_RW),.LCD_RS(LCD_RS),.LCD_DATA(LCD_DATA));
	
	int num=0;
	
	always #50 CLK = ~CLK;
	initial
	begin
		repeat(100) 
		@(negedge CLK)
		begin
			num = $urandom_range(0,16);
		//	num = 4;
			dataIn <= num;
		end
	end
endmodule
					