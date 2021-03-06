/*													code
	Instruction					RS R/W B7 B6 B5 B4 B3  B2  B1 B0 Description
	Clear display				0	 0  0  0  0  0  0   0   0   1	
	Cursor home					0   0  0  0  0  0  0   0   1   *
	Entry mode set				0   0  0  0  0  0  0   1   I/D S
	Display on/off control  0   0  0  0  0  0  1   D   C   B
	Cursor/dissplay shift   0   0  0  0  0  1  S/C R/L *   *
	Function set				0   0  0  0  1  DL N   F   *   *
	
	I/D:	=1: Increment							0: Decrement
	S:		=1: Display Shift						0: No Display Shift
	D:		=1: Display On 						0: Display Off
	C:		=1: Cursor On							0: Cursor Off
	B:		=1: Cursor Blink On					0: Cursor Blink Off
	S/C:	=1: Shift Display 					0: Move Cursor
	R/L:	=1: Shift Right						0: Shift Left
	D/L:	=1: 8-bit interface					0: 4-bit interface
	N:		=1: 2 lines								0: 1 lines
	F:		=1: 5x10 dots							0: 5x8 dots
	BF:	=1: Internal Operation Progress	0: can accept instruction
	
	Function set:
	
	Command		Description
	0x3D:			LCD 1 line, 5x8  dot matrix, 4-bit interface
	0x24:			LCD 1 line, 5x10 dot matrix, 4-bit interface
	0x28:			LCD 2 line, 5x8  dot matrix, 4-bit interface
	0x2C:			LCD 2 line, 5x10 dot matrix, 4-bit interface
	0x30:			LCD 1 line, 5x8  dot matrix, 8-bit interface
	0x34:			LCD 1 line, 5x10 dot matrix, 8-bit interface
	0x38:			LCD 2 line, 5x8  dot matrix, 8-bit interface
	0x20:			LCD 2 line, 5x10 dot matrix, 8-bit interface
	
	Input Mode Commands:
		
	Command		Description
	
	0x40:			After each character displayed on the LCD, shift the cursor to the left
	0x05:			After each character displayed on the LCD, shift the cursor and display left to the left
	0x06:			After each character displayed on the LCD, shift the cursor to the right
	0x07:			After each character displayed on the LCD, shift the cursor and display to the right
	
	Display/Cursor Shift Commands:
	
	Command		Description
	0x10:			Shift cursor to the left
	0x14:			Shift cursor to the right
	0x18:			Shift display to the left
	0x1C:			Shift display to the right
	
	0: 00110000
	1: 00110001
	2: 00110010
	3:	00110011
	4: 00110100
	5:	00110101
	6: 00110110
	7: 00110111
	8: 00111000
	9: 00111001
	(: 00101000
	): 00101001
	=: 00111101
	-: 10110000
	/: 11111101
	.: 00101110
*/

module Lcd_sys(input logic CLK,
					//LCD Control Signals
					input logic [31:0] dataIn,
					output logic LCD_ENABLE,
					output logic LCD_RW,
					output logic LCD_RS,	
					//LCD Data Signals
					output logic [7:0] LCD_DATA,
					output logic testLED
					);	
		
		typedef enum logic [5:0]
		{S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, 
		 S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, 
		 S20, S21, S22, S23, S24, S25, S26, S27, S28, S29, 
		 S30, S31, S32, S33, S34, S35, S36, S37, S38, S39, IDLE} statetype;
		 
		 statetype currentstate, nextstate;
	 
		 always_ff @(posedge CLK)
		 begin
			currentstate <= nextstate;
		 end
		 
		 always_comb
