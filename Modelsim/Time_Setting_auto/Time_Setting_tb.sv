`timescale 1ns/1ps

module Time_Setting_tb ();
	
	parameter CLK_HALF_PERIOD = 10;
	parameter CLK_FULL_PERIOD = CLK_HALF_PERIOD * 2;
	
	logic in_clk, in_rstn, in_set, out_hr_en, out_min_en, out_sec_en;
	logic [5:0] in_ext_input;
	
	logic [4:0] out_hr;
	logic [5:0] out_min, out_sec;
	
	logic set_data [0:20];
	logic [5:0] ext_input_data [0:20];
	
	logic expected_hr_en [0:20];
	logic expected_min_en [0:20];
	logic expected_sec_en [0:20];
	logic [4:0] expected_hr [0:20];
	logic [5:0] expected_min [0:20];
	logic [5:0] expected_sec [0:20];
	
	int error_count;
	
	Time_Setting DUT (	.clk(in_clk), 
						.rstn(in_rstn), 
						.ext_input(in_ext_input), 
						.set(in_set), 
						.hr(out_hr), 
						.min(out_min), 
						.sec(out_sec), 
						.hr_en(out_hr_en), 
						.min_en(out_min_en), 
						.sec_en(out_sec_en)
					);
					
	initial begin
		in_clk = 0;
		forever #CLK_HALF_PERIOD in_clk = ~in_clk;
	end
	
	// Test Reset
	initial begin
		in_rstn = 1;
		#5 in_rstn = 0;
		#CLK_FULL_PERIOD in_rstn = 1;
	end
	
	initial begin
		error_count = 0;
		in_set = 1;
		$readmemb("in_set.txt", set_data);
		$readmemb("in_ext_input.txt", ext_input_data);
		$readmemb("out_hr_en.txt", expected_hr_en);
		$readmemb("out_min_en.txt", expected_min_en);
		$readmemb("out_sec_en.txt", expected_sec_en);
		$readmemb("out_hr.txt", expected_hr);
		$readmemb("out_min.txt", expected_min);
		$readmemb("out_sec.txt", expected_sec);
		#45;
		
		for (int i = 0; i < 21; i++) begin
			in_set = set_data[i];
			in_ext_input = ext_input_data[i];
			#CLK_HALF_PERIOD;
			
			if (out_hr_en !== expected_hr_en[i]) begin
				error_count += 1;
				$display("At %0g ns", $time);
				$display("Output 'hr_en' = %0b and Expected Output 'hr_en' = %0b", out_hr_en, expected_hr_en[i]);
			end
			
			if (out_min_en !== expected_min_en[i]) begin
				error_count += 1;
				$display("At %0g ns", $time);
				
				$display("Output 'min_en' = %0b and Expected Output 'min_en' = %0b", out_min_en, expected_min_en[i]);
			end
			
			if (out_sec_en !== expected_sec_en[i]) begin
				error_count += 1;
				$display("At %0g ns", $time);
				$display("Output 'sec_en' = %0d and Expected Output 'sec_en' = %0d", out_sec_en, expected_sec_en[i]);
			end
			
			#CLK_FULL_PERIOD;
			
			if (out_hr !== expected_hr[i]) begin
				error_count += 1;
				$display("At %0g ns", $time);
				$display("ERROR: input 'ext_input' = %0d", in_ext_input);
				$display("Output 'hr' = %0d and Expected Output 'hr' = %0d", out_hr, expected_hr[i]);
			end
			
			if (out_min !== expected_min[i]) begin
				error_count += 1;
				$display("At %0g ns", $time);
				$display("ERROR: input 'ext_input' = %0d", in_ext_input);
				$display("Output 'min' = %0d and Expected Output 'min' = %0d", out_min, expected_min[i]);
			end
			
			if (out_sec !== expected_sec[i]) begin
				error_count += 1;
				$display("At %0g ns", $time);
				$display("ERROR: input 'ext_input' = %0d", in_ext_input);
				$display("Output 'sec' = %0d and Expected Output 'sec' = %0d", out_sec, expected_sec[i]);
			end
			#CLK_HALF_PERIOD;
		end
	end
	
	initial begin
		$display("At %0g ns", $time);
		$display("<< Simulation Started >>");
		#900;
		$display("At %0g ns", $time);
		$display("<< Simulation Finished >>");
		$display("With %0d Output Mismatch(es)", error_count);
		$finish;
		$stop;
	end
	
endmodule 