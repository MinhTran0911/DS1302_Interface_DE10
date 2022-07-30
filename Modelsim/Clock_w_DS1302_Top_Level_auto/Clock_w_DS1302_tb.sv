`timescale 1ns/1ps

module Clock_w_DS1302_tb ();
	
	parameter CLK_HALF_PERIOD = 10;
	parameter CLK_FULL_PERIOD = CLK_HALF_PERIOD * 2;
	
	// This reset_clk signal is used to set the initial state of clk_out for simulation only.
	// Modelsim defaults a signal on power-up to be x, without setting the initial state for clk_out, it will be x all the time.
	// The CLK_div_50 module in the Quartus_Projects folder (which is used to upload to the FPGA) DOES NOT have this reset_clk signal.
	// On the FPGA, there is no x state. On power-up, clk_out will be either 0 or 1. Hence, the system will work fine without the reset_clk signal.
	logic reset_clk;
	
	logic clk50, clk1, rstn, rd_btn, wr_btn, set_btn; 
	logic CE, SCLK, hr_en, min_en, sec_en;
	logic IO_drive, IO_dir;
	wire IO;
	logic [5:0] ext_input;
	logic [6:0] HEX [0:5];
	logic [7:0] hr_out, min_out, sec_out;
	
	logic rstn_data [0:71];
	logic expected_CE_rst [0:71];
	logic expected_SCLK_rst [0:71];
	logic expected_IO_rst [0:71];
	
	logic set_btn_data [0:16];
	logic [5:0] ext_input_data [0:16];
	logic expected_hr_en [0:16];
	logic expected_min_en [0:16];
	logic expected_sec_en [0:16];
	
	logic wr_btn_data [0:146];
	logic expected_CE_wr [0:146];
	logic expected_SCLK_wr [0:146];
	logic expected_IO_wr [0:146];
	
	logic rd_btn_data [0:16];
	logic expected_CE_rd [0:16];
	logic expected_SCLK_rd [0:16];
	logic expected_IO_rd [0:16];
	
	logic [7:0] expected_hr_out [0:1];
	logic [7:0] expected_min_out [0:1];
	logic [7:0] expected_sec_out [0:1];
	logic [6:0] expected_HEX5 [0:1];
	logic [6:0] expected_HEX4 [0:1];
	logic [6:0] expected_HEX3 [0:1];
	logic [6:0] expected_HEX2 [0:1];
	logic [6:0] expected_HEX1 [0:1];
	logic [6:0] expected_HEX0 [0:1];
	
	int error_count;
	
	assign IO = IO_dir ? IO_drive : 1'bz;
	
	Clock_w_DS1302 DUT (.reset_clk(reset_clk),
						.clk50(clk50), 
						.clk1(clk1),
						.rstn(rstn), 
						.rd_btn(rd_btn), 
						.wr_btn(wr_btn), 
						.set_btn(set_btn), 
						.ext_input(ext_input), 
						.HEX(HEX), 
						.CE(CE), 
						.SCLK(SCLK), 
						.IO(IO), 
						.hr_en(hr_en), 
						.min_en(min_en), 
						.sec_en(sec_en), 
						.hr_out(hr_out), 
						.min_out(min_out), 
						.sec_out(sec_out)
					);
	
	initial begin
		clk50 = 0;
		forever #CLK_HALF_PERIOD clk50 = ~clk50;
	end
	
	initial begin
		reset_clk = 0;
		#5 reset_clk = 1;
		#CLK_HALF_PERIOD reset_clk = 0;
	end
	
	initial begin
		error_count = 0;
		rstn = 1;
		IO_dir = 0;
		IO_drive = 0;
	end
	
	// Test Reset
	initial begin
		$readmemb("in_rstn.txt", rstn_data);
		$readmemb("out_CE.txt", expected_CE_rst);
		$readmemb("out_SCLK.txt", expected_SCLK_rst);
		$readmemb("out_IO.txt", expected_IO_rst);
		#1310;
		
		for (int i = 0; i < 72; i++) begin
			rstn = rstn_data[i];
			#520;
			if (CE !== expected_CE_rst[i]) begin
				error_count += 1;
				$display("At %0g ns", $time);
				$display("ERROR: Output 'CE' = %0b and Expected Output 'CE' = %0b", CE, expected_CE_rst[i]);
			end
			
			if (SCLK !== expected_SCLK_rst[i]) begin
				error_count += 1;
				$display("At %0g ns", $time);
				$display("ERROR: Output 'SCLK' = %0b and Expected Output 'SCLK' = %0b", SCLK, expected_SCLK_rst[i]);
			end
			
			if (IO !== expected_IO_rst[i]) begin
				error_count += 1;
				$display("At %0g ns", $time);
				$display("ERROR: Output 'IO' = %0b and Expected Output 'IO' = %0b", IO, expected_IO_rst[i]);
			end
			#520;
		end
	end
	
	initial begin
		wr_btn = 1;
		rd_btn = 1;
		set_btn = 1;
		ext_input = 6'd0;
	end
	
	// Test Input Time
	initial begin
		$readmemb("in_set_btn.txt", set_btn_data);
		$readmemb("in_ext_input.txt", ext_input_data);
		$readmemb("out_hr_en.txt", expected_hr_en);
		$readmemb("out_min_en.txt", expected_min_en);
		$readmemb("out_sec_en.txt", expected_sec_en);
		#77985;
		
		for (int i = 0; i < 17; i++) begin
			set_btn = set_btn_data[i];
			ext_input = ext_input_data[i];
			#CLK_HALF_PERIOD;
			if (hr_en !== expected_hr_en[i]) begin
				error_count += 1;
				$display("At %0g ns", $time);
				$display("ERROR: Output 'hr_en' = %0b and Expected Output 'hr_en' = %0b", hr_en, expected_hr_en[i]);
			end
			
			if (min_en !== expected_min_en[i]) begin
				error_count += 1;
				$display("At %0g ns", $time);
				$display("ERROR: Output 'min_en' = %0b and Expected Output 'min_en' = %0b", min_en, expected_min_en[i]);
			end
			
			if (sec_en !== expected_sec_en[i]) begin
				error_count += 1;
				$display("At %0g ns", $time);
				$display("ERROR: Output 'sec_en' = %0b and Expected Output 'sec_en' = %0b", sec_en, expected_sec_en[i]);
			end
			#CLK_HALF_PERIOD;
		end
		
		set_btn = 1;
	end
	
	// Test Write
	initial begin
		$readmemb("in_wr_btn.txt", wr_btn_data);
		$readmemb("out_CE_wr.txt", expected_CE_wr);
		$readmemb("out_SCLK_wr.txt", expected_SCLK_wr);
		$readmemb("out_IO_wr.txt", expected_IO_wr);
		#83470;
		
		for (int i = 0; i < 147; i++) begin
			wr_btn = wr_btn_data[i];
			#520;
			if (CE !== expected_CE_wr[i]) begin
				error_count += 1;
				$display("At %0g ns", $time);
				$display("ERROR: Output 'CE' = %0b and Expected Output 'CE' = %0b", CE, expected_CE_wr[i]);
			end
			
			if (SCLK !== expected_SCLK_wr[i]) begin
				error_count += 1;
				$display("At %0g ns", $time);
				$display("ERROR: Output 'SCLK' = %0b and Expected Output 'SCLK' = %0b", SCLK, expected_SCLK_wr[i]);
			end
			
			if (IO !== expected_IO_wr[i]) begin
				error_count += 1;
				$display("At %0g ns", $time);
				$display("ERROR: Output 'IO' = %0b and Expected Output 'IO' = %0b", IO, expected_IO_wr[i]);
			end
			#520;
		end
		wr_btn = 1;	
	end
	
	// Test Read
	initial begin
		$readmemb("in_rd_btn.txt", rd_btn_data);
		$readmemb("out_CE_rd.txt", expected_CE_rd);
		$readmemb("out_SCLK_rd.txt", expected_SCLK_rd);
		$readmemb("out_IO_rd.txt", expected_IO_rd);
		#244670;
		
		for (int i = 0; i < 17; i++) begin
			rd_btn = rd_btn_data[i];
			#520;
			if (CE !== expected_CE_rd[i]) begin
				error_count += 1;
				$display("At %0g ns", $time);
				$display("ERROR: Output 'CE' = %0b and Expected Output 'CE' = %0b", CE, expected_CE_rd[i]);
			end
			
			if (SCLK !== expected_SCLK_rd[i]) begin
				error_count += 1;
				$display("At %0g ns", $time);
				$display("ERROR: Output 'SCLK' = %0b and Expected Output 'SCLK' = %0b", SCLK, expected_SCLK_rd[i]);
			end
			
			if (IO !== expected_IO_rd[i]) begin
				error_count += 1;
				$display("At %0g ns", $time);
				$display("ERROR: Output 'IO' = %0b and Expected Output 'IO' = %0b", IO, expected_IO_rd[i]);
			end
			#520;
		end
		rd_btn = 1;	
	end
	
	// Simulate the RTC sends 20:52:18
	logic [7:0] simulate_hr = 8'b0010_0000; // 20 in BCD
	logic [7:0] simulate_min = 8'b0101_0010; // 52 in BCD
	logic [7:0] simulate_sec = 8'b0001_1000; // 18 in BCD
	// Simulate the time data receive from the RTC
	initial begin
		#262610;
		IO_dir = 1;
		#1040;
		for (int i = 0; i < 8; i++) begin
			IO_drive = simulate_sec[i];
			#2080;
		end
		
		for (int i = 0; i < 8; i++) begin
			IO_drive = simulate_min[i];
			#2080;
		end
		
		for (int i = 0; i < 8; i++) begin
			IO_drive = simulate_hr[i];
			#2080;
		end
	end
	
	// Check hr, min, sec read from RTC
	initial begin
		$readmemb("hr_out.txt", expected_hr_out);
		$readmemb("min_out.txt", expected_min_out);
		$readmemb("sec_out.txt", expected_sec_out);
		$readmemb("out_HEX5.txt", expected_HEX5);
		$readmemb("out_HEX4.txt", expected_HEX4);
		$readmemb("out_HEX3.txt", expected_HEX3);
		$readmemb("out_HEX2.txt", expected_HEX2);
		$readmemb("out_HEX1.txt", expected_HEX1);
		$readmemb("out_HEX0.txt", expected_HEX0);
		
		#400000;
		if (hr_out !== expected_hr_out[0]) begin
			error_count += 1;
			$display("At %0g ns", $time);
			$display("ERROR: Output 'hr_out' = %8b and Expected Output 'hr_out' = %8b", hr_out, expected_hr_out[0]);
		end
		
		if (min_out !== expected_min_out[0]) begin
			error_count += 1;
			$display("At %0g ns", $time);
			$display("ERROR: Output 'min_out' = %8b and Expected Output 'min_out' = %8b", min_out, expected_min_out[0]);
		end
		
		if (sec_out !== expected_sec_out[0]) begin
			error_count += 1;
			$display("At %0g ns", $time);
			$display("ERROR: Output 'sec_out' = %8b and Expected Output 'sec_out' = %8b", sec_out, expected_sec_out[0]);
		end
		
		if (HEX[5] !== expected_HEX5[0]) begin
			error_count += 1;
			$display("At %0g ns", $time);
			$display("ERROR: Output 'HEX5' = %7b and Expected Output 'HEX5' = %7b", HEX[5], expected_HEX5[0]);
		end
		
		if (HEX[4] !== expected_HEX4[0]) begin
			error_count += 1;
			$display("At %0g ns", $time);
			$display("ERROR: Output 'HEX4' = %7b and Expected Output 'HEX4' = %7b", HEX[4], expected_HEX4[0]);
		end
		
		if (HEX[3] !== expected_HEX3[0]) begin
			error_count += 1;
			$display("At %0g ns", $time);
			$display("ERROR: Output 'HEX3' = %7b and Expected Output 'HEX3' = %7b", HEX[3], expected_HEX3[0]);
		end
		
		if (HEX[2] !== expected_HEX2[0]) begin
			error_count += 1;
			$display("At %0g ns", $time);
			$display("ERROR: Output 'HEX2' = %7b and Expected Output 'HEX2' = %7b", HEX[2], expected_HEX2[0]);
		end
		
		if (HEX[1] !== expected_HEX1[0]) begin
			error_count += 1;
			$display("At %0g ns", $time);
			$display("ERROR: Output 'HEX1' = %7b and Expected Output 'HEX1' = %7b", HEX[1], expected_HEX1[0]);
		end
		
		if (HEX[0] !== expected_HEX0[0]) begin
			error_count += 1;
			$display("At %0g ns", $time);
			$display("ERROR: Output 'HEX0' = %7b and Expected Output 'HEX0' = %7b", HEX[0], expected_HEX0[0]);
		end
	end
	
	initial begin
		$display("At %0g ns", $time);
		$display("<< Simulation Started >>");
		#450000;
		$display("At %0g ns", $time);
		$display("<< Simulation Finished >>");
		$display("With %0d Output Mismatch(es)", error_count);
		$finish;
		$stop;
	end
endmodule 
	
	