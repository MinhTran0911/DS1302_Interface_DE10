`timescale 1us/1ps

module DS1302_Controller_tb ();
	
	parameter CLK_HALF_PERIOD = 5; 
	parameter CLK_FULL_PERIOD = 2 * CLK_HALF_PERIOD;
	
	logic clk1, rstn, rd_btn, wr_btn;
	logic [7:0] hr, min, sec; 
	logic [63:0] time_out;
	logic CE, SCLK;
	wire IO;
	
	DS1302_Controller DUT (	.clk1(clk1), 
							.rstn(rstn),
							.rd_btn(rd_btn), 
							.wr_btn(wr_btn), 
							.hr(hr), 
							.min(min), 
							.sec(sec), 
							.time_out(time_out), 
							.CE(CE), 
							.SCLK(SCLK), 
							.IO(IO)
						);
						
	// Generate clk
	initial begin
		clk1 = 0;
		forever #CLK_HALF_PERIOD clk1 = ~clk1;
	end
	
	// Test Reset
	initial begin
		rstn = 1;
		#(2*CLK_FULL_PERIOD) rstn = 0;
		#CLK_FULL_PERIOD rstn = 1;
	end
	
	// Test Write
	initial begin
		// Write 8:45:15
		hr = 8'b0000_1000; // 08 BCD
		min = 8'b0100_0101; // 45 BCD
		sec = 8'b0001_0101; // 15 BCD
		
		wr_btn = 1;
		#800;
		wr_btn = 0;
		#(3*CLK_FULL_PERIOD) wr_btn = 1;
	end
	
	// Test Read
	initial begin
		rd_btn = 1;
		#2300 rd_btn = 0;
		#(3*CLK_FULL_PERIOD) rd_btn = 1;
	end
	
	// Simulate the data coming from DS1302 RTC
	// Assume time from RTC is 22:06:48 (day, date, month, year are ignored)
	logic [63:0] RTC_data = {8'b0, 8'b0, 8'b0, 8'b0, 8'b0, 8'b0010_0010, 8'b0000_0110, 8'b0100_1000};
	
	logic IO_drive;
	logic io_dir;
	
	// io_dir set the direction for the bi-directional port IO. io_dir = 1: output io_dir = 0 input
	// IO can be set as input by setting it to the high-Z state. This allow the DUT module to drive this IO 
	assign IO = io_dir ? IO_drive : 1'bz;
	
	initial begin
		io_dir = 0;
		// Align the time data from RTC with the falling edge of SCLK after the write address is sent to RTC
		#2485;	
		io_dir = 1;
		for (int i = 0; i < 64; i++) begin
			IO_drive = RTC_data[i];
			#(2*CLK_FULL_PERIOD); // SCLK is toggled every rising edge of clk1, T_SCLK = 2*T_clk1
		end
	end
	
	initial begin
		$display("At %0g us", $time);
		$display("<< Simulation Started >>");
		#3850;
		$display("At %0g us", $time);
		$display("<< Simulation Finished >>");
		$finish;
		$stop;
	end
endmodule 