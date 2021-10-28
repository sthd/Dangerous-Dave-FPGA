// (c) Technion IIT, Department of Electrical Engineering 2018 

// Implements a 4 bits down counter 9 to 0 with enable, enable count and loadN data.
// It outputs count and asynchronous terminal count, tc, signal 

module up_counter
	(
	input logic clk, 
	input logic resetN, 
	input logic loadN, 
	input logic ena,
	input logic ena_cnt, 
	input logic countDownMode, 
	input logic [3:0] datain,
	
	output logic [3:0] count,
	output logic tc
   );
	
logic [3:0] changeDigit;

// Down counter
always_ff @(posedge clk or negedge resetN)
begin  
	if ( !resetN )	begin// Asynchronic reset
		//count=4'b0000;
		count<=datain;
	end
	else if (!loadN) begin
		count<=datain;
	end
   else if (ena && ena_cnt) begin
	
			//count down option
			if (countDownMode) begin
				changeDigit=4'b0000;
				if (count==4'b0000) begin
					count<=4'b1001;
				end
				else begin
					count<=count-1;
				end
			end// count down
			
			//count up
			else begin
				changeDigit=4'b1001;
				if (count==4'b1001) begin
					count<=4'b0000;
				end
				else begin
					count<=count+1;
				end
			end
	end //if enable
			
end //always

assign tc = (count == changeDigit) ? 1'b1 : 1'b0;

endmodule
/*
always_comb
begin


	if (count==4'b0000) begin
		tc=1'b1;
	end
	else begin
		tc=1'b0;
	end
end
	*/

