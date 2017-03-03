 /***************************************************************
 * Inputs:  readyGo, fromShunt, inToken
 * Outputs: rEn, readPtr
 * Description: implementing shunting yard algorithm to parse math equations 
*/
 module calculateNotation(
			input logic clk,
            input logic readyGo,        //input to tell me when to go
            input logic [5:0] fromShunt, //from shunting yard -- to get largest ptr value, so we know when i am done with the inputmemory postfix expression
			input logic [31:0] inToken,
			output logic [5:0] rPtr, 
     		output logic rEn, 
			output logic done,
            output logic [31:0] answer
            );
	
	// consider: an operation or 32 bit number
	parameter 	
				OP_MULT = 32'd2147483651,  	// 10000000000000000000000000000000
				OP_DIV = 32'd2147483653,  	// 10000000000000000000000000000001
				OP_ADD = 32'd2147483649, 	// 10000000000000000000000000000010
				OP_SUB = 32'd2147483650; 	// 10000000000000000000000000000011

	typedef enum logic [3:0] {IDLE, CHECKCONDITIONSTATE, READMEMORY, NUMOROP, NUMBERSTATE, OPERATORSTATE, DONE1, DONE2, BUFFER_READ} statetype;
	
	statetype currentState, nextState;
	
	logic [31:0] token;              //sized to match inToken from (port list)
	logic [31:0] temp_stack [63:0];
	logic [5:0] stackPtr;
	logic [5:0] largestPtr;         //Highest value of ptr I should get to in my reads from memory
  
	initial begin
		currentState <= IDLE; 
		stackPtr <= 6'b0;
		//tempPtr <= 5'b0;
		answer <= 16'b0;
		//done <= 1'b0;
		rPtr <= 0;
		
		for(int i = 0; i < 64; i = i + 1'b1) begin
			temp_stack[i] <= 6'b0;
		end  			
	end

	assign largestPtr = fromShunt;
	
  //Advance to the next state on every clock edge
	always_ff @(posedge clk) begin
		currentState <= nextState;
	end
	
	always_ff @(posedge clk) begin
		if(readyGo == 1)
			rPtr <= 0;
		if(rEn == 1'b1)
			rPtr <= rPtr + 1;
	end
	
	assign rEn = (nextState == READMEMORY);
	
  //FSM logic
	always_comb begin
		case(currentState) 
			IDLE: begin                         
				if (readyGo) begin
					nextState <= CHECKCONDITIONSTATE;
				end
				else begin
					nextState <= IDLE;
				end
			end
			CHECKCONDITIONSTATE: begin       //check to see if there is stuff left in external memory
				if (rPtr < largestPtr) begin //means we can read from memory and will
					nextState <= READMEMORY;
				end
				else begin                   //means the input memory is empty and we are done with the expression
					if (stackPtr == 6'b1) begin
						nextState <= DONE1;
					end
					else
						nextState <= CHECKCONDITIONSTATE;
				end
			end
			READMEMORY: begin
				nextState <= BUFFER_READ;
			end
			BUFFER_READ: begin
				nextState <= NUMOROP; 		//go to the state where i decide if the input is a operator or number
			end
			NUMOROP: begin
				if (token < 32'd2147483648) begin
					nextState <= NUMBERSTATE;
				end
				else begin
					nextState <= OPERATORSTATE;
				end
			end
			NUMBERSTATE: begin
				nextState <= CHECKCONDITIONSTATE; 		//goes back to check if i have more items to read (i should)
			end
			OPERATORSTATE: begin
				nextState <= CHECKCONDITIONSTATE;
			end
			DONE1: begin                            	//**DONE1 and DONE2 are just there to provide a HIGH to LOW event when done
				nextState <= DONE2;
			end
			DONE2: begin                         		//this states sole purpose is to bring done line to zero 
				nextState <= IDLE;
			end
		endcase
	end
	
	always_ff @(posedge clk) begin
		case(currentState) 
			IDLE: begin                         
				end
			CHECKCONDITIONSTATE: begin       //check to see if there is stuff left in external memory
			end
			READMEMORY: begin
				token <= inToken; 			//read what i got back from the inputMemory module (external)				//turn OFF the read from EXTERNAL memory (inputMemory module)
			end
			BUFFER_READ: begin
			end
			NUMOROP: begin
			end
			NUMBERSTATE: begin
				temp_stack[stackPtr] <= token;
				stackPtr <= stackPtr + 6'b1;
			end
			OPERATORSTATE: begin
				if (token == OP_MULT) begin               //its a multiply
					temp_stack[stackPtr-6'b10] <= temp_stack[stackPtr-6'b10] * temp_stack[stackPtr-6'b01];
				end 
				else if (token == OP_DIV) begin           //its a divide  -----NEEDS FIXING----
					temp_stack[stackPtr-6'b10] <= temp_stack[stackPtr-6'b10] / temp_stack[stackPtr-6'b01];
				end 
				else if (token == OP_ADD)begin            //its an add
					temp_stack[stackPtr-6'b10] <= temp_stack[stackPtr-6'b10] + temp_stack[stackPtr-6'b01];
				end
				else if (token == OP_SUB)begin            //its a subtract
					temp_stack[stackPtr-6'b10] <= temp_stack[stackPtr-6'b10] - temp_stack[stackPtr-6'b01];
				end 
				
				stackPtr <= stackPtr - 6'b1;
			end
			DONE1: begin                           	//**DONE1 and DONE2 are just there to provide a HIGH to LOW event when done
				answer <= temp_stack[stackPtr- 6'b1];
				done <= 1'b1;
			end
			DONE2: begin                         		//this states sole purpose is to bring done line to zero 
				done <= 1'b0; 
				stackPtr <= 6'b0; 						//reset an variables that may need reset before going back to IDLE state
			end
		endcase
	end
endmodule