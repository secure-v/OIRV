module MUL65 (
    input [64:0]   A            ,
    input [64:0]   B            ,
    output [127:0] part_mul_res0,
    output [127:0] part_mul_res1
);

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
wire sign33;
wire sign35;
wire sign37;
wire sign39;
wire sign41;
wire sign43;
wire sign45;
wire sign47;
wire sign49;
wire sign51;
wire sign53;
wire sign55;
wire sign57;
wire sign59;
wire sign61;
wire sign63;

wire [64:0] pp0_64_0_32;
assign pp0_64_0_32 = (B[0] == 1'b1)? {A[64], ~A[63:0]}: {1'b1, 64'b0};

wire [65:0] pp0_66_1_31;
wire [65:0] pp0_68_3_30;
wire [65:0] pp0_70_5_29;
wire [65:0] pp0_72_7_28;
wire [65:0] pp0_74_9_27;
wire [65:0] pp0_76_11_26;
wire [65:0] pp0_78_13_25;
wire [65:0] pp0_80_15_24;
wire [65:0] pp0_82_17_23;
wire [65:0] pp0_84_19_22;
wire [65:0] pp0_86_21_21;
wire [65:0] pp0_88_23_20;
wire [65:0] pp0_90_25_19;
wire [65:0] pp0_92_27_18;
wire [65:0] pp0_94_29_17;
wire [65:0] pp0_96_31_16;
wire [65:0] pp0_98_33_15;
wire [65:0] pp0_100_35_14;
wire [65:0] pp0_102_37_13;
wire [65:0] pp0_104_39_12;
wire [65:0] pp0_106_41_11;
wire [65:0] pp0_108_43_10;
wire [65:0] pp0_110_45_9;
wire [65:0] pp0_112_47_8;
wire [65:0] pp0_114_49_7;
wire [65:0] pp0_116_51_6;
wire [65:0] pp0_118_53_5;
wire [65:0] pp0_120_55_4;
wire [65:0] pp0_122_57_3;
wire [65:0] pp0_124_59_2;
wire [65:0] pp0_126_61_1;
wire [65:0] pp0_128_63_0;

wire [129:0] pp0_129_0_33;

assign pp0_129_0_33  = {66'b101010101010101010101010101010101010101010101010101010101010101011, sign63, 1'b0, sign61, 1'b0, sign59, 1'b0, sign57, 1'b0, sign55, 1'b0, sign53, 1'b0, sign51, 1'b0, sign49, 1'b0, sign47, 1'b0, sign45, 1'b0, sign43, 1'b0, sign41, 1'b0, sign39, 1'b0, sign37, 1'b0, sign35, 1'b0, sign33, 1'b0, sign31, 1'b0, sign29, 1'b0, sign27, 1'b0, sign25, 1'b0, sign23, 1'b0, sign21, 1'b0, sign19, 1'b0, sign17, 1'b0, sign15, 1'b0, sign13, 1'b0, sign11, 1'b0, sign9, 1'b0, sign7, 1'b0, sign5, 1'b0, sign3, 1'b0, sign1, B[0]}; 

gen_partial_product #(.WIDTH(65)) gpp1 (
    .A   (A               ),
    .b0  (B[0]            ),
    .b1  (B[1]            ),
    .b2  (B[2]            ),
    .sign(sign1           ),
    .P   (pp0_66_1_31     )
    );

gen_partial_product #(.WIDTH(65)) gpp3 (
    .A   (A               ),
    .b0  (B[2]            ),
    .b1  (B[3]            ),
    .b2  (B[4]            ),
    .sign(sign3           ),
    .P   (pp0_68_3_30     )
    );

gen_partial_product #(.WIDTH(65)) gpp5 (
    .A   (A               ),
    .b0  (B[4]            ),
    .b1  (B[5]            ),
    .b2  (B[6]            ),
    .sign(sign5           ),
    .P   (pp0_70_5_29     )
    );

gen_partial_product #(.WIDTH(65)) gpp7 (
    .A   (A               ),
    .b0  (B[6]            ),
    .b1  (B[7]            ),
    .b2  (B[8]            ),
    .sign(sign7           ),
    .P   (pp0_72_7_28     )
    );

gen_partial_product #(.WIDTH(65)) gpp9 (
    .A   (A               ),
    .b0  (B[8]            ),
    .b1  (B[9]            ),
    .b2  (B[10]           ),
    .sign(sign9           ),
    .P   (pp0_74_9_27     )
    );

gen_partial_product #(.WIDTH(65)) gpp11 (
    .A   (A               ),
    .b0  (B[10]           ),
    .b1  (B[11]           ),
    .b2  (B[12]           ),
    .sign(sign11          ),
    .P   (pp0_76_11_26    )
    );

