module post_processing32 (
	input                odd_leading_zero ,
	input [4:0]          iter_val         ,
	input [34:0]         last_iter_sum    ,
	input [34:0]         last_iter_carry  ,
	input [34:0]         last_iter_q      ,
	input [34:0]         shifted_b        ,
	// output [31:0]	     q_nocomp         , // need shift
	// output [31:0]	     q_comp           , // need shift
	// output [31:0]	     rem_nocomp       ,
	// output [31:0]	     rem_comp         ,
	// output               need_adjust      ,
    output [31:0]        q                ,
	output [31:0]        rem                 
);

	wire signed[34:0]    rem_unshift                    ;
	wire signed[34:0]    rem_unshift_comp               ;
	wire [34:0]          rem_unjustified                ;
	wire [34:0]          rem_unjustified_comp           ;
	// wire [34:0]          rem_unjustified_comp_op0       ;
	// wire [34:0]          rem_unjustified_comp_op1       ;
	wire [34:0]          rem_justified                  ;
	wire [5:0]           shift_val                      ;
	wire [34:0]          q_tmp                          ;
	wire [31:0]          q_unjustified                  ;

	assign rem_unshift = last_iter_sum + last_iter_carry;
	// assign rem_unshift_comp = rem_unjustified_comp_op0 + rem_unjustified_comp_op1;
	assign rem_unshift_comp = last_iter_sum + last_iter_carry + shifted_b;
	assign shift_val   = {iter_val, 1'b0}               ;
	assign rem_unjustified = rem_unshift >>> shift_val  ;
	assign rem_unjustified_comp = rem_unshift_comp >>> shift_val  ;
	assign rem_justified = (rem_unshift[34])? rem_unjustified_comp : rem_unjustified    ;
	assign rem = rem_justified[31:0]                                                    ;

	assign q_tmp = (odd_leading_zero)? (last_iter_q >> 1) : last_iter_q                 ;
	assign q_unjustified = q_tmp[31:0]                                                  ;
	assign q = (rem_unshift[34])? (q_unjustified - 1) : q_unjustified                   ;

	// assign q_nocomp   = rem_unshift[31:0];
	// assign q_comp     = rem_unshift_comp[31:0];
	// assign rem_nocomp = q_unjustified;
	// assign rem_comp   = q_unjustified - 1;
	// assign need_adjust = rem_unshift[34];

	// CSA3_2 #(67) CSA3_2_inst0
	// (
	//     .cin  (0                       ),
	//     .A    (last_iter_sum           ),
	//     .B    (last_iter_carry         ),
	//     .C    (shifted_b               ),
	//     .sum  (rem_unjustified_comp_op0),
	//     .carry(rem_unjustified_comp_op1)
	// );

endmodule
