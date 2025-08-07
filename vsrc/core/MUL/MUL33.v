module MUL33 (
    input [32:0]   A            ,
    input [32:0]   B            ,
    output [63:0]  part_mul_res0,
    output [63:0]  part_mul_res1
);

// wire signed [32:0] a_sgn = A;
// wire signed [32:0] b_sgn = B;
// wire signed [65:0] real_res = a_sgn * b_sgn;

// wire judge = (add0_val == real_res);
// wire [65:0] add0_val = {33'b0, pp0_64_0_32} + pp0_129_0_33 + {31'b0, pp0_66_1_31, 1'b0} + {29'b0, pp0_68_3_30, 3'b0} + {27'b0, pp0_70_5_29, 5'b0} + {25'b0, pp0_72_7_28, 7'b0} + {23'b0, pp0_74_9_27, 9'b0} + {21'b0, pp0_76_11_26, 11'b0} + {19'b0, pp0_78_13_25, 13'b0} + {17'b0, pp0_80_15_24, 15'b0} + {15'b0, pp0_82_17_23, 17'b0} + {13'b0, pp0_84_19_22, 19'b0} + {11'b0, pp0_86_21_21, 21'b0} + {9'b0, pp0_88_23_20, 23'b0} + {7'b0, pp0_90_25_19, 25'b0} + {5'b0, pp0_92_27_18, 27'b0} + {3'b0, pp0_94_29_17, 29'b0} + {1'b0, pp0_96_31_16, 31'b0};

wire sign1;
wire sign3;
wire sign5;
wire sign7;
wire sign9;
wire sign11;
wire sign13;
wire sign15;
wire sign17;
wire sign19;
wire sign21;
wire sign23;
wire sign25;
wire sign27;
wire sign29;
wire sign31;

wire [32:0] pp0_64_0_32;
assign pp0_64_0_32 = (B[0] == 1'b1)? {A[32], ~A[31:0]} : {1'b1, 32'b0};

wire [33:0] pp0_66_1_31;
wire [33:0] pp0_68_3_30;
wire [33:0] pp0_70_5_29;
wire [33:0] pp0_72_7_28;
wire [33:0] pp0_74_9_27;
wire [33:0] pp0_76_11_26;
wire [33:0] pp0_78_13_25;
wire [33:0] pp0_80_15_24;
wire [33:0] pp0_82_17_23;
wire [33:0] pp0_84_19_22;
wire [33:0] pp0_86_21_21;
wire [33:0] pp0_88_23_20;
wire [33:0] pp0_90_25_19;
wire [33:0] pp0_92_27_18;
wire [33:0] pp0_94_29_17;
wire [33:0] pp0_96_31_16;

wire [65:0] pp0_129_0_33;

assign pp0_129_0_33  = {34'b1010101010101010101010101010101011, sign31, 1'b0, sign29, 1'b0, sign27, 1'b0, sign25, 1'b0, sign23, 1'b0, sign21, 1'b0, sign19, 1'b0, sign17, 1'b0, sign15, 1'b0, sign13, 1'b0, sign11, 1'b0, sign9, 1'b0, sign7, 1'b0, sign5, 1'b0, sign3, 1'b0, sign1, B[0]}; 

gen_partial_product #(.WIDTH(33)) gpp1 (
    .A   (A               ),
    .b0  (B[0]            ),
    .b1  (B[1]            ),
    .b2  (B[2]            ),
    .sign(sign1           ),
    .P   (pp0_66_1_31     )
    );

gen_partial_product #(.WIDTH(33)) gpp3 (
    .A   (A               ),
    .b0  (B[2]            ),
    .b1  (B[3]            ),
    .b2  (B[4]            ),
    .sign(sign3           ),
    .P   (pp0_68_3_30     )
    );

gen_partial_product #(.WIDTH(33)) gpp5 (
    .A   (A               ),
    .b0  (B[4]            ),
    .b1  (B[5]            ),
    .b2  (B[6]            ),
    .sign(sign5           ),
    .P   (pp0_70_5_29     )
    );

