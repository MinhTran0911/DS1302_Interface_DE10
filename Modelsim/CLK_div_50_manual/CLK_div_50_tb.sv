`timescale 1ns/1ps

module CLK_div_50_tb ();
	
	parameter CLK_HALF_PERIOD = 10;
	
	// clk_reset is used to set the initial state of clk_out in simulation only.
	// The CLK_div_50 module in the Quartus_Projects folder does not have the clk_reset signal. 
	// On an FPGA, there is no x state, the power on state for clk_out is either 0 or 1, hence it will not affect the system on FPGA.
	logic clk_in, clk_reset, clk_out;
	
	CLK_div_50 DUT (.clk_in(clk_in), .clk_reset(clk_reset), .clk_out(clk_out));
	
	initial begin
		clk_reset = 0;
		#5 clk_reset = 1;
		#10 clk_reset = 0;
	end
	
	initial begin
		clk_in = 0;
		forever #CLK_HALF_PERIOD clk_in = ~clk_in;
	end
	
	initial begin
		#2_000;
		$finish;
		$stop;
	end
	
endmodule