`timescale 1ns/1ps

module Sev_Seg_Display_tb ();

	logic [7:0] in_hr, in_min, in_sec;
	
	logic [6:0] out_HEX [0:5];
	
	logic [7:0] hr_data [0:8];
	logic [7:0] min_data [0:8];
	logic [7:0] sec_data [0:8];
	
	logic [6:0] expected_HEX0 [0:8];
	logic [6:0] expected_HEX1 [0:8];
	logic [6:0] expected_HEX2 [0:8];
	logic [6:0] expected_HEX3 [0:8];
	logic [6:0] expected_HEX4 [0:8];
	logic [6:0] expected_HEX5 [0:8];
	
	int error_count;
	
	Sev_Seg_Display DUT (.hr(in_hr),
						 .min(in_min),
						 .sec(in_sec),
						 .HEX(out_HEX)
						);
	
	initial begin
		$readmemb("in_hr.txt", hr_data);
		$readmemb("in_min.txt", min_data);
		$readmemb("in_sec.txt", sec_data);
		$readmemb("out_HEX0.txt", expected_HEX0);
		$readmemb("out_HEX1.txt", expected_HEX1);
		$readmemb("out_HEX2.txt", expected_HEX2);
		$readmemb("out_HEX3.txt", expected_HEX3);
		$readmemb("out_HEX4.txt", expected_HEX4);
		$readmemb("out_HEX5.txt", expected_HEX5);
		#5;
		
		for (int i = 0; i < 8; i++) begin
			
			in_hr = hr_data[i];
			in_min = min_data[i];
			in_sec = sec_data[i];
			#10;
			
			if (out_HEX[0] !== expected_HEX0[i]) begin
				error_count += 1;
				$display("Error: Inputs 'hr' = %0d, 'min' = %0d, and 'sec' = %0d", in_hr, in_min, in_sec);
				$display("Output 'HEX0' = %7b and Expected Output 'HEX0' = %7b", out_HEX[0], expected_HEX0[i]);
			end
			
			if (out_HEX[1] !== expected_HEX1[i]) begin
				error_count += 1;
				$display("Error: Inputs 'hr' = %0d, 'min' = %0d, and 'sec' = %0d", in_hr, in_min, in_sec);
				$display("Output 'HEX1' = %7b and Expected Output 'HEX1' = %7b", out_HEX[1], expected_HEX1[i]);
			end
			
			if (out_HEX[2] !== expected_HEX2[i]) begin
				error_count += 1;
				$display("Error: Inputs 'hr' = %0d, 'min' = %0d, and 'sec' = %0d", in_hr, in_min, in_sec);
				$display("Output 'HEX2' = %7b and Expected Output 'HEX2' = %7b", out_HEX[2], expected_HEX2[i]);
			end
			
			if (out_HEX[3] !== expected_HEX3[i]) begin
				error_count += 1;
				$display("Error: Inputs 'hr' = %0d, 'min' = %0d, and 'sec' = %0d", in_hr, in_min, in_sec);
				$display("Output 'HEX3' = %7b and Expected Output 'HEX3' = %7b", out_HEX[3], expected_HEX3[i]);
			end
			
			if (out_HEX[4] !== expected_HEX4[i]) begin
				error_count += 1;
				$display("Error: Inputs 'hr' = %0d, 'min' = %0d, and 'sec' = %0d", in_hr, in_min, in_sec);
				$display("Output 'HEX4' = %7b and Expected Output 'HEX4' = %7b", out_HEX[4], expected_HEX4[i]);
			end
			
			if (out_HEX[5] !== expected_HEX5[i]) begin
				error_count += 1;
				$display("Error: Inputs 'hr' = %0d, 'min' = %0d, and 'sec' = %0d", in_hr, in_min, in_sec);
				$display("Output 'HEX5' = %7b and Expected Output 'HEX5' = %7b", out_HEX[5], expected_HEX5[i]);
			end
			
			#10;
			
		end
	end
	
	initial begin
		$display("At %0g ns", $time);
		$display("<< Simulation Started >>");
		#180;
		$display("At %0g ns", $time);
		$display("<< Simulation Finished >>");
		$display("With %0d Output Mismatch(es)", error_count);
		$finish;
		$stop;
	end
	
endmodule 