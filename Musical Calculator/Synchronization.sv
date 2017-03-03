module synchronization(input logic clock,
							  input logic [7:0] buttonIn,
							  output logic [7:0] syncButtonOut);
			
		logic [7:0] Sync_1, Sync_2, Sync_3;			
		logic internal;
		
		always_ff @(posedge clock)
		begin
				Sync_1 <= buttonIn;
				Sync_2 <= Sync_1;
				Sync_3 <= Sync_2;
		end
		
		assign internal = (Sync_2) != (Sync_3); // 1 0r 0
		
		always_ff @(posedge clock)
		begin
			if(internal == 1)
				syncButtonOut <= Sync_3;
			else
				syncButtonOut <= 0;
		end
		
		
endmodule
		
		