gen_partial_product #(.WIDTH(33)) gpp7 (
    .A   (A               ),
    .b0  (B[6]            ),
    .b1  (B[7]            ),
    .b2  (B[8]            ),
    .sign(sign7           ),
    .P   (pp0_72_7_28     )
    );

gen_partial_product #(.WIDTH(33)) gpp9 (
    .A   (A               ),
    .b0  (B[8]            ),
    .b1  (B[9]            ),
    .b2  (B[10]           ),
    .sign(sign9           ),
    .P   (pp0_74_9_27     )
    );

gen_partial_product #(.WIDTH(33)) gpp11 (
    .A   (A               ),
    .b0  (B[10]           ),
    .b1  (B[11]           ),
    .b2  (B[12]           ),
    .sign(sign11          ),
    .P   (pp0_76_11_26    )
    );

gen_partial_product #(.WIDTH(33)) gpp13 (
    .A   (A               ),
    .b0  (B[12]           ),
    .b1  (B[13]           ),
    .b2  (B[14]           ),
    .sign(sign13          ),
    .P   (pp0_78_13_25    )
    );

gen_partial_product #(.WIDTH(33)) gpp15 (
    .A   (A               ),
    .b0  (B[14]           ),
    .b1  (B[15]           ),
    .b2  (B[16]           ),
    .sign(sign15          ),
    .P   (pp0_80_15_24    )
    );

gen_partial_product #(.WIDTH(33)) gpp17 (
    .A   (A               ),
    .b0  (B[16]           ),
    .b1  (B[17]           ),
    .b2  (B[18]           ),
    .sign(sign17          ),
    .P   (pp0_82_17_23    )
    );

gen_partial_product #(.WIDTH(33)) gpp19 (
    .A   (A               ),
    .b0  (B[18]           ),
    .b1  (B[19]           ),
    .b2  (B[20]           ),
    .sign(sign19          ),
    .P   (pp0_84_19_22    )
    );

gen_partial_product #(.WIDTH(33)) gpp21 (
    .A   (A               ),
    .b0  (B[20]           ),
    .b1  (B[21]           ),
    .b2  (B[22]           ),
    .sign(sign21          ),
    .P   (pp0_86_21_21    )
    );

gen_partial_product #(.WIDTH(33)) gpp23 (
    .A   (A               ),
    .b0  (B[22]           ),
    .b1  (B[23]           ),
    .b2  (B[24]           ),
    .sign(sign23          ),
    .P   (pp0_88_23_20    )
    );

gen_partial_product #(.WIDTH(33)) gpp25 (
    .A   (A               ),
    .b0  (B[24]           ),
    .b1  (B[25]           ),
    .b2  (B[26]           ),
    .sign(sign25          ),
    .P   (pp0_90_25_19    )
    );

gen_partial_product #(.WIDTH(33)) gpp27 (
    .A   (A               ),
    .b0  (B[26]           ),
    .b1  (B[27]           ),
    .b2  (B[28]           ),
    .sign(sign27          ),
    .P   (pp0_92_27_18    )
    );

gen_partial_product #(.WIDTH(33)) gpp29 (
    .A   (A               ),
    .b0  (B[28]           ),
    .b1  (B[29]           ),
    .b2  (B[30]           ),
    .sign(sign29          ),
    .P   (pp0_94_29_17    )
    );

gen_partial_product #(.WIDTH(33)) gpp31 (
    .A   (A               ),
    .b0  (B[30]           ),
    .b1  (B[31]           ),
    .b2  (B[32]           ),
    .sign(sign31          ),
    .P   (pp0_96_31_16    )
    );

wire [39:0] pp1_96_25_41;
wire [39:0] pp1_88_17_43;
wire [39:0] pp1_80_9_45;
wire [39:0] pp1_72_1_47;
wire [48:0] pp2_97_17_55;
wire [48:0] pp2_81_1_57;
wire [65:0] pp3_98_1_63;

wire [39:0] pp1_97_26_42;
wire [39:0] pp1_89_18_44;
wire [39:0] pp1_81_10_46;
wire [39:0] pp1_73_2_48;
wire [48:0] pp2_98_18_56;
wire [48:0] pp2_82_2_58;
wire [65:0] pp3_99_2_64;

wire [65:0] sum_res    ;   
wire [65:0] carry_res  ; 

