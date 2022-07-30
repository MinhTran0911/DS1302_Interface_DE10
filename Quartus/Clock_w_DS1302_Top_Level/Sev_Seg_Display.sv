module Sev_Seg_Display (hr, min, sec, HEX);
	
	input logic [7:0] hr, min, sec; // in BCD
	
	output logic [6:0] HEX [0:5];
	
	// 7-seg pattern
	localparam ZERO = 7'b100_0000;
	localparam ONE = 7'b111_1001;
	localparam TWO = 7'b010_0100;
	localparam THREE = 7'b011_0000;
	localparam FOUR = 7'b001_1001;
	localparam FIVE = 7'b001_0010;
	localparam SIX = 7'b000_0010;
	localparam SEVEN = 7'b111_1000;
	localparam EIGHT = 7'b000_0000;
	localparam NINE = 7'b001_0000;
	localparam DASH = 7'b011_1111;
	
	// Tens digit of hour
	always_comb begin
		case ({2'b00, hr[5:4]})
			4'd0: HEX[5] = ZERO; 
			4'd1: HEX[5] = ONE; 
			4'd2: HEX[5] = TWO; 
			4'd3: HEX[5] = THREE; 
			4'd4: HEX[5] = FOUR; 
			4'd5: HEX[5] = FIVE; 
			4'd6: HEX[5] = SIX; 
			4'd7: HEX[5] = SEVEN; 
			4'd8: HEX[5] = EIGHT; 
			4'd9: HEX[5] = NINE; 
			default: HEX[5] = DASH;
		endcase
	end 
	
	// Ones digit of hour
	always_comb begin
		case (hr[3:0])
			4'd0: HEX[4] = ZERO; 
			4'd1: HEX[4] = ONE; 
			4'd2: HEX[4] = TWO; 
			4'd3: HEX[4] = THREE; 
			4'd4: HEX[4] = FOUR; 
			4'd5: HEX[4] = FIVE; 
			4'd6: HEX[4] = SIX; 
			4'd7: HEX[4] = SEVEN; 
			4'd8: HEX[4] = EIGHT; 
			4'd9: HEX[4] = NINE; 
			default: HEX[4] = DASH;
		endcase
	end 
	
	// Tens digit of minute
	always_comb begin
		case ({1'b0, min[6:4]})
			4'd0: HEX[3] = ZERO; 
			4'd1: HEX[3] = ONE; 
			4'd2: HEX[3] = TWO; 
			4'd3: HEX[3] = THREE; 
			4'd4: HEX[3] = FOUR; 
			4'd5: HEX[3] = FIVE; 
			4'd6: HEX[3] = SIX; 
			4'd7: HEX[3] = SEVEN; 
			4'd8: HEX[3] = EIGHT; 
			4'd9: HEX[3] = NINE; 
			default: HEX[3] = DASH;
		endcase
	end 
	
	// Ones digit of minute
	always_comb begin
		case (min[3:0])
			4'd0: HEX[2] = ZERO; 
			4'd1: HEX[2] = ONE; 
			4'd2: HEX[2] = TWO; 
			4'd3: HEX[2] = THREE; 
			4'd4: HEX[2] = FOUR; 
			4'd5: HEX[2] = FIVE; 
			4'd6: HEX[2] = SIX; 
			4'd7: HEX[2] = SEVEN; 
			4'd8: HEX[2] = EIGHT; 
			4'd9: HEX[2] = NINE; 
			default: HEX[2] = DASH;
		endcase
	end 
	
	// Tens digit of second
	always_comb begin
		case ({1'b0, sec[6:4]})
			4'd0: HEX[1] = ZERO; 
			4'd1: HEX[1] = ONE; 
			4'd2: HEX[1] = TWO; 
			4'd3: HEX[1] = THREE; 
			4'd4: HEX[1] = FOUR; 
			4'd5: HEX[1] = FIVE; 
			4'd6: HEX[1] = SIX; 
			4'd7: HEX[1] = SEVEN; 
			4'd8: HEX[1] = EIGHT; 
			4'd9: HEX[1] = NINE; 
			default: HEX[1] = DASH;
		endcase
	end 
	
	// Ones digit of second
	always_comb begin
		case (sec[3:0])
			4'd0: HEX[0] = ZERO; 
			4'd1: HEX[0] = ONE; 
			4'd2: HEX[0] = TWO; 
			4'd3: HEX[0] = THREE; 
			4'd4: HEX[0] = FOUR; 
			4'd5: HEX[0] = FIVE; 
			4'd6: HEX[0] = SIX; 
			4'd7: HEX[0] = SEVEN; 
			4'd8: HEX[0] = EIGHT; 
			4'd9: HEX[0] = NINE; 
			default: HEX[0] = DASH;
		endcase
	end
	
endmodule 