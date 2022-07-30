module DS1302_Controller (clk1, rstn, rd_btn, wr_btn, hr, min, sec, time_out, CE, SCLK, IO);
	
	// Clock address of DS1302 RTC module
	localparam BURST_RD_ADDR = 8'hBF;
	localparam BURST_WR_ADDR = 8'hBE;
	localparam WR_CTRL_REG_ADDR = 8'h8E;
	localparam WR_SEC_REG_ADDR = 8'h80;
	
	input logic clk1, rstn, rd_btn, wr_btn;
	input logic [7:0] hr, min, sec; // Time to write, in BCD format
	
	output logic CE, SCLK;
	output logic [63:0] time_out;
	
	inout logic IO; // IO is a bi-directional port (used for both read and write operations)
	
	logic prev_rd_btn, prev_wr_btn;
	logic io_dir, io; // io_dir controls the direction of IO port, io_dir = 1: output, io_dir = 0: input
	logic CH_init, WP_init; // These flags check if the RTC module has been initialized (Write Protection and Clock Halt is cleared) or not
	logic [3:0] state;
	logic [6:0] count; // count to keep track of the current data bit
	logic [7:0] addr;
	logic [63:0] burst_data;
	
	typedef enum {IDLE, WR_ADDR_PREP, WR_ADDR, CNT_RST, WR_BURST_PREP, WR_BURST, WR_SINGLE_PREP, WR_SINGLE, RD_BURST, STO_BURST, TERMINATE} States;
	
	// Time data to write to RTC module, day, date, month, year are sent as 0s. Functionality can be expanded later
	assign burst_data = {8'b0, 8'b0, 8'b0, 8'b0, 8'b0, hr, min, sec};
	
	assign IO = io_dir ? io : 1'bz; // In order for IO port to be an input port, it has to be set to a high-imdedance state (hi-Z)
	
	// Detect Read button falling edge
	always_ff @(posedge clk1) begin
		if (rd_btn) prev_rd_btn <= 1;
		else if (prev_rd_btn) begin
			prev_rd_btn <= 0;
		end
	end // end always_ff
	
	// Detect Write button falling edge
	always_ff @(posedge clk1) begin
		if (wr_btn) prev_wr_btn <= 1;
		else if (prev_wr_btn) begin
			prev_wr_btn <= 0;
		end
	end // end always_ff
	
					  
	always_ff @(posedge clk1) begin
		if (!rstn) begin
			count <= 0;
			state <= IDLE;
			CE <= 0;
			SCLK <= 0;
			io_dir <= 1;
			io <= 0;
			time_out <= 64'd0;
			WP_init <= 0;
			CH_init <= 0;
		end // end if (!rstn)
		
		else begin
			case (state)
				IDLE:
					begin
						CE <= 0;
						SCLK <= 0;
						count <= 0;
						io_dir <= 1;
						
						if (!WP_init) begin
							addr <= WR_CTRL_REG_ADDR;
							state <= WR_ADDR_PREP;
						end // end if (!WP_init)
						else if (!CH_init) begin
							addr <= WR_SEC_REG_ADDR;
							state <= WR_ADDR_PREP;
						end // end if (!CH_init)
						else if (!wr_btn && prev_wr_btn) begin
							addr <= BURST_WR_ADDR;
							state <= WR_ADDR_PREP;
						end // end if (!wr_btn && prev_wr_btn)
						else if (!rd_btn && prev_rd_btn) begin
							addr <= BURST_RD_ADDR;
							state <= WR_ADDR_PREP;
						end // end if (!rd_btn && prev_rd_btn)
						else state <= IDLE;
					end // end IDLE state
					
				WR_ADDR_PREP: // Prepare the current address bit value at SCLK low level
					begin
						CE <= 1; // CE is set HIGH to initiate communication
						SCLK <= 0;
						io_dir <= 1;
						io <= addr[count];
						state <= WR_ADDR;
					end // end WR_ADDR_PREP state
					
				WR_ADDR: // Raise SCLK to send address bit
					begin
						SCLK <= 1;
						count <= count + 7'd1;
						
						if (count == 7'd7) state <= CNT_RST; // If all 8 address bits are sent, move to transferring data
						else state <= WR_ADDR_PREP; // Else continue to send remaining address bits
					end // end WR_ADDR state
					
				CNT_RST: // Reset count and move to read or write state based on the sent address
					begin
						count <= 0;
						
						if (addr == WR_CTRL_REG_ADDR) state <= WR_SINGLE_PREP;
						else if (addr == WR_SEC_REG_ADDR) state <= WR_SINGLE_PREP;
						// If reading, change direction of IO port to input
						else if (addr == BURST_RD_ADDR) begin
							state <= RD_BURST;
							io_dir <= 0;
						end // end if (addr == BURST_RD_ADDR)
						else if (addr == BURST_WR_ADDR) state <= WR_BURST_PREP;
						else state <= IDLE;
					end // end CNT_RST state
					
				WR_SINGLE_PREP: // Single-byte write, prepare the current data bit at SCLK low level
					begin
						SCLK <= 0;
						io <= 0;
						
						state <= WR_SINGLE;
					end // end WR_SINGLE_PREP state
					
				WR_SINGLE: // Single-byte write, raise SCLK to send data bit
					begin
						SCLK <= 1;
						count <= count + 7'd1;
						
						if (count == 7'd7) state <= TERMINATE; // If all 8 data bits for the single-byte write are sent, terminate the communication
						else state <= WR_SINGLE_PREP; // Else, continue to send remaining data bits
					end // end WR_SINGLE state
					
				WR_BURST_PREP: // Burst-mode write, prepare the current data bit at SCLK low level
					begin
						SCLK <= 0;
						io <= burst_data[count];
						
						state <= WR_BURST;
					end // end WR_BURST_PREP state
					
				WR_BURST: // Burst-mode write, raise SCLK to send the data bit
					begin
						SCLK <= 1;
						count <= count + 7'd1;
						
						if (count == 7'd63) state <= TERMINATE; // If all 64 bits for 8x8-bit Clock registers are sent, terminate the communication
						else state <= WR_BURST_PREP; // Else continue to send the remaining data bits
					end // end WR_BURST state
					
				RD_BURST: // Burst-mode read, pull SCLK low to receive the data from RTC
					begin
						SCLK <= 0;
						
						state <= STO_BURST;
					end // end RD_BURST state
					
				STO_BURST: // Burst-mode read, check the data from IO port at SCLK high level and store to system's internal time register
					begin
						SCLK <= 1;
						time_out[count] <= IO;
						count <= count + 7'd1;
						
						if (count == 7'd63) state <= TERMINATE; // If all 64 bits from 8x8-bit Clock registers are received, terminate the communication
						else state <= RD_BURST; // Else continue to read the remaining data bits
					end // end STO_BURST state
				
				TERMINATE: // Terminate the communication by pulling CE and SCLK low and reset count
					begin
						CE <= 0;
						SCLK <= 0;
						count <= 0;
						if (addr == WR_CTRL_REG_ADDR) WP_init <= 1;
						if (addr == WR_SEC_REG_ADDR) CH_init <= 1;
						state <= IDLE;
					end // end TERMINATE state
				
			endcase
		end // end else (!rstn)
	end // end always_ff
	
endmodule 
	