gen_partial_product #(.WIDTH(65)) gpp13 (
    .A   (A               ),
    .b0  (B[12]           ),
    .b1  (B[13]           ),
    .b2  (B[14]           ),
    .sign(sign13          ),
    .P   (pp0_78_13_25    )
    );

gen_partial_product #(.WIDTH(65)) gpp15 (
    .A   (A               ),
    .b0  (B[14]           ),
    .b1  (B[15]           ),
    .b2  (B[16]           ),
    .sign(sign15          ),
    .P   (pp0_80_15_24    )
    );

gen_partial_product #(.WIDTH(65)) gpp17 (
    .A   (A               ),
    .b0  (B[16]           ),
    .b1  (B[17]           ),
    .b2  (B[18]           ),
    .sign(sign17          ),
    .P   (pp0_82_17_23    )
    );

gen_partial_product #(.WIDTH(65)) gpp19 (
    .A   (A               ),
    .b0  (B[18]           ),
    .b1  (B[19]           ),
    .b2  (B[20]           ),
    .sign(sign19          ),
    .P   (pp0_84_19_22    )
    );

gen_partial_product #(.WIDTH(65)) gpp21 (
    .A   (A               ),
    .b0  (B[20]           ),
    .b1  (B[21]           ),
    .b2  (B[22]           ),
    .sign(sign21          ),
    .P   (pp0_86_21_21    )
    );

gen_partial_product #(.WIDTH(65)) gpp23 (
    .A   (A               ),
    .b0  (B[22]           ),
    .b1  (B[23]           ),
    .b2  (B[24]           ),
    .sign(sign23          ),
    .P   (pp0_88_23_20    )
    );

gen_partial_product #(.WIDTH(65)) gpp25 (
    .A   (A               ),
    .b0  (B[24]           ),
    .b1  (B[25]           ),
    .b2  (B[26]           ),
    .sign(sign25          ),
    .P   (pp0_90_25_19    )
    );

gen_partial_product #(.WIDTH(65)) gpp27 (
    .A   (A               ),
    .b0  (B[26]           ),
    .b1  (B[27]           ),
    .b2  (B[28]           ),
    .sign(sign27          ),
    .P   (pp0_92_27_18    )
    );

gen_partial_product #(.WIDTH(65)) gpp29 (
    .A   (A               ),
    .b0  (B[28]           ),
    .b1  (B[29]           ),
    .b2  (B[30]           ),
    .sign(sign29          ),
    .P   (pp0_94_29_17    )
    );

gen_partial_product #(.WIDTH(65)) gpp31 (
    .A   (A               ),
    .b0  (B[30]           ),
    .b1  (B[31]           ),
    .b2  (B[32]           ),
    .sign(sign31          ),
    .P   (pp0_96_31_16    )
    );

gen_partial_product #(.WIDTH(65)) gpp33 (
    .A   (A               ),
    .b0  (B[32]           ),
    .b1  (B[33]           ),
    .b2  (B[34]           ),
    .sign(sign33          ),
    .P   (pp0_98_33_15    )
    );

gen_partial_product #(.WIDTH(65)) gpp35 (
    .A   (A               ),
    .b0  (B[34]           ),
    .b1  (B[35]           ),
    .b2  (B[36]           ),
    .sign(sign35          ),
    .P   (pp0_100_35_14   )
    );

gen_partial_product #(.WIDTH(65)) gpp37 (
    .A   (A               ),
    .b0  (B[36]           ),
    .b1  (B[37]           ),
    .b2  (B[38]           ),
    .sign(sign37          ),
    .P   (pp0_102_37_13   )
    );

gen_partial_product #(.WIDTH(65)) gpp39 (
    .A   (A               ),
    .b0  (B[38]           ),
    .b1  (B[39]           ),
    .b2  (B[40]           ),
    .sign(sign39          ),
    .P   (pp0_104_39_12   )
    );

gen_partial_product #(.WIDTH(65)) gpp41 (
    .A   (A               ),
    .b0  (B[40]           ),
    .b1  (B[41]           ),
    .b2  (B[42]           ),
    .sign(sign41          ),
    .P   (pp0_106_41_11   )
    );

gen_partial_product #(.WIDTH(65)) gpp43 (
    .A   (A               ),
    .b0  (B[42]           ),
    .b1  (B[43]           ),
    .b2  (B[44]           ),
    .sign(sign43          ),
    .P   (pp0_108_43_10   )
    );

