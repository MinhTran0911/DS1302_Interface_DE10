module CLK_div_50 (clk_in, clk_reset, clk_out);
	
	input logic clk_in;
	
	// This clock reset signal is for simulation only, otherwise the initial state of clk_out is x, and clk_out stays as x forever.
	// Reset allows clk_out to drop to 0 initially.
	
	// The CLK_div_50 module in the Quartus_Projects folder (which is used to load to the FPGA) does not have a clk_reset signal.
	// On the FPGA, there is no x state. Hence at power on, clk_out will either be 1 or 0, the behavior of the system on FPGA is not affected.
	input logic clk_reset;
	
	output logic clk_out = 1'b0;
	
	localparam DIVISOR = 5'd25;
	
	logic [4:0] count;
	
	always_ff @(posedge clk_in) begin
			if (clk_reset) begin
				count <= 0;
				clk_out <= 0;
			end
			
			else begin
				count <= count + 5'd1;
				if (count == DIVISOR) begin
					count <= 0;
					clk_out <= ~clk_out;
				end
			end
	end
	
endmodule 
		