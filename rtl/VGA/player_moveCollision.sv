module	player_move_Collision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  	// short pulse every start of frame 30Hz 
					input	logic	right_key,				// 
					input	logic	jump_key, 				//jump 
					input	logic	left_key,		// move left
					input 	logic collision,  //collision if gargamel hits an object
					input	logic	[3:0] HitEdgeCode,//one bit per edge 
					input	logic	[3:0] randomLevel,
					
					output	 logic signed 	[10:0]	topLeftX,// output the top left corner 
					output	 logic signed	[10:0]	topLeftY// output the top right corner
					
);


// a module used to generate the  ball trajectory.  


parameter int INITIAL_X_SPEED = 40;
parameter int INITIAL_Y_SPEED = 0;

parameter int X_play	 = 40;
parameter int Y_play	 = -30;
parameter int Y_grav = 10;

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to work with integers in high resolution 
// we do all calulations with topLeftX_FixedPoint  so we get a resulytion inthe calcuatuions of 1/64 pixel 
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n 
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;

// local parameters 
int Xspeed, topLeftX_FixedPoint; 
int Yspeed, topLeftY_FixedPoint;

int Xcollisionfix;
int Ycollisionfix;

int INITIAL_X;
int INITIAL_Y;

logic flagYdown;
logic flagYup;
logic flagXleft;
logic flagXright;

logic enableJump;

logic signed 	[10:0]	oldtopLeftX;
logic signed 	[10:0]	oldtopLeftY;


always_comb
	begin
	INITIAL_X = 280;
	INITIAL_Y = 185;		
	case (randomLevel)
	
		0: begin
			INITIAL_X = 320;
			INITIAL_Y = 128;	
		end // level1
		1: begin
			INITIAL_X = 224;
			INITIAL_Y = 352;	
		end // level2
		2: begin
			INITIAL_X = 224;
			INITIAL_Y = 288;	
		end // level3
		3: begin
			INITIAL_X = 96;
			INITIAL_Y = 128;	
		end // level4
		4: begin
			INITIAL_X = 64;
			INITIAL_Y = 192;	
		end // level5
		5: begin
			INITIAL_X = 288;
			INITIAL_Y = 128;	
		end // level6
		6: begin
			INITIAL_X = 256;
			INITIAL_Y = 256;	
		end // level7

		
		
	endcase
end // always_comb





//Xspeed calcuatuions
always_ff@(posedge clk or negedge resetN) begin

	if(!resetN) begin 
		Xspeed	<= 0;
		flagXleft <= 1'b0 ; 
		flagXright <= 1'b0 ;
	end 
	else begin
	
			if(startOfFrame) begin
				flagXleft = 1'b0 ; 
				flagXright = 1'b0 ; 
			end
			
			//left side of player hits right of obstacle
			if (collision && HitEdgeCode[3] && (flagXleft == 1'b0)) begin 
				flagXleft <= 1'b1; // to enter only once 
				if (right_key == 1'b0)
					Xspeed <=X_play ;
				else
					Xspeed <=0 ;
			end // left
			
			//right side of player hits left of obstacle
			else if (collision && HitEdgeCode [1] == 1 && (flagXright == 1'b0)) begin 
				flagXright	<= 1'b1;
				if (left_key == 1'b0)
					Xspeed <=-X_play ;
				else
					Xspeed <=0 ;
			end //right 
			
			else if (right_key == 1'b0 && !flagXright) begin
				Xspeed <=X_play ;
			end

			else if (left_key == 1'b0 && !flagXleft) begin //&& (oldtopLeftX!=topLeftX) 
				Xspeed <=-X_play;
			end
			else begin
				Xspeed <=0 ;
			end

	end //else reset

end //always ff

//manage to land speed 0 on top without oldtopY

//Y speed
always_ff@(posedge clk or negedge resetN) 
begin
	if(!resetN) begin 
		Yspeed	<= 0;
		enableJump <= 1'b0;
		flagYdown <= 1'b0;
		flagYup <= 1'b0;
	end //if
	else begin

			if(startOfFrame) begin
				flagYdown = 1'b0 ; 
			end
			//touching floor and ceiling at the same time
			if ( (collision && HitEdgeCode [2]) && HitEdgeCode [0] && (flagYup == 1'b0) && (flagYdown == 1'b0) ) begin 
				flagYup	<= 1'b1; // to enter only once
				flagYdown<=1'b1;
				Yspeed <= 0;
			end
			
			//legs hit brick for the first time
			else if ( (collision && HitEdgeCode [0]) && (flagYdown == 1'b0)) begin 
				flagYdown	<= 1'b1; // to enter only once 			
				enableJump <=1;
				if ((jump_key==1'b0))
					Yspeed <=Y_play;
				else
					Yspeed <= 0;
			end //legs
			else if ((enableJump == 1'b1) && (jump_key==1'b0) && flagYup == 1'b0 ) begin
					Yspeed <=Y_play;
				end
			else if (flagYdown) begin
				Yspeed <= 0;
				enableJump <=1;
			end
			else begin
				Yspeed <= Y_grav; // deAccelerate : slow the speed down every clock tick
				enableJump <=0;
			end
	end //else reset
end //end always_ff

//////////--------------------------------------------------------------------------------------------------------------=
// position calculate 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
	end
	else begin
		
		if (startOfFrame == 1'b1) begin // perform  position integral only 30 times per second 
			topLeftY_FixedPoint  <= topLeftY_FixedPoint + Yspeed; 
			topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed;
		end
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule


			/*
			else if ( (collision && HitEdgeCode [2] )  ) begin
				Yspeed <=Y_grav;
			end
			*/
			
			//not standing but started to jump already
			
			//if ( ( (counter < 10) && (counter > 0) ) && (jump_key==1'b0) ) begin


			
			/*
			if (jump_key==1'b0) begin
					Yspeed <=Y_play;
					//oldtopLeftY <= topLeftY;
					//counter<=1;
				end
				else begin;
					Yspeed <= 0;
					//enableJump <=0;
					//counter <=0;
				end
			*/


/*
			//left side of player hits right of obstacle
			if (collision && HitEdgeCode [3] == 1  && (flagXleft == 1'b0)) begin 
				Xspeed <=0;
				flagXleft <= 1'b1; // to enter only once 
				//Xcollisionfix<=-Xspeed;
				if (right_key == 1'b0 ) begin
					Xspeed <=X_play ;
				end
			end // left
		
			//right side of player hits left of obstacle
			else if (collision && HitEdgeCode [1] == 1 && (flagXright == 1'b0)) begin 
				Xspeed <=0;
				flagXright	<= 1'b1;
				//Xcollisionfix<=-Xspeed;
				if (left_key == 1'b0 ) begin
					Xspeed <=-X_play;
					oldtopLeftX <= topLeftX;
				end
				//else
				//Xcollisionfix<=0;
			end //right 
			
			else if (right_key == 1'b0  ) begin //&& (oldtopLeftX!=topLeftX)
				Xspeed <=X_play ;
				//Xcollisionfix<=0;
			end
			else if (left_key == 1'b0 ) begin //&& (oldtopLeftX!=topLeftX) 
				Xspeed <=-X_play;
				//Xcollisionfix<=0;
			end
			else begin
				Xspeed <=0 ;
				//Xcollisionfix<=0;
			end
*/