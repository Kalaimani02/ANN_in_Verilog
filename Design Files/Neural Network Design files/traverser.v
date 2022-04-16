
`timescale 1 ns / 1 ps

	module traverser 
	(
	
		input wire  ACLK,
		input wire  ARESETN,
		
        output wire     [31:0]  layerNumber,      
        output wire     [31:0]  neuronNumber 
	);
	reg [31:0] increment_l;
	reg [31:0] increment_n;
 
	assign neuronNumber = increment_n ;
	assign layerNumber = increment_l;
	
	always @(posedge ACLK)
	begin
		if ( ARESETN == 1'b0 )
			begin
				increment_n <= 1;
				increment_l <= 1;
			end
		else 
		begin
			case(layerNumber)
			3'h1: begin
					  if(neuronNumber < 30 )
						begin
						  increment_n <= increment_n + 1;
						end
						else
						begin
							increment_n <= 0;
							increment_l <= increment_l + 1;
						end
						
					end
			3'h2: begin
					  if(neuronNumber < 30 )
						begin
						  increment_n <= increment_n + 1;
						end
						else
						begin
							increment_n <= 0;
							increment_l <= increment_l + 1;
						end
					end
			3'h3: begin

					  if(neuronNumber < 10 )
						begin
						  increment_n <= increment_n + 1;
						end
						else
						begin
							increment_n <= 0;
							increment_l <= increment_l + 1;
						end
						
					end

			3'h4: begin
					  if(neuronNumber < 10 )
						begin
						  increment_n <= increment_n + 1;
						end
						else
						begin
							increment_n <= 0;
							increment_l <= increment_l + 1;
						end
						
					end		
			endcase
			
		end
			
	end
	 
	 
		
endmodule
