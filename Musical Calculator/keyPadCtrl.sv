/******************
	1	2	3	4
	5	6 	7 	8
	9	10 	11	12
	13	14	15	16
*******************
Truth Table Output
button  12345678
1		10001000
2		01001000
3		00101000
4		00011000
5		10000100
6		01000100
7		00100100
8		00010100
9		10000010
10		01000010
11		00100010
12		00010010
13		10000001
14		01000001
15		00100001
16		00010001
******************/

module keyPadCtrl(input logic [7:0] keyPadInput, input logic parenthesesLeft,
				input logic parenthesesRight, input logic clk, input logic doneSolving,
				output logic [31:0] tokenToWrite, output logic wEn, output logic [5:0] wPtr,
				output logic enterKey, output logic resetMem, output logic [31:0] LCD_TOKEN);
	
	parameter IDLE = 0, PUSH_NUM = 1, SOLVING = 2, PUSH_OP = 3, BUFFER_WRITE = 4, BUFFER_WRITE2 = 5, PUSH_NUM_SOLVE=6, BUFFER_WRITE_SOLVE = 7;
	
	logic [3:0] currentState;
	logic [3:0] nextState;
	
	logic [31:0] tempOp;
	logic [31:0] tempToken;
	logic [31:0] tempInput;
	
	logic fifoEmpty;
	
	assign wEn = (currentState == BUFFER_WRITE) || (currentState == BUFFER_WRITE2) || (currentState == BUFFER_WRITE_SOLVE);
	assign enterKey = (tempInput == 32'd2147483653);
	
	initial begin
		wPtr <= 0;
		tempToken <= 0;
	end
	
	always_ff @(posedge clk) begin
		if(wEn == 1)
			wPtr <= wPtr + 1'b1;
	end
	
	always_ff @(posedge clk) begin
		currentState <= nextState;
	end
	
	assign LCD_TOKEN = tempInput;

	always_ff @(posedge clk)
	begin
		case(currentState)
			IDLE: begin
				resetMem <= 0;
				if(enterKey == 1) begin
					nextState <= PUSH_NUM_SOLVE;
				end
				else if(tempInput != 32'd2147483657) begin //if something is pushed
					if(tempInput == 32'd2147483653) begin
						nextState <= PUSH_NUM;
					end 
					else if (tempInput < 10) begin
						tempToken <= ((tempToken * 10) + tempInput);
					end
					else if (tempInput > 9) begin
						tempOp <= tempInput;
						if(tempToken != 0) begin
							nextState <= PUSH_NUM;
						end
						else begin
							nextState <= PUSH_OP;
						end
					end
				end
				else 
					nextState <= IDLE;
			end
			
			PUSH_NUM: begin
				tokenToWrite <= tempToken;
				nextState <= BUFFER_WRITE;
			end
			
			BUFFER_WRITE: begin
				tokenToWrite <= tempOp;
				nextState <= PUSH_OP;
			end
			
			PUSH_OP: begin
				tempToken <= 0;
				tokenToWrite <= tempOp;
				nextState <= BUFFER_WRITE2;
			end
			
			BUFFER_WRITE2: begin
				nextState <= IDLE;
			end
			
			PUSH_NUM_SOLVE: begin
				tokenToWrite <= tempToken;
				nextState <= BUFFER_WRITE_SOLVE;
			end
			
			BUFFER_WRITE_SOLVE: begin
				nextState <= SOLVING;
			end
			
			SOLVING: begin
				if(doneSolving) begin
					resetMem <= 1;
					nextState <= IDLE;
				end
				else begin
					nextState <= SOLVING;
				end
			end
			
			default:
				nextState <= IDLE;
		endcase
	end
	
	always_comb
	begin
		case(keyPadInput)
			8'b10001000: tempInput <= 32'd1; //1
			8'b01001000: tempInput <= 32'd2; //2
			8'b00101000: tempInput <= 32'd3; //3
			8'b00011000: tempInput <= 32'd2147483649; //+ A == 32'b10000000000000000000000000000001
			8'b10000100: tempInput <= 32'd4; //4
			8'b01000100: tempInput <= 32'd5; //5
			8'b00100100: tempInput <= 32'd6; //6
			8'b00010100: tempInput <= 32'd2147483650; //- B == 32'b10000000000000000000000000000010
			8'b10000010: tempInput <= 32'd7; //7
			8'b01000010: tempInput <= 32'd8; //8
			8'b00100010: tempInput <= 32'd9; //9
			8'b00010010: tempInput <= 32'd2147483651; //X C == 32'b10000000000000000000000000000011
			8'b10000001: tempInput <= 32'd0; //0
			8'b01000001: tempInput <= 32'd2147483652; //DELETE F == 32'b10000000000000000000000000000100
			8'b00100001: tempInput <= 32'd2147483653; //Enter E ==  32'b10000000000000000000000000000101
			8'b00010001: tempInput <= 32'd2147483654; /// D == 32'b10000000000000000000000000000110
			8'b11111111: tempInput <= 32'd2147483657;
			default: begin
				if(parenthesesLeft == 1) tempInput <= 32'd2147483655; //(
				else if(parenthesesRight == 1) tempInput <= 32'd2147483656; //)
				else tempInput <= 32'd2147483657; //NOTHING PUSHED
			end
		endcase
	end		
endmodule