gen_partial_product #(.WIDTH(65)) gpp45 (
    .A   (A               ),
    .b0  (B[44]           ),
    .b1  (B[45]           ),
    .b2  (B[46]           ),
    .sign(sign45          ),
    .P   (pp0_110_45_9    )
    );

gen_partial_product #(.WIDTH(65)) gpp47 (
    .A   (A               ),
    .b0  (B[46]           ),
    .b1  (B[47]           ),
    .b2  (B[48]           ),
    .sign(sign47          ),
    .P   (pp0_112_47_8    )
    );

gen_partial_product #(.WIDTH(65)) gpp49 (
    .A   (A               ),
    .b0  (B[48]           ),
    .b1  (B[49]           ),
    .b2  (B[50]           ),
    .sign(sign49          ),
    .P   (pp0_114_49_7    )
    );

gen_partial_product #(.WIDTH(65)) gpp51 (
    .A   (A               ),
    .b0  (B[50]           ),
    .b1  (B[51]           ),
    .b2  (B[52]           ),
    .sign(sign51          ),
    .P   (pp0_116_51_6    )
    );

gen_partial_product #(.WIDTH(65)) gpp53 (
    .A   (A               ),
    .b0  (B[52]           ),
    .b1  (B[53]           ),
    .b2  (B[54]           ),
    .sign(sign53          ),
    .P   (pp0_118_53_5    )
    );

gen_partial_product #(.WIDTH(65)) gpp55 (
    .A   (A               ),
    .b0  (B[54]           ),
    .b1  (B[55]           ),
    .b2  (B[56]           ),
    .sign(sign55          ),
    .P   (pp0_120_55_4    )
    );

gen_partial_product #(.WIDTH(65)) gpp57 (
    .A   (A               ),
    .b0  (B[56]           ),
    .b1  (B[57]           ),
    .b2  (B[58]           ),
    .sign(sign57          ),
    .P   (pp0_122_57_3    )
    );

gen_partial_product #(.WIDTH(65)) gpp59 (
    .A   (A               ),
    .b0  (B[58]           ),
    .b1  (B[59]           ),
    .b2  (B[60]           ),
    .sign(sign59          ),
    .P   (pp0_124_59_2    )
    );

gen_partial_product #(.WIDTH(65)) gpp61 (
    .A   (A               ),
    .b0  (B[60]           ),
    .b1  (B[61]           ),
    .b2  (B[62]           ),
    .sign(sign61          ),
    .P   (pp0_126_61_1    )
    );

gen_partial_product #(.WIDTH(65)) gpp63 (
    .A   (A               ),
    .b0  (B[62]           ),
    .b1  (B[63]           ),
    .b2  (B[64]           ),
    .sign(sign63          ),
    .P   (pp0_128_63_0    )
    );


wire [71:0] pp1_128_57_33;
wire [71:0] pp1_120_49_35;
wire [71:0] pp1_112_41_37;
wire [71:0] pp1_104_33_39;
wire [71:0] pp1_96_25_41;
wire [71:0] pp1_88_17_43;
wire [71:0] pp1_80_9_45;
wire [71:0] pp1_72_1_47;
wire [80:0] pp2_129_49_51;
wire [80:0] pp2_113_33_53;
wire [80:0] pp2_97_17_55;
wire [80:0] pp2_81_1_57;
wire [96:0] pp3_129_33_61;
wire [97:0] pp3_98_1_63;
wire [128:0] pp4_129_1_67;
wire [129:0] pp5_129_0_71;

wire [71:0] pp1_129_58_34;
wire [71:0] pp1_121_50_36;
wire [71:0] pp1_113_42_38;
wire [71:0] pp1_105_34_40;
wire [71:0] pp1_97_26_42;
wire [71:0] pp1_89_18_44;
wire [71:0] pp1_81_10_46;
wire [71:0] pp1_73_2_48;
wire [79:0] pp2_129_50_52;
wire [80:0] pp2_114_34_54;
wire [80:0] pp2_98_18_56;
wire [80:0] pp2_82_2_58;
wire [95:0] pp3_129_34_62;
wire [97:0] pp3_99_2_64;
wire [127:0] pp4_129_2_68;
wire [128:0] pp5_129_1_72;

wire [64:0] pp1_64_0_49;
wire [129:0] pp1_129_0_50;
wire [64:0] pp2_64_0_59;
wire [129:0] pp2_129_0_60;
wire [64:0] pp3_64_0_65;
wire [129:0] pp3_129_0_66;
wire [64:0] pp4_64_0_69;
wire [129:0] pp4_129_0_70;

