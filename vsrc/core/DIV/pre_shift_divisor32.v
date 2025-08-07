module pre_shift_divisor32 (
	input [31:0]         divisor          ,
	output reg           odd_leading_zero ,
	output reg[34:0]     pre_shift_divisor,
    output reg[4:0]      iter_val         //00...0001: iteration number == 2; //00...0010: iteration number == 3     
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

	wire[34:0]pre_shift_divisor_or_val0 ;
	wire[34:0]pre_shift_divisor_or_val1 ;
	wire[34:0]pre_shift_divisor_or_val2 ;
	wire[34:0]pre_shift_divisor_or_val3 ;
	wire[34:0]pre_shift_divisor_or_val4 ;
	wire[34:0]pre_shift_divisor_or_val5 ;
	wire[34:0]pre_shift_divisor_or_val6 ;
	wire[34:0]pre_shift_divisor_or_val7 ;
	wire[34:0]pre_shift_divisor_or_val8 ;
	wire[34:0]pre_shift_divisor_or_val9 ;
	wire[34:0]pre_shift_divisor_or_val10;
	wire[34:0]pre_shift_divisor_or_val11;
	wire[34:0]pre_shift_divisor_or_val12;
	wire[34:0]pre_shift_divisor_or_val13;
	wire[34:0]pre_shift_divisor_or_val14;
	wire[34:0]pre_shift_divisor_or_val15;
	wire[34:0]pre_shift_divisor_or_val16;
	wire[34:0]pre_shift_divisor_or_val17;
	wire[34:0]pre_shift_divisor_or_val18;
	wire[34:0]pre_shift_divisor_or_val19;
	wire[34:0]pre_shift_divisor_or_val20;
	wire[34:0]pre_shift_divisor_or_val21;
	wire[34:0]pre_shift_divisor_or_val22;
	wire[34:0]pre_shift_divisor_or_val23;
	wire[34:0]pre_shift_divisor_or_val24;
	wire[34:0]pre_shift_divisor_or_val25;
	wire[34:0]pre_shift_divisor_or_val26;
	wire[34:0]pre_shift_divisor_or_val27;
	wire[34:0]pre_shift_divisor_or_val28;
	wire[34:0]pre_shift_divisor_or_val29;
	wire[34:0]pre_shift_divisor_or_val30;
	wire[34:0]pre_shift_divisor_or_val31;

	assign pre_shift_divisor_or_val0  = (divisor[31:31] == 1'b1)? {3'd0  , divisor[31:0]} : 0;
	assign pre_shift_divisor_or_val1  = (divisor[31:30] == 2'b01)? {3'd0  , divisor[30:0], 1'd0} : 0;
	assign pre_shift_divisor_or_val2  = (divisor[31:29] == 3'b001)? {3'd0  , divisor[29:0], 2'd0} : 0;
	assign pre_shift_divisor_or_val3  = (divisor[31:28] == 4'b0001)? {3'd0  , divisor[28:0], 3'd0} : 0;
	assign pre_shift_divisor_or_val4  = (divisor[31:27] == 5'b00001)? {3'd0  , divisor[27:0], 4'd0} : 0;
	assign pre_shift_divisor_or_val5  = (divisor[31:26] == 6'b000001)? {3'd0  , divisor[26:0], 5'd0} : 0;
	assign pre_shift_divisor_or_val6  = (divisor[31:25] == 7'b0000001)? {3'd0  , divisor[25:0], 6'd0} : 0;
	assign pre_shift_divisor_or_val7  = (divisor[31:24] == 8'b00000001)? {3'd0  , divisor[24:0], 7'd0} : 0;
	assign pre_shift_divisor_or_val8  = (divisor[31:23] == 9'b000000001)? {3'd0  , divisor[23:0], 8'd0} : 0;
	assign pre_shift_divisor_or_val9  = (divisor[31:22] == 10'b0000000001)? {3'd0  , divisor[22:0], 9'd0} : 0;
	assign pre_shift_divisor_or_val10 = (divisor[31:21] == 11'b00000000001)? {3'd0  , divisor[21:0], 10'd0} : 0;
	assign pre_shift_divisor_or_val11 = (divisor[31:20] == 12'b000000000001)? {3'd0  , divisor[20:0], 11'd0} : 0;
	assign pre_shift_divisor_or_val12 = (divisor[31:19] == 13'b0000000000001)? {3'd0  , divisor[19:0], 12'd0} : 0;
	assign pre_shift_divisor_or_val13 = (divisor[31:18] == 14'b00000000000001)? {3'd0  , divisor[18:0], 13'd0} : 0;
	assign pre_shift_divisor_or_val14 = (divisor[31:17] == 15'b000000000000001)? {3'd0  , divisor[17:0], 14'd0} : 0;
	assign pre_shift_divisor_or_val15 = (divisor[31:16] == 16'b0000000000000001)? {3'd0  , divisor[16:0], 15'd0} : 0;
	assign pre_shift_divisor_or_val16 = (divisor[31:15] == 17'b00000000000000001)? {3'd0  , divisor[15:0], 16'd0} : 0;
	assign pre_shift_divisor_or_val17 = (divisor[31:14] == 18'b000000000000000001)? {3'd0  , divisor[14:0], 17'd0} : 0;
	assign pre_shift_divisor_or_val18 = (divisor[31:13] == 19'b0000000000000000001)? {3'd0  , divisor[13:0], 18'd0} : 0;
	assign pre_shift_divisor_or_val19 = (divisor[31:12] == 20'b00000000000000000001)? {3'd0  , divisor[12:0], 19'd0} : 0;
	assign pre_shift_divisor_or_val20 = (divisor[31:11] == 21'b000000000000000000001)? {3'd0  , divisor[11:0], 20'd0} : 0;
	assign pre_shift_divisor_or_val21 = (divisor[31:10] == 22'b0000000000000000000001)? {3'd0  , divisor[10:0], 21'd0} : 0;
	assign pre_shift_divisor_or_val22 = (divisor[31:9 ] == 23'b00000000000000000000001)? {3'd0  , divisor[ 9:0], 22'd0} : 0;
	assign pre_shift_divisor_or_val23 = (divisor[31:8 ] == 24'b000000000000000000000001)? {3'd0  , divisor[ 8:0], 23'd0} : 0;
	assign pre_shift_divisor_or_val24 = (divisor[31:7 ] == 25'b0000000000000000000000001)? {3'd0  , divisor[ 7:0], 24'd0} : 0;
	assign pre_shift_divisor_or_val25 = (divisor[31:6 ] == 26'b00000000000000000000000001)? {3'd0  , divisor[ 6:0], 25'd0} : 0;
	assign pre_shift_divisor_or_val26 = (divisor[31:5 ] == 27'b000000000000000000000000001)? {3'd0  , divisor[ 5:0], 26'd0} : 0;
	assign pre_shift_divisor_or_val27 = (divisor[31:4 ] == 28'b0000000000000000000000000001)? {3'd0  , divisor[ 4:0], 27'd0} : 0;
	assign pre_shift_divisor_or_val28 = (divisor[31:3 ] == 29'b00000000000000000000000000001)? {3'd0  , divisor[ 3:0], 28'd0} : 0;
	assign pre_shift_divisor_or_val29 = (divisor[31:2 ] == 30'b000000000000000000000000000001)? {3'd0  , divisor[ 2:0], 29'd0} : 0;
	assign pre_shift_divisor_or_val30 = (divisor[31:1 ] == 31'b0000000000000000000000000000001)? {3'd0  , divisor[ 1:0], 30'd0} : 0;
	assign pre_shift_divisor_or_val31 = (divisor[31:0 ] == 32'b00000000000000000000000000000001)? {3'd0  , divisor[   0], 31'd0} : 0;

	wire[4:0] iter_val_or_val0 ;
	wire[4:0] iter_val_or_val1 ;
	wire[4:0] iter_val_or_val2 ;
	wire[4:0] iter_val_or_val3 ;
	wire[4:0] iter_val_or_val4 ;
	wire[4:0] iter_val_or_val5 ;
	wire[4:0] iter_val_or_val6 ;
	wire[4:0] iter_val_or_val7 ;
	wire[4:0] iter_val_or_val8 ;
	wire[4:0] iter_val_or_val9 ;
	wire[4:0] iter_val_or_val10;
	wire[4:0] iter_val_or_val11;
	wire[4:0] iter_val_or_val12;
	wire[4:0] iter_val_or_val13;
	wire[4:0] iter_val_or_val14;
	wire[4:0] iter_val_or_val15;
	wire[4:0] iter_val_or_val16;
	wire[4:0] iter_val_or_val17;
	wire[4:0] iter_val_or_val18;
	wire[4:0] iter_val_or_val19;
	wire[4:0] iter_val_or_val20;
	wire[4:0] iter_val_or_val21;
	wire[4:0] iter_val_or_val22;
	wire[4:0] iter_val_or_val23;
	wire[4:0] iter_val_or_val24;
	wire[4:0] iter_val_or_val25;
	wire[4:0] iter_val_or_val26;
	wire[4:0] iter_val_or_val27;
	wire[4:0] iter_val_or_val28;
	wire[4:0] iter_val_or_val29;
	wire[4:0] iter_val_or_val30;
	wire[4:0] iter_val_or_val31;

	assign iter_val_or_val0  = (divisor[31:31] == 1'b1)? 0  : 0;
	assign iter_val_or_val1  = (divisor[31:30] == 2'b01)? 1  : 0;
	assign iter_val_or_val2  = (divisor[31:29] == 3'b001)? 1  : 0;
	assign iter_val_or_val3  = (divisor[31:28] == 4'b0001)? 2  : 0;
	assign iter_val_or_val4  = (divisor[31:27] == 5'b00001)? 2  : 0;
	assign iter_val_or_val5  = (divisor[31:26] == 6'b000001)? 3  : 0;
	assign iter_val_or_val6  = (divisor[31:25] == 7'b0000001)? 3  : 0;
	assign iter_val_or_val7  = (divisor[31:24] == 8'b00000001)? 4  : 0;
	assign iter_val_or_val8  = (divisor[31:23] == 9'b000000001)? 4  : 0;
	assign iter_val_or_val9  = (divisor[31:22] == 10'b0000000001)? 5  : 0;
	assign iter_val_or_val10 = (divisor[31:21] == 11'b00000000001)? 5  : 0;
	assign iter_val_or_val11 = (divisor[31:20] == 12'b000000000001)? 6  : 0;
	assign iter_val_or_val12 = (divisor[31:19] == 13'b0000000000001)? 6  : 0;
	assign iter_val_or_val13 = (divisor[31:18] == 14'b00000000000001)? 7  : 0;
	assign iter_val_or_val14 = (divisor[31:17] == 15'b000000000000001)? 7  : 0;
	assign iter_val_or_val15 = (divisor[31:16] == 16'b0000000000000001)? 8  : 0;
	assign iter_val_or_val16 = (divisor[31:15] == 17'b00000000000000001)? 8  : 0;
	assign iter_val_or_val17 = (divisor[31:14] == 18'b000000000000000001)? 9  : 0;
	assign iter_val_or_val18 = (divisor[31:13] == 19'b0000000000000000001)? 9  : 0;
	assign iter_val_or_val19 = (divisor[31:12] == 20'b00000000000000000001)? 10 : 0;
	assign iter_val_or_val20 = (divisor[31:11] == 21'b000000000000000000001)? 10 : 0;
	assign iter_val_or_val21 = (divisor[31:10] == 22'b0000000000000000000001)? 11 : 0;
	assign iter_val_or_val22 = (divisor[31:9 ] == 23'b00000000000000000000001)? 11 : 0;
	assign iter_val_or_val23 = (divisor[31:8 ] == 24'b000000000000000000000001)? 12 : 0;
	assign iter_val_or_val24 = (divisor[31:7 ] == 25'b0000000000000000000000001)? 12 : 0;
	assign iter_val_or_val25 = (divisor[31:6 ] == 26'b00000000000000000000000001)? 13 : 0;
	assign iter_val_or_val26 = (divisor[31:5 ] == 27'b000000000000000000000000001)? 13 : 0;
	assign iter_val_or_val27 = (divisor[31:4 ] == 28'b0000000000000000000000000001)? 14 : 0;
	assign iter_val_or_val28 = (divisor[31:3 ] == 29'b00000000000000000000000000001)? 14 : 0;
	assign iter_val_or_val29 = (divisor[31:2 ] == 30'b000000000000000000000000000001)? 15 : 0;
	assign iter_val_or_val30 = (divisor[31:1 ] == 31'b0000000000000000000000000000001)? 15 : 0;
	assign iter_val_or_val31 = (divisor[31:0 ] == 32'b00000000000000000000000000000001)? 16 : 0;

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


	assign odd_leading_zero_or_val0  = (divisor[31:31] == 1'b1)? 0  : 0;
	assign odd_leading_zero_or_val1  = (divisor[31:30] == 2'b01)? 1  : 0;
	assign odd_leading_zero_or_val2  = (divisor[31:29] == 3'b001)? 0  : 0;
	assign odd_leading_zero_or_val3  = (divisor[31:28] == 4'b0001)? 1  : 0;
	assign odd_leading_zero_or_val4  = (divisor[31:27] == 5'b00001)? 0  : 0;
	assign odd_leading_zero_or_val5  = (divisor[31:26] == 6'b000001)? 1  : 0;
	assign odd_leading_zero_or_val6  = (divisor[31:25] == 7'b0000001)? 0  : 0;
	assign odd_leading_zero_or_val7  = (divisor[31:24] == 8'b00000001)? 1  : 0;
	assign odd_leading_zero_or_val8  = (divisor[31:23] == 9'b000000001)? 0  : 0;
	assign odd_leading_zero_or_val9  = (divisor[31:22] == 10'b0000000001)? 1  : 0;
	assign odd_leading_zero_or_val10 = (divisor[31:21] == 11'b00000000001)? 0  : 0;
	assign odd_leading_zero_or_val11 = (divisor[31:20] == 12'b000000000001)? 1  : 0;
	assign odd_leading_zero_or_val12 = (divisor[31:19] == 13'b0000000000001)? 0  : 0;
	assign odd_leading_zero_or_val13 = (divisor[31:18] == 14'b00000000000001)? 1  : 0;
	assign odd_leading_zero_or_val14 = (divisor[31:17] == 15'b000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val15 = (divisor[31:16] == 16'b0000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val16 = (divisor[31:15] == 17'b00000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val17 = (divisor[31:14] == 18'b000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val18 = (divisor[31:13] == 19'b0000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val19 = (divisor[31:12] == 20'b00000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val20 = (divisor[31:11] == 21'b000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val21 = (divisor[31:10] == 22'b0000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val22 = (divisor[31:9 ] == 23'b00000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val23 = (divisor[31:8 ] == 24'b000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val24 = (divisor[31:7 ] == 25'b0000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val25 = (divisor[31:6 ] == 26'b00000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val26 = (divisor[31:5 ] == 27'b000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val27 = (divisor[31:4 ] == 28'b0000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val28 = (divisor[31:3 ] == 29'b00000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val29 = (divisor[31:2 ] == 30'b000000000000000000000000000001)? 1  : 0;
	assign odd_leading_zero_or_val30 = (divisor[31:1 ] == 31'b0000000000000000000000000000001)? 0  : 0;
	assign odd_leading_zero_or_val31 = (divisor[31:0 ] == 32'b00000000000000000000000000000001)? 1  : 0;

	always @(*) begin
		pre_shift_divisor = pre_shift_divisor_or_val0 | pre_shift_divisor_or_val1 | pre_shift_divisor_or_val2 | pre_shift_divisor_or_val3 | pre_shift_divisor_or_val4 | pre_shift_divisor_or_val5 | pre_shift_divisor_or_val6 | pre_shift_divisor_or_val7 | pre_shift_divisor_or_val8 | pre_shift_divisor_or_val9 | pre_shift_divisor_or_val10 | pre_shift_divisor_or_val11 | pre_shift_divisor_or_val12 | pre_shift_divisor_or_val13 | pre_shift_divisor_or_val14 | pre_shift_divisor_or_val15 | pre_shift_divisor_or_val16 | pre_shift_divisor_or_val17 | pre_shift_divisor_or_val18 | pre_shift_divisor_or_val19 | pre_shift_divisor_or_val20 | pre_shift_divisor_or_val21 | pre_shift_divisor_or_val22 | pre_shift_divisor_or_val23 | pre_shift_divisor_or_val24 | pre_shift_divisor_or_val25 | pre_shift_divisor_or_val26 | pre_shift_divisor_or_val27 | pre_shift_divisor_or_val28 | pre_shift_divisor_or_val29 | pre_shift_divisor_or_val30 | pre_shift_divisor_or_val31 ;
		iter_val =  iter_val_or_val0 | iter_val_or_val1 | iter_val_or_val2 | iter_val_or_val3 | iter_val_or_val4 | iter_val_or_val5 | iter_val_or_val6 | iter_val_or_val7 | iter_val_or_val8 | iter_val_or_val9 | iter_val_or_val10 | iter_val_or_val11 | iter_val_or_val12 | iter_val_or_val13 | iter_val_or_val14 | iter_val_or_val15 | iter_val_or_val16 | iter_val_or_val17 | iter_val_or_val18 | iter_val_or_val19 | iter_val_or_val20 | iter_val_or_val21 | iter_val_or_val22 | iter_val_or_val23 | iter_val_or_val24 | iter_val_or_val25 | iter_val_or_val26 | iter_val_or_val27 | iter_val_or_val28 | iter_val_or_val29 | iter_val_or_val30 | iter_val_or_val31 ;            
		odd_leading_zero =  odd_leading_zero_or_val0 | odd_leading_zero_or_val1 | odd_leading_zero_or_val2 | odd_leading_zero_or_val3 | odd_leading_zero_or_val4 | odd_leading_zero_or_val5 | odd_leading_zero_or_val6 | odd_leading_zero_or_val7 | odd_leading_zero_or_val8 | odd_leading_zero_or_val9 | odd_leading_zero_or_val10 | odd_leading_zero_or_val11 | odd_leading_zero_or_val12 | odd_leading_zero_or_val13 | odd_leading_zero_or_val14 | odd_leading_zero_or_val15 | odd_leading_zero_or_val16 | odd_leading_zero_or_val17 | odd_leading_zero_or_val18 | odd_leading_zero_or_val19 | odd_leading_zero_or_val20 | odd_leading_zero_or_val21 | odd_leading_zero_or_val22 | odd_leading_zero_or_val23 | odd_leading_zero_or_val24 | odd_leading_zero_or_val25 | odd_leading_zero_or_val26 | odd_leading_zero_or_val27 | odd_leading_zero_or_val28 | odd_leading_zero_or_val29 | odd_leading_zero_or_val30 | odd_leading_zero_or_val31 ;            
	end

endmodule
