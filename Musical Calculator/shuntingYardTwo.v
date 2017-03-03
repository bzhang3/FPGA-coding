module shuntingYard(input [31:0] inputToken, output [5:0] inputPtr, output readInputEnable,
					input [5:0] maxWritePtr, input enterKeyPushed, input clk,
					output outputWrEn, output [5:0] outputPtr, output [31:0] outputToken, output solveSignal);

	parameter IDLE = 0,
			  READ_TOKEN = 1,
			  BUFFER_READ = 2,
			  PROCESS_TOKEN = 3,
			  PUSH_OP = 4,
			  PROCESS_PUSH_OP = 5,
			  POP_FROM_OP_STACK_PAREN = 6,
			  PUSH_IN_TO_OUTPUT_STACK = 7,
			  PUSH_OP_TO_OUTPUT_STACK = 8,
			  EMPTY_OP_STACK = 9,
			  CHECK_LEFT_PAREN = 10,
			  POP_OP = 11,
			  PROCESS_PUSH_TO_OUTPUT = 12,
			  PROCESS_EMPTY = 13,
			  SOLVEEQ = 14;
			  
	parameter OP_MULT = 32'd2147483651,
			  OP_DIV = 32'd2147483654,
			  OP_PLUS = 32'd2147483649,
			  OP_MINUS = 32'd2147483650,
			  PAREN_LEFT = 32'd2147483655,
			  PAREN_RIGHT = 32'd2147483656;

	reg [31:0] opStack[31:0];
	reg [4:0] opStackPtr;
	reg [31:0] tempOpToken;
	
	reg [3:0] currentState;
	reg [3:0] nextState;
	
	wire fifoEmpty;
	
	reg [5:0] x_inputPtr;
	reg [5:0] x_outputPtr;
	reg [31:0] x_outputToken;
	
	assign inputPtr = x_inputPtr;
	assign outputPtr = x_outputPtr;
	assign outputToken = x_outputToken;
		
	initial begin
		currentState <= IDLE;
		nextState <= IDLE;
	end

	assign fifoEmpty = (maxWritePtr == x_inputPtr);
	assign readInputEnable = (currentState == READ_TOKEN);
	assign outputWrEn = (currentState == PUSH_IN_TO_OUTPUT_STACK || currentState == PUSH_OP_TO_OUTPUT_STACK || currentState == EMPTY_OP_STACK);
	assign solveSignal = (currentState == SOLVEEQ);
	
	//CURRENT STATE FF
	always @(posedge clk) begin
		currentState <= nextState;
	end

	//INPUT PTR DRIVER
	always @(currentState or enterKeyPushed) begin
		if(currentState == PROCESS_TOKEN)
			x_inputPtr <= x_inputPtr + 1;
		if(enterKeyPushed)
			x_inputPtr <= 0;
	end
	
	//OPSTACK PTR DRIVER
	always @(currentState or enterKeyPushed) begin
		if(enterKeyPushed) begin
			opStackPtr <= 0;
		end
		if(currentState == PUSH_OP)
			opStackPtr <= opStackPtr + 1;
		else if (currentState == PROCESS_PUSH_TO_OUTPUT)
			opStackPtr <= opStackPtr - 1;
		else if (currentState == PROCESS_EMPTY)
			opStackPtr <= opStackPtr - 1;
		else if (currentState == POP_OP)
			opStackPtr <= opStackPtr - 1;
	end
	
	//OUTPUT PTR DRIVER
	always @(nextState or enterKeyPushed) begin
		if(enterKeyPushed) begin
			x_outputPtr <= -1;
		end
		if(nextState == PUSH_IN_TO_OUTPUT_STACK || currentState == PROCESS_EMPTY || currentState == SOLVEEQ)
			x_outputPtr <= x_outputPtr + 1;
	end
	
	//State flow block
	always @(currentState or enterKeyPushed) begin
		case(currentState)
			IDLE: begin
				if(enterKeyPushed) begin
					nextState <= READ_TOKEN;
				end
				else begin
					nextState <= IDLE;
				end
			end
			READ_TOKEN: begin //read
				nextState <= BUFFER_READ;
			end
			BUFFER_READ: begin
				nextState <= PROCESS_TOKEN;
			end	
			PROCESS_TOKEN: begin
				if(inputToken == OP_MULT || inputToken == OP_DIV || inputToken == OP_MINUS || inputToken == OP_PLUS  || inputToken == PAREN_LEFT) begin
					nextState <= PUSH_OP;
				end
				else if (inputToken == PAREN_RIGHT) begin
					nextState <= POP_FROM_OP_STACK_PAREN;
				end
				else begin
					nextState <= PUSH_IN_TO_OUTPUT_STACK;
				end
			end
			PUSH_OP: begin
				nextState <= PROCESS_PUSH_OP;
			end
			PROCESS_PUSH_OP: begin
				nextState <= READ_TOKEN;
			end
			POP_FROM_OP_STACK_PAREN: begin
				nextState <= CHECK_LEFT_PAREN;
			end
			CHECK_LEFT_PAREN: begin
				if(tempOpToken == PAREN_LEFT) begin
					nextState <= POP_OP;
				end
				else begin
					nextState <= PUSH_OP_TO_OUTPUT_STACK;
				end
			end
			PUSH_IN_TO_OUTPUT_STACK: begin //write
				if(fifoEmpty == 1) begin
					nextState <= EMPTY_OP_STACK;
				end
				else nextState <= READ_TOKEN;
			end
			PUSH_OP_TO_OUTPUT_STACK: begin //write
				nextState <= PROCESS_PUSH_TO_OUTPUT;
			end
			PROCESS_PUSH_TO_OUTPUT: begin
				nextState <= POP_FROM_OP_STACK_PAREN;
			end
			POP_OP: begin
				nextState <= READ_TOKEN;
			end
			EMPTY_OP_STACK: begin
				if(opStackPtr == 0) nextState <= SOLVEEQ;
				else nextState <= PROCESS_EMPTY;
			end
			PROCESS_EMPTY: begin
				nextState <= EMPTY_OP_STACK;
			end
			SOLVEEQ: begin
				nextState <= SOLVEEQ;//IDLE;
			end
			default: begin
				nextState <= IDLE;
			end
		endcase
	end
	
	always @(posedge clk) begin
		case(currentState)
			IDLE: begin end
			READ_TOKEN: begin end
			BUFFER_READ: begin end
			PROCESS_TOKEN: begin
				if(inputToken < OP_PLUS) x_outputToken <= inputToken;
			end
			PUSH_OP: opStack[opStackPtr] <= inputToken;
			POP_FROM_OP_STACK_PAREN: tempOpToken <= opStack[opStackPtr];
			CHECK_LEFT_PAREN: begin end
			PUSH_IN_TO_OUTPUT_STACK: begin end
			PUSH_OP_TO_OUTPUT_STACK: begin end
			PROCESS_PUSH_TO_OUTPUT: begin end
			POP_OP: begin end
			EMPTY_OP_STACK: begin
				if(opStackPtr > 0) x_outputToken <= opStack[opStackPtr];
			end
			PROCESS_EMPTY: begin end
			SOLVEEQ: begin end
			default: begin end
		endcase
	end
endmodule
