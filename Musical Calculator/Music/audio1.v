module audio1(
  // Clock Input (50 MHz)
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



wire [6:0] myclock;
wire RST;
assign RST = KEY[0];

// reset delay gives some time for peripherals to initialize
wire DLY_RST;
Reset_Delay r0(	.iCLK(CLOCK_50),.oRESET(DLY_RST) );

// Send switches to red leds 
//assign LEDR = SW;

									VGA_Audio_PLL 	p1 (	
											.areset(~DLY_RST),
											.inclk0(CLOCK_27),
											.c0(VGA_CTRL_CLK),
											.c1(AUD_CTRL_CLK),
											.c2(VGA_CLK)
										);

										I2C_AV_Config u3(	
										//	Host Side
										  .iCLK(CLOCK_50),
										  .iRST_N(KEY[0]),
										//	I2C Side
										  .I2C_SCLK(I2C_SCLK),
										  .I2C_SDAT(I2C_SDAT)	
										);

assign	AUD_ADCLRCK	=	AUD_DACLRCK;
assign	AUD_XCK		=	AUD_CTRL_CLK;

										audio_clock u4(	
										//	Audio Side
										.oAUD_BCK(AUD_BCLK),
										.oAUD_LRCK(AUD_DACLRCK),
										//	Control Signals
										.iCLK_18_4(AUD_CTRL_CLK),
										.iRST_N(DLY_RST)	
										);

wire [15:0] audio_inL, audio_inR;
reg [15:0] audio_outL,audio_outR;

always @(negedge AUD_DACLRCK)
	audio_outR <= audio_inR;

always @(posedge AUD_DACLRCK)
	audio_outL <= audio_inL;

//	reg aAUD_ADCDAT,aAUD_DACDAT;
										audio_converter u5(
										// Audio side
										.AUD_BCK(AUD_BCLK),       // Audio bit clock
										.AUD_LRCK(AUD_DACLRCK), // left-right clock
										.AUD_ADCDAT(AUD_ADCDAT),
										.AUD_DATA(AUD_DACDAT),
										// Controller side
										.iRST_N(DLY_RST),  // reset
										.AUD_outL(audio_outL),
										.AUD_outR(audio_outR),
										.AUD_inL(audio_inL),
										.AUD_inR(audio_inR)
										);


endmodule