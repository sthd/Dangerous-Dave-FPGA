// (c) Technion IIT, Department of Electrical Engineering 2018 
// 
// Implements the state machine of the bomb mini-project
// FSM, with present and next states

module livesFsm
	(
	input logic clk, 
	input logic resetN, 
	input logic immortal,
	input logic decreaselife,
	
	output logic [3:0] remainingLives
   );

//-------------------------------------------------------------------------------------------

// state machine decleration 
	enum logic [1:0] {threeLives, twoLives, oneLife, noLife } pres_st, next_st;
 	
//--------------------------------------------------------------------------------------------
//  1.  syncronous code:  executed once every clock to update the current state 
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN )  // Asynchronic reset
		pres_st <= threeLives;
   
	else 		// Synchronic logic FSM
		pres_st <= next_st;
		
	end // always sync
	
//--------------------------------------------------------------------------------------------
//  2.  asynchornous code: logically defining what is the next state, and the ouptput 
//      							(not seperating to two different always sections)  	
always_comb // Update next state and outputs
	begin
	// set all default values 
		next_st = pres_st; 

		case (pres_st)

			threeLives: begin
				remainingLives = 3;
				if ((decreaselife) && !immortal ) begin
					next_st = twoLives; 
				end
			end // threeLives
					
			twoLives: begin
				remainingLives = 2;
				 if ((decreaselife) && !immortal ) begin
					next_st = oneLife; 
					end
					
			end // twoLives
						
			oneLife: begin
				remainingLives = 1;
				if ((decreaselife) && !immortal ) begin
					next_st = noLife; 
					end
			end // oneLife
					
			noLife: begin
				remainingLives = 0;
				next_st = pres_st;
			end // noLife
						
		endcase
	end // always comb
	
endmodule