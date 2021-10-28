//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// New bitmap dudy October 2020
// (c) Technion IIT, Department of Electrical Engineering 2020 

module	diamondsBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] pixelX,// offset from top left  position 
					input logic	[10:0] pixelY,
					input	logic objectExists, //input that the pixel is within a bracket 
					//input logic enableDraw,

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
					//output	logic	[3:0] HitEdgeCode //one bit per edge 
 ) ;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  // 2^5 = 32 
localparam  int OBJECT_NUMBER_OF_X_BITS = 5;  // 2^5 = 32


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_HEIGHT_Y_DIVIDER = OBJECT_NUMBER_OF_Y_BITS - 2; //how many pixel bits are in every collision pixel
localparam  int OBJECT_WIDTH_X_DIVIDER =  OBJECT_NUMBER_OF_X_BITS - 2;

// generating a smiley bitmap

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 


// it's a diamond
logic [0:OBJECT_WIDTH_X-1] [0:OBJECT_HEIGHT_Y-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h45, 8'h45, 8'hFF, 8'h25, 8'h25, 8'h49, 8'h25, 8'h49, 8'h49, 8'h49, 8'h49, 8'h92, 8'h6D, 8'h6D, 8'h6D, 8'h8D, 8'h6D, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h25, 8'h72, 8'h92, 8'h6D, 8'hB6, 8'h96, 8'hB2, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hDB, 8'hDB, 8'hB6, 8'h92, 8'hB6, 8'hB6, 8'hDA, 8'hDB, 8'h92, 8'h49, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h6D, 8'h72, 8'h49, 8'h49, 8'hB6, 8'hB6, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h92, 8'h92, 8'h92, 8'h92, 8'hB6, 8'hFF, 8'hFF, 8'hDA, 8'h4D, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h96, 8'hB2, 8'h6D, 8'h25, 8'h72, 8'hDA, 8'hB6, 8'hDB, 8'hB6, 8'h92, 8'h92, 8'h92, 8'h92, 8'h6D, 8'h91, 8'hD6, 8'hB1, 8'h92, 8'hB6, 8'hDF, 8'hFF, 8'hDB, 8'h92, 8'h25, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h72, 8'h72, 8'hB6, 8'h6D, 8'h49, 8'h91, 8'hB6, 8'hDB, 8'hBB, 8'h96, 8'h72, 8'h92, 8'h72, 8'h72, 8'h6D, 8'hB6, 8'hD6, 8'hD6, 8'h92, 8'hB6, 8'hDF, 8'hFB, 8'hDA, 8'hB6, 8'h91, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h49, 8'h92, 8'h92, 8'hDB, 8'h72, 8'h72, 8'h72, 8'h72, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'h92, 8'h92, 8'h6D, 8'h6D, 8'h6D, 8'hB6, 8'hDA, 8'hBA, 8'h96, 8'hBA, 8'hB6, 8'h92, 8'hB6, 8'h96, 8'h92, 8'h49, 8'hFF, 8'hFF },
{8'hFF, 8'h25, 8'h96, 8'h92, 8'hB6, 8'hB6, 8'h72, 8'hB6, 8'hB6, 8'hDA, 8'hFF, 8'hB6, 8'hDB, 8'hFF, 8'h92, 8'h72, 8'h6D, 8'h6D, 8'h6D, 8'hBB, 8'hDA, 8'hBA, 8'h9A, 8'hB6, 8'h6D, 8'h72, 8'hFF, 8'hB6, 8'h72, 8'h6D, 8'h6D, 8'hFF },
{8'hFF, 8'h92, 8'hDA, 8'hBB, 8'hDB, 8'hBB, 8'h72, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hDA, 8'h92, 8'hFF, 8'hFF, 8'hB6, 8'h6D, 8'h6D, 8'h6D, 8'hDB, 8'hDB, 8'hDA, 8'hBA, 8'h92, 8'h6E, 8'hB6, 8'hFF, 8'h49, 8'h6D, 8'h92, 8'h92, 8'h49 },
{8'h49, 8'hB6, 8'h92, 8'h96, 8'hFF, 8'hFF, 8'hBA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'hFF, 8'hFF, 8'hDB, 8'h92, 8'h92, 8'h92, 8'hB6, 8'hDA, 8'hBA, 8'hB6, 8'h6E, 8'h92, 8'hDB, 8'hDB, 8'h72, 8'h76, 8'h92, 8'h92, 8'h6D },
{8'h25, 8'h6E, 8'h92, 8'hB6, 8'hDB, 8'hDF, 8'hDB, 8'hDB, 8'hBB, 8'hB6, 8'hB6, 8'hB6, 8'hFF, 8'hFF, 8'hDA, 8'hD6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDB, 8'h92, 8'h6D, 8'h92, 8'h92, 8'h72, 8'h92, 8'h6E, 8'h92, 8'h92, 8'hB6, 8'h49 },
{8'hFF, 8'h25, 8'h92, 8'hB6, 8'hBB, 8'hBF, 8'hBB, 8'h96, 8'h8D, 8'h49, 8'h49, 8'h49, 8'hDB, 8'h72, 8'h65, 8'h64, 8'h89, 8'h69, 8'h4E, 8'h4D, 8'h49, 8'h29, 8'h49, 8'h72, 8'h72, 8'h4E, 8'h4E, 8'h6E, 8'h96, 8'h72, 8'h6E, 8'hFF },
{8'hFF, 8'hFF, 8'h4D, 8'hB6, 8'h77, 8'h9F, 8'hBF, 8'h97, 8'hB1, 8'h6D, 8'h49, 8'h49, 8'h72, 8'h49, 8'h25, 8'h49, 8'hB1, 8'h8D, 8'h49, 8'h49, 8'h49, 8'h6D, 8'hB6, 8'h92, 8'h6D, 8'h4E, 8'h72, 8'h4E, 8'h52, 8'h4D, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h72, 8'hBA, 8'hBF, 8'hFF, 8'hDB, 8'h8D, 8'h49, 8'h49, 8'h49, 8'h29, 8'h69, 8'h49, 8'h6D, 8'h4D, 8'h4D, 8'h49, 8'h49, 8'h49, 8'h91, 8'h96, 8'h4D, 8'h72, 8'h73, 8'h4F, 8'h2A, 8'h4D, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h49, 8'hB6, 8'h76, 8'hDF, 8'hDA, 8'h4D, 8'h49, 8'h6D, 8'h25, 8'h49, 8'h4D, 8'h49, 8'h49, 8'h49, 8'h29, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h52, 8'h53, 8'h4E, 8'h4E, 8'h45, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h6D, 8'h96, 8'hDE, 8'h4D, 8'h49, 8'h49, 8'h49, 8'h69, 8'h49, 8'h29, 8'h25, 8'h29, 8'h25, 8'h29, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h52, 8'h4F, 8'h6E, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h4D, 8'h6D, 8'hDA, 8'h92, 8'h49, 8'h6D, 8'h49, 8'h8D, 8'h49, 8'h49, 8'h69, 8'h25, 8'h49, 8'h91, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h33, 8'h73, 8'h6E, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h04, 8'h6D, 8'h72, 8'hB6, 8'h6D, 8'h92, 8'h96, 8'hDA, 8'h92, 8'h91, 8'h96, 8'h6D, 8'h92, 8'hBA, 8'h4D, 8'h96, 8'hB6, 8'h6D, 8'h72, 8'h9B, 8'h72, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h6D, 8'h96, 8'hDA, 8'hB6, 8'hDB, 8'hB6, 8'h9A, 8'hB6, 8'hDA, 8'hBB, 8'h6E, 8'h91, 8'h91, 8'h92, 8'h96, 8'hB6, 8'h92, 8'h29, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'hB6, 8'hB6, 8'hBB, 8'hB6, 8'hDB, 8'hB6, 8'h96, 8'h96, 8'hB6, 8'h92, 8'h6D, 8'hB6, 8'h91, 8'h4D, 8'h6D, 8'hB6, 8'h49, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h92, 8'h72, 8'hB6, 8'hDB, 8'hB6, 8'hDA, 8'hDB, 8'hDA, 8'hB2, 8'h8D, 8'hB6, 8'h4D, 8'h6E, 8'h91, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h04, 8'h6E, 8'h6E, 8'h72, 8'h72, 8'hB6, 8'hDB, 8'hDB, 8'hDB, 8'h95, 8'hB6, 8'h96, 8'h92, 8'hB6, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h25, 8'h92, 8'h72, 8'h4D, 8'h72, 8'hDB, 8'hBA, 8'h72, 8'h6D, 8'hBB, 8'hDB, 8'hDB, 8'hBA, 8'h49, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h92, 8'h72, 8'h92, 8'hDB, 8'h72, 8'h49, 8'h71, 8'h6E, 8'hDB, 8'hB6, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'hDB, 8'hB6, 8'hB6, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'hB6, 8'h72, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'hFF, 8'hB6, 8'h4D, 8'h72, 8'hB6, 8'h92, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h25, 8'hDA, 8'hB6, 8'h49, 8'h49, 8'h92, 8'h6E, 8'h25, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h29, 8'hB6, 8'hDA, 8'hB2, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'hB6, 8'hB6, 8'h49, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h72, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};



//////////--------------------------------------------------------------------------------------------------------------=
//hit bit map has one bit per edge:  hit_colors[3:0] =   {Left, Top, Right, Bottom}	
//there is one bit per edge, in the corner two bits are set  


// pipeline (ff) to get the pixel color from the array 	 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
		if (objectExists)  // inside an external bracket 
			RGBout <= object_colors[pixelY[5:0] ][pixelX[5:0] ];	 
//			RGBout <=  {HitEdgeCode, 4'b0000 } ;  //get RGB from the colors table, option  for debug 
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = ((RGBout != TRANSPARENT_ENCODING ) ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule
