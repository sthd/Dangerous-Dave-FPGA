
// game controller Dudy October 2020
// (c) Technion IIT, Department of Electrical Engineering 2020 


module	game_controller (	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	drawR_player,
			input	logic	drawR_borders,
			input	logic	drawR_bricks,
			input	logic	drawR_diamonds,
			input	logic	drawR_mines,
			input	logic	drawR_door,
			input	logic	timeUp,
			input	logic	[3:0] remainingLives,
			
			
			output logic [3:0] collision, // active in case of collision between two objects
			output logic SingleHitPulse, // critical code, generating A single pulse in a frame 
			output logic gameOn,
			output logic decreaseLife,
			output logic openDoor,
			output logic timerEnable,
			output logic raiseScore,
			output logic nextLevel
);

//collision of square and smiley
//assign collision = ((drawR_dave &&  drawR_borders) || (drawR_dave &&  drawR_bricks)  ) ; 

//assign collision = ( drawR_dave && ( drawR_borders || drawR_bricks || drawR_diamonds || drawR_crown )  );

/*
dave collides with:
0 borders or bricks
1 bricks
*/
assign collision[0]= drawR_player && (drawR_borders || drawR_bricks) ;
assign collision[1]= drawR_player && drawR_diamonds;
assign collision[2]= drawR_player && (drawR_mines);
assign collision[3]= drawR_player && drawR_door;



logic flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 


//==----------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 1'b0;
		SingleHitPulse <= 1'b0 ;
		gameOn<=1'b1;
		timerEnable <=1'b1;
		nextLevel <=1'b0;
	end 
	else begin 
			if (!remainingLives) begin
				gameOn<=1'b0;
				timerEnable <=1'b0;
			end
			
			// defaults 
			SingleHitPulse <= 1'b0 ;
			decreaseLife <=1'b0;
			raiseScore <=1'b0;
	
			if(startOfFrame) 
				flag = 1'b0 ; // reset for next time	
				
			if ( (collision[0] || collision[1] || collision[2] || collision[3])   && (flag == 1'b0) && gameOn) begin 
				flag	<= 1'b1; // to enter only once 
				SingleHitPulse <= 1'b1 ; 
				if (collision[2] || timeUp)
					decreaseLife <=1'b1;
				if (collision[1])
					raiseScore <=1'b1;
				if (collision[3])
					nextLevel <=1;
			end ; 
	end 
end

endmodule
	