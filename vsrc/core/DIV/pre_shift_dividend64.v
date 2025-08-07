module pre_shift_dividend64 (
	input [63:0]         dividend          ,
	output reg[66:0]     pre_shift_dividend,
    output reg[5:0]      iter_dec          //00...0001: iteration number -= 1; //00...0010: iteration number -= 2     
);

	// always@(*) begin
	// 	casez(dividend)
	// 		64'b1???????????????????????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'b000, dividend}             ;
	// 			iter_dec              = 6'd0                           ;
	// 		end
	// 		64'b01??????????????????????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'b000, dividend}             ;
	// 			iter_dec              = 6'd0                           ;
	// 		end
	// 		64'b001?????????????????????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[61:0], 2'd0} ;
	// 			iter_dec              = 6'd1                           ;
	// 		end
	// 		64'b0001????????????????????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[61:0], 2'd0} ;
	// 			iter_dec              = 6'd1                           ;
	// 		end
	// 		64'b00001???????????????????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[59:0], 4'd0} ;
	// 			iter_dec              = 6'd2                           ;
	// 		end
	// 		64'b000001??????????????????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[59:0], 4'd0} ;
	// 			iter_dec              = 6'd2                           ;
	// 		end
	// 		64'b0000001?????????????????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[57:0], 6'd0} ;
	// 			iter_dec              = 6'd3                           ;
	// 		end
	// 		64'b00000001????????????????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[57:0], 6'd0} ;
	// 			iter_dec              = 6'd3                           ;
	// 		end
	// 		64'b000000001???????????????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[55:0], 8'd0} ;
	// 			iter_dec              = 6'd4                           ;
	// 		end
	// 		64'b0000000001??????????????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[55:0], 8'd0} ;
	// 			iter_dec              = 6'd4                           ;
	// 		end
	// 		64'b00000000001?????????????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[53:0], 10'd0};
	// 			iter_dec              = 6'd5                           ;
	// 		end
	// 		64'b000000000001????????????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[53:0], 10'd0};
	// 			iter_dec              = 6'd5                           ;
	// 		end
	// 		64'b0000000000001???????????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[51:0], 12'd0};
	// 			iter_dec              = 6'd6                           ;
	// 		end
	// 		64'b00000000000001??????????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[51:0], 12'd0};
	// 			iter_dec              = 6'd6                           ;
	// 		end
	// 		64'b000000000000001?????????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[49:0], 14'd0};
	// 			iter_dec              = 6'd7                           ;
	// 		end
	// 		64'b0000000000000001????????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[49:0], 14'd0};
	// 			iter_dec              = 6'd7                           ;
	// 		end
	// 		64'b00000000000000001???????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[47:0], 16'd0};
	// 			iter_dec              = 6'd8                           ;
	// 		end
	// 		64'b000000000000000001??????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[47:0], 16'd0};
	// 			iter_dec              = 6'd8                           ;
	// 		end
	// 		64'b0000000000000000001?????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[45:0], 18'd0};
	// 			iter_dec              = 6'd9                           ;
	// 		end
	// 		64'b00000000000000000001????????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[45:0], 18'd0};
	// 			iter_dec              = 6'd9                           ;
	// 		end
	// 		64'b000000000000000000001???????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[43:0], 20'd0};
	// 			iter_dec              = 6'd10                          ;
	// 		end
	// 		64'b0000000000000000000001??????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[43:0], 20'd0};
	// 			iter_dec              = 6'd10                          ;
	// 		end
	// 		64'b00000000000000000000001?????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[41:0], 22'd0};
	// 			iter_dec              = 6'd11                          ;
	// 		end
	// 		64'b000000000000000000000001????????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[41:0], 22'd0};
	// 			iter_dec              = 6'd11                          ;
	// 		end
	// 		64'b0000000000000000000000001???????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[39:0], 24'd0};
	// 			iter_dec              = 6'd12                          ;
	// 		end
	// 		64'b00000000000000000000000001??????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[39:0], 24'd0};
	// 			iter_dec              = 6'd12                          ;
	// 		end
	// 		64'b000000000000000000000000001?????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[37:0], 26'd0};
	// 			iter_dec              = 6'd13                          ;
	// 		end
	// 		64'b0000000000000000000000000001????????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[37:0], 26'd0};
	// 			iter_dec              = 6'd13                          ;
	// 		end
	// 		64'b00000000000000000000000000001???????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[35:0], 28'd0};
	// 			iter_dec              = 6'd14                          ;
	// 		end
	// 		64'b000000000000000000000000000001??????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[35:0], 28'd0};
	// 			iter_dec              = 6'd14                          ;
	// 		end
	// 		64'b0000000000000000000000000000001?????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[33:0], 30'd0};
	// 			iter_dec              = 6'd15                          ;
	// 		end
	// 		64'b00000000000000000000000000000001????????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[33:0], 30'd0};
	// 			iter_dec              = 6'd15                          ;
	// 		end
	// 		64'b000000000000000000000000000000001???????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[31:0], 32'd0};
	// 			iter_dec              = 6'd16                          ;
	// 		end
	// 		64'b0000000000000000000000000000000001??????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[31:0], 32'd0};
	// 			iter_dec              = 6'd16                          ;
	// 		end
	// 		64'b00000000000000000000000000000000001?????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[29:0], 34'd0};
	// 			iter_dec              = 6'd17                          ;
	// 		end
	// 		64'b000000000000000000000000000000000001????????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[29:0], 34'd0};
	// 			iter_dec              = 6'd17                          ;
	// 		end
	// 		64'b0000000000000000000000000000000000001???????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[27:0], 36'd0};
	// 			iter_dec              = 6'd18                          ;
	// 		end
	// 		64'b00000000000000000000000000000000000001??????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[27:0], 36'd0};
	// 			iter_dec              = 6'd18                          ;
	// 		end
	// 		64'b000000000000000000000000000000000000001?????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[25:0], 38'd0};
	// 			iter_dec              = 6'd19                          ;
	// 		end
	// 		64'b0000000000000000000000000000000000000001????????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[25:0], 38'd0};
	// 			iter_dec              = 6'd19                          ;
	// 		end
	// 		64'b00000000000000000000000000000000000000001???????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[23:0], 40'd0};
	// 			iter_dec              = 6'd20                          ;
	// 		end
	// 		64'b000000000000000000000000000000000000000001??????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[23:0], 40'd0};
	// 			iter_dec              = 6'd20                          ;
	// 		end
	// 		64'b0000000000000000000000000000000000000000001?????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[21:0], 42'd0};
	// 			iter_dec              = 6'd21                          ;
	// 		end
	// 		64'b00000000000000000000000000000000000000000001????????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[21:0], 42'd0};
	// 			iter_dec              = 6'd21                          ;
	// 		end
	// 		64'b000000000000000000000000000000000000000000001???????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[19:0], 44'd0};
	// 			iter_dec              = 6'd22                          ;
	// 		end
	// 		64'b0000000000000000000000000000000000000000000001??????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[19:0], 44'd0};
	// 			iter_dec              = 6'd22                          ;
	// 		end
	// 		64'b00000000000000000000000000000000000000000000001?????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[17:0], 46'd0};
	// 			iter_dec              = 6'd23                          ;
	// 		end
	// 		64'b000000000000000000000000000000000000000000000001????????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[17:0], 46'd0};
	// 			iter_dec              = 6'd23                          ;
	// 		end
	// 		64'b0000000000000000000000000000000000000000000000001???????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[15:0], 48'd0};
	// 			iter_dec              = 6'd24                          ;
	// 		end
	// 		64'b00000000000000000000000000000000000000000000000001??????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[15:0], 48'd0};
	// 			iter_dec              = 6'd24                          ;
	// 		end
	// 		64'b000000000000000000000000000000000000000000000000001?????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[13:0], 50'd0};
	// 			iter_dec              = 6'd25                          ;
	// 		end
	// 		64'b0000000000000000000000000000000000000000000000000001????????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[13:0], 50'd0};
	// 			iter_dec              = 6'd25                          ;
	// 		end
	// 		64'b00000000000000000000000000000000000000000000000000001???????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[11:0], 52'd0};
	// 			iter_dec              = 6'd26                          ;
	// 		end
	// 		64'b000000000000000000000000000000000000000000000000000001??????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[11:0], 52'd0};
	// 			iter_dec              = 6'd26                          ;
	// 		end
	// 		64'b0000000000000000000000000000000000000000000000000000001?????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[9:0], 54'd0} ;
	// 			iter_dec              = 6'd27                          ;
	// 		end
	// 		64'b00000000000000000000000000000000000000000000000000000001????????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[9:0], 54'd0} ;
	// 			iter_dec              = 6'd27                          ;
	// 		end
	// 		64'b000000000000000000000000000000000000000000000000000000001???????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[7:0], 56'd0} ;
	// 			iter_dec              = 6'd28                          ;
	// 		end
	// 		64'b0000000000000000000000000000000000000000000000000000000001??????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[7:0], 56'd0} ;
	// 			iter_dec              = 6'd28                          ;
	// 		end
	// 		64'b00000000000000000000000000000000000000000000000000000000001?????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[5:0], 58'd0} ;
	// 			iter_dec              = 6'd29                          ;
	// 		end
	// 		64'b000000000000000000000000000000000000000000000000000000000001????: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[5:0], 58'd0} ;
	// 			iter_dec              = 6'd29                          ;
	// 		end
	// 		64'b0000000000000000000000000000000000000000000000000000000000001???: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[3:0], 60'd0} ;
	// 			iter_dec              = 6'd30                          ;
	// 		end
	// 		64'b00000000000000000000000000000000000000000000000000000000000001??: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[3:0], 60'd0} ;
	// 			iter_dec              = 6'd30                          ;
	// 		end
	// 		64'b000000000000000000000000000000000000000000000000000000000000001?: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[1:0], 62'd0} ;
	// 			iter_dec              = 6'd31                          ;
	// 		end
	// 		64'b0000000000000000000000000000000000000000000000000000000000000001: begin
	// 			pre_shift_dividend    = {3'd0  , dividend[1:0], 62'd0} ;
	// 			iter_dec              = 6'd31                          ;
	// 		end
	// 		default: begin
	// 			pre_shift_dividend    = 67'd0                          ;
	// 			iter_dec              = 6'd0                           ;
	// 		end
	// 	endcase
	// end

	wire [66:0] pre_shift_dividend_or_val0 ; 
	wire [66:0] pre_shift_dividend_or_val1 ; 
	wire [66:0] pre_shift_dividend_or_val2 ; 
	wire [66:0] pre_shift_dividend_or_val3 ; 
	wire [66:0] pre_shift_dividend_or_val4 ; 
	wire [66:0] pre_shift_dividend_or_val5 ; 
	wire [66:0] pre_shift_dividend_or_val6 ; 
	wire [66:0] pre_shift_dividend_or_val7 ; 
	wire [66:0] pre_shift_dividend_or_val8 ; 
	wire [66:0] pre_shift_dividend_or_val9 ; 
	wire [66:0] pre_shift_dividend_or_val10; 
	wire [66:0] pre_shift_dividend_or_val11; 
	wire [66:0] pre_shift_dividend_or_val12; 
	wire [66:0] pre_shift_dividend_or_val13; 
	wire [66:0] pre_shift_dividend_or_val14; 
	wire [66:0] pre_shift_dividend_or_val15; 
	wire [66:0] pre_shift_dividend_or_val16; 
	wire [66:0] pre_shift_dividend_or_val17; 
	wire [66:0] pre_shift_dividend_or_val18; 
	wire [66:0] pre_shift_dividend_or_val19; 
	wire [66:0] pre_shift_dividend_or_val20; 
	wire [66:0] pre_shift_dividend_or_val21; 
	wire [66:0] pre_shift_dividend_or_val22; 
	wire [66:0] pre_shift_dividend_or_val23; 
	wire [66:0] pre_shift_dividend_or_val24; 
	wire [66:0] pre_shift_dividend_or_val25; 
	wire [66:0] pre_shift_dividend_or_val26; 
	wire [66:0] pre_shift_dividend_or_val27; 
	wire [66:0] pre_shift_dividend_or_val28; 
	wire [66:0] pre_shift_dividend_or_val29; 
	wire [66:0] pre_shift_dividend_or_val30; 
	wire [66:0] pre_shift_dividend_or_val31; 
	wire [66:0] pre_shift_dividend_or_val32; 
	wire [66:0] pre_shift_dividend_or_val33; 
	wire [66:0] pre_shift_dividend_or_val34; 
	wire [66:0] pre_shift_dividend_or_val35; 
	wire [66:0] pre_shift_dividend_or_val36; 
	wire [66:0] pre_shift_dividend_or_val37; 
	wire [66:0] pre_shift_dividend_or_val38; 
	wire [66:0] pre_shift_dividend_or_val39; 
	wire [66:0] pre_shift_dividend_or_val40; 
	wire [66:0] pre_shift_dividend_or_val41; 
	wire [66:0] pre_shift_dividend_or_val42; 
	wire [66:0] pre_shift_dividend_or_val43; 
	wire [66:0] pre_shift_dividend_or_val44; 
	wire [66:0] pre_shift_dividend_or_val45; 
	wire [66:0] pre_shift_dividend_or_val46; 
	wire [66:0] pre_shift_dividend_or_val47; 
	wire [66:0] pre_shift_dividend_or_val48; 
	wire [66:0] pre_shift_dividend_or_val49; 
	wire [66:0] pre_shift_dividend_or_val50; 
	wire [66:0] pre_shift_dividend_or_val51; 
	wire [66:0] pre_shift_dividend_or_val52; 
	wire [66:0] pre_shift_dividend_or_val53; 
	wire [66:0] pre_shift_dividend_or_val54; 
	wire [66:0] pre_shift_dividend_or_val55; 
	wire [66:0] pre_shift_dividend_or_val56; 
	wire [66:0] pre_shift_dividend_or_val57; 
	wire [66:0] pre_shift_dividend_or_val58; 
	wire [66:0] pre_shift_dividend_or_val59; 
	wire [66:0] pre_shift_dividend_or_val60; 
	wire [66:0] pre_shift_dividend_or_val61; 
	wire [66:0] pre_shift_dividend_or_val62; 
	wire [66:0] pre_shift_dividend_or_val63; 

	assign pre_shift_dividend_or_val0  = (dividend[63] == 1'b1)? {3'd0  , dividend[63:0]} : `ZERO;
	assign pre_shift_dividend_or_val1  = (dividend[63:62] == 2'b01)? {3'd0  , dividend[63:0]} : `ZERO;
	assign pre_shift_dividend_or_val2  = (dividend[63:61] == 3'b001)? {3'd0  , dividend[61:0], 2'd0} : `ZERO;
	assign pre_shift_dividend_or_val3  = (dividend[63:60] == 4'b0001)? {3'd0  , dividend[61:0], 2'd0} : `ZERO;
	assign pre_shift_dividend_or_val4  = (dividend[63:59] == 5'b00001)? {3'd0  , dividend[59:0], 4'd0} : `ZERO;
	assign pre_shift_dividend_or_val5  = (dividend[63:58] == 6'b000001)? {3'd0  , dividend[59:0], 4'd0} : `ZERO;
	assign pre_shift_dividend_or_val6  = (dividend[63:57] == 7'b0000001)? {3'd0  , dividend[57:0], 6'd0} : `ZERO;
	assign pre_shift_dividend_or_val7  = (dividend[63:56] == 8'b00000001)? {3'd0  , dividend[57:0], 6'd0} : `ZERO;
	assign pre_shift_dividend_or_val8  = (dividend[63:55] == 9'b000000001)? {3'd0  , dividend[55:0], 8'd0} : `ZERO;
	assign pre_shift_dividend_or_val9  = (dividend[63:54] == 10'b0000000001)? {3'd0  , dividend[55:0], 8'd0} : `ZERO;
	assign pre_shift_dividend_or_val10 = (dividend[63:53] == 11'b00000000001)? {3'd0  , dividend[53:0], 10'd0} : `ZERO;
	assign pre_shift_dividend_or_val11 = (dividend[63:52] == 12'b000000000001)? {3'd0  , dividend[53:0], 10'd0} : `ZERO;
	assign pre_shift_dividend_or_val12 = (dividend[63:51] == 13'b0000000000001)? {3'd0  , dividend[51:0], 12'd0} : `ZERO;
	assign pre_shift_dividend_or_val13 = (dividend[63:50] == 14'b00000000000001)? {3'd0  , dividend[51:0], 12'd0} : `ZERO;
	assign pre_shift_dividend_or_val14 = (dividend[63:49] == 15'b000000000000001)? {3'd0  , dividend[49:0], 14'd0} : `ZERO;
	assign pre_shift_dividend_or_val15 = (dividend[63:48] == 16'b0000000000000001)? {3'd0  , dividend[49:0], 14'd0} : `ZERO;
	assign pre_shift_dividend_or_val16 = (dividend[63:47] == 17'b00000000000000001)? {3'd0  , dividend[47:0], 16'd0} : `ZERO;
	assign pre_shift_dividend_or_val17 = (dividend[63:46] == 18'b000000000000000001)? {3'd0  , dividend[47:0], 16'd0} : `ZERO;
	assign pre_shift_dividend_or_val18 = (dividend[63:45] == 19'b0000000000000000001)? {3'd0  , dividend[45:0], 18'd0} : `ZERO;
	assign pre_shift_dividend_or_val19 = (dividend[63:44] == 20'b00000000000000000001)? {3'd0  , dividend[45:0], 18'd0} : `ZERO;
	assign pre_shift_dividend_or_val20 = (dividend[63:43] == 21'b000000000000000000001)? {3'd0  , dividend[43:0], 20'd0} : `ZERO;
	assign pre_shift_dividend_or_val21 = (dividend[63:42] == 22'b0000000000000000000001)? {3'd0  , dividend[43:0], 20'd0} : `ZERO;
	assign pre_shift_dividend_or_val22 = (dividend[63:41] == 23'b00000000000000000000001)? {3'd0  , dividend[41:0], 22'd0} : `ZERO;
	assign pre_shift_dividend_or_val23 = (dividend[63:40] == 24'b000000000000000000000001)? {3'd0  , dividend[41:0], 22'd0} : `ZERO;
	assign pre_shift_dividend_or_val24 = (dividend[63:39] == 25'b0000000000000000000000001)? {3'd0  , dividend[39:0], 24'd0} : `ZERO;
	assign pre_shift_dividend_or_val25 = (dividend[63:38] == 26'b00000000000000000000000001)? {3'd0  , dividend[39:0], 24'd0} : `ZERO;
	assign pre_shift_dividend_or_val26 = (dividend[63:37] == 27'b000000000000000000000000001)? {3'd0  , dividend[37:0], 26'd0} : `ZERO;
	assign pre_shift_dividend_or_val27 = (dividend[63:36] == 28'b0000000000000000000000000001)? {3'd0  , dividend[37:0], 26'd0} : `ZERO;
	assign pre_shift_dividend_or_val28 = (dividend[63:35] == 29'b00000000000000000000000000001)? {3'd0  , dividend[35:0], 28'd0} : `ZERO;
	assign pre_shift_dividend_or_val29 = (dividend[63:34] == 30'b000000000000000000000000000001)? {3'd0  , dividend[35:0], 28'd0} : `ZERO;
	assign pre_shift_dividend_or_val30 = (dividend[63:33] == 31'b0000000000000000000000000000001)? {3'd0  , dividend[33:0], 30'd0} : `ZERO;
	assign pre_shift_dividend_or_val31 = (dividend[63:32] == 32'b00000000000000000000000000000001)? {3'd0  , dividend[33:0], 30'd0} : `ZERO;
	assign pre_shift_dividend_or_val32 = (dividend[63:31] == 33'b000000000000000000000000000000001)? {3'd0  , dividend[31:0], 32'd0} : `ZERO;
	assign pre_shift_dividend_or_val33 = (dividend[63:30] == 34'b0000000000000000000000000000000001)? {3'd0  , dividend[31:0], 32'd0} : `ZERO;
	assign pre_shift_dividend_or_val34 = (dividend[63:29] == 35'b00000000000000000000000000000000001)? {3'd0  , dividend[29:0], 34'd0} : `ZERO;
	assign pre_shift_dividend_or_val35 = (dividend[63:28] == 36'b000000000000000000000000000000000001)? {3'd0  , dividend[29:0], 34'd0} : `ZERO;
	assign pre_shift_dividend_or_val36 = (dividend[63:27] == 37'b0000000000000000000000000000000000001)? {3'd0  , dividend[27:0], 36'd0} : `ZERO;
	assign pre_shift_dividend_or_val37 = (dividend[63:26] == 38'b00000000000000000000000000000000000001)? {3'd0  , dividend[27:0], 36'd0} : `ZERO;
	assign pre_shift_dividend_or_val38 = (dividend[63:25] == 39'b000000000000000000000000000000000000001)? {3'd0  , dividend[25:0], 38'd0} : `ZERO;
	assign pre_shift_dividend_or_val39 = (dividend[63:24] == 40'b0000000000000000000000000000000000000001)? {3'd0  , dividend[25:0], 38'd0} : `ZERO;
	assign pre_shift_dividend_or_val40 = (dividend[63:23] == 41'b00000000000000000000000000000000000000001)? {3'd0  , dividend[23:0], 40'd0} : `ZERO;
	assign pre_shift_dividend_or_val41 = (dividend[63:22] == 42'b000000000000000000000000000000000000000001)? {3'd0  , dividend[23:0], 40'd0} : `ZERO;
	assign pre_shift_dividend_or_val42 = (dividend[63:21] == 43'b0000000000000000000000000000000000000000001)? {3'd0  , dividend[21:0], 42'd0} : `ZERO;
	assign pre_shift_dividend_or_val43 = (dividend[63:20] == 44'b00000000000000000000000000000000000000000001)? {3'd0  , dividend[21:0], 42'd0} : `ZERO;
	assign pre_shift_dividend_or_val44 = (dividend[63:19] == 45'b000000000000000000000000000000000000000000001)? {3'd0  , dividend[19:0], 44'd0} : `ZERO;
	assign pre_shift_dividend_or_val45 = (dividend[63:18] == 46'b0000000000000000000000000000000000000000000001)? {3'd0  , dividend[19:0], 44'd0} : `ZERO;
	assign pre_shift_dividend_or_val46 = (dividend[63:17] == 47'b00000000000000000000000000000000000000000000001)? {3'd0  , dividend[17:0], 46'd0} : `ZERO;
	assign pre_shift_dividend_or_val47 = (dividend[63:16] == 48'b000000000000000000000000000000000000000000000001)? {3'd0  , dividend[17:0], 46'd0} : `ZERO;
	assign pre_shift_dividend_or_val48 = (dividend[63:15] == 49'b0000000000000000000000000000000000000000000000001)? {3'd0  , dividend[15:0], 48'd0} : `ZERO;
	assign pre_shift_dividend_or_val49 = (dividend[63:14] == 50'b00000000000000000000000000000000000000000000000001)? {3'd0  , dividend[15:0], 48'd0} : `ZERO;
	assign pre_shift_dividend_or_val50 = (dividend[63:13] == 51'b000000000000000000000000000000000000000000000000001)? {3'd0  , dividend[13:0], 50'd0} : `ZERO;
	assign pre_shift_dividend_or_val51 = (dividend[63:12] == 52'b0000000000000000000000000000000000000000000000000001)? {3'd0  , dividend[13:0], 50'd0} : `ZERO;
	assign pre_shift_dividend_or_val52 = (dividend[63:11] == 53'b00000000000000000000000000000000000000000000000000001)? {3'd0  , dividend[11:0], 52'd0} : `ZERO;
	assign pre_shift_dividend_or_val53 = (dividend[63:10] == 54'b000000000000000000000000000000000000000000000000000001)? {3'd0  , dividend[11:0], 52'd0} : `ZERO;
	assign pre_shift_dividend_or_val54 = (dividend[63:9] == 55'b0000000000000000000000000000000000000000000000000000001)? {3'd0  , dividend[9:0], 54'd0} : `ZERO;
	assign pre_shift_dividend_or_val55 = (dividend[63:8] == 56'b00000000000000000000000000000000000000000000000000000001)? {3'd0  , dividend[9:0], 54'd0} : `ZERO;
	assign pre_shift_dividend_or_val56 = (dividend[63:7] == 57'b000000000000000000000000000000000000000000000000000000001)? {3'd0  , dividend[7:0], 56'd0} : `ZERO;
	assign pre_shift_dividend_or_val57 = (dividend[63:6] == 58'b0000000000000000000000000000000000000000000000000000000001)? {3'd0  , dividend[7:0], 56'd0} : `ZERO;
	assign pre_shift_dividend_or_val58 = (dividend[63:5] == 59'b00000000000000000000000000000000000000000000000000000000001)? {3'd0  , dividend[5:0], 58'd0} : `ZERO;
	assign pre_shift_dividend_or_val59 = (dividend[63:4] == 60'b000000000000000000000000000000000000000000000000000000000001)? {3'd0  , dividend[5:0], 58'd0} : `ZERO;
	assign pre_shift_dividend_or_val60 = (dividend[63:3] == 61'b0000000000000000000000000000000000000000000000000000000000001)? {3'd0  , dividend[3:0], 60'd0} : `ZERO;
	assign pre_shift_dividend_or_val61 = (dividend[63:2] == 62'b00000000000000000000000000000000000000000000000000000000000001)? {3'd0  , dividend[3:0], 60'd0} : `ZERO;
	assign pre_shift_dividend_or_val62 = (dividend[63:1] == 63'b000000000000000000000000000000000000000000000000000000000000001)? {3'd0  , dividend[1:0], 62'd0} : `ZERO;
	assign pre_shift_dividend_or_val63 = (dividend[63:0] == 64'b0000000000000000000000000000000000000000000000000000000000000001)? {3'd0  , dividend[1:0], 62'd0} : `ZERO;

	wire [5:0] iter_dec_or_val0 ; 
	wire [5:0] iter_dec_or_val1 ; 
	wire [5:0] iter_dec_or_val2 ; 
	wire [5:0] iter_dec_or_val3 ; 
	wire [5:0] iter_dec_or_val4 ; 
	wire [5:0] iter_dec_or_val5 ; 
	wire [5:0] iter_dec_or_val6 ; 
	wire [5:0] iter_dec_or_val7 ; 
	wire [5:0] iter_dec_or_val8 ; 
	wire [5:0] iter_dec_or_val9 ; 
	wire [5:0] iter_dec_or_val10; 
	wire [5:0] iter_dec_or_val11; 
	wire [5:0] iter_dec_or_val12; 
	wire [5:0] iter_dec_or_val13; 
	wire [5:0] iter_dec_or_val14; 
	wire [5:0] iter_dec_or_val15; 
	wire [5:0] iter_dec_or_val16; 
	wire [5:0] iter_dec_or_val17; 
	wire [5:0] iter_dec_or_val18; 
	wire [5:0] iter_dec_or_val19; 
	wire [5:0] iter_dec_or_val20; 
	wire [5:0] iter_dec_or_val21; 
	wire [5:0] iter_dec_or_val22; 
	wire [5:0] iter_dec_or_val23; 
	wire [5:0] iter_dec_or_val24; 
	wire [5:0] iter_dec_or_val25; 
	wire [5:0] iter_dec_or_val26; 
	wire [5:0] iter_dec_or_val27; 
	wire [5:0] iter_dec_or_val28; 
	wire [5:0] iter_dec_or_val29; 
	wire [5:0] iter_dec_or_val30; 
	wire [5:0] iter_dec_or_val31; 
	wire [5:0] iter_dec_or_val32; 
	wire [5:0] iter_dec_or_val33; 
	wire [5:0] iter_dec_or_val34; 
	wire [5:0] iter_dec_or_val35; 
	wire [5:0] iter_dec_or_val36; 
	wire [5:0] iter_dec_or_val37; 
	wire [5:0] iter_dec_or_val38; 
	wire [5:0] iter_dec_or_val39; 
	wire [5:0] iter_dec_or_val40; 
	wire [5:0] iter_dec_or_val41; 
	wire [5:0] iter_dec_or_val42; 
	wire [5:0] iter_dec_or_val43; 
	wire [5:0] iter_dec_or_val44; 
	wire [5:0] iter_dec_or_val45; 
	wire [5:0] iter_dec_or_val46; 
	wire [5:0] iter_dec_or_val47; 
	wire [5:0] iter_dec_or_val48; 
	wire [5:0] iter_dec_or_val49; 
	wire [5:0] iter_dec_or_val50; 
	wire [5:0] iter_dec_or_val51; 
	wire [5:0] iter_dec_or_val52; 
	wire [5:0] iter_dec_or_val53; 
	wire [5:0] iter_dec_or_val54; 
	wire [5:0] iter_dec_or_val55; 
	wire [5:0] iter_dec_or_val56; 
	wire [5:0] iter_dec_or_val57; 
	wire [5:0] iter_dec_or_val58; 
	wire [5:0] iter_dec_or_val59; 
	wire [5:0] iter_dec_or_val60; 
	wire [5:0] iter_dec_or_val61; 
	wire [5:0] iter_dec_or_val62; 
	wire [5:0] iter_dec_or_val63; 

	assign iter_dec_or_val0  = (dividend[63] == 1'b1)? 0  : 0;
	assign iter_dec_or_val1  = (dividend[63:62] == 2'b01)? 0  : 0;
	assign iter_dec_or_val2  = (dividend[63:61] == 3'b001)? 1  : 0;
	assign iter_dec_or_val3  = (dividend[63:60] == 4'b0001)? 1  : 0;
	assign iter_dec_or_val4  = (dividend[63:59] == 5'b00001)? 2  : 0;
	assign iter_dec_or_val5  = (dividend[63:58] == 6'b000001)? 2  : 0;
	assign iter_dec_or_val6  = (dividend[63:57] == 7'b0000001)? 3  : 0;
	assign iter_dec_or_val7  = (dividend[63:56] == 8'b00000001)? 3  : 0;
	assign iter_dec_or_val8  = (dividend[63:55] == 9'b000000001)? 4  : 0;
	assign iter_dec_or_val9  = (dividend[63:54] == 10'b0000000001)? 4  : 0;
	assign iter_dec_or_val10 = (dividend[63:53] == 11'b00000000001)? 5  : 0;
	assign iter_dec_or_val11 = (dividend[63:52] == 12'b000000000001)? 5  : 0;
	assign iter_dec_or_val12 = (dividend[63:51] == 13'b0000000000001)? 6  : 0;
	assign iter_dec_or_val13 = (dividend[63:50] == 14'b00000000000001)? 6  : 0;
	assign iter_dec_or_val14 = (dividend[63:49] == 15'b000000000000001)? 7  : 0;
	assign iter_dec_or_val15 = (dividend[63:48] == 16'b0000000000000001)? 7  : 0;
	assign iter_dec_or_val16 = (dividend[63:47] == 17'b00000000000000001)? 8  : 0;
	assign iter_dec_or_val17 = (dividend[63:46] == 18'b000000000000000001)? 8  : 0;
	assign iter_dec_or_val18 = (dividend[63:45] == 19'b0000000000000000001)? 9  : 0;
	assign iter_dec_or_val19 = (dividend[63:44] == 20'b00000000000000000001)? 9  : 0;
	assign iter_dec_or_val20 = (dividend[63:43] == 21'b000000000000000000001)? 10 : 0;
	assign iter_dec_or_val21 = (dividend[63:42] == 22'b0000000000000000000001)? 10 : 0;
	assign iter_dec_or_val22 = (dividend[63:41] == 23'b00000000000000000000001)? 11 : 0;
	assign iter_dec_or_val23 = (dividend[63:40] == 24'b000000000000000000000001)? 11 : 0;
	assign iter_dec_or_val24 = (dividend[63:39] == 25'b0000000000000000000000001)? 12 : 0;
	assign iter_dec_or_val25 = (dividend[63:38] == 26'b00000000000000000000000001)? 12 : 0;
	assign iter_dec_or_val26 = (dividend[63:37] == 27'b000000000000000000000000001)? 13 : 0;
	assign iter_dec_or_val27 = (dividend[63:36] == 28'b0000000000000000000000000001)? 13 : 0;
	assign iter_dec_or_val28 = (dividend[63:35] == 29'b00000000000000000000000000001)? 14 : 0;
	assign iter_dec_or_val29 = (dividend[63:34] == 30'b000000000000000000000000000001)? 14 : 0;
	assign iter_dec_or_val30 = (dividend[63:33] == 31'b0000000000000000000000000000001)? 15 : 0;
	assign iter_dec_or_val31 = (dividend[63:32] == 32'b00000000000000000000000000000001)? 15 : 0;
	assign iter_dec_or_val32 = (dividend[63:31] == 33'b000000000000000000000000000000001)? 16 : 0;
	assign iter_dec_or_val33 = (dividend[63:30] == 34'b0000000000000000000000000000000001)? 16 : 0;
	assign iter_dec_or_val34 = (dividend[63:29] == 35'b00000000000000000000000000000000001)? 17 : 0;
	assign iter_dec_or_val35 = (dividend[63:28] == 36'b000000000000000000000000000000000001)? 17 : 0;
	assign iter_dec_or_val36 = (dividend[63:27] == 37'b0000000000000000000000000000000000001)? 18 : 0;
	assign iter_dec_or_val37 = (dividend[63:26] == 38'b00000000000000000000000000000000000001)? 18 : 0;
	assign iter_dec_or_val38 = (dividend[63:25] == 39'b000000000000000000000000000000000000001)? 19 : 0;
	assign iter_dec_or_val39 = (dividend[63:24] == 40'b0000000000000000000000000000000000000001)? 19 : 0;
	assign iter_dec_or_val40 = (dividend[63:23] == 41'b00000000000000000000000000000000000000001)? 20 : 0;
	assign iter_dec_or_val41 = (dividend[63:22] == 42'b000000000000000000000000000000000000000001)? 20 : 0;
	assign iter_dec_or_val42 = (dividend[63:21] == 43'b0000000000000000000000000000000000000000001)? 21 : 0;
	assign iter_dec_or_val43 = (dividend[63:20] == 44'b00000000000000000000000000000000000000000001)? 21 : 0;
	assign iter_dec_or_val44 = (dividend[63:19] == 45'b000000000000000000000000000000000000000000001)? 22 : 0;
	assign iter_dec_or_val45 = (dividend[63:18] == 46'b0000000000000000000000000000000000000000000001)? 22 : 0;
	assign iter_dec_or_val46 = (dividend[63:17] == 47'b00000000000000000000000000000000000000000000001)? 23 : 0;
	assign iter_dec_or_val47 = (dividend[63:16] == 48'b000000000000000000000000000000000000000000000001)? 23 : 0;
	assign iter_dec_or_val48 = (dividend[63:15] == 49'b0000000000000000000000000000000000000000000000001)? 24 : 0;
	assign iter_dec_or_val49 = (dividend[63:14] == 50'b00000000000000000000000000000000000000000000000001)? 24 : 0;
	assign iter_dec_or_val50 = (dividend[63:13] == 51'b000000000000000000000000000000000000000000000000001)? 25 : 0;
	assign iter_dec_or_val51 = (dividend[63:12] == 52'b0000000000000000000000000000000000000000000000000001)? 25 : 0;
	assign iter_dec_or_val52 = (dividend[63:11] == 53'b00000000000000000000000000000000000000000000000000001)? 26 : 0;
	assign iter_dec_or_val53 = (dividend[63:10] == 54'b000000000000000000000000000000000000000000000000000001)? 26 : 0;
	assign iter_dec_or_val54 = (dividend[63:9] == 55'b0000000000000000000000000000000000000000000000000000001)? 27 : 0;
	assign iter_dec_or_val55 = (dividend[63:8] == 56'b00000000000000000000000000000000000000000000000000000001)? 27 : 0;
	assign iter_dec_or_val56 = (dividend[63:7] == 57'b000000000000000000000000000000000000000000000000000000001)? 28 : 0;
	assign iter_dec_or_val57 = (dividend[63:6] == 58'b0000000000000000000000000000000000000000000000000000000001)? 28 : 0;
	assign iter_dec_or_val58 = (dividend[63:5] == 59'b00000000000000000000000000000000000000000000000000000000001)? 29 : 0;
	assign iter_dec_or_val59 = (dividend[63:4] == 60'b000000000000000000000000000000000000000000000000000000000001)? 29 : 0;
	assign iter_dec_or_val60 = (dividend[63:3] == 61'b0000000000000000000000000000000000000000000000000000000000001)? 30 : 0;
	assign iter_dec_or_val61 = (dividend[63:2] == 62'b00000000000000000000000000000000000000000000000000000000000001)? 30 : 0;
	assign iter_dec_or_val62 = (dividend[63:1] == 63'b000000000000000000000000000000000000000000000000000000000000001)? 31 : 0;
	assign iter_dec_or_val63 = (dividend[63:0] == 64'b0000000000000000000000000000000000000000000000000000000000000001)? 31 : 0;

	always @(*) begin
		pre_shift_dividend = pre_shift_dividend_or_val0 | pre_shift_dividend_or_val1 | pre_shift_dividend_or_val2 | pre_shift_dividend_or_val3 | pre_shift_dividend_or_val4 | pre_shift_dividend_or_val5 | pre_shift_dividend_or_val6 | pre_shift_dividend_or_val7 | pre_shift_dividend_or_val8 | pre_shift_dividend_or_val9 | pre_shift_dividend_or_val10 | pre_shift_dividend_or_val11 | pre_shift_dividend_or_val12 | pre_shift_dividend_or_val13 | pre_shift_dividend_or_val14 | pre_shift_dividend_or_val15 | pre_shift_dividend_or_val16 | pre_shift_dividend_or_val17 | pre_shift_dividend_or_val18 | pre_shift_dividend_or_val19 | pre_shift_dividend_or_val20 | pre_shift_dividend_or_val21 | pre_shift_dividend_or_val22 | pre_shift_dividend_or_val23 | pre_shift_dividend_or_val24 | pre_shift_dividend_or_val25 | pre_shift_dividend_or_val26 | pre_shift_dividend_or_val27 | pre_shift_dividend_or_val28 | pre_shift_dividend_or_val29 | pre_shift_dividend_or_val30 | pre_shift_dividend_or_val31 | pre_shift_dividend_or_val32 | pre_shift_dividend_or_val33 | pre_shift_dividend_or_val34 | pre_shift_dividend_or_val35 | pre_shift_dividend_or_val36 | pre_shift_dividend_or_val37 | pre_shift_dividend_or_val38 | pre_shift_dividend_or_val39 | pre_shift_dividend_or_val40 | pre_shift_dividend_or_val41 | pre_shift_dividend_or_val42 | pre_shift_dividend_or_val43 | pre_shift_dividend_or_val44 | pre_shift_dividend_or_val45 | pre_shift_dividend_or_val46 | pre_shift_dividend_or_val47 | pre_shift_dividend_or_val48 | pre_shift_dividend_or_val49 | pre_shift_dividend_or_val50 | pre_shift_dividend_or_val51 | pre_shift_dividend_or_val52 | pre_shift_dividend_or_val53 | pre_shift_dividend_or_val54 | pre_shift_dividend_or_val55 | pre_shift_dividend_or_val56 | pre_shift_dividend_or_val57 | pre_shift_dividend_or_val58 | pre_shift_dividend_or_val59 | pre_shift_dividend_or_val60 | pre_shift_dividend_or_val61 | pre_shift_dividend_or_val62 | pre_shift_dividend_or_val63;
		iter_dec =  iter_dec_or_val0 | iter_dec_or_val1 | iter_dec_or_val2 | iter_dec_or_val3 | iter_dec_or_val4 | iter_dec_or_val5 | iter_dec_or_val6 | iter_dec_or_val7 | iter_dec_or_val8 | iter_dec_or_val9 | iter_dec_or_val10 | iter_dec_or_val11 | iter_dec_or_val12 | iter_dec_or_val13 | iter_dec_or_val14 | iter_dec_or_val15 | iter_dec_or_val16 | iter_dec_or_val17 | iter_dec_or_val18 | iter_dec_or_val19 | iter_dec_or_val20 | iter_dec_or_val21 | iter_dec_or_val22 | iter_dec_or_val23 | iter_dec_or_val24 | iter_dec_or_val25 | iter_dec_or_val26 | iter_dec_or_val27 | iter_dec_or_val28 | iter_dec_or_val29 | iter_dec_or_val30 | iter_dec_or_val31 | iter_dec_or_val32 | iter_dec_or_val33 | iter_dec_or_val34 | iter_dec_or_val35 | iter_dec_or_val36 | iter_dec_or_val37 | iter_dec_or_val38 | iter_dec_or_val39 | iter_dec_or_val40 | iter_dec_or_val41 | iter_dec_or_val42 | iter_dec_or_val43 | iter_dec_or_val44 | iter_dec_or_val45 | iter_dec_or_val46 | iter_dec_or_val47 | iter_dec_or_val48 | iter_dec_or_val49 | iter_dec_or_val50 | iter_dec_or_val51 | iter_dec_or_val52 | iter_dec_or_val53 | iter_dec_or_val54 | iter_dec_or_val55 | iter_dec_or_val56 | iter_dec_or_val57 | iter_dec_or_val58 | iter_dec_or_val59 | iter_dec_or_val60 | iter_dec_or_val61 | iter_dec_or_val62 | iter_dec_or_val63;            
	end


endmodule
