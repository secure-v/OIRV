module pre_shift_dividend32 (
	input [31:0]         dividend          ,
	output reg[34:0]     pre_shift_dividend,
    output reg[4:0]      iter_dec          //00...0001: iteration number -= 1; //00...0010: iteration number -= 2     
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

	wire [34:0] pre_shift_dividend_or_val0 ; 
	wire [34:0] pre_shift_dividend_or_val1 ; 
	wire [34:0] pre_shift_dividend_or_val2 ; 
	wire [34:0] pre_shift_dividend_or_val3 ; 
	wire [34:0] pre_shift_dividend_or_val4 ; 
	wire [34:0] pre_shift_dividend_or_val5 ; 
	wire [34:0] pre_shift_dividend_or_val6 ; 
	wire [34:0] pre_shift_dividend_or_val7 ; 
	wire [34:0] pre_shift_dividend_or_val8 ; 
	wire [34:0] pre_shift_dividend_or_val9 ; 
	wire [34:0] pre_shift_dividend_or_val10; 
	wire [34:0] pre_shift_dividend_or_val11; 
	wire [34:0] pre_shift_dividend_or_val12; 
	wire [34:0] pre_shift_dividend_or_val13; 
	wire [34:0] pre_shift_dividend_or_val14; 
	wire [34:0] pre_shift_dividend_or_val15; 
	wire [34:0] pre_shift_dividend_or_val16; 
	wire [34:0] pre_shift_dividend_or_val17; 
	wire [34:0] pre_shift_dividend_or_val18; 
	wire [34:0] pre_shift_dividend_or_val19; 
	wire [34:0] pre_shift_dividend_or_val20; 
	wire [34:0] pre_shift_dividend_or_val21; 
	wire [34:0] pre_shift_dividend_or_val22; 
	wire [34:0] pre_shift_dividend_or_val23; 
	wire [34:0] pre_shift_dividend_or_val24; 
	wire [34:0] pre_shift_dividend_or_val25; 
	wire [34:0] pre_shift_dividend_or_val26; 
	wire [34:0] pre_shift_dividend_or_val27; 
	wire [34:0] pre_shift_dividend_or_val28; 
	wire [34:0] pre_shift_dividend_or_val29; 
	wire [34:0] pre_shift_dividend_or_val30; 
	wire [34:0] pre_shift_dividend_or_val31; 

	assign pre_shift_dividend_or_val0  = (dividend[31] == 1'b1)? {3'd0  , dividend[31:0]} : `ZERO;
	assign pre_shift_dividend_or_val1  = (dividend[31:30] == 2'b01)? {3'd0  , dividend[31:0]} : `ZERO;
	assign pre_shift_dividend_or_val2  = (dividend[31:29] == 3'b001)? {3'd0  , dividend[29:0], 2'd0} : `ZERO;
	assign pre_shift_dividend_or_val3  = (dividend[31:28] == 4'b0001)? {3'd0  , dividend[29:0], 2'd0} : `ZERO;
	assign pre_shift_dividend_or_val4  = (dividend[31:27] == 5'b00001)? {3'd0  , dividend[27:0], 4'd0} : `ZERO;
	assign pre_shift_dividend_or_val5  = (dividend[31:26] == 6'b000001)? {3'd0  , dividend[27:0], 4'd0} : `ZERO;
	assign pre_shift_dividend_or_val6  = (dividend[31:25] == 7'b0000001)? {3'd0  , dividend[25:0], 6'd0} : `ZERO;
	assign pre_shift_dividend_or_val7  = (dividend[31:24] == 8'b00000001)? {3'd0  , dividend[25:0], 6'd0} : `ZERO;
	assign pre_shift_dividend_or_val8  = (dividend[31:23] == 9'b000000001)? {3'd0  , dividend[23:0], 8'd0} : `ZERO;
	assign pre_shift_dividend_or_val9  = (dividend[31:22] == 10'b0000000001)? {3'd0  , dividend[23:0], 8'd0} : `ZERO;
	assign pre_shift_dividend_or_val10 = (dividend[31:21] == 11'b00000000001)? {3'd0  , dividend[21:0], 10'd0} : `ZERO;
	assign pre_shift_dividend_or_val11 = (dividend[31:20] == 12'b000000000001)? {3'd0  , dividend[21:0], 10'd0} : `ZERO;
	assign pre_shift_dividend_or_val12 = (dividend[31:19] == 13'b0000000000001)? {3'd0  , dividend[19:0], 12'd0} : `ZERO;
	assign pre_shift_dividend_or_val13 = (dividend[31:18] == 14'b00000000000001)? {3'd0  , dividend[19:0], 12'd0} : `ZERO;
	assign pre_shift_dividend_or_val14 = (dividend[31:17] == 15'b000000000000001)? {3'd0  , dividend[17:0], 14'd0} : `ZERO;
	assign pre_shift_dividend_or_val15 = (dividend[31:16] == 16'b0000000000000001)? {3'd0  , dividend[17:0], 14'd0} : `ZERO;
	assign pre_shift_dividend_or_val16 = (dividend[31:15] == 17'b00000000000000001)? {3'd0  , dividend[15:0], 16'd0} : `ZERO;
	assign pre_shift_dividend_or_val17 = (dividend[31:14] == 18'b000000000000000001)? {3'd0  , dividend[15:0], 16'd0} : `ZERO;
	assign pre_shift_dividend_or_val18 = (dividend[31:13] == 19'b0000000000000000001)? {3'd0  , dividend[13:0], 18'd0} : `ZERO;
	assign pre_shift_dividend_or_val19 = (dividend[31:12] == 20'b00000000000000000001)? {3'd0  , dividend[13:0], 18'd0} : `ZERO;
	assign pre_shift_dividend_or_val20 = (dividend[31:11] == 21'b000000000000000000001)? {3'd0  , dividend[11:0], 20'd0} : `ZERO;
	assign pre_shift_dividend_or_val21 = (dividend[31:10] == 22'b0000000000000000000001)? {3'd0  , dividend[11:0], 20'd0} : `ZERO;
	assign pre_shift_dividend_or_val22 = (dividend[31:9 ] == 23'b00000000000000000000001)? {3'd0  , dividend[ 9:0], 22'd0} : `ZERO;
	assign pre_shift_dividend_or_val23 = (dividend[31:8 ] == 24'b000000000000000000000001)? {3'd0  , dividend[ 9:0], 22'd0} : `ZERO;
	assign pre_shift_dividend_or_val24 = (dividend[31:7 ] == 25'b0000000000000000000000001)? {3'd0  , dividend[ 7:0], 24'd0} : `ZERO;
	assign pre_shift_dividend_or_val25 = (dividend[31:6 ] == 26'b00000000000000000000000001)? {3'd0  , dividend[ 7:0], 24'd0} : `ZERO;
	assign pre_shift_dividend_or_val26 = (dividend[31:5 ] == 27'b000000000000000000000000001)? {3'd0  , dividend[ 5:0], 26'd0} : `ZERO;
	assign pre_shift_dividend_or_val27 = (dividend[31:4 ] == 28'b0000000000000000000000000001)? {3'd0  , dividend[ 5:0], 26'd0} : `ZERO;
	assign pre_shift_dividend_or_val28 = (dividend[31:3 ] == 29'b00000000000000000000000000001)? {3'd0  , dividend[ 3:0], 28'd0} : `ZERO;
	assign pre_shift_dividend_or_val29 = (dividend[31:2 ] == 30'b000000000000000000000000000001)? {3'd0  , dividend[ 3:0], 28'd0} : `ZERO;
	assign pre_shift_dividend_or_val30 = (dividend[31:1 ] == 31'b0000000000000000000000000000001)? {3'd0  , dividend[ 1:0], 30'd0} : `ZERO;
	assign pre_shift_dividend_or_val31 = (dividend[31:0 ] == 32'b00000000000000000000000000000001)? {3'd0  , dividend[ 1:0], 30'd0} : `ZERO;

	wire [4:0] iter_dec_or_val0 ; 
	wire [4:0] iter_dec_or_val1 ; 
	wire [4:0] iter_dec_or_val2 ; 
	wire [4:0] iter_dec_or_val3 ; 
	wire [4:0] iter_dec_or_val4 ; 
	wire [4:0] iter_dec_or_val5 ; 
	wire [4:0] iter_dec_or_val6 ; 
	wire [4:0] iter_dec_or_val7 ; 
	wire [4:0] iter_dec_or_val8 ; 
	wire [4:0] iter_dec_or_val9 ; 
	wire [4:0] iter_dec_or_val10; 
	wire [4:0] iter_dec_or_val11; 
	wire [4:0] iter_dec_or_val12; 
	wire [4:0] iter_dec_or_val13; 
	wire [4:0] iter_dec_or_val14; 
	wire [4:0] iter_dec_or_val15; 
	wire [4:0] iter_dec_or_val16; 
	wire [4:0] iter_dec_or_val17; 
	wire [4:0] iter_dec_or_val18; 
	wire [4:0] iter_dec_or_val19; 
	wire [4:0] iter_dec_or_val20; 
	wire [4:0] iter_dec_or_val21; 
	wire [4:0] iter_dec_or_val22; 
	wire [4:0] iter_dec_or_val23; 
	wire [4:0] iter_dec_or_val24; 
	wire [4:0] iter_dec_or_val25; 
	wire [4:0] iter_dec_or_val26; 
	wire [4:0] iter_dec_or_val27; 
	wire [4:0] iter_dec_or_val28; 
	wire [4:0] iter_dec_or_val29; 
	wire [4:0] iter_dec_or_val30; 
	wire [4:0] iter_dec_or_val31; 

	assign iter_dec_or_val0  = (dividend[31] == 1'b1)? 0  : 0;
	assign iter_dec_or_val1  = (dividend[31:30] == 2'b01)? 0  : 0;
	assign iter_dec_or_val2  = (dividend[31:29] == 3'b001)? 1  : 0;
	assign iter_dec_or_val3  = (dividend[31:28] == 4'b0001)? 1  : 0;
	assign iter_dec_or_val4  = (dividend[31:27] == 5'b00001)? 2  : 0;
	assign iter_dec_or_val5  = (dividend[31:26] == 6'b000001)? 2  : 0;
	assign iter_dec_or_val6  = (dividend[31:25] == 7'b0000001)? 3  : 0;
	assign iter_dec_or_val7  = (dividend[31:24] == 8'b00000001)? 3  : 0;
	assign iter_dec_or_val8  = (dividend[31:23] == 9'b000000001)? 4  : 0;
	assign iter_dec_or_val9  = (dividend[31:22] == 10'b0000000001)? 4  : 0;
	assign iter_dec_or_val10 = (dividend[31:21] == 11'b00000000001)? 5  : 0;
	assign iter_dec_or_val11 = (dividend[31:20] == 12'b000000000001)? 5  : 0;
	assign iter_dec_or_val12 = (dividend[31:19] == 13'b0000000000001)? 6  : 0;
	assign iter_dec_or_val13 = (dividend[31:18] == 14'b00000000000001)? 6  : 0;
	assign iter_dec_or_val14 = (dividend[31:17] == 15'b000000000000001)? 7  : 0;
	assign iter_dec_or_val15 = (dividend[31:16] == 16'b0000000000000001)? 7  : 0;
	assign iter_dec_or_val16 = (dividend[31:15] == 17'b00000000000000001)? 8  : 0;
	assign iter_dec_or_val17 = (dividend[31:14] == 18'b000000000000000001)? 8  : 0;
	assign iter_dec_or_val18 = (dividend[31:13] == 19'b0000000000000000001)? 9  : 0;
	assign iter_dec_or_val19 = (dividend[31:12] == 20'b00000000000000000001)? 9  : 0;
	assign iter_dec_or_val20 = (dividend[31:11] == 21'b000000000000000000001)? 10 : 0;
	assign iter_dec_or_val21 = (dividend[31:10] == 22'b0000000000000000000001)? 10 : 0;
	assign iter_dec_or_val22 = (dividend[31:9 ] == 23'b00000000000000000000001)? 11 : 0;
	assign iter_dec_or_val23 = (dividend[31:8 ] == 24'b000000000000000000000001)? 11 : 0;
	assign iter_dec_or_val24 = (dividend[31:7 ] == 25'b0000000000000000000000001)? 12 : 0;
	assign iter_dec_or_val25 = (dividend[31:6 ] == 26'b00000000000000000000000001)? 12 : 0;
	assign iter_dec_or_val26 = (dividend[31:5 ] == 27'b000000000000000000000000001)? 13 : 0;
	assign iter_dec_or_val27 = (dividend[31:4 ] == 28'b0000000000000000000000000001)? 13 : 0;
	assign iter_dec_or_val28 = (dividend[31:3 ] == 29'b00000000000000000000000000001)? 14 : 0;
	assign iter_dec_or_val29 = (dividend[31:2 ] == 30'b000000000000000000000000000001)? 14 : 0;
	assign iter_dec_or_val30 = (dividend[31:1 ] == 31'b0000000000000000000000000000001)? 15 : 0;
	assign iter_dec_or_val31 = (dividend[31:0 ] == 32'b00000000000000000000000000000001)? 15 : 0;

	always @(*) begin
		pre_shift_dividend = pre_shift_dividend_or_val0 | pre_shift_dividend_or_val1 | pre_shift_dividend_or_val2 | pre_shift_dividend_or_val3 | pre_shift_dividend_or_val4 | pre_shift_dividend_or_val5 | pre_shift_dividend_or_val6 | pre_shift_dividend_or_val7 | pre_shift_dividend_or_val8 | pre_shift_dividend_or_val9 | pre_shift_dividend_or_val10 | pre_shift_dividend_or_val11 | pre_shift_dividend_or_val12 | pre_shift_dividend_or_val13 | pre_shift_dividend_or_val14 | pre_shift_dividend_or_val15 | pre_shift_dividend_or_val16 | pre_shift_dividend_or_val17 | pre_shift_dividend_or_val18 | pre_shift_dividend_or_val19 | pre_shift_dividend_or_val20 | pre_shift_dividend_or_val21 | pre_shift_dividend_or_val22 | pre_shift_dividend_or_val23 | pre_shift_dividend_or_val24 | pre_shift_dividend_or_val25 | pre_shift_dividend_or_val26 | pre_shift_dividend_or_val27 | pre_shift_dividend_or_val28 | pre_shift_dividend_or_val29 | pre_shift_dividend_or_val30 | pre_shift_dividend_or_val31 ;
		iter_dec =  iter_dec_or_val0 | iter_dec_or_val1 | iter_dec_or_val2 | iter_dec_or_val3 | iter_dec_or_val4 | iter_dec_or_val5 | iter_dec_or_val6 | iter_dec_or_val7 | iter_dec_or_val8 | iter_dec_or_val9 | iter_dec_or_val10 | iter_dec_or_val11 | iter_dec_or_val12 | iter_dec_or_val13 | iter_dec_or_val14 | iter_dec_or_val15 | iter_dec_or_val16 | iter_dec_or_val17 | iter_dec_or_val18 | iter_dec_or_val19 | iter_dec_or_val20 | iter_dec_or_val21 | iter_dec_or_val22 | iter_dec_or_val23 | iter_dec_or_val24 | iter_dec_or_val25 | iter_dec_or_val26 | iter_dec_or_val27 | iter_dec_or_val28 | iter_dec_or_val29 | iter_dec_or_val30 | iter_dec_or_val31 ;            
	end


endmodule
