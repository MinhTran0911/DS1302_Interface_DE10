module CLK_div_50 (clk_in, reset_clk, clk_out);
	
	input logic clk_in;
	
	// This reset_clk signal is used to set the initial state of clk_out for simulation only.
	// Modelsim defaults a signal on power-up to be x, without setting the initial state for clk_out, it will be x all the time.
	// The CLK_div_50 module in the Quartus_Projects folder (which is used to upload to the FPGA) DOES NOT have this reset_clk signal.
	// On the FPGA, there is no x state. On power-up, clk_out will be either 0 or 1. Hence, the system will work fine without the reset_clk signal.
	input logic reset_clk;
	
	output logic clk_out;
	
	localparam DIVISOR = 5'd25;
	
	logic [4:0] count;
	
	always_ff @(posedge clk_in) begin
		if (reset_clk) begin
			clk_out <= 0;
			count <= 0;
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
		