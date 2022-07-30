module Time_Setting (clk, rstn, ext_input, set, hr, min, sec, hr_en, min_en, sec_en);

	input logic clk, rstn, set;
	input logic [5:0] ext_input;
	
	output logic [4:0] hr;
	output logic [5:0] min, sec;
	
	// These logics are set as output for verification purpose only, they are not real outputs of the system
	output logic hr_en, min_en, sec_en;
	
	logic [1:0] state, next_state;
	logic prev_set;
	
	typedef enum {SET_HR, SET_MIN, SET_SEC, IDLE} States;
	
	always_ff @(posedge clk) begin
		if (!rstn) begin
			hr <= 5'd0;
			min <= 6'd0;
			sec <= 6'd0;
		end // end if (!rstn)
		
		else begin
			// Set the hr, min, or sec to the value from the external switches input when the corresponding enable signal is HIGH
			if (hr_en) begin
				if (ext_input > 5'd24) hr <= 5'd23; // Max hour is 23, even if inputting greater number
				else hr <= ext_input;
			end // end if (hr_en)
			else if (min_en) begin
				if (ext_input > 6'd59) min <= 6'd59; // Max minute is 59, even if inputting greater number
				else min <= ext_input;
			end // end if (min_en)
			else if (sec_en) begin
				if (ext_input > 6'd59) sec <= 6'd59; // Max second is 59, even if inputting greater number
				else sec <= ext_input;
			end // end if (sec_en)
		end
	end
	
	// Detect falling edge of set button
	always_ff @(posedge clk) begin
		if (set) prev_set <= 1;
		else if (prev_set) prev_set <= 0;
	end
	
	always_ff @(posedge clk) begin
		if (!rstn) state <= IDLE;
		else state <= next_state;
	end
	
	// Comb block to determine next state
	always_comb begin
		case (state)
			SET_HR:
				begin
					if (!set && prev_set) next_state = SET_MIN;
					else next_state = SET_HR;
				end
				
			SET_MIN:
				begin
					if (!set && prev_set) next_state = SET_SEC;
					else next_state = SET_MIN;
				end
				
			SET_SEC:
				begin
					if (!set && prev_set) next_state = IDLE;
					else next_state = SET_SEC;
				end
				
			IDLE:
				begin
					if (!set && prev_set) next_state = SET_HR;
					else next_state = IDLE;
				end
				
			default:
				begin
					next_state = IDLE;
				end
		endcase
	end
	
	// Comb block to determine outputs
	always_comb begin
		case (state)
			SET_HR:
				begin
					hr_en = 1;
					min_en = 0;
					sec_en = 0;
				end
				
			SET_MIN:
				begin
					hr_en = 0;
					min_en = 1;
					sec_en = 0;
				end
				
			SET_SEC:
				begin
					hr_en = 0;
					min_en = 0;
					sec_en = 1;
				end
				
			IDLE:
				begin
					hr_en = 0;
					min_en = 0;
					sec_en = 0;
				end
				
			default:
				begin
					hr_en = 0;
					min_en = 0;
					sec_en = 0;
				end
		endcase
			
	end
	
endmodule 