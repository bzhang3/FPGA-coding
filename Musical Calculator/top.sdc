# Create clock constraints
create_clock -name clock -period 20.000 [get_ports {clk}]
create_clock -name clk_virt -period 20.000

# Create IO constraints
set_input_delay -clock { clk_virt } -min 0 [get_ports {AUD_ADCDAT AUD_ADCLRCK AUD_BCLK AUD_DACDAT AUD_DACLRCK AUD_XCK CLOCK_27 I2C_SCLK I2C_SDAT KEY[0] KEY[1] KEY[2] KEY[3] TP1 TP2 TP3 altera_reserved_tck altera_reserved_tdi altera_reserved_tdo altera_reserved_tms auto_stp_external_clock_0 clk keyPadInput[0] keyPadInput[1] keyPadInput[2] keyPadInput[3] keyPadOutput[0] keyPadOutput[1] keyPadOutput[2] keyPadOutput[3] lcd_data[0] lcd_data[1] lcd_data[2] lcd_data[3] lcd_data[4] lcd_data[5] lcd_data[6] lcd_data[7] lcd_enable lcd_rs lcd_rw outLED[0] outLED[1] outLED[2] outLED[3] parenthesesLeft parenthesesRight solved testLED testingLEDs[0] testingLEDs[1] testingLEDs[2] testingLEDs[3] testingLEDs[4] testingLEDs[5] testingLEDs[6] testingLEDs[7]}]
set_input_delay -clock { clk_virt } -max 1 [get_ports {AUD_ADCDAT AUD_ADCLRCK AUD_BCLK AUD_DACDAT AUD_DACLRCK AUD_XCK CLOCK_27 I2C_SCLK I2C_SDAT KEY[0] KEY[1] KEY[2] KEY[3] TP1 TP2 TP3 altera_reserved_tck altera_reserved_tdi altera_reserved_tdo altera_reserved_tms auto_stp_external_clock_0 clk keyPadInput[0] keyPadInput[1] keyPadInput[2] keyPadInput[3] keyPadOutput[0] keyPadOutput[1] keyPadOutput[2] keyPadOutput[3] lcd_data[0] lcd_data[1] lcd_data[2] lcd_data[3] lcd_data[4] lcd_data[5] lcd_data[6] lcd_data[7] lcd_enable lcd_rs lcd_rw outLED[0] outLED[1] outLED[2] outLED[3] parenthesesLeft parenthesesRight solved testLED testingLEDs[0] testingLEDs[1] testingLEDs[2] testingLEDs[3] testingLEDs[4] testingLEDs[5] testingLEDs[6] testingLEDs[7]}]

set_output_delay -clock { clk_virt } -min 0 [get_ports {AUD_ADCDAT AUD_ADCLRCK AUD_BCLK AUD_DACDAT AUD_DACLRCK AUD_XCK CLOCK_27 I2C_SCLK I2C_SDAT KEY[0] KEY[1] KEY[2] KEY[3] TP1 TP2 TP3 altera_reserved_tck altera_reserved_tdi altera_reserved_tdo altera_reserved_tms auto_stp_external_clock_0 clk keyPadInput[0] keyPadInput[1] keyPadInput[2] keyPadInput[3] keyPadOutput[0] keyPadOutput[1] keyPadOutput[2] keyPadOutput[3] lcd_data[0] lcd_data[1] lcd_data[2] lcd_data[3] lcd_data[4] lcd_data[5] lcd_data[6] lcd_data[7] lcd_enable lcd_rs lcd_rw outLED[0] outLED[1] outLED[2] outLED[3] parenthesesLeft parenthesesRight solved testLED testingLEDs[0] testingLEDs[1] testingLEDs[2] testingLEDs[3] testingLEDs[4] testingLEDs[5] testingLEDs[6] testingLEDs[7]}]
set_output_delay -clock { clk_virt } -max 1 [get_ports {AUD_ADCDAT AUD_ADCLRCK AUD_BCLK AUD_DACDAT AUD_DACLRCK AUD_XCK CLOCK_27 I2C_SCLK I2C_SDAT KEY[0] KEY[1] KEY[2] KEY[3] TP1 TP2 TP3 altera_reserved_tck altera_reserved_tdi altera_reserved_tdo altera_reserved_tms auto_stp_external_clock_0 clk keyPadInput[0] keyPadInput[1] keyPadInput[2] keyPadInput[3] keyPadOutput[0] keyPadOutput[1] keyPadOutput[2] keyPadOutput[3] lcd_data[0] lcd_data[1] lcd_data[2] lcd_data[3] lcd_data[4] lcd_data[5] lcd_data[6] lcd_data[7] lcd_enable lcd_rs lcd_rw outLED[0] outLED[1] outLED[2] outLED[3] parenthesesLeft parenthesesRight solved testLED testingLEDs[0] testingLEDs[1] testingLEDs[2] testingLEDs[3] testingLEDs[4] testingLEDs[5] testingLEDs[6] testingLEDs[7]}]
# PLLs and uncertainty
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty