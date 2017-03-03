
 
 module music_top(
					input solved,
					input CLOCK_50, // 50 MHz
					input CLOCK_27, // 27 MHz
  //  Push Buttons
					input  [3:0]  KEY,
 
					inout  I2C_SDAT, // I2C Data
					output I2C_SCLK, // I2C Clock
  // Audio CODEC
					output/*inout*/ AUD_ADCLRCK, // Audio CODEC ADC LR Clock
					input	 AUD_ADCDAT,  // Audio CODEC ADC Data
					output /*inout*/  AUD_DACLRCK, // Audio CODEC DAC LR Clock
					output AUD_DACDAT,  // Audio CODEC DAC Data
					inout	 AUD_BCLK,    // Audio CODEC Bit-Stream Clock
					output AUD_XCK     // Audio CODEC Chip Clock
					);

					
	reg internalReset;
	
	
	parameter Idle = 0, Reset = 1,Reset2 = 4, Music = 2, NoMusic = 3;
	
	reg [3:0] Currentstate, Nextstate;
	
	always @(posedge CLOCK_50)
	begin
		Currentstate <= Nextstate;
	end
	
	
	reg aAUD_ADCDAT;
	assign led = solved;
	
//----------------------------------
 audio1 audiocontrol(
  // Clock Input (50 MHz)
  .CLOCK_50(CLOCK_50), // 50 MHz
  .CLOCK_27(CLOCK_27), // 27 MHz
  //  Push Buttons
 .KEY(KEY),
 
  .I2C_SDAT(I2C_SDAT), // I2C Data
  .I2C_SCLK(I2C_SCLK), // I2C Clock
  // Audio CODEC
  .AUD_ADCLRCK(AUD_ADCLRCK), // Audio CODEC ADC LR Clock
  .AUD_ADCDAT(aAUD_ADCDAT),  // Audio CODEC ADC Data
	.AUD_DACLRCK(AUD_DACLRCK), // Audio CODEC DAC LR Clock
  .AUD_DACDAT(AUD_DACDAT),  // Audio CODEC DAC Data
  .AUD_BCLK(AUD_BCLK),    // Audio CODEC Bit-Stream Clock
  .AUD_XCK(AUD_XCK)     // Audio CODEC Chip Clock 
);
//----------------------------------
	
	
	always @(*)
	begin
		case(Currentstate)
			Reset: begin
					internalReset <= 0;
					Nextstate <= Reset2;
			end
			
			Reset2: begin
				internalReset <= 1;
				Nextstate <= Idle;
			end
				
			Idle: begin
					if(solved == 1) Nextstate <= Music;
					else Nextstate <= Idle;
			end
			
			Music: begin		
				if(solved == 1) begin
					aAUD_ADCDAT <= AUD_ADCDAT;
					Nextstate <= Music;
				end else begin
					Nextstate <= NoMusic;
				end	
			end
			
			NoMusic: begin
				if(solved == 1) Nextstate <= Music;
				else begin Nextstate <= NoMusic;
					aAUD_ADCDAT <= 0;
					end 
			end
			
			default:
				Nextstate <= Idle;
		endcase
	end
	
endmodule
	