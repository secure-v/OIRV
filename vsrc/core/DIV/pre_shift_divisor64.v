module pre_shift_divisor64 (
	input [63:0]         divisor          ,
	output reg           odd_leading_zero ,
	output reg[66:0]     pre_shift_divisor,
    output reg[5:0]      iter_val         //00...0001: iteration number == 2; //00...0010: iteration number == 3     
);

	// always@(*) begin
	// 		casez(divisor)
	// 			64'b1???????????????????????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'b000, divisor}             ;
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd0                          ;
	// 			end
	// 			64'b01??????????????????????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[62:0], 1'd0} ;
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd1                          ;
	// 			end
	// 			64'b001?????????????????????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[61:0], 2'd0} ;
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd1                          ;
	// 			end
	// 			64'b0001????????????????????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[60:0], 3'd0} ;
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd2                          ;
	// 			end
	// 			64'b00001???????????????????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[59:0], 4'd0} ;
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd2                          ;
	// 			end
	// 			64'b000001??????????????????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[58:0], 5'd0} ;
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd3                          ;
	// 			end
	// 			64'b0000001?????????????????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[57:0], 6'd0} ;
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd3                          ;
	// 			end
	// 			64'b00000001????????????????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[56:0], 7'd0} ;
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd4                          ;
	// 			end
	// 			64'b000000001???????????????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[55:0], 8'd0} ;
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd4                          ;
	// 			end
	// 			64'b0000000001??????????????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[54:0], 9'd0} ;
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd5                          ;
	// 			end
	// 			64'b00000000001?????????????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[53:0], 10'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd5                          ;
	// 			end
	// 			64'b000000000001????????????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[52:0], 11'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd6                          ;
	// 			end
	// 			64'b0000000000001???????????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[51:0], 12'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd6                          ;
	// 			end
	// 			64'b00000000000001??????????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[50:0], 13'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd7                          ;
	// 			end
	// 			64'b000000000000001?????????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[49:0], 14'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd7                          ;
	// 			end
	// 			64'b0000000000000001????????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[48:0], 15'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd8                          ;
	// 			end
	// 			64'b00000000000000001???????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[47:0], 16'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd8                          ;
	// 			end
	// 			64'b000000000000000001??????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[46:0], 17'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd9                          ;
	// 			end
	// 			64'b0000000000000000001?????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[45:0], 18'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd9                          ;
	// 			end
	// 			64'b00000000000000000001????????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[44:0], 19'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd10                         ;
	// 			end
	// 			64'b000000000000000000001???????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[43:0], 20'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd10                         ;
	// 			end
	// 			64'b0000000000000000000001??????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[42:0], 21'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd11                         ;
	// 			end
	// 			64'b00000000000000000000001?????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[41:0], 22'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd11                         ;
	// 			end
	// 			64'b000000000000000000000001????????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[40:0], 23'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd12                         ;
	// 			end
	// 			64'b0000000000000000000000001???????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[39:0], 24'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd12                         ;
	// 			end
	// 			64'b00000000000000000000000001??????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[38:0], 25'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd13                         ;
	// 			end
	// 			64'b000000000000000000000000001?????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[37:0], 26'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd13                         ;
	// 			end
	// 			64'b0000000000000000000000000001????????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[36:0], 27'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd14                         ;
	// 			end
	// 			64'b00000000000000000000000000001???????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[35:0], 28'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd14                         ;
	// 			end
	// 			64'b000000000000000000000000000001??????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[34:0], 29'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd15                         ;
	// 			end
	// 			64'b0000000000000000000000000000001?????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[33:0], 30'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd15                         ;
	// 			end
	// 			64'b00000000000000000000000000000001????????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[32:0], 31'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd16                         ;
	// 			end
	// 			64'b000000000000000000000000000000001???????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[31:0], 32'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd16                         ;
	// 			end
	// 			64'b0000000000000000000000000000000001??????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[30:0], 33'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd17                         ;
	// 			end
	// 			64'b00000000000000000000000000000000001?????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[29:0], 34'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd17                         ;
	// 			end
	// 			64'b000000000000000000000000000000000001????????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[28:0], 35'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd18                         ;
	// 			end
	// 			64'b0000000000000000000000000000000000001???????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[27:0], 36'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd18                         ;
	// 			end
	// 			64'b00000000000000000000000000000000000001??????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[26:0], 37'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd19                         ;
	// 			end
	// 			64'b000000000000000000000000000000000000001?????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[25:0], 38'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd19                         ;
	// 			end
	// 			64'b0000000000000000000000000000000000000001????????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[24:0], 39'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd20                         ;
	// 			end
	// 			64'b00000000000000000000000000000000000000001???????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[23:0], 40'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd20                         ;
	// 			end
	// 			64'b000000000000000000000000000000000000000001??????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[22:0], 41'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd21                         ;
	// 			end
	// 			64'b0000000000000000000000000000000000000000001?????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[21:0], 42'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd21                         ;
	// 			end
	// 			64'b00000000000000000000000000000000000000000001????????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[20:0], 43'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd22                         ;
	// 			end
	// 			64'b000000000000000000000000000000000000000000001???????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[19:0], 44'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd22                         ;
	// 			end
	// 			64'b0000000000000000000000000000000000000000000001??????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[18:0], 45'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd23                         ;
	// 			end
	// 			64'b00000000000000000000000000000000000000000000001?????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[17:0], 46'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd23                         ;
	// 			end
	// 			64'b000000000000000000000000000000000000000000000001????????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[16:0], 47'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd24                         ;
	// 			end
	// 			64'b0000000000000000000000000000000000000000000000001???????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[15:0], 48'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd24                         ;
	// 			end
	// 			64'b00000000000000000000000000000000000000000000000001??????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[14:0], 49'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd25                         ;
	// 			end
	// 			64'b000000000000000000000000000000000000000000000000001?????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[13:0], 50'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd25                         ;
	// 			end
	// 			64'b0000000000000000000000000000000000000000000000000001????????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[12:0], 51'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd26                         ;
	// 			end
	// 			64'b00000000000000000000000000000000000000000000000000001???????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[11:0], 52'd0};
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd26                         ;
	// 			end
	// 			64'b000000000000000000000000000000000000000000000000000001??????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[10:0], 53'd0};
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd27                         ;
	// 			end
	// 			64'b0000000000000000000000000000000000000000000000000000001?????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[9:0], 54'd0} ;
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd27                         ;
	// 			end
	// 			64'b00000000000000000000000000000000000000000000000000000001????????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[8:0], 55'd0} ;
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd28                         ;
	// 			end
	// 			64'b000000000000000000000000000000000000000000000000000000001???????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[7:0], 56'd0} ;
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd28                         ;
	// 			end
	// 			64'b0000000000000000000000000000000000000000000000000000000001??????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[6:0], 57'd0} ;
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd29                         ;
	// 			end
	// 			64'b00000000000000000000000000000000000000000000000000000000001?????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[5:0], 58'd0} ;
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd29                         ;
	// 			end
	// 			64'b000000000000000000000000000000000000000000000000000000000001????: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[4:0], 59'd0} ;
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd30                         ;
	// 			end
	// 			64'b0000000000000000000000000000000000000000000000000000000000001???: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[3:0], 60'd0} ;
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd30                         ;
	// 			end
	// 			64'b00000000000000000000000000000000000000000000000000000000000001??: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[2:0], 61'd0} ;
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd31                         ;
	// 			end
	// 			64'b000000000000000000000000000000000000000000000000000000000000001?: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[1:0], 62'd0} ;
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd31                         ;
	// 			end
	// 			64'b0000000000000000000000000000000000000000000000000000000000000001: begin
	// 				pre_shift_divisor     = {3'd0  , divisor[0], 63'd0}   ;
	// 				odd_leading_zero      = 1                             ;
	// 				iter_val              = 6'd32                         ;
	// 			end
	// 			default: begin
	// 				pre_shift_divisor     = 67'd0                         ;
	// 				odd_leading_zero      = 0                             ;
	// 				iter_val              = 6'd0                          ;
	// 			end
	// 		endcase
	// end

	wire[66:0]pre_shift_divisor_or_val0 ;
	wire[66:0]pre_shift_divisor_or_val1 ;
	wire[66:0]pre_shift_divisor_or_val2 ;
	wire[66:0]pre_shift_divisor_or_val3 ;
	wire[66:0]pre_shift_divisor_or_val4 ;
	wire[66:0]pre_shift_divisor_or_val5 ;
	wire[66:0]pre_shift_divisor_or_val6 ;
	wire[66:0]pre_shift_divisor_or_val7 ;
	wire[66:0]pre_shift_divisor_or_val8 ;
	wire[66:0]pre_shift_divisor_or_val9 ;
	wire[66:0]pre_shift_divisor_or_val10;
	wire[66:0]pre_shift_divisor_or_val11;
	wire[66:0]pre_shift_divisor_or_val12;
	wire[66:0]pre_shift_divisor_or_val13;
	wire[66:0]pre_shift_divisor_or_val14;
	wire[66:0]pre_shift_divisor_or_val15;
	wire[66:0]pre_shift_divisor_or_val16;
	wire[66:0]pre_shift_divisor_or_val17;
	wire[66:0]pre_shift_divisor_or_val18;
	wire[66:0]pre_shift_divisor_or_val19;
	wire[66:0]pre_shift_divisor_or_val20;
	wire[66:0]pre_shift_divisor_or_val21;
	wire[66:0]pre_shift_divisor_or_val22;
	wire[66:0]pre_shift_divisor_or_val23;
	wire[66:0]pre_shift_divisor_or_val24;
	wire[66:0]pre_shift_divisor_or_val25;
	wire[66:0]pre_shift_divisor_or_val26;
	wire[66:0]pre_shift_divisor_or_val27;
	wire[66:0]pre_shift_divisor_or_val28;
	wire[66:0]pre_shift_divisor_or_val29;
	wire[66:0]pre_shift_divisor_or_val30;
	wire[66:0]pre_shift_divisor_or_val31;
	wire[66:0]pre_shift_divisor_or_val32;
	wire[66:0]pre_shift_divisor_or_val33;
	wire[66:0]pre_shift_divisor_or_val34;
	wire[66:0]pre_shift_divisor_or_val35;
	wire[66:0]pre_shift_divisor_or_val36;
	wire[66:0]pre_shift_divisor_or_val37;
	wire[66:0]pre_shift_divisor_or_val38;
	wire[66:0]pre_shift_divisor_or_val39;
	wire[66:0]pre_shift_divisor_or_val40;
	wire[66:0]pre_shift_divisor_or_val41;
	wire[66:0]pre_shift_divisor_or_val42;
	wire[66:0]pre_shift_divisor_or_val43;
	wire[66:0]pre_shift_divisor_or_val44;
	wire[66:0]pre_shift_divisor_or_val45;
	wire[66:0]pre_shift_divisor_or_val46;
	wire[66:0]pre_shift_divisor_or_val47;
	wire[66:0]pre_shift_divisor_or_val48;
	wire[66:0]pre_shift_divisor_or_val49;
	wire[66:0]pre_shift_divisor_or_val50;
	wire[66:0]pre_shift_divisor_or_val51;
	wire[66:0]pre_shift_divisor_or_val52;
	wire[66:0]pre_shift_divisor_or_val53;
	wire[66:0]pre_shift_divisor_or_val54;
	wire[66:0]pre_shift_divisor_or_val55;
	wire[66:0]pre_shift_divisor_or_val56;
	wire[66:0]pre_shift_divisor_or_val57;
	wire[66:0]pre_shift_divisor_or_val58;
	wire[66:0]pre_shift_divisor_or_val59;
	wire[66:0]pre_shift_divisor_or_val60;
	wire[66:0]pre_shift_divisor_or_val61;
	wire[66:0]pre_shift_divisor_or_val62;
	wire[66:0]pre_shift_divisor_or_val63;

	assign pre_shift_divisor_or_val0 = (divisor[63:63] == 1'b1)? {3'd0  , divisor[63:0]} : 0;
	assign pre_shift_divisor_or_val1 = (divisor[63:62] == 2'b01)? {3'd0  , divisor[62:0], 1'd0} : 0;
	assign pre_shift_divisor_or_val2 = (divisor[63:61] == 3'b001)? {3'd0  , divisor[61:0], 2'd0} : 0;
	assign pre_shift_divisor_or_val3 = (divisor[63:60] == 4'b0001)? {3'd0  , divisor[60:0], 3'd0} : 0;
	assign pre_shift_divisor_or_val4 = (divisor[63:59] == 5'b00001)? {3'd0  , divisor[59:0], 4'd0} : 0;
	assign pre_shift_divisor_or_val5 = (divisor[63:58] == 6'b000001)? {3'd0  , divisor[58:0], 5'd0} : 0;
	assign pre_shift_divisor_or_val6 = (divisor[63:57] == 7'b0000001)? {3'd0  , divisor[57:0], 6'd0} : 0;
	assign pre_shift_divisor_or_val7 = (divisor[63:56] == 8'b00000001)? {3'd0  , divisor[56:0], 7'd0} : 0;
	assign pre_shift_divisor_or_val8 = (divisor[63:55] == 9'b000000001)? {3'd0  , divisor[55:0], 8'd0} : 0;
	assign pre_shift_divisor_or_val9 = (divisor[63:54] == 10'b0000000001)? {3'd0  , divisor[54:0], 9'd0} : 0;
	assign pre_shift_divisor_or_val10 = (divisor[63:53] == 11'b00000000001)? {3'd0  , divisor[53:0], 10'd0} : 0;
	assign pre_shift_divisor_or_val11 = (divisor[63:52] == 12'b000000000001)? {3'd0  , divisor[52:0], 11'd0} : 0;
	assign pre_shift_divisor_or_val12 = (divisor[63:51] == 13'b0000000000001)? {3'd0  , divisor[51:0], 12'd0} : 0;
	assign pre_shift_divisor_or_val13 = (divisor[63:50] == 14'b00000000000001)? {3'd0  , divisor[50:0], 13'd0} : 0;
	assign pre_shift_divisor_or_val14 = (divisor[63:49] == 15'b000000000000001)? {3'd0  , divisor[49:0], 14'd0} : 0;
	assign pre_shift_divisor_or_val15 = (divisor[63:48] == 16'b0000000000000001)? {3'd0  , divisor[48:0], 15'd0} : 0;
	assign pre_shift_divisor_or_val16 = (divisor[63:47] == 17'b00000000000000001)? {3'd0  , divisor[47:0], 16'd0} : 0;
	assign pre_shift_divisor_or_val17 = (divisor[63:46] == 18'b000000000000000001)? {3'd0  , divisor[46:0], 17'd0} : 0;
	assign pre_shift_divisor_or_val18 = (divisor[63:45] == 19'b0000000000000000001)? {3'd0  , divisor[45:0], 18'd0} : 0;
	assign pre_shift_divisor_or_val19 = (divisor[63:44] == 20'b00000000000000000001)? {3'd0  , divisor[44:0], 19'd0} : 0;
	assign pre_shift_divisor_or_val20 = (divisor[63:43] == 21'b000000000000000000001)? {3'd0  , divisor[43:0], 20'd0} : 0;
	assign pre_shift_divisor_or_val21 = (divisor[63:42] == 22'b0000000000000000000001)? {3'd0  , divisor[42:0], 21'd0} : 0;
	assign pre_shift_divisor_or_val22 = (divisor[63:41] == 23'b00000000000000000000001)? {3'd0  , divisor[41:0], 22'd0} : 0;
	assign pre_shift_divisor_or_val23 = (divisor[63:40] == 24'b000000000000000000000001)? {3'd0  , divisor[40:0], 23'd0} : 0;
	assign pre_shift_divisor_or_val24 = (divisor[63:39] == 25'b0000000000000000000000001)? {3'd0  , divisor[39:0], 24'd0} : 0;
	assign pre_shift_divisor_or_val25 = (divisor[63:38] == 26'b00000000000000000000000001)? {3'd0  , divisor[38:0], 25'd0} : 0;
	assign pre_shift_divisor_or_val26 = (divisor[63:37] == 27'b000000000000000000000000001)? {3'd0  , divisor[37:0], 26'd0} : 0;
	assign pre_shift_divisor_or_val27 = (divisor[63:36] == 28'b0000000000000000000000000001)? {3'd0  , divisor[36:0], 27'd0} : 0;
	assign pre_shift_divisor_or_val28 = (divisor[63:35] == 29'b00000000000000000000000000001)? {3'd0  , divisor[35:0], 28'd0} : 0;
	assign pre_shift_divisor_or_val29 = (divisor[63:34] == 30'b000000000000000000000000000001)? {3'd0  , divisor[34:0], 29'd0} : 0;
	assign pre_shift_divisor_or_val30 = (divisor[63:33] == 31'b0000000000000000000000000000001)? {3'd0  , divisor[33:0], 30'd0} : 0;
	assign pre_shift_divisor_or_val31 = (divisor[63:32] == 32'b00000000000000000000000000000001)? {3'd0  , divisor[32:0], 31'd0} : 0;
	assign pre_shift_divisor_or_val32 = (divisor[63:31] == 33'b000000000000000000000000000000001)? {3'd0  , divisor[31:0], 32'd0} : 0;
	assign pre_shift_divisor_or_val33 = (divisor[63:30] == 34'b0000000000000000000000000000000001)? {3'd0  , divisor[30:0], 33'd0} : 0;
	assign pre_shift_divisor_or_val34 = (divisor[63:29] == 35'b00000000000000000000000000000000001)? {3'd0  , divisor[29:0], 34'd0} : 0;
	assign pre_shift_divisor_or_val35 = (divisor[63:28] == 36'b000000000000000000000000000000000001)? {3'd0  , divisor[28:0], 35'd0} : 0;
	assign pre_shift_divisor_or_val36 = (divisor[63:27] == 37'b0000000000000000000000000000000000001)? {3'd0  , divisor[27:0], 36'd0} : 0;
	assign pre_shift_divisor_or_val37 = (divisor[63:26] == 38'b00000000000000000000000000000000000001)? {3'd0  , divisor[26:0], 37'd0} : 0;
	assign pre_shift_divisor_or_val38 = (divisor[63:25] == 39'b000000000000000000000000000000000000001)? {3'd0  , divisor[25:0], 38'd0} : 0;
	assign pre_shift_divisor_or_val39 = (divisor[63:24] == 40'b0000000000000000000000000000000000000001)? {3'd0  , divisor[24:0], 39'd0} : 0;
	assign pre_shift_divisor_or_val40 = (divisor[63:23] == 41'b00000000000000000000000000000000000000001)? {3'd0  , divisor[23:0], 40'd0} : 0;
	assign pre_shift_divisor_or_val41 = (divisor[63:22] == 42'b000000000000000000000000000000000000000001)? {3'd0  , divisor[22:0], 41'd0} : 0;
	assign pre_shift_divisor_or_val42 = (divisor[63:21] == 43'b0000000000000000000000000000000000000000001)? {3'd0  , divisor[21:0], 42'd0} : 0;
	assign pre_shift_divisor_or_val43 = (divisor[63:20] == 44'b00000000000000000000000000000000000000000001)? {3'd0  , divisor[20:0], 43'd0} : 0;
	assign pre_shift_divisor_or_val44 = (divisor[63:19] == 45'b000000000000000000000000000000000000000000001)? {3'd0  , divisor[19:0], 44'd0} : 0;
	assign pre_shift_divisor_or_val45 = (divisor[63:18] == 46'b0000000000000000000000000000000000000000000001)? {3'd0  , divisor[18:0], 45'd0} : 0;
	assign pre_shift_divisor_or_val46 = (divisor[63:17] == 47'b00000000000000000000000000000000000000000000001)? {3'd0  , divisor[17:0], 46'd0} : 0;
	assign pre_shift_divisor_or_val47 = (divisor[63:16] == 48'b000000000000000000000000000000000000000000000001)? {3'd0  , divisor[16:0], 47'd0} : 0;
	assign pre_shift_divisor_or_val48 = (divisor[63:15] == 49'b0000000000000000000000000000000000000000000000001)? {3'd0  , divisor[15:0], 48'd0} : 0;
	assign pre_shift_divisor_or_val49 = (divisor[63:14] == 50'b00000000000000000000000000000000000000000000000001)? {3'd0  , divisor[14:0], 49'd0} : 0;
	assign pre_shift_divisor_or_val50 = (divisor[63:13] == 51'b000000000000000000000000000000000000000000000000001)? {3'd0  , divisor[13:0], 50'd0} : 0;
	assign pre_shift_divisor_or_val51 = (divisor[63:12] == 52'b0000000000000000000000000000000000000000000000000001)? {3'd0  , divisor[12:0], 51'd0} : 0;
	assign pre_shift_divisor_or_val52 = (divisor[63:11] == 53'b00000000000000000000000000000000000000000000000000001)? {3'd0  , divisor[11:0], 52'd0} : 0;
	assign pre_shift_divisor_or_val53 = (divisor[63:10] == 54'b000000000000000000000000000000000000000000000000000001)? {3'd0  , divisor[10:0], 53'd0} : 0;
	assign pre_shift_divisor_or_val54 = (divisor[63:9] == 55'b0000000000000000000000000000000000000000000000000000001)? {3'd0  , divisor[9:0], 54'd0} : 0;
	assign pre_shift_divisor_or_val55 = (divisor[63:8] == 56'b00000000000000000000000000000000000000000000000000000001)? {3'd0  , divisor[8:0], 55'd0} : 0;
	assign pre_shift_divisor_or_val56 = (divisor[63:7] == 57'b000000000000000000000000000000000000000000000000000000001)? {3'd0  , divisor[7:0], 56'd0} : 0;
	assign pre_shift_divisor_or_val57 = (divisor[63:6] == 58'b0000000000000000000000000000000000000000000000000000000001)? {3'd0  , divisor[6:0], 57'd0} : 0;
	assign pre_shift_divisor_or_val58 = (divisor[63:5] == 59'b00000000000000000000000000000000000000000000000000000000001)? {3'd0  , divisor[5:0], 58'd0} : 0;
	assign pre_shift_divisor_or_val59 = (divisor[63:4] == 60'b000000000000000000000000000000000000000000000000000000000001)? {3'd0  , divisor[4:0], 59'd0} : 0;
	assign pre_shift_divisor_or_val60 = (divisor[63:3] == 61'b0000000000000000000000000000000000000000000000000000000000001)? {3'd0  , divisor[3:0], 60'd0} : 0;
	assign pre_shift_divisor_or_val61 = (divisor[63:2] == 62'b00000000000000000000000000000000000000000000000000000000000001)? {3'd0  , divisor[2:0], 61'd0} : 0;
	assign pre_shift_divisor_or_val62 = (divisor[63:1] == 63'b000000000000000000000000000000000000000000000000000000000000001)? {3'd0  , divisor[1:0], 62'd0} : 0;
	assign pre_shift_divisor_or_val63 = (divisor[63:0] == 64'b0000000000000000000000000000000000000000000000000000000000000001)? {3'd0  , divisor[0:0], 63'd0} : 0;

	wire[5:0] iter_val_or_val0 ;
	wire[5:0] iter_val_or_val1 ;
	wire[5:0] iter_val_or_val2 ;
	wire[5:0] iter_val_or_val3 ;
	wire[5:0] iter_val_or_val4 ;
	wire[5:0] iter_val_or_val5 ;
	wire[5:0] iter_val_or_val6 ;
	wire[5:0] iter_val_or_val7 ;
	wire[5:0] iter_val_or_val8 ;
	wire[5:0] iter_val_or_val9 ;
	wire[5:0] iter_val_or_val10;
	wire[5:0] iter_val_or_val11;
	wire[5:0] iter_val_or_val12;
	wire[5:0] iter_val_or_val13;
	wire[5:0] iter_val_or_val14;
	wire[5:0] iter_val_or_val15;
	wire[5:0] iter_val_or_val16;
	wire[5:0] iter_val_or_val17;
	wire[5:0] iter_val_or_val18;
	wire[5:0] iter_val_or_val19;
	wire[5:0] iter_val_or_val20;
	wire[5:0] iter_val_or_val21;
	wire[5:0] iter_val_or_val22;
	wire[5:0] iter_val_or_val23;
	wire[5:0] iter_val_or_val24;
	wire[5:0] iter_val_or_val25;
	wire[5:0] iter_val_or_val26;
	wire[5:0] iter_val_or_val27;
	wire[5:0] iter_val_or_val28;
	wire[5:0] iter_val_or_val29;
	wire[5:0] iter_val_or_val30;
	wire[5:0] iter_val_or_val31;
	wire[5:0] iter_val_or_val32;
	wire[5:0] iter_val_or_val33;
	wire[5:0] iter_val_or_val34;
	wire[5:0] iter_val_or_val35;
	wire[5:0] iter_val_or_val36;
	wire[5:0] iter_val_or_val37;
	wire[5:0] iter_val_or_val38;
	wire[5:0] iter_val_or_val39;
	wire[5:0] iter_val_or_val40;
	wire[5:0] iter_val_or_val41;
	wire[5:0] iter_val_or_val42;
	wire[5:0] iter_val_or_val43;
	wire[5:0] iter_val_or_val44;
	wire[5:0] iter_val_or_val45;
	wire[5:0] iter_val_or_val46;
	wire[5:0] iter_val_or_val47;
	wire[5:0] iter_val_or_val48;
	wire[5:0] iter_val_or_val49;
	wire[5:0] iter_val_or_val50;
	wire[5:0] iter_val_or_val51;
	wire[5:0] iter_val_or_val52;
	wire[5:0] iter_val_or_val53;
	wire[5:0] iter_val_or_val54;
	wire[5:0] iter_val_or_val55;
	wire[5:0] iter_val_or_val56;
	wire[5:0] iter_val_or_val57;
	wire[5:0] iter_val_or_val58;
	wire[5:0] iter_val_or_val59;
	wire[5:0] iter_val_or_val60;
	wire[5:0] iter_val_or_val61;
	wire[5:0] iter_val_or_val62;
	wire[5:0] iter_val_or_val63;

	assign iter_val_or_val0  = (divisor[63:63] == 1'b1)? 0  : 0;
	assign iter_val_or_val1  = (divisor[63:62] == 2'b01)? 1  : 0;
	assign iter_val_or_val2  = (divisor[63:61] == 3'b001)? 1  : 0;
	assign iter_val_or_val3  = (divisor[63:60] == 4'b0001)? 2  : 0;
	assign iter_val_or_val4  = (divisor[63:59] == 5'b00001)? 2  : 0;
	assign iter_val_or_val5  = (divisor[63:58] == 6'b000001)? 3  : 0;
	assign iter_val_or_val6  = (divisor[63:57] == 7'b0000001)? 3  : 0;
	assign iter_val_or_val7  = (divisor[63:56] == 8'b00000001)? 4  : 0;
	assign iter_val_or_val8  = (divisor[63:55] == 9'b000000001)? 4  : 0;
	assign iter_val_or_val9  = (divisor[63:54] == 10'b0000000001)? 5  : 0;
	assign iter_val_or_val10 = (divisor[63:53] == 11'b00000000001)? 5  : 0;
	assign iter_val_or_val11 = (divisor[63:52] == 12'b000000000001)? 6  : 0;
	assign iter_val_or_val12 = (divisor[63:51] == 13'b0000000000001)? 6  : 0;
	assign iter_val_or_val13 = (divisor[63:50] == 14'b00000000000001)? 7  : 0;
	assign iter_val_or_val14 = (divisor[63:49] == 15'b000000000000001)? 7  : 0;
	assign iter_val_or_val15 = (divisor[63:48] == 16'b0000000000000001)? 8  : 0;
	assign iter_val_or_val16 = (divisor[63:47] == 17'b00000000000000001)? 8  : 0;
	assign iter_val_or_val17 = (divisor[63:46] == 18'b000000000000000001)? 9  : 0;
	assign iter_val_or_val18 = (divisor[63:45] == 19'b0000000000000000001)? 9  : 0;
	assign iter_val_or_val19 = (divisor[63:44] == 20'b00000000000000000001)? 10 : 0;
	assign iter_val_or_val20 = (divisor[63:43] == 21'b000000000000000000001)? 10 : 0;
	assign iter_val_or_val21 = (divisor[63:42] == 22'b0000000000000000000001)? 11 : 0;
	assign iter_val_or_val22 = (divisor[63:41] == 23'b00000000000000000000001)? 11 : 0;
	assign iter_val_or_val23 = (divisor[63:40] == 24'b000000000000000000000001)? 12 : 0;
	assign iter_val_or_val24 = (divisor[63:39] == 25'b0000000000000000000000001)? 12 : 0;
	assign iter_val_or_val25 = (divisor[63:38] == 26'b00000000000000000000000001)? 13 : 0;
	assign iter_val_or_val26 = (divisor[63:37] == 27'b000000000000000000000000001)? 13 : 0;
	assign iter_val_or_val27 = (divisor[63:36] == 28'b0000000000000000000000000001)? 14 : 0;
	assign iter_val_or_val28 = (divisor[63:35] == 29'b00000000000000000000000000001)? 14 : 0;
	assign iter_val_or_val29 = (divisor[63:34] == 30'b000000000000000000000000000001)? 15 : 0;
	assign iter_val_or_val30 = (divisor[63:33] == 31'b0000000000000000000000000000001)? 15 : 0;
	assign iter_val_or_val31 = (divisor[63:32] == 32'b00000000000000000000000000000001)? 16 : 0;
	assign iter_val_or_val32 = (divisor[63:31] == 33'b000000000000000000000000000000001)? 16 : 0;
	assign iter_val_or_val33 = (divisor[63:30] == 34'b0000000000000000000000000000000001)? 17 : 0;
	assign iter_val_or_val34 = (divisor[63:29] == 35'b00000000000000000000000000000000001)? 17 : 0;
	assign iter_val_or_val35 = (divisor[63:28] == 36'b000000000000000000000000000000000001)? 18 : 0;
	assign iter_val_or_val36 = (divisor[63:27] == 37'b0000000000000000000000000000000000001)? 18 : 0;
	assign iter_val_or_val37 = (divisor[63:26] == 38'b00000000000000000000000000000000000001)? 19 : 0;
	assign iter_val_or_val38 = (divisor[63:25] == 39'b000000000000000000000000000000000000001)? 19 : 0;
	assign iter_val_or_val39 = (divisor[63:24] == 40'b0000000000000000000000000000000000000001)? 20 : 0;
	assign iter_val_or_val40 = (divisor[63:23] == 41'b00000000000000000000000000000000000000001)? 20 : 0;
	assign iter_val_or_val41 = (divisor[63:22] == 42'b000000000000000000000000000000000000000001)? 21 : 0;
	assign iter_val_or_val42 = (divisor[63:21] == 43'b0000000000000000000000000000000000000000001)? 21 : 0;
	assign iter_val_or_val43 = (divisor[63:20] == 44'b00000000000000000000000000000000000000000001)? 22 : 0;
	assign iter_val_or_val44 = (divisor[63:19] == 45'b000000000000000000000000000000000000000000001)? 22 : 0;
	assign iter_val_or_val45 = (divisor[63:18] == 46'b0000000000000000000000000000000000000000000001)? 23 : 0;
	assign iter_val_or_val46 = (divisor[63:17] == 47'b00000000000000000000000000000000000000000000001)? 23 : 0;
	assign iter_val_or_val47 = (divisor[63:16] == 48'b000000000000000000000000000000000000000000000001)? 24 : 0;
	assign iter_val_or_val48 = (divisor[63:15] == 49'b0000000000000000000000000000000000000000000000001)? 24 : 0;
	assign iter_val_or_val49 = (divisor[63:14] == 50'b00000000000000000000000000000000000000000000000001)? 25 : 0;
	assign iter_val_or_val50 = (divisor[63:13] == 51'b000000000000000000000000000000000000000000000000001)? 25 : 0;
	assign iter_val_or_val51 = (divisor[63:12] == 52'b0000000000000000000000000000000000000000000000000001)? 26 : 0;
	assign iter_val_or_val52 = (divisor[63:11] == 53'b00000000000000000000000000000000000000000000000000001)? 26 : 0;
	assign iter_val_or_val53 = (divisor[63:10] == 54'b000000000000000000000000000000000000000000000000000001)? 27 : 0;
	assign iter_val_or_val54 = (divisor[63:9] == 55'b0000000000000000000000000000000000000000000000000000001)? 27 : 0;
	assign iter_val_or_val55 = (divisor[63:8] == 56'b00000000000000000000000000000000000000000000000000000001)? 28 : 0;
	assign iter_val_or_val56 = (divisor[63:7] == 57'b000000000000000000000000000000000000000000000000000000001)? 28 : 0;
	assign iter_val_or_val57 = (divisor[63:6] == 58'b0000000000000000000000000000000000000000000000000000000001)? 29 : 0;
	assign iter_val_or_val58 = (divisor[63:5] == 59'b00000000000000000000000000000000000000000000000000000000001)? 29 : 0;
	assign iter_val_or_val59 = (divisor[63:4] == 60'b000000000000000000000000000000000000000000000000000000000001)? 30 : 0;
	assign iter_val_or_val60 = (divisor[63:3] == 61'b0000000000000000000000000000000000000000000000000000000000001)? 30 : 0;
	assign iter_val_or_val61 = (divisor[63:2] == 62'b00000000000000000000000000000000000000000000000000000000000001)? 31 : 0;
	assign iter_val_or_val62 = (divisor[63:1] == 63'b000000000000000000000000000000000000000000000000000000000000001)? 31 : 0;
	assign iter_val_or_val63 = (divisor[63:0] == 64'b0000000000000000000000000000000000000000000000000000000000000001)? 32 : 0;

	wire odd_leading_zero_or_val0 ;
	wire odd_leading_zero_or_val1 ;
	wire odd_leading_zero_or_val2 ;
	wire odd_leading_zero_or_val3 ;
	wire odd_leading_zero_or_val4 ;
	wire odd_leading_zero_or_val5 ;
	wire odd_leading_zero_or_val6 ;
	wire odd_leading_zero_or_val7 ;
	wire odd_leading_zero_or_val8 ;
	wire odd_leading_zero_or_val9 ;
	wire odd_leading_zero_or_val10;
	wire odd_leading_zero_or_val11;
	wire odd_leading_zero_or_val12;
	wire odd_leading_zero_or_val13;
	wire odd_leading_zero_or_val14;
	wire odd_leading_zero_or_val15;
	wire odd_leading_zero_or_val16;
	wire odd_leading_zero_or_val17;
	wire odd_leading_zero_or_val18;
	wire odd_leading_zero_or_val19;
	wire odd_leading_zero_or_val20;
	wire odd_leading_zero_or_val21;
	wire odd_leading_zero_or_val22;
	wire odd_leading_zero_or_val23;
	wire odd_leading_zero_or_val24;
	wire odd_leading_zero_or_val25;
	wire odd_leading_zero_or_val26;
	wire odd_leading_zero_or_val27;
	wire odd_leading_zero_or_val28;
	wire odd_leading_zero_or_val29;
	wire odd_leading_zero_or_val30;
	wire odd_leading_zero_or_val31;
	wire odd_leading_zero_or_val32;
	wire odd_leading_zero_or_val33;
	wire odd_leading_zero_or_val34;
	wire odd_leading_zero_or_val35;
	wire odd_leading_zero_or_val36;
	wire odd_leading_zero_or_val37;
	wire odd_leading_zero_or_val38;
	wire odd_leading_zero_or_val39;
	wire odd_leading_zero_or_val40;
	wire odd_leading_zero_or_val41;
	wire odd_leading_zero_or_val42;
	wire odd_leading_zero_or_val43;
	wire odd_leading_zero_or_val44;
	wire odd_leading_zero_or_val45;
	wire odd_leading_zero_or_val46;
	wire odd_leading_zero_or_val47;
	wire odd_leading_zero_or_val48;
	wire odd_leading_zero_or_val49;
	wire odd_leading_zero_or_val50;
	wire odd_leading_zero_or_val51;
	wire odd_leading_zero_or_val52;
	wire odd_leading_zero_or_val53;
	wire odd_leading_zero_or_val54;
	wire odd_leading_zero_or_val55;
	wire odd_leading_zero_or_val56;
	wire odd_leading_zero_or_val57;
	wire odd_leading_zero_or_val58;
	wire odd_leading_zero_or_val59;
	wire odd_leading_zero_or_val60;
	wire odd_leading_zero_or_val61;
	wire odd_leading_zero_or_val62;
	wire odd_leading_zero_or_val63;

	assign odd_leading_zero_or_val0  = (divisor[63:63] == 1'b1)? 0  : 0;
	assign odd_leading_zero_or_val1  = (divisor[63:62] == 2'b01)? 1  : 0;
	assign odd_leading_zero_or_val2  = (divisor[63:61] == 3'b001)? 0  : 0;
	assign odd_leading_zero_or_val3  = (divisor[63:60] == 4'b0001)? 1  : 0;
	assign odd_leading_zero_or_val4  = (divisor[63:59] == 5'b00001)? 0  : 0;
	assign odd_leading_zero_or_val5  = (divisor[63:58] == 6'b000001)? 1  : 0;
	assign odd_leading_zero_or_val6  = (divisor[63:57] == 7'b0000001)? 0  : 0;
	assign odd_leading_zero_or_val7  = (divisor[63:56] == 8'b00000001)? 1  : 0;
	assign odd_leading_zero_or_val8  = (divisor[63:55] == 9'b000000001)? 0  : 0;
	assign odd_leading_zero_or_val9  = (divisor[63:54] == 10'b0000000001)? 1  : 0;
	assign odd_leading_zero_or_val10 = (divisor[63:53] == 11'b00000000001)? 0  : 0;
	assign odd_leading_zero_or_val11 = (divisor[63:52] == 12'b000000000001)? 1  : 0;
	assign odd_leading_zero_or_val12 = (divisor[63:51] == 13'b0000000000001)? 0  : 0;
	assign odd_leading_zero_or_val13 = (divisor[63:50] == 14'b00000000000001)? 1  : 0;
	assign odd_leading_zero_or_val14 = (divisor[63:49] == 15'b000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val15 = (divisor[63:48] == 16'b0000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val16 = (divisor[63:47] == 17'b00000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val17 = (divisor[63:46] == 18'b000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val18 = (divisor[63:45] == 19'b0000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val19 = (divisor[63:44] == 20'b00000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val20 = (divisor[63:43] == 21'b000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val21 = (divisor[63:42] == 22'b0000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val22 = (divisor[63:41] == 23'b00000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val23 = (divisor[63:40] == 24'b000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val24 = (divisor[63:39] == 25'b0000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val25 = (divisor[63:38] == 26'b00000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val26 = (divisor[63:37] == 27'b000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val27 = (divisor[63:36] == 28'b0000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val28 = (divisor[63:35] == 29'b00000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val29 = (divisor[63:34] == 30'b000000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val30 = (divisor[63:33] == 31'b0000000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val31 = (divisor[63:32] == 32'b00000000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val32 = (divisor[63:31] == 33'b000000000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val33 = (divisor[63:30] == 34'b0000000000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val34 = (divisor[63:29] == 35'b00000000000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val35 = (divisor[63:28] == 36'b000000000000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val36 = (divisor[63:27] == 37'b0000000000000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val37 = (divisor[63:26] == 38'b00000000000000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val38 = (divisor[63:25] == 39'b000000000000000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val39 = (divisor[63:24] == 40'b0000000000000000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val40 = (divisor[63:23] == 41'b00000000000000000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val41 = (divisor[63:22] == 42'b000000000000000000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val42 = (divisor[63:21] == 43'b0000000000000000000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val43 = (divisor[63:20] == 44'b00000000000000000000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val44 = (divisor[63:19] == 45'b000000000000000000000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val45 = (divisor[63:18] == 46'b0000000000000000000000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val46 = (divisor[63:17] == 47'b00000000000000000000000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val47 = (divisor[63:16] == 48'b000000000000000000000000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val48 = (divisor[63:15] == 49'b0000000000000000000000000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val49 = (divisor[63:14] == 50'b00000000000000000000000000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val50 = (divisor[63:13] == 51'b000000000000000000000000000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val51 = (divisor[63:12] == 52'b0000000000000000000000000000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val52 = (divisor[63:11] == 53'b00000000000000000000000000000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val53 = (divisor[63:10] == 54'b000000000000000000000000000000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val54 = (divisor[63:9] == 55'b0000000000000000000000000000000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val55 = (divisor[63:8] == 56'b00000000000000000000000000000000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val56 = (divisor[63:7] == 57'b000000000000000000000000000000000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val57 = (divisor[63:6] == 58'b0000000000000000000000000000000000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val58 = (divisor[63:5] == 59'b00000000000000000000000000000000000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val59 = (divisor[63:4] == 60'b000000000000000000000000000000000000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val60 = (divisor[63:3] == 61'b0000000000000000000000000000000000000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val61 = (divisor[63:2] == 62'b00000000000000000000000000000000000000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val62 = (divisor[63:1] == 63'b000000000000000000000000000000000000000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val63 = (divisor[63:0] == 64'b0000000000000000000000000000000000000000000000000000000000000001)? 1  : 0;

	always @(*) begin
		pre_shift_divisor = pre_shift_divisor_or_val0 | pre_shift_divisor_or_val1 | pre_shift_divisor_or_val2 | pre_shift_divisor_or_val3 | pre_shift_divisor_or_val4 | pre_shift_divisor_or_val5 | pre_shift_divisor_or_val6 | pre_shift_divisor_or_val7 | pre_shift_divisor_or_val8 | pre_shift_divisor_or_val9 | pre_shift_divisor_or_val10 | pre_shift_divisor_or_val11 | pre_shift_divisor_or_val12 | pre_shift_divisor_or_val13 | pre_shift_divisor_or_val14 | pre_shift_divisor_or_val15 | pre_shift_divisor_or_val16 | pre_shift_divisor_or_val17 | pre_shift_divisor_or_val18 | pre_shift_divisor_or_val19 | pre_shift_divisor_or_val20 | pre_shift_divisor_or_val21 | pre_shift_divisor_or_val22 | pre_shift_divisor_or_val23 | pre_shift_divisor_or_val24 | pre_shift_divisor_or_val25 | pre_shift_divisor_or_val26 | pre_shift_divisor_or_val27 | pre_shift_divisor_or_val28 | pre_shift_divisor_or_val29 | pre_shift_divisor_or_val30 | pre_shift_divisor_or_val31 | pre_shift_divisor_or_val32 | pre_shift_divisor_or_val33 | pre_shift_divisor_or_val34 | pre_shift_divisor_or_val35 | pre_shift_divisor_or_val36 | pre_shift_divisor_or_val37 | pre_shift_divisor_or_val38 | pre_shift_divisor_or_val39 | pre_shift_divisor_or_val40 | pre_shift_divisor_or_val41 | pre_shift_divisor_or_val42 | pre_shift_divisor_or_val43 | pre_shift_divisor_or_val44 | pre_shift_divisor_or_val45 | pre_shift_divisor_or_val46 | pre_shift_divisor_or_val47 | pre_shift_divisor_or_val48 | pre_shift_divisor_or_val49 | pre_shift_divisor_or_val50 | pre_shift_divisor_or_val51 | pre_shift_divisor_or_val52 | pre_shift_divisor_or_val53 | pre_shift_divisor_or_val54 | pre_shift_divisor_or_val55 | pre_shift_divisor_or_val56 | pre_shift_divisor_or_val57 | pre_shift_divisor_or_val58 | pre_shift_divisor_or_val59 | pre_shift_divisor_or_val60 | pre_shift_divisor_or_val61 | pre_shift_divisor_or_val62 | pre_shift_divisor_or_val63;
		iter_val =  iter_val_or_val0 | iter_val_or_val1 | iter_val_or_val2 | iter_val_or_val3 | iter_val_or_val4 | iter_val_or_val5 | iter_val_or_val6 | iter_val_or_val7 | iter_val_or_val8 | iter_val_or_val9 | iter_val_or_val10 | iter_val_or_val11 | iter_val_or_val12 | iter_val_or_val13 | iter_val_or_val14 | iter_val_or_val15 | iter_val_or_val16 | iter_val_or_val17 | iter_val_or_val18 | iter_val_or_val19 | iter_val_or_val20 | iter_val_or_val21 | iter_val_or_val22 | iter_val_or_val23 | iter_val_or_val24 | iter_val_or_val25 | iter_val_or_val26 | iter_val_or_val27 | iter_val_or_val28 | iter_val_or_val29 | iter_val_or_val30 | iter_val_or_val31 | iter_val_or_val32 | iter_val_or_val33 | iter_val_or_val34 | iter_val_or_val35 | iter_val_or_val36 | iter_val_or_val37 | iter_val_or_val38 | iter_val_or_val39 | iter_val_or_val40 | iter_val_or_val41 | iter_val_or_val42 | iter_val_or_val43 | iter_val_or_val44 | iter_val_or_val45 | iter_val_or_val46 | iter_val_or_val47 | iter_val_or_val48 | iter_val_or_val49 | iter_val_or_val50 | iter_val_or_val51 | iter_val_or_val52 | iter_val_or_val53 | iter_val_or_val54 | iter_val_or_val55 | iter_val_or_val56 | iter_val_or_val57 | iter_val_or_val58 | iter_val_or_val59 | iter_val_or_val60 | iter_val_or_val61 | iter_val_or_val62 | iter_val_or_val63;            
		odd_leading_zero =  odd_leading_zero_or_val0 | odd_leading_zero_or_val1 | odd_leading_zero_or_val2 | odd_leading_zero_or_val3 | odd_leading_zero_or_val4 | odd_leading_zero_or_val5 | odd_leading_zero_or_val6 | odd_leading_zero_or_val7 | odd_leading_zero_or_val8 | odd_leading_zero_or_val9 | odd_leading_zero_or_val10 | odd_leading_zero_or_val11 | odd_leading_zero_or_val12 | odd_leading_zero_or_val13 | odd_leading_zero_or_val14 | odd_leading_zero_or_val15 | odd_leading_zero_or_val16 | odd_leading_zero_or_val17 | odd_leading_zero_or_val18 | odd_leading_zero_or_val19 | odd_leading_zero_or_val20 | odd_leading_zero_or_val21 | odd_leading_zero_or_val22 | odd_leading_zero_or_val23 | odd_leading_zero_or_val24 | odd_leading_zero_or_val25 | odd_leading_zero_or_val26 | odd_leading_zero_or_val27 | odd_leading_zero_or_val28 | odd_leading_zero_or_val29 | odd_leading_zero_or_val30 | odd_leading_zero_or_val31 | odd_leading_zero_or_val32 | odd_leading_zero_or_val33 | odd_leading_zero_or_val34 | odd_leading_zero_or_val35 | odd_leading_zero_or_val36 | odd_leading_zero_or_val37 | odd_leading_zero_or_val38 | odd_leading_zero_or_val39 | odd_leading_zero_or_val40 | odd_leading_zero_or_val41 | odd_leading_zero_or_val42 | odd_leading_zero_or_val43 | odd_leading_zero_or_val44 | odd_leading_zero_or_val45 | odd_leading_zero_or_val46 | odd_leading_zero_or_val47 | odd_leading_zero_or_val48 | odd_leading_zero_or_val49 | odd_leading_zero_or_val50 | odd_leading_zero_or_val51 | odd_leading_zero_or_val52 | odd_leading_zero_or_val53 | odd_leading_zero_or_val54 | odd_leading_zero_or_val55 | odd_leading_zero_or_val56 | odd_leading_zero_or_val57 | odd_leading_zero_or_val58 | odd_leading_zero_or_val59 | odd_leading_zero_or_val60 | odd_leading_zero_or_val61 | odd_leading_zero_or_val62 | odd_leading_zero_or_val63;            
	end

endmodule