CSA4_2 #(.WIDTH(40)) CSA4_2_inst1_4 (
    .cin  (0                             ),
    .A    ({pp0_96_31_16, 6'd0}          ),
    .B    ({2'd0, pp0_94_29_17, 4'd0}    ),
    .C    ({4'd0, pp0_92_27_18, 2'd0}    ),
    .D    ({6'd0, pp0_90_25_19}          ),
    .sum  (pp1_96_25_41                  ),
    .carry(pp1_97_26_42                  )
    );

CSA4_2 #(.WIDTH(40)) CSA4_2_inst1_5 (
    .cin  (0                             ),
    .A    ({pp0_88_23_20, 6'd0}          ),
    .B    ({2'd0, pp0_86_21_21, 4'd0}    ),
    .C    ({4'd0, pp0_84_19_22, 2'd0}    ),
    .D    ({6'd0, pp0_82_17_23}          ),
    .sum  (pp1_88_17_43                  ),
    .carry(pp1_89_18_44                  )
    );

CSA4_2 #(.WIDTH(40)) CSA4_2_inst1_6 (
    .cin  (0                             ),
    .A    ({pp0_80_15_24, 6'd0}          ),
    .B    ({2'd0, pp0_78_13_25, 4'd0}    ),
    .C    ({4'd0, pp0_76_11_26, 2'd0}    ),
    .D    ({6'd0, pp0_74_9_27}           ),
    .sum  (pp1_80_9_45                   ),
    .carry(pp1_81_10_46                  )
    );

CSA4_2 #(.WIDTH(40)) CSA4_2_inst1_7 (
    .cin  (0                             ),
    .A    ({pp0_72_7_28, 6'd0}           ),
    .B    ({2'd0, pp0_70_5_29, 4'd0}     ),
    .C    ({4'd0, pp0_68_3_30, 2'd0}     ),
    .D    ({6'd0, pp0_66_1_31}           ),
    .sum  (pp1_72_1_47                   ),
    .carry(pp1_73_2_48                   )
    );

CSA4_2 #(.WIDTH(49)) CSA4_2_inst2_10 (
    .cin  (0                             ),
    .A    ({1'd0, pp1_96_25_41, 8'd0}    ),
    .B    ({pp1_97_26_42, 9'd0}          ),
    .C    ({9'd0, pp1_88_17_43}          ),
    .D    ({8'd0, pp1_89_18_44, 1'd0}    ),
    .sum  (pp2_97_17_55                  ),
    .carry(pp2_98_18_56                  )
    );

CSA4_2 #(.WIDTH(49)) CSA4_2_inst2_11 (
    .cin  (0                             ),
    .A    ({1'd0, pp1_80_9_45, 8'd0}     ),
    .B    ({pp1_81_10_46, 9'd0}          ),
    .C    ({9'd0, pp1_72_1_47}           ),
    .D    ({8'd0, pp1_73_2_48, 1'd0}     ),
    .sum  (pp2_81_1_57                   ),
    .carry(pp2_82_2_58                   )
    );

CSA4_2 #(.WIDTH(66)) CSA4_2_inst3_13 (
    .cin  (0                             ),
    .A    ({1'd0, pp2_97_17_55, 16'd0}   ),
    .B    ({pp2_98_18_56, 17'd0}         ),
    .C    ({17'd0, pp2_81_1_57}          ),
    .D    ({16'd0, pp2_82_2_58, 1'd0}    ),
    .sum  (pp3_98_1_63                   ),
    .carry(pp3_99_2_64                   )
    );

CSA4_2 #(.WIDTH(66)) CSA4_2_inst4_14 (
    .cin  (0                             ),
    .A    (pp0_129_0_33                  ),
    .B    ({33'b0, pp0_64_0_32}          ),
    .C    ({pp3_98_1_63[64:0], 1'b0}     ),
    .D    ({pp3_99_2_64[63:0], 2'b0}     ),
    .sum  (sum_res                       ),
    .carry(carry_res                     )
    );

assign part_mul_res0 = sum_res[63:0]          ;
assign part_mul_res1 = {carry_res[62:0], 1'b0};

endmodule