//		 always_ff @(posedge CLK)
		 begin
	 
				case(currentstate)
					// FUNCTION SET
					S0:	begin
							nextstate <= S1;
							LCD_DATA		= 8'b00111101;
							LCD_ENABLE	= 1;
							LCD_RW 		= 0;
							LCD_RS		= 0; 
							end
							
					S1:	begin
							nextstate <= S2;
							LCD_DATA		= 8'b00111101;	
							LCD_ENABLE  = 0;
							LCD_RW 		= 0;
							LCD_RS		= 0; 
							end
							
					S2:	begin
							nextstate <= S3;
							LCD_DATA		= 8'b00111101;
							LCD_ENABLE	= 1;
							LCD_RW 		= 0;
							LCD_RS		= 0; 
							end
						
					//clean display
					S3:	begin
							nextstate <= S4;
							LCD_DATA		= 8'b00000001;
							LCD_ENABLE  = 1;
							LCD_RW 		= 0;
							LCD_RS		= 0;
							end
							
					S4:	begin
							nextstate <= S5;
							LCD_DATA		= 8'b00000001;
							LCD_ENABLE	= 0;
							LCD_RW 		= 0;
							LCD_RS		= 0;
							end
							
					S5:	begin
							nextstate <= S6;
							LCD_DATA		= 8'b00000001;
							LCD_ENABLE	= 1;
							LCD_RW 		= 0;
							LCD_RS		= 0;
							end
							
					// Display on
					
					S6:	begin
							nextstate <= S7;					
							LCD_DATA		= 8'b00001110;
							LCD_ENABLE	= 1;
							LCD_RW 		= 0;
							LCD_RS		= 0;
							end
							
					S7:	begin
							nextstate <= S8;					
							LCD_DATA		= 8'b00001110;
							LCD_ENABLE	= 0;
							LCD_RW 		= 0;
							LCD_RS		= 0;
							end
							
					S8:	begin
							nextstate <= S9;					
							LCD_DATA		= 8'b00001110;
							LCD_ENABLE	= 1;
							LCD_RW 		= 0;
							LCD_RS		= 0;
							end
					// set cursor location
					
					S9:	begin
							nextstate <= S10;					
							LCD_DATA		= 8'b00000011;
							LCD_ENABLE	= 1;
							LCD_RW 		= 0;
							LCD_RS		= 0;
					
							end
							
					S10:	begin
							nextstate <= S11;					
							LCD_DATA		= 8'b00000011;
							LCD_ENABLE	= 0;
							LCD_RW 		= 0;
							LCD_RS		= 0;
							end
							
					S11:	begin
							nextstate <= S12;					
							LCD_DATA		= 8'b00000011;
							LCD_ENABLE	= 1;
							LCD_RW 		= 0;
							LCD_RS		= 0;
							end
					//	After each character displayed on the LCD, shift the cursor and display to the right
					
					S12: begin
							nextstate <= S13;
							LCD_DATA		= 8'b00000110;
							LCD_ENABLE	= 1;
							LCD_RW 		= 0;
							LCD_RS		= 0;
							end
							
					S13: begin
							nextstate <= S14;
							LCD_DATA		= 8'b00000110;
							LCD_ENABLE	= 0;
							LCD_RW 		= 0;
							LCD_RS		= 0;
							end
							
					S14: begin
							nextstate <= S15;
							LCD_DATA		= 8'b00000110;
							LCD_ENABLE	= 1;
							LCD_RW 		= 0;
							LCD_RS		= 0;
							end
							
					// wirte data
					S15:	begin
							nextstate <= S16;				
								if(dataIn == 32'd0) 			begin
										LCD_ENABLE  = 0; 
										LCD_DATA  = 8'b00110000; //0
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'b1)  	begin	
										LCD_DATA = 8'b00110001; // 1
										LCD_ENABLE  = 0;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd2)	begin
										LCD_DATA = 8'b00110010; // 2
										LCD_ENABLE  = 0;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd3)	begin
										LCD_DATA = 8'b00110011; // 3
										LCD_ENABLE  = 0;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd4)	begin
										LCD_DATA = 8'b00110100; // 4
										LCD_ENABLE  = 0;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd5)	begin
										LCD_DATA = 8'b00110101; // 5
										LCD_ENABLE  = 0;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn ==32'd6)	begin
										LCD_DATA = 8'b00110110; // 6
										LCD_ENABLE  = 0;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd7)	begin
										LCD_DATA = 8'b00110111; // 7
										LCD_ENABLE  = 0;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd8)	begin
										LCD_DATA = 8'b00111000; // 8
										LCD_ENABLE  = 0;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd9)	begin
										LCD_DATA = 8'b00111001; // 9
										LCD_ENABLE  = 0;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd2147483655)	begin
										LCD_DATA = 8'b00101000; // (
										LCD_ENABLE  = 0;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd2147483656)	begin
										LCD_DATA = 8'b00101001; // )
										LCD_ENABLE  = 0;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd2147483653)	begin
										LCD_DATA = 8'b00111101; // =
										LCD_ENABLE  = 0;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd2147483650)	begin
										LCD_DATA = 8'b10110000; // -
										LCD_ENABLE  = 0;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd2147483654)	begin
										LCD_DATA = 8'b11111101; // /
										LCD_ENABLE  = 0;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd2147483652)	begin
										LCD_DATA = 8'b00000001; // clear display
										LCD_ENABLE  = 0;
										LCD_RW 		= 0;
										LCD_RS		= 0;	//data
										end
								else if(dataIn == 32'd2147483651)	begin
										LCD_DATA = 8'b00101010; // x
										LCD_ENABLE  = 0;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end		
								else if(dataIn == 32'd2147483649)	begin
										LCD_DATA = 8'b00101011; // +
										LCD_ENABLE  = 0;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else	begin
										LCD_DATA = 8'b00100001;
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end	
									
							end
					
					S16:	begin
							nextstate <= S15;
								if(dataIn == 32'd0) 			begin
										LCD_ENABLE  = 1;
										LCD_DATA = 8'b00110000; //0
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd1)  	begin	
										LCD_DATA = 8'b00110001; // 1
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd2)	begin
										LCD_DATA = 8'b00110010; // 2
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd3)	begin
										LCD_DATA = 8'b00110011; // 3
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd4)	begin
										LCD_DATA = 8'b00110100; // 4
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd5)	begin
										LCD_DATA = 8'b00110101; // 5
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd6)	begin
										LCD_DATA = 8'b00110110; // 6
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd7)	begin
										LCD_DATA = 8'b00110111; // 7
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd8)	begin
										LCD_DATA = 8'b00111000; // 8
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd9)	begin
										LCD_DATA = 8'b00111001; // 9
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd2147483655)	begin
										LCD_DATA = 8'b00101000; // (
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd2147483656)	begin
										LCD_DATA = 8'b00101001; // )
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd2147483653)	begin
										LCD_DATA = 8'b00111101; // =
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd2147483650)	begin
										LCD_DATA = 8'b10110000; // -
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd2147483654)	begin
										LCD_DATA = 8'b11111101; // /
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd2147483652)	begin
										LCD_DATA = 8'b00000001; // clear display
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 0;	//data
										end
								else if(dataIn == 32'd2147483651)	begin
										LCD_DATA = 8'b00101010; // x
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end
								else if(dataIn == 32'd2147483649)	begin
										LCD_DATA = 8'b00101011; // +
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end		
								 else	begin
										LCD_DATA = 8'b00100001;
										LCD_ENABLE  = 1;
										LCD_RW 		= 0;
										LCD_RS		= 1;	//data
										end	
							end
					
					IDLE: begin
									nextstate <= S0;
									LCD_DATA = 8'b00100000;
									LCD_ENABLE  = 0;
									LCD_RW 		= 0;
									LCD_RS		= 1;	//data
									end
							
					default:
							nextstate <= IDLE;
					endcase
				
		 end
endmodule
		 
			
		 
		 
		 
