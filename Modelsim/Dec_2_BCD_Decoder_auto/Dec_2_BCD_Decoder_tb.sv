`timescale 1ns/1ps

module Dec_2_BCD_Decoder_tb ();

	logic [4:0] hr_in;
	logic [5:0] min_in, sec_in;
	
	logic [7:0] hr_out, min_out, sec_out;
	
	logic [4:0] hr_in_data [0:5];
	logic [5:0] min_in_data [0:5];
	logic [5:0] sec_in_data [0:5];
	
	logic [7:0] expected_hr_out [0:5];
	logic [7:0] expected_min_out [0:5];
	logic [7:0] expected_sec_out [0:5];
	
	int error_count;
	
	Dec_2_BCD_Decoder DUT (.hr_in(hr_in),
							.min_in(min_in),
							.sec_in(sec_in),
							.hr_out(hr_out),
							.min_out(min_out),
							.sec_out(sec_out)
							);
							
	initial begin
		$readmemb("hr_in.txt", hr_in_data);
		$readmemb("min_in.txt", min_in_data);
		$readmemb("sec_in.txt", sec_in_data);
		$readmemb("hr_out.txt", expected_hr_out);
		$readmemb("min_out.txt", expected_min_out);
		$readmemb("sec_out.txt", expected_sec_out);
		#5;
		
		for (int i = 0; i < 6; i++) begin
			hr_in = hr_in_data[i];
			min_in = min_in_data[i];
			sec_in = sec_in_data[i];
			#5;
			
			if (hr_out !== expected_hr_out[i]) begin
				error_count += 1;
				$display("At %0g ns:", $time);
				$display("Error: Input 'hr_in' = %0d", hr_in);
				$display("Output 'hr_out' = %0d and Expected Output 'hr_out' = %0d", hr_out, expected_hr_out[i]);
			end
			
			if (min_out !== expected_min_out[i]) begin
				error_count += 1;
				$display("At %0g ns:", $time);
				$display("Error: Input 'min_in' = %0d", hr_in);
				$display("Output 'min_out' = %0d and Expected Output 'min_out' = %0d", min_out, expected_min_out[i]);
			end
			
			if (sec_out !== expected_sec_out[i]) begin
				error_count += 1;
				$display("At %0g ns:", $time);
				$display("Error: Input 'sec_in' = %0d", hr_in);
				$display("Output 'sec_out' = %0d and Expected Output 'sec_out' = %0d", sec_out, expected_sec_out[i]);
			end
			#5;
		end
	
	end
	
	initial begin
		$display("At %0g ns", $time);
		$display("<< Simulation Started >>");
		#70;
		$display("At %0g ns", $time);
		$display("<< Simulation Finished >>");
		$display("With %0d Output Mismatch(es)", error_count);
		$finish;
		$stop;
	end
	
endmodule 