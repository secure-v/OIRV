`include "params.v"

module srt4_32 (
	input                clk     ,
	input                rstn    ,
	input                hold    ,
	input [31:0]         dividend,
	input [31:0]         divisor ,
	input                start   , //           _____
	output reg           valid   , // _________|valid|________________
	output reg [31:0]    q       ,
	output reg [31:0]    rem     
);
	// --------------- pre_shift_divisor --------------- //
	wire                odd_leading_zero  ;
	wire [34:0]         pre_shift_divisor ;
    wire [4:0]          iter_val          ;

	reg                 lockup_odd_leading_zero ;
	reg  [34:0]         lockup_pre_shift_divisor;
	reg [34:0]          lockup_shifted_divisor  ;

	// --------------- pre_shift_dividend -------------- //
	wire [34:0]     pre_shift_dividend;
    wire [4:0]      iter_dec          ;    

	wire [4:0]      pre_shift_iter_val    ;
	reg [4:0]       pre_shift_iter_val_reg;
	wire            dont_need_iter        ;
	reg             dont_need_iter_reg    ;
	reg [31:0]      lockup_dividend       ;

	assign          pre_shift_iter_val = iter_val - iter_dec;
	assign          dont_need_iter = (iter_dec != `ZERO) && (pre_shift_iter_val[4]); // do not iteration

	// ------------- on_the_fly_conversion ------------- //
	// wire [2:0]          q                 ; // from qds
	reg [34:0]          current_qa        ;
	reg [34:0]          current_qb        ;

	// ---------------- carry save adder --------------- //
    reg                 cin               ;
    reg  [34:0]         A                 /*verilator public*/;
    reg  [34:0]         B                 /*verilator public*/;
    reg  [34:0]         C                 /*verilator public*/;
    wire  [34:0]        sum               ;
    wire  [34:0]        carry             ;

	wire [34:0]         carry_shift       ;
	wire [34:0]         sum_shift         ;

	assign carry_shift = carry << 2       ;
	assign sum_shift = sum << 2           ;
	// ---------------------- qds ---------------------- //
	wire [6:0]          partial_sum       /*verilator public*/;
	reg [2:0]           d                 /*verilator public*/;
	wire [2:0]          q_part            /*verilator public*/;

	wire [7:0]          partial_sum_tmp   ;

	assign partial_sum_tmp = A[34:27] + B[34:27];
	assign partial_sum = partial_sum_tmp[7:1]                     ;

	// -------------------- post_processing ------------ //
	wire [4:0]          iter_val_pstproc ;
	wire [34:0]         last_iter_sum    ;
	wire [34:0]         last_iter_carry  ;
	wire [34:0]         last_iter_q      ;
    wire [31:0]         q_tmp            ;
	wire [31:0]         rem_tmp          ;


	assign iter_val_pstproc = (state == PSTP_STATE)? iter_val_reg : `ZERO;
	assign last_iter_sum = A                                             ;
	assign last_iter_carry = B                                           ;
	assign last_iter_q = (state == PSTP_STATE)? current_qa : `ZERO       ;

	// assign q_nocomp_shifted = q_nocomp    >>> {iter_val, 1'b0};  
	// assign q_comp_shifted   = q_comp      >>> {iter_val, 1'b0};  

	reg [4:0]           iter_val_reg      ;
	reg [4:0]           iter_cur_reg      /*verilator public*/; // decreaing in every iteration
	reg [34:0]          q_mul_divisor     ;

	always@(*) begin
		if ((lockup_odd_leading_zero) && (state == ITER_STATE) && (iter_cur_reg == `ZERO)) begin // b: odd leading zero, adjust
			case (q_part)
			3'b000 : begin q_mul_divisor = `ZERO                           ; cin = 0; end
			3'b001 : begin q_mul_divisor = `ZERO                           ; cin = 0; end
			3'b010 : begin q_mul_divisor = ~(lockup_pre_shift_divisor << 1); cin = 1; end
			3'b101 : begin q_mul_divisor = (lockup_pre_shift_divisor)  << 1; cin = 0; end
			3'b110 : begin q_mul_divisor = (lockup_pre_shift_divisor)  << 1; cin = 0; end
			default: begin q_mul_divisor = `ZERO                           ; cin = 0; end
		endcase
		end
		else begin
		case (q_part)
			3'b000 : begin q_mul_divisor = `ZERO                           ; cin = 0; end
			3'b001 : begin q_mul_divisor = ~lockup_pre_shift_divisor       ; cin = 1; end
			3'b010 : begin q_mul_divisor = ~(lockup_pre_shift_divisor << 1); cin = 1; end
			3'b101 : begin q_mul_divisor = lockup_pre_shift_divisor        ; cin = 0; end
			3'b110 : begin q_mul_divisor = (lockup_pre_shift_divisor)  << 1; cin = 0; end
			default: begin q_mul_divisor = `ZERO                           ; cin = 0; end
		endcase
		end
	end

	always@(posedge clk) begin
		if (rstn == `RESET_EN)
			A <= `ZERO;
		else if ((iter_cur_reg == `ZERO) && (state == ITER_STATE))
			A <= sum               ;
		else if (state == ITER_STATE)
			A <= sum_shift         ;
		else if (state == PREP_STATE)
			A <= A                 ;
		else if (state == PSTP_STATE)
			A <= A                 ;
		else 
			A <= pre_shift_dividend;
	end

	always@(posedge clk) begin
		if (rstn == `RESET_EN)
			B <= `ZERO             ;
		else if ((iter_cur_reg == `ZERO) && (state == ITER_STATE))
			B <= carry             ;
		else if (state == PREP_STATE)
			B <= `ZERO             ;
		else if (state == ITER_STATE)
			B <= carry_shift       ;
		else 
			B <= B                 ;
	end

	always@(*) begin
		if (rstn == `RESET_EN)
			C = `ZERO             ;
		else if (state == PREP_STATE)
			C = q_mul_divisor     ;
		else if (state == ITER_STATE)
			C = q_mul_divisor     ;
		else 
			C = `ZERO             ;
	end


	parameter DIV_VALID = 1'b1;

	always@(posedge clk) begin
		if (rstn == `RESET_EN)
			valid <= !DIV_VALID     ;
		else if (state == PSTP_STATE)
			valid <= DIV_VALID      ;
		else if (hold == `HOLD)
			valid <= valid          ;
		else
			valid <= !DIV_VALID     ;
	end

	parameter IDLE_STATE = 3'd0; 
	parameter PREP_STATE = 3'd1; // Preprocessing stage
	parameter ITER_STATE = 3'd2; 
	parameter PSTP_STATE = 3'd3; // Postprocessing stage

	reg[2:0] state/*verilator public*/;

	always@(posedge clk) begin
		if (rstn == `RESET_EN)
			state <= IDLE_STATE;
		else if ((start == `DIV_START) && (state == IDLE_STATE))
			state <= PREP_STATE;
		else if (state == PREP_STATE) begin
			if (dont_need_iter_reg)
				state <= PSTP_STATE;
			else
				state <= ITER_STATE;
		end
		else if ((state == ITER_STATE) && (iter_cur_reg == `ZERO))
			state <= PSTP_STATE;
		else if (state == PSTP_STATE)
			state <= IDLE_STATE;
		else 
			state <= state;
	end

	always@(posedge clk) begin
		if (rstn == `RESET_EN)
			iter_val_reg <= `ZERO;
		else if (state == IDLE_STATE)
			iter_val_reg <= iter_val;
		else
			iter_val_reg <= iter_val_reg;
	end
	
	always@(posedge clk) begin
		if (rstn == `RESET_EN)
			pre_shift_iter_val_reg <= `ZERO;
		else if (state == IDLE_STATE)
			pre_shift_iter_val_reg <= pre_shift_iter_val;
		else
			pre_shift_iter_val_reg <= pre_shift_iter_val_reg;
	end

	always@(posedge clk) begin
		if (rstn == `RESET_EN)
			dont_need_iter_reg <= `ZERO;
		else if (state == IDLE_STATE)
			dont_need_iter_reg <= dont_need_iter;
		else
			dont_need_iter_reg <= dont_need_iter_reg;
	end

	always@(posedge clk) begin
		if (rstn == `RESET_EN)
			lockup_pre_shift_divisor <= `ZERO                    ;
		else if (state == IDLE_STATE)
			lockup_pre_shift_divisor <= pre_shift_divisor        ;
		else
			lockup_pre_shift_divisor <= lockup_pre_shift_divisor ;
	end

	always@(posedge clk) begin
		if (rstn == `RESET_EN)
			lockup_shifted_divisor <= `ZERO                              ;
		else if (state == IDLE_STATE)
			lockup_shifted_divisor <= (odd_leading_zero)? (pre_shift_divisor << 1) : pre_shift_divisor;
		else
			lockup_shifted_divisor <= lockup_shifted_divisor             ;
	end

	always@(posedge clk) begin
		if (rstn == `RESET_EN)
			lockup_dividend <= `ZERO                             ;
		else if (state == IDLE_STATE)
			lockup_dividend <= dividend                          ;
		else
			lockup_dividend <= lockup_dividend                   ;
	end

	always@(posedge clk) begin
		if (rstn == `RESET_EN)
			lockup_odd_leading_zero <= `ZERO                     ;
		else if (state == IDLE_STATE)
			lockup_odd_leading_zero <= odd_leading_zero          ;
		else
			lockup_odd_leading_zero <= lockup_odd_leading_zero   ;
	end

	always@(posedge clk) begin
		if (rstn == `RESET_EN)
			iter_cur_reg <= `ZERO;
		else if (state == IDLE_STATE)
			iter_cur_reg <= `ZERO;
		else if (state == PREP_STATE)
			iter_cur_reg <= pre_shift_iter_val_reg;
		else if ((iter_cur_reg != `ZERO) && (state == ITER_STATE))
			iter_cur_reg <= iter_cur_reg - 1      ;
		else
			iter_cur_reg <= iter_cur_reg          ;
	end

	always@(posedge clk) begin
		if (rstn == `RESET_EN)
			d <= `ZERO                          ;    
		else if (state == PREP_STATE)
			d <= lockup_pre_shift_divisor[30:28];
		else
			d <= d                              ;
	end

	always@(posedge clk) begin
		if (rstn == `RESET_EN) begin
			q   <= `ZERO  ;
			rem <= `ZERO  ;
		end
		else if (state == PSTP_STATE) begin
			if (dont_need_iter_reg) begin
				q   <= `ZERO          ;
				rem <= lockup_dividend;
			end
			else begin
				q   <= q_tmp  ;
				rem <= rem_tmp;
			end
		end
		else begin
			q   <= q      ;
			rem <= rem    ;
		end
	end   

// ----------------------- on the fly conversion ----------------------- //
	always@(posedge clk) begin
		if (rstn == `RESET_EN) begin
			current_qa <= `ZERO;
			current_qb <= `ZERO;
		end
		else if (state == ITER_STATE) begin
			case (q_part)
				3'b000: begin // 0
					current_qa <= {current_qa[32:0], 2'b00};
					current_qb <= {current_qb[32:0], 2'b11};
					end
				3'b001: begin // 1
					current_qa <= {current_qa[32:0], 2'b01};
					current_qb <= {current_qa[32:0], 2'b00};
					end
				3'b010: begin // 2
					current_qa <= {current_qa[32:0], 2'b10};
					current_qb <= {current_qa[32:0], 2'b01};
					end
				3'b101: begin // -1
					current_qa <= {current_qb[32:0], 2'b11};
					current_qb <= {current_qb[32:0], 2'b10};
					end
				3'b110: begin // -2
					current_qa <= {current_qb[32:0], 2'b10};
					current_qb <= {current_qb[32:0], 2'b01};
					end 
				default: begin
					current_qa <= {current_qa[32:0], 2'b00};
					current_qb <= {current_qb[32:0], 2'b00};
				end 
			endcase
		end
		else if (state == PREP_STATE) begin
			current_qa <= `ZERO;
			current_qb <= `ZERO;
		end
		else begin
			current_qa <= current_qa;
			current_qb <= current_qb;
		end
	end

pre_shift_divisor32 pre_shift_divisor32_inst0 (
	.divisor                 (divisor                 ),
	.odd_leading_zero        (odd_leading_zero        ),
	.pre_shift_divisor       (pre_shift_divisor       ),
    .iter_val                (iter_val                )  
);

pre_shift_dividend32 pre_shift_dividend32_inst0 (
	.dividend          (dividend          ),
	.pre_shift_dividend(pre_shift_dividend),
    .iter_dec          (iter_dec          )     
);

post_processing32 post_processing32_inst0 (
	.odd_leading_zero (lockup_odd_leading_zero ),
	.iter_val         (iter_val_pstproc        ),
	.last_iter_sum    (last_iter_sum           ),
	.last_iter_carry  (last_iter_carry         ),
	.last_iter_q      (last_iter_q             ),
	.shifted_b        (lockup_shifted_divisor  ),
	// .q_nocomp         (q_nocomp                ),
	// .q_comp           (q_comp                  ),
	// .rem_nocomp       (rem_nocomp              ),
	// .rem_comp         (rem_comp                ),
	// .need_adjust      (need_adjust             ),
    .q                (q_tmp                   ),
	.rem              (rem_tmp                 )   
);

CSA3_2 #(35) CSA3_2_inst0
(
    .cin  (cin    ),
    .A    (A      ),
    .B    (B      ),
    .C    (C      ),
    .sum  (sum    ),
    .carry(carry  )
);

srt4_qds_table srt4_qds_table_inst0 (
	.partial_sum(partial_sum),
	.d          (d          ),
	.q          (q_part     )
);

endmodule
