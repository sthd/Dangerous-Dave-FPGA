//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// New bitmap dudy October 2020
// (c) Technion IIT, Department of Electrical Engineering 2020 

module	playerBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input 	logic	[10:0] offsetX,// offset from top left  position 
					input 	logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					//input logic enableDraw,

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout,  //rgb value from the bitmap 
					output	logic	[3:0] HitEdgeCode //one bit per edge 
 ) ;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  // 2^5 = 32 
localparam  int OBJECT_NUMBER_OF_X_BITS = 5;  // 2^5 = 32


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_HEIGHT_Y_DIVIDER = OBJECT_NUMBER_OF_Y_BITS - 2; //how many pixel bits are in every collision pixel
localparam  int OBJECT_WIDTH_X_DIVIDER =  OBJECT_NUMBER_OF_X_BITS - 2;


localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 


// it's a player bitmap
logic [0:OBJECT_WIDTH_X-1] [0:OBJECT_HEIGHT_Y-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hA0, 8'hA0, 8'hC0, 8'hC0, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hA0, 8'hA0, 8'h80, 8'h80, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hA0, 8'hA0, 8'hC0, 8'hC0, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hA0, 8'hA0, 8'h80, 8'h80, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h80, 8'h80, 8'hC0, 8'hC0, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hC0, 8'hC0, 8'hA0, 8'hA0, 8'h80, 8'h80, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h80, 8'h80, 8'hC0, 8'hC0, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hC0, 8'hC0, 8'hA0, 8'hA0, 8'h80, 8'h80, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h89, 8'h89, 8'h68, 8'h68, 8'hAD, 8'hAD, 8'hF6, 8'hF6, 8'h83, 8'h83, 8'hF1, 8'hF1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h89, 8'h89, 8'h68, 8'h68, 8'hAD, 8'hAD, 8'hF6, 8'hF6, 8'h83, 8'h83, 8'hF1, 8'hF1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h68, 8'h68, 8'hF6, 8'hF6, 8'hAD, 8'hAD, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF1, 8'hF1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h68, 8'h68, 8'hF6, 8'hF6, 8'hAD, 8'hAD, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF1, 8'hF1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF1, 8'hF1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF1, 8'hF1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hB6, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hB6, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF1, 8'hF1, 8'hB6, 8'hB6, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hF6, 8'hF6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF1, 8'hF1, 8'hB6, 8'hB6, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hF6, 8'hF6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF1, 8'hF1, 8'hF1, 8'hF1, 8'hB6, 8'hB6, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF1, 8'hF1, 8'hF1, 8'hF1, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF1, 8'hF1, 8'hF1, 8'hF1, 8'hB6, 8'hB6, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF1, 8'hF1, 8'hF1, 8'hF1, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF1, 8'hF1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF1, 8'hF1, 8'hF1, 8'hF1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hF6, 8'hF6, 8'hF6, 8'hF6, 8'hF1, 8'hF1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF1, 8'hF1, 8'hF1, 8'hF1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h57, 8'h57, 8'h33, 8'h33, 8'h13, 8'h13, 8'h0F, 8'h0F, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h57, 8'h57, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h57, 8'h57, 8'h33, 8'h33, 8'h13, 8'h13, 8'h0F, 8'h0F, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h57, 8'h57, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'h57, 8'h57, 8'h33, 8'h33, 8'h13, 8'h13, 8'h0F, 8'h0F, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'hFF, 8'hFF, 8'h57, 8'h57, 8'h33, 8'h33, 8'h13, 8'h13, 8'h0E, 8'h0E, 8'h0A, 8'h0A, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'h57, 8'h57, 8'h33, 8'h33, 8'h13, 8'h13, 8'h0F, 8'h0F, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'hFF, 8'hFF, 8'h57, 8'h57, 8'h33, 8'h33, 8'h13, 8'h13, 8'h0E, 8'h0E, 8'h0A, 8'h0A, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'h57, 8'h57, 8'h33, 8'h33, 8'h13, 8'h13, 8'h0E, 8'h0E, 8'h0A, 8'h0A, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h57, 8'h57, 8'h13, 8'h13, 8'h0A, 8'h0A, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'h57, 8'h57, 8'h33, 8'h33, 8'h13, 8'h13, 8'h0E, 8'h0E, 8'h0A, 8'h0A, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h57, 8'h57, 8'h13, 8'h13, 8'h0A, 8'h0A, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hB6, 8'hB6, 8'h6D, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hB6, 8'hB6, 8'h6D, 8'h6D, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hB6, 8'hB6, 8'h6D, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hB6, 8'hB6, 8'h6D, 8'h6D, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};



//////////--------------------------------------------------------------------------------------------------------------=
//hit bit map has one bit per edge:  hit_colors[3:0] =   {Left, Top, Right, Bottom}	
//there is one bit per edge, in the corner two bits are set  


/*
//a is which row (for y), b is which column (for x), the value is 4 bits
logic [0:3] [0:3] [3:0] hit_colors = 
{16'hC446,     //16'b1100010001000110	1100 0100 0100 0110
 16'h8C62,    	//16'b1000110001100010	1000 1100 0110 0010
 16'h8932,		//16'b1000100100110010	1000 1001 0011 0010
 16'h9113};		//16'b1001000100010011	1001 0001 0001 0011  
 */

logic [0:3] [0:3] [3:0] hit_colors = 
{16'b0100010001000100,     //1100 0100 0100 0110  //1100 0100 0100 0110
 16'b1000100001100010,    	//1000 1100 0110 0010  //1000 1100 0110 0010
 16'b1000000100100010,		//1000 1001 0011 0010  //1000 1001 0011 0010
 16'b0001000100010001};		//1001 0001 0001 0011  //1001 0001 0001 0011 

// pipeline (ff) to get the pixel color from the array 	 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
		HitEdgeCode <= hit_colors[offsetY >> OBJECT_HEIGHT_Y_DIVIDER][offsetX >> OBJECT_WIDTH_X_DIVIDER];	//get hitting edge from the colors table  

	
		if (InsideRectangle == 1'b1 )  // inside an external bracket 
			RGBout <= object_colors[offsetY][offsetX];	 
//			RGBout <=  {HitEdgeCode, 4'b0000 } ;  //get RGB from the colors table, option  for debug 
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = ((RGBout != TRANSPARENT_ENCODING ) ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule
