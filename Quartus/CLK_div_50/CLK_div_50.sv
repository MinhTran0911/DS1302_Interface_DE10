module CLK_div_50 (clk_in, clk_out);
	// freq clk_out = 1/50 freq clk_in 
	
	input logic clk_in;
	output logic clk_out;
	
	localparam DIVISOR = 5'd25;
	
	logic [4:0] count;
	
	always_ff @(posedge clk_in) begin
			count <= count + 5'd1;
			if (count == DIVISOR) begin
				count <= 0;
				clk_out <= ~clk_out;
			end
	end
	
endmodule 
		