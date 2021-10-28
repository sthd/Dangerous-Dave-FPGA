module random 	
 ( 
	input	logic  clk,
	input	logic  resetN, 
	input	logic	 secondLevel,
	
	output logic [SIZE_BITS-1:0] dout	
  ) ;

  //generating a random number by latching a fast counter with the rising edge of an input ( e.g. key pressed )
  
parameter SIZE_BITS = 4;
parameter MIN_VAL = 0;  //set the min and max values 
parameter MAX_VAL = 6;
parameter mazeLevel = 7;


	logic [SIZE_BITS-1:0] counter = MIN_VAL;
	logic rise_d;
	

			//	dout <= 0;
			//counter <= MIN_VAL;
			//rise_d <= 1'b0;
	
always_ff @(posedge clk or negedge resetN) begin
			if(!resetN) begin
				dout <= counter;
			end
			else begin
				//dout <= 4'b0000;
				counter <= counter+1;
				if ( counter >= MAX_VAL ) 
						counter <=  MIN_VAL ; // set min and max mvalues 
				if (secondLevel)
					dout <= mazeLevel;
			end
end
	
 

 
endmodule

/*

module random 	
 ( 
	input	logic  clk,
	input	logic  resetN, 
	input	logic	 rise,
	input	logic	 secondLevel,
	output logic [SIZE_BITS-1:0] dout	
  ) ;

  //generating a random number by latching a fast counter with the rising edge of an input ( e.g. key pressed )
  
parameter SIZE_BITS = 8;
parameter MIN_VAL = 0;  //set the min and max values 
parameter MAX_VAL = 6;
parameter mazeLevel = 7;


	logic [SIZE_BITS-1:0] counter;
	logic rise_d;
	
	dout = 0;
	counter= MIN_VAL;
	rise_d= 1'b0;
			//	dout <= 0;
			//counter <= MIN_VAL;
			//rise_d <= 1'b0;
	
always_ff @(posedge clk or negedge resetN) begin
		if(!resetN) begin
			dout <= 0;
			counter <= MIN_VAL;
			rise_d <= 1'b0;
		end
		
		else begin
			counter <= counter+1;
			if ( counter >= MAX_VAL ) 
					counter <=  MIN_VAL ; // set min and max mvalues 
			rise_d <= rise;
			if (secondLevel)
				dout <= mazeLevel;
			else if (rise && !rise_d) // rizing edge 
				dout <= counter;
		end
			
	
	end
	
 

 
endmodule


*/
