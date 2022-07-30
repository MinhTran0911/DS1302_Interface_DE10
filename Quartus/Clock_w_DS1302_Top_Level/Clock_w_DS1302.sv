module Clock_w_DS1302 (clk50, rstn, rd_btn, wr_btn, set_btn, ext_input, HEX, CE, SCLK, IO, hr_en, min_en, sec_en, hr_out, min_out, sec_out);
	
	input logic clk50, rstn, rd_btn, wr_btn, set_btn;
	input logic [5:0] ext_input;
	
	output logic [6:0] HEX [0:5];
	output logic CE, SCLK, hr_en, min_en, sec_en;
	
	// These are declared as output for verification purpose only, they are not real outputs of the system
	output logic [7:0] hr_out, min_out, sec_out;
	
	inout IO;
	
	logic clk1;
	logic [4:0] hr;
	logic [5:0] min, sec;
	logic [7:0] hr_bcd, min_bcd, sec_bcd;
	logic [63:0] time_data_out;
	
	Time_Setting Time_Set (.clk(clk50),
										.rstn(rstn),
										.set(set_btn),
										.ext_input(ext_input),
										.hr(hr),
										.min(min),
										.sec(sec),
										.hr_en(hr_en),
										.min_en(min_en),
										.sec_en(sec_en)
										);
	
	CLK_div_50 CLK_divider_50 (.clk_in(clk50), .clk_out(clk1));
	
	Dec_2_BCD_Decoder D2BCD (	.hr_in(hr), 
										.min_in(min), 
										.sec_in(sec), 
										.hr_out(hr_bcd), 
										.min_out(min_bcd), 
										.sec_out(sec_bcd)
									);
	
	DS1302_Controller Controller (.clk1(clk1), 
											.rstn(rstn), 
											.rd_btn(rd_btn), 
											.wr_btn(wr_btn), 
											.hr(hr_bcd), 
											.min(min_bcd), 
											.sec(sec_bcd), 
											.time_out(time_data_out), 
											.CE(CE), 
											.SCLK(SCLK), 
											.IO(IO)
											);
	
	// Extract hour, minute, second from the 64-bit register read from RTC in burst mode
	assign hr_out = {2'b00, time_data_out[21:16]}; // Bit 7 of hour register is to set 12/24 hour mode, bit 6 always read 0
	assign min_out = {1'b0, time_data_out[14:8]}; // Bit 7 of minute register does not affect the minute reading
	assign sec_out = {1'b0, time_data_out[6:0]}; // Bit 7 of second register is the Clock Halt (CH) flag
	
	Sev_Seg_Display HEX_Disp (	.hr(hr_out), 
										.min(min_out), 
										.sec(sec_out), 
										.HEX(HEX)
										);
									

endmodule