assign pp1_64_0_49 = pp0_64_0_32;
assign pp1_129_0_50 = pp0_129_0_33;
assign pp2_64_0_59 = pp1_64_0_49;
assign pp2_129_0_60 = pp1_129_0_50;
assign pp3_64_0_65 = pp2_64_0_59;
assign pp3_129_0_66 = pp2_129_0_60;
assign pp4_64_0_69 = pp3_64_0_65;
assign pp4_129_0_70 = pp3_129_0_66;

wire [80:0] tmp_pp2_130_50;
wire [96:0] tmp_pp3_130_34;
wire [128:0] tmp_pp4_130_2;
wire [129:0] tmp_pp5_130_1;

assign pp2_129_50_52 = tmp_pp2_130_50[79:0];
assign pp3_129_34_62 = tmp_pp3_130_34[95:0];
assign pp4_129_2_68 = tmp_pp4_130_2[127:0];
assign pp5_129_1_72 = tmp_pp5_130_1[128:0];

CSA4_2 #(.WIDTH(72)) CSA4_2_inst1_0 (
    .cin  (0                             ),
    .A    ({pp0_128_63_0, 6'd0}          ),
    .B    ({2'd0, pp0_126_61_1, 4'd0}    ),
    .C    ({4'd0, pp0_124_59_2, 2'd0}    ),
    .D    ({6'd0, pp0_122_57_3}          ),
    .sum  (pp1_128_57_33                 ),
    .carry(pp1_129_58_34                 )
    );

CSA4_2 #(.WIDTH(72)) CSA4_2_inst1_1 (
    .cin  (0                             ),
    .A    ({pp0_120_55_4, 6'd0}          ),
    .B    ({2'd0, pp0_118_53_5, 4'd0}    ),
    .C    ({4'd0, pp0_116_51_6, 2'd0}    ),
    .D    ({6'd0, pp0_114_49_7}          ),
    .sum  (pp1_120_49_35                 ),
    .carry(pp1_121_50_36                 )
    );

CSA4_2 #(.WIDTH(72)) CSA4_2_inst1_2 (
    .cin  (0                             ),
    .A    ({pp0_112_47_8, 6'd0}          ),
    .B    ({2'd0, pp0_110_45_9, 4'd0}    ),
    .C    ({4'd0, pp0_108_43_10, 2'd0}   ),
    .D    ({6'd0, pp0_106_41_11}         ),
    .sum  (pp1_112_41_37                 ),
    .carry(pp1_113_42_38                 )
    );

CSA4_2 #(.WIDTH(72)) CSA4_2_inst1_3 (
    .cin  (0                             ),
    .A    ({pp0_104_39_12, 6'd0}         ),
    .B    ({2'd0, pp0_102_37_13, 4'd0}   ),
    .C    ({4'd0, pp0_100_35_14, 2'd0}   ),
    .D    ({6'd0, pp0_98_33_15}          ),
    .sum  (pp1_104_33_39                 ),
    .carry(pp1_105_34_40                 )
    );

CSA4_2 #(.WIDTH(72)) CSA4_2_inst1_4 (
    .cin  (0                             ),
    .A    ({pp0_96_31_16, 6'd0}          ),
    .B    ({2'd0, pp0_94_29_17, 4'd0}    ),
    .C    ({4'd0, pp0_92_27_18, 2'd0}    ),
    .D    ({6'd0, pp0_90_25_19}          ),
    .sum  (pp1_96_25_41                  ),
    .carry(pp1_97_26_42                  )
    );

CSA4_2 #(.WIDTH(72)) CSA4_2_inst1_5 (
    .cin  (0                             ),
    .A    ({pp0_88_23_20, 6'd0}          ),
    .B    ({2'd0, pp0_86_21_21, 4'd0}    ),
    .C    ({4'd0, pp0_84_19_22, 2'd0}    ),
    .D    ({6'd0, pp0_82_17_23}          ),
    .sum  (pp1_88_17_43                  ),
    .carry(pp1_89_18_44                  )
    );

CSA4_2 #(.WIDTH(72)) CSA4_2_inst1_6 (
    .cin  (0                             ),
    .A    ({pp0_80_15_24, 6'd0}          ),
    .B    ({2'd0, pp0_78_13_25, 4'd0}    ),
    .C    ({4'd0, pp0_76_11_26, 2'd0}    ),
    .D    ({6'd0, pp0_74_9_27}           ),
    .sum  (pp1_80_9_45                   ),
    .carry(pp1_81_10_46                  )
    );

CSA4_2 #(.WIDTH(72)) CSA4_2_inst1_7 (
    .cin  (0                             ),
    .A    ({pp0_72_7_28, 6'd0}           ),
    .B    ({2'd0, pp0_70_5_29, 4'd0}     ),
    .C    ({4'd0, pp0_68_3_30, 2'd0}     ),
    .D    ({6'd0, pp0_66_1_31}           ),
    .sum  (pp1_72_1_47                   ),
    .carry(pp1_73_2_48                   )
    );

CSA4_2 #(.WIDTH(81)) CSA4_2_inst2_8 (
    .cin  (0                             ),
    .A    ({1'd0, pp1_128_57_33, 8'd0}   ),
    .B    ({pp1_129_58_34, 9'd0}         ),
    .C    ({9'd0, pp1_120_49_35}         ),
    .D    ({8'd0, pp1_121_50_36, 1'd0}   ),
    .sum  (pp2_129_49_51                 ),
    .carry(tmp_pp2_130_50                )
    );

CSA4_2 #(.WIDTH(81)) CSA4_2_inst2_9 (
    .cin  (0                             ),
    .A    ({1'd0, pp1_112_41_37, 8'd0}   ),
    .B    ({pp1_113_42_38, 9'd0}         ),
    .C    ({9'd0, pp1_104_33_39}         ),
    .D    ({8'd0, pp1_105_34_40, 1'd0}   ),
    .sum  (pp2_113_33_53                 ),
    .carry(pp2_114_34_54                 )
    );

CSA4_2 #(.WIDTH(81)) CSA4_2_inst2_10 (
    .cin  (0                             ),
    .A    ({1'd0, pp1_96_25_41, 8'd0}    ),
    .B    ({pp1_97_26_42, 9'd0}          ),
    .C    ({9'd0, pp1_88_17_43}          ),
    .D    ({8'd0, pp1_89_18_44, 1'd0}    ),
    .sum  (pp2_97_17_55                  ),
    .carry(pp2_98_18_56                  )
    );

CSA4_2 #(.WIDTH(81)) CSA4_2_inst2_11 (
    .cin  (0                             ),
    .A    ({1'd0, pp1_80_9_45, 8'd0}     ),
    .B    ({pp1_81_10_46, 9'd0}          ),
    .C    ({9'd0, pp1_72_1_47}           ),
    .D    ({8'd0, pp1_73_2_48, 1'd0}     ),
    .sum  (pp2_81_1_57                   ),
    .carry(pp2_82_2_58                   )
    );

CSA4_2 #(.WIDTH(97)) CSA4_2_inst3_12 (
    .cin  (0                             ),
    .A    ({pp2_129_49_51, 16'd0}        ),
    .B    ({pp2_129_50_52, 17'd0}        ),
    .C    ({16'd0, pp2_113_33_53}        ),
    .D    ({15'd0, pp2_114_34_54, 1'd0}  ),
    .sum  (pp3_129_33_61                 ),
    .carry(tmp_pp3_130_34                )
    );

CSA4_2 #(.WIDTH(98)) CSA4_2_inst3_13 (
    .cin  (0                             ),
    .A    ({1'd0, pp2_97_17_55, 16'd0}   ),
    .B    ({pp2_98_18_56, 17'd0}         ),
    .C    ({17'd0, pp2_81_1_57}          ),
    .D    ({16'd0, pp2_82_2_58, 1'd0}    ),
    .sum  (pp3_98_1_63                   ),
    .carry(pp3_99_2_64                   )
    );

CSA4_2 #(.WIDTH(129)) CSA4_2_inst4_14 (
    .cin  (0                             ),
    .A    ({pp3_129_33_61, 32'd0}        ),
    .B    ({pp3_129_34_62, 33'd0}        ),
    .C    ({31'd0, pp3_98_1_63}          ),
    .D    ({30'd0, pp3_99_2_64, 1'd0}    ),
    .sum  (pp4_129_1_67                  ),
    .carry(tmp_pp4_130_2                 )
    );

CSA4_2 #(.WIDTH(130)) CSA4_2_inst5_15 (
    .cin  (0                             ),
    .A    ({pp4_129_1_67, 1'd0}          ),
    .B    ({pp4_129_2_68, 2'd0}          ),
    .C    ({65'd0, pp4_64_0_69}          ),
    .D    ({pp4_129_0_70}                ),
    .sum  (pp5_129_0_71                  ),
    .carry(tmp_pp5_130_1                 )
    );


// wire adder_c;

// PTA130 PTA130_inst0 (
//     .A    (pp5_129_0_71        ),
//     .B    ({pp5_129_1_72, 1'b0}),
//     .S    (mul                 ),
//     .C    (adder_c             )
//     );

assign part_mul_res0 = pp5_129_0_71[127:0]        ;
assign part_mul_res1 = {pp5_129_1_72[126:0], 1'b0};

endmodule