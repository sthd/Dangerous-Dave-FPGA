//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering  May 2019 

module	objects_mux	(
//		--------	Clock Input		
					input		logic	clk,
					input		logic	resetN,
					
					//player
					input		logic	playerDraw_req,
					input		logic	[7:0] playerRGB, 
					
					// background 
					input		logic	[7:0] backGroundRGB, 
					
					// bricks
					input		logic	bricksDraw_req, // two set of inputs per unit
					input		logic	[7:0] bricksRGB, 
					
					//	diamonds
					input		logic	diamondsDraw_req, // two set of inputs per unit
					input		logic	[7:0] diamondsRGB, 

					//	mines
					input		logic	minesDraw_req, // two set of inputs per unit
					input		logic	[7:0] minesRGB, 
					
					input		logic	doorDraw_req, // two set of inputs per unit
					input		logic	[7:0] doorRGB, 
					
					input	logic	secondsDraw_req,
					input		logic	[7:0] secondsRGB,
					
					input	logic	tensSecondsDraw_req,
					input		logic	[7:0] tensSecondsRGB,
					
					input	logic	onesScoreDraw_req,
					input		logic	[7:0] onesScoreRGB,
					
					input	logic	tensScoreDraw_req,
					input		logic	[7:0] tensScoreRGB,
					
					//output of 24 bits of colour
					output	logic	[7:0] redOut,
					output	logic	[7:0] greenOut, 
					output	logic	[7:0] blueOut 
);

logic [7:0] tmpRGB;


assign redOut	  = {tmpRGB[7:5], {5{tmpRGB[5]}}}; //--  extend LSB to create 10 bits per color  
assign greenOut  = {tmpRGB[4:2], {5{tmpRGB[2]}}};
assign blueOut	  = {tmpRGB[1:0], {6{tmpRGB[0]}}};



//======--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (playerDraw_req == 1'b1 )   
			tmpRGB <= playerRGB;  // player 1st

		else if (bricksDraw_req == 1'b1 )
			tmpRGB <= bricksRGB;  // bricks 2nd

		else if (diamondsDraw_req == 1'b1 )   
			tmpRGB <= diamondsRGB;  // diamonds 3rd
			
		else if (minesDraw_req == 1'b1 )   
			tmpRGB <= minesRGB;  //mines 4th
			
		else if (doorDraw_req == 1'b1 )   
			tmpRGB <= doorRGB;  //bomb 5th
			
		else if (tensSecondsDraw_req == 1'b1 ) 
			tmpRGB <= tensSecondsRGB;  
			
		else if (secondsDraw_req == 1'b1 ) 
			tmpRGB <= secondsRGB;  
			
		else if (onesScoreDraw_req == 1'b1 ) 
			tmpRGB <= onesScoreRGB;  
			
		else if (tensScoreDraw_req == 1'b1 ) 
			tmpRGB <= tensScoreRGB;  
	
			
		else
			tmpRGB <= backGroundRGB ; // background last priority
		end ; 
	end

endmodule


