//-----------------------interface signal---------------------------//
module PTA130(
        input[129:0]     A,
        input[129:0]     B,
        output[129:0]    S,
        output           C
);
//////////////////////////////////////////////////////////////////////

//-----------------------internal signal----------------------------//
                     wire P0_0;
                     wire G0_0;

                     wire P1_1;
                     wire G1_1;

                     wire P2_2;
                     wire G2_2;

                     wire P3_3;
                     wire G3_3;

                     wire P4_4;
                     wire G4_4;

                     wire P5_5;
                     wire G5_5;

                     wire P6_6;
                     wire G6_6;

                     wire P7_7;
                     wire G7_7;

                     wire P8_8;
                     wire G8_8;

                     wire P9_9;
                     wire G9_9;

                     wire P10_10;
                     wire G10_10;

                     wire P11_11;
                     wire G11_11;

                     wire P12_12;
                     wire G12_12;

                     wire P13_13;
                     wire G13_13;

                     wire P14_14;
                     wire G14_14;

                     wire P15_15;
                     wire G15_15;

                     wire P16_16;
                     wire G16_16;

                     wire P17_17;
                     wire G17_17;

                     wire P18_18;
                     wire G18_18;

                     wire P19_19;
                     wire G19_19;

                     wire P20_20;
                     wire G20_20;

                     wire P21_21;
                     wire G21_21;

                     wire P22_22;
                     wire G22_22;

                     wire P23_23;
                     wire G23_23;

                     wire P24_24;
                     wire G24_24;

                     wire P25_25;
                     wire G25_25;

                     wire P26_26;
                     wire G26_26;

                     wire P27_27;
                     wire G27_27;

                     wire P28_28;
                     wire G28_28;

                     wire P29_29;
                     wire G29_29;

                     wire P30_30;
                     wire G30_30;

                     wire P31_31;
                     wire G31_31;

                     wire P32_32;
                     wire G32_32;

                     wire P33_33;
                     wire G33_33;

                     wire P34_34;
                     wire G34_34;

                     wire P35_35;
                     wire G35_35;

                     wire P36_36;
                     wire G36_36;

                     wire P37_37;
                     wire G37_37;

                     wire P38_38;
                     wire G38_38;

                     wire P39_39;
                     wire G39_39;

                     wire P40_40;
                     wire G40_40;

                     wire P41_41;
                     wire G41_41;

                     wire P42_42;
                     wire G42_42;

                     wire P43_43;
                     wire G43_43;

                     wire P44_44;
                     wire G44_44;

                     wire P45_45;
                     wire G45_45;

                     wire P46_46;
                     wire G46_46;

                     wire P47_47;
                     wire G47_47;

                     wire P48_48;
                     wire G48_48;

                     wire P49_49;
                     wire G49_49;

                     wire P50_50;
                     wire G50_50;

                     wire P51_51;
                     wire G51_51;

                     wire P52_52;
                     wire G52_52;

                     wire P53_53;
                     wire G53_53;

                     wire P54_54;
                     wire G54_54;

                     wire P55_55;
                     wire G55_55;

                     wire P56_56;
                     wire G56_56;

                     wire P57_57;
                     wire G57_57;

                     wire P58_58;
                     wire G58_58;

                     wire P59_59;
                     wire G59_59;

                     wire P60_60;
                     wire G60_60;

                     wire P61_61;
                     wire G61_61;

                     wire P62_62;
                     wire G62_62;

                     wire P63_63;
                     wire G63_63;

                     wire P64_64;
                     wire G64_64;

                     wire P65_65;
                     wire G65_65;

                     wire P66_66;
                     wire G66_66;

                     wire P67_67;
                     wire G67_67;

                     wire P68_68;
                     wire G68_68;

                     wire P69_69;
                     wire G69_69;

                     wire P70_70;
                     wire G70_70;

                     wire P71_71;
                     wire G71_71;

                     wire P72_72;
                     wire G72_72;

                     wire P73_73;
                     wire G73_73;

                     wire P74_74;
                     wire G74_74;

                     wire P75_75;
                     wire G75_75;

                     wire P76_76;
                     wire G76_76;

                     wire P77_77;
                     wire G77_77;

                     wire P78_78;
                     wire G78_78;

                     wire P79_79;
                     wire G79_79;

                     wire P80_80;
                     wire G80_80;

                     wire P81_81;
                     wire G81_81;

                     wire P82_82;
                     wire G82_82;

                     wire P83_83;
                     wire G83_83;

                     wire P84_84;
                     wire G84_84;

                     wire P85_85;
                     wire G85_85;

                     wire P86_86;
                     wire G86_86;

                     wire P87_87;
                     wire G87_87;

                     wire P88_88;
                     wire G88_88;

                     wire P89_89;
                     wire G89_89;

                     wire P90_90;
                     wire G90_90;

                     wire P91_91;
                     wire G91_91;

                     wire P92_92;
                     wire G92_92;

                     wire P93_93;
                     wire G93_93;

                     wire P94_94;
                     wire G94_94;

                     wire P95_95;
                     wire G95_95;

                     wire P96_96;
                     wire G96_96;

                     wire P97_97;
                     wire G97_97;

                     wire P98_98;
                     wire G98_98;

                     wire P99_99;
                     wire G99_99;

                     wire P100_100;
                     wire G100_100;

                     wire P101_101;
                     wire G101_101;

                     wire P102_102;
                     wire G102_102;

                     wire P103_103;
                     wire G103_103;

                     wire P104_104;
                     wire G104_104;

                     wire P105_105;
                     wire G105_105;

                     wire P106_106;
                     wire G106_106;

                     wire P107_107;
                     wire G107_107;

                     wire P108_108;
                     wire G108_108;

                     wire P109_109;
                     wire G109_109;

                     wire P110_110;
                     wire G110_110;

                     wire P111_111;
                     wire G111_111;

                     wire P112_112;
                     wire G112_112;

                     wire P113_113;
                     wire G113_113;

                     wire P114_114;
                     wire G114_114;

                     wire P115_115;
                     wire G115_115;

                     wire P116_116;
                     wire G116_116;

                     wire P117_117;
                     wire G117_117;

                     wire P118_118;
                     wire G118_118;

                     wire P119_119;
                     wire G119_119;

                     wire P120_120;
                     wire G120_120;

                     wire P121_121;
                     wire G121_121;

                     wire P122_122;
                     wire G122_122;

                     wire P123_123;
                     wire G123_123;

                     wire P124_124;
                     wire G124_124;

                     wire P125_125;
                     wire G125_125;

                     wire P126_126;
                     wire G126_126;

                     wire P127_127;
                     wire G127_127;

                     wire P128_128;
                     wire G128_128;

                     wire P129_129;
                     wire G129_129;

                     wire G1_0;

                     wire G2_1;
                     wire P2_1;

                     wire G3_2;
                     wire P3_2;

                     wire G4_3;
                     wire P4_3;

                     wire G5_4;
                     wire P5_4;

                     wire G6_5;
                     wire P6_5;

                     wire G7_6;
                     wire P7_6;

                     wire G8_7;
                     wire P8_7;

                     wire G9_8;
                     wire P9_8;

                     wire G10_9;
                     wire P10_9;

                     wire G11_10;
                     wire P11_10;

                     wire G12_11;
                     wire P12_11;

                     wire G13_12;
                     wire P13_12;

                     wire G14_13;
                     wire P14_13;

                     wire G15_14;
                     wire P15_14;

                     wire G16_15;
                     wire P16_15;

                     wire G17_16;
                     wire P17_16;

                     wire G18_17;
                     wire P18_17;

                     wire G19_18;
                     wire P19_18;

                     wire G20_19;
                     wire P20_19;

                     wire G21_20;
                     wire P21_20;

                     wire G22_21;
                     wire P22_21;

                     wire G23_22;
                     wire P23_22;

                     wire G24_23;
                     wire P24_23;

                     wire G25_24;
                     wire P25_24;

                     wire G26_25;
                     wire P26_25;

                     wire G27_26;
                     wire P27_26;

                     wire G28_27;
                     wire P28_27;

                     wire G29_28;
                     wire P29_28;

                     wire G30_29;
                     wire P30_29;

                     wire G31_30;
                     wire P31_30;

                     wire G32_31;
                     wire P32_31;

                     wire G33_32;
                     wire P33_32;

                     wire G34_33;
                     wire P34_33;

                     wire G35_34;
                     wire P35_34;

                     wire G36_35;
                     wire P36_35;

                     wire G37_36;
                     wire P37_36;

                     wire G38_37;
                     wire P38_37;

                     wire G39_38;
                     wire P39_38;

                     wire G40_39;
                     wire P40_39;

                     wire G41_40;
                     wire P41_40;

                     wire G42_41;
                     wire P42_41;

                     wire G43_42;
                     wire P43_42;

                     wire G44_43;
                     wire P44_43;

                     wire G45_44;
                     wire P45_44;

                     wire G46_45;
                     wire P46_45;

                     wire G47_46;
                     wire P47_46;

                     wire G48_47;
                     wire P48_47;

                     wire G49_48;
                     wire P49_48;

                     wire G50_49;
                     wire P50_49;

                     wire G51_50;
                     wire P51_50;

                     wire G52_51;
                     wire P52_51;

                     wire G53_52;
                     wire P53_52;

                     wire G54_53;
                     wire P54_53;

                     wire G55_54;
                     wire P55_54;

                     wire G56_55;
                     wire P56_55;

                     wire G57_56;
                     wire P57_56;

                     wire G58_57;
                     wire P58_57;

                     wire G59_58;
                     wire P59_58;

                     wire G60_59;
                     wire P60_59;

                     wire G61_60;
                     wire P61_60;

                     wire G62_61;
                     wire P62_61;

                     wire G63_62;
                     wire P63_62;

                     wire G64_63;
                     wire P64_63;

                     wire G65_64;
                     wire P65_64;

                     wire G66_65;
                     wire P66_65;

                     wire G67_66;
                     wire P67_66;

                     wire G68_67;
                     wire P68_67;

                     wire G69_68;
                     wire P69_68;

                     wire G70_69;
                     wire P70_69;

                     wire G71_70;
                     wire P71_70;

                     wire G72_71;
                     wire P72_71;

                     wire G73_72;
                     wire P73_72;

                     wire G74_73;
                     wire P74_73;

                     wire G75_74;
                     wire P75_74;

                     wire G76_75;
                     wire P76_75;

                     wire G77_76;
                     wire P77_76;

                     wire G78_77;
                     wire P78_77;

                     wire G79_78;
                     wire P79_78;

                     wire G80_79;
                     wire P80_79;

                     wire G81_80;
                     wire P81_80;

                     wire G82_81;
                     wire P82_81;

                     wire G83_82;
                     wire P83_82;

                     wire G84_83;
                     wire P84_83;

                     wire G85_84;
                     wire P85_84;

                     wire G86_85;
                     wire P86_85;

                     wire G87_86;
                     wire P87_86;

                     wire G88_87;
                     wire P88_87;

                     wire G89_88;
                     wire P89_88;

                     wire G90_89;
                     wire P90_89;

                     wire G91_90;
                     wire P91_90;

                     wire G92_91;
                     wire P92_91;

                     wire G93_92;
                     wire P93_92;

                     wire G94_93;
                     wire P94_93;

                     wire G95_94;
                     wire P95_94;

                     wire G96_95;
                     wire P96_95;

                     wire G97_96;
                     wire P97_96;

                     wire G98_97;
                     wire P98_97;

                     wire G99_98;
                     wire P99_98;

                     wire G100_99;
                     wire P100_99;

                     wire G101_100;
                     wire P101_100;

                     wire G102_101;
                     wire P102_101;

                     wire G103_102;
                     wire P103_102;

                     wire G104_103;
                     wire P104_103;

                     wire G105_104;
                     wire P105_104;

                     wire G106_105;
                     wire P106_105;

                     wire G107_106;
                     wire P107_106;

                     wire G108_107;
                     wire P108_107;

                     wire G109_108;
                     wire P109_108;

                     wire G110_109;
                     wire P110_109;

                     wire G111_110;
                     wire P111_110;

                     wire G112_111;
                     wire P112_111;

                     wire G113_112;
                     wire P113_112;

                     wire G114_113;
                     wire P114_113;

                     wire G115_114;
                     wire P115_114;

                     wire G116_115;
                     wire P116_115;

                     wire G117_116;
                     wire P117_116;

                     wire G118_117;
                     wire P118_117;

                     wire G119_118;
                     wire P119_118;

                     wire G120_119;
                     wire P120_119;

                     wire G121_120;
                     wire P121_120;

                     wire G122_121;
                     wire P122_121;

                     wire G123_122;
                     wire P123_122;

                     wire G124_123;
                     wire P124_123;

                     wire G125_124;
                     wire P125_124;

                     wire G126_125;
                     wire P126_125;

                     wire G127_126;
                     wire P127_126;

                     wire G128_127;
                     wire P128_127;

                     wire G129_128;
                     wire P129_128;

                     wire G2_0;

                     wire G3_0;

                     wire G4_1;
                     wire P4_1;

                     wire G5_2;
                     wire P5_2;

                     wire G6_3;
                     wire P6_3;

                     wire G7_4;
                     wire P7_4;

                     wire G8_5;
                     wire P8_5;

                     wire G9_6;
                     wire P9_6;

                     wire G10_7;
                     wire P10_7;

                     wire G11_8;
                     wire P11_8;

                     wire G12_9;
                     wire P12_9;

                     wire G13_10;
                     wire P13_10;

                     wire G14_11;
                     wire P14_11;

                     wire G15_12;
                     wire P15_12;

                     wire G16_13;
                     wire P16_13;

                     wire G17_14;
                     wire P17_14;

                     wire G18_15;
                     wire P18_15;

                     wire G19_16;
                     wire P19_16;

                     wire G20_17;
                     wire P20_17;

                     wire G21_18;
                     wire P21_18;

                     wire G22_19;
                     wire P22_19;

                     wire G23_20;
                     wire P23_20;

                     wire G24_21;
                     wire P24_21;

                     wire G25_22;
                     wire P25_22;

                     wire G26_23;
                     wire P26_23;

                     wire G27_24;
                     wire P27_24;

                     wire G28_25;
                     wire P28_25;

                     wire G29_26;
                     wire P29_26;

                     wire G30_27;
                     wire P30_27;

                     wire G31_28;
                     wire P31_28;

                     wire G32_29;
                     wire P32_29;

                     wire G33_30;
                     wire P33_30;

                     wire G34_31;
                     wire P34_31;

                     wire G35_32;
                     wire P35_32;

                     wire G36_33;
                     wire P36_33;

                     wire G37_34;
                     wire P37_34;

                     wire G38_35;
                     wire P38_35;

                     wire G39_36;
                     wire P39_36;

                     wire G40_37;
                     wire P40_37;

                     wire G41_38;
                     wire P41_38;

                     wire G42_39;
                     wire P42_39;

                     wire G43_40;
                     wire P43_40;

                     wire G44_41;
                     wire P44_41;

                     wire G45_42;
                     wire P45_42;

                     wire G46_43;
                     wire P46_43;

                     wire G47_44;
                     wire P47_44;

                     wire G48_45;
                     wire P48_45;

                     wire G49_46;
                     wire P49_46;

                     wire G50_47;
                     wire P50_47;

                     wire G51_48;
                     wire P51_48;

                     wire G52_49;
                     wire P52_49;

                     wire G53_50;
                     wire P53_50;

                     wire G54_51;
                     wire P54_51;

                     wire G55_52;
                     wire P55_52;

                     wire G56_53;
                     wire P56_53;

                     wire G57_54;
                     wire P57_54;

                     wire G58_55;
                     wire P58_55;

                     wire G59_56;
                     wire P59_56;

                     wire G60_57;
                     wire P60_57;

                     wire G61_58;
                     wire P61_58;

                     wire G62_59;
                     wire P62_59;

                     wire G63_60;
                     wire P63_60;

                     wire G64_61;
                     wire P64_61;

                     wire G65_62;
                     wire P65_62;

                     wire G66_63;
                     wire P66_63;

                     wire G67_64;
                     wire P67_64;

                     wire G68_65;
                     wire P68_65;

                     wire G69_66;
                     wire P69_66;

                     wire G70_67;
                     wire P70_67;

                     wire G71_68;
                     wire P71_68;

                     wire G72_69;
                     wire P72_69;

                     wire G73_70;
                     wire P73_70;

                     wire G74_71;
                     wire P74_71;

                     wire G75_72;
                     wire P75_72;

                     wire G76_73;
                     wire P76_73;

                     wire G77_74;
                     wire P77_74;

                     wire G78_75;
                     wire P78_75;

                     wire G79_76;
                     wire P79_76;

                     wire G80_77;
                     wire P80_77;

                     wire G81_78;
                     wire P81_78;

                     wire G82_79;
                     wire P82_79;

                     wire G83_80;
                     wire P83_80;

                     wire G84_81;
                     wire P84_81;

                     wire G85_82;
                     wire P85_82;

                     wire G86_83;
                     wire P86_83;

                     wire G87_84;
                     wire P87_84;

                     wire G88_85;
                     wire P88_85;

                     wire G89_86;
                     wire P89_86;

                     wire G90_87;
                     wire P90_87;

                     wire G91_88;
                     wire P91_88;

                     wire G92_89;
                     wire P92_89;

                     wire G93_90;
                     wire P93_90;

                     wire G94_91;
                     wire P94_91;

                     wire G95_92;
                     wire P95_92;

                     wire G96_93;
                     wire P96_93;

                     wire G97_94;
                     wire P97_94;

                     wire G98_95;
                     wire P98_95;

                     wire G99_96;
                     wire P99_96;

                     wire G100_97;
                     wire P100_97;

                     wire G101_98;
                     wire P101_98;

                     wire G102_99;
                     wire P102_99;

                     wire G103_100;
                     wire P103_100;

                     wire G104_101;
                     wire P104_101;

                     wire G105_102;
                     wire P105_102;

                     wire G106_103;
                     wire P106_103;

                     wire G107_104;
                     wire P107_104;

                     wire G108_105;
                     wire P108_105;

                     wire G109_106;
                     wire P109_106;

                     wire G110_107;
                     wire P110_107;

                     wire G111_108;
                     wire P111_108;

                     wire G112_109;
                     wire P112_109;

                     wire G113_110;
                     wire P113_110;

                     wire G114_111;
                     wire P114_111;

                     wire G115_112;
                     wire P115_112;

                     wire G116_113;
                     wire P116_113;

                     wire G117_114;
                     wire P117_114;

                     wire G118_115;
                     wire P118_115;

                     wire G119_116;
                     wire P119_116;

                     wire G120_117;
                     wire P120_117;

                     wire G121_118;
                     wire P121_118;

                     wire G122_119;
                     wire P122_119;

                     wire G123_120;
                     wire P123_120;

                     wire G124_121;
                     wire P124_121;

                     wire G125_122;
                     wire P125_122;

                     wire G126_123;
                     wire P126_123;

                     wire G127_124;
                     wire P127_124;

                     wire G128_125;
                     wire P128_125;

                     wire G129_126;
                     wire P129_126;

                     wire G4_0;

                     wire G5_0;

                     wire G6_0;

                     wire G7_0;

                     wire G8_1;
                     wire P8_1;

                     wire G9_2;
                     wire P9_2;

                     wire G10_3;
                     wire P10_3;

                     wire G11_4;
                     wire P11_4;

                     wire G12_5;
                     wire P12_5;

                     wire G13_6;
                     wire P13_6;

                     wire G14_7;
                     wire P14_7;

                     wire G15_8;
                     wire P15_8;

                     wire G16_9;
                     wire P16_9;

                     wire G17_10;
                     wire P17_10;

                     wire G18_11;
                     wire P18_11;

                     wire G19_12;
                     wire P19_12;

                     wire G20_13;
                     wire P20_13;

                     wire G21_14;
                     wire P21_14;

                     wire G22_15;
                     wire P22_15;

                     wire G23_16;
                     wire P23_16;

                     wire G24_17;
                     wire P24_17;

                     wire G25_18;
                     wire P25_18;

                     wire G26_19;
                     wire P26_19;

                     wire G27_20;
                     wire P27_20;

                     wire G28_21;
                     wire P28_21;

                     wire G29_22;
                     wire P29_22;

                     wire G30_23;
                     wire P30_23;

                     wire G31_24;
                     wire P31_24;

                     wire G32_25;
                     wire P32_25;

                     wire G33_26;
                     wire P33_26;

                     wire G34_27;
                     wire P34_27;

                     wire G35_28;
                     wire P35_28;

                     wire G36_29;
                     wire P36_29;

                     wire G37_30;
                     wire P37_30;

                     wire G38_31;
                     wire P38_31;

                     wire G39_32;
                     wire P39_32;

                     wire G40_33;
                     wire P40_33;

                     wire G41_34;
                     wire P41_34;

                     wire G42_35;
                     wire P42_35;

                     wire G43_36;
                     wire P43_36;

                     wire G44_37;
                     wire P44_37;

                     wire G45_38;
                     wire P45_38;

                     wire G46_39;
                     wire P46_39;

                     wire G47_40;
                     wire P47_40;

                     wire G48_41;
                     wire P48_41;

                     wire G49_42;
                     wire P49_42;

                     wire G50_43;
                     wire P50_43;

                     wire G51_44;
                     wire P51_44;

                     wire G52_45;
                     wire P52_45;

                     wire G53_46;
                     wire P53_46;

                     wire G54_47;
                     wire P54_47;

                     wire G55_48;
                     wire P55_48;

                     wire G56_49;
                     wire P56_49;

                     wire G57_50;
                     wire P57_50;

                     wire G58_51;
                     wire P58_51;

                     wire G59_52;
                     wire P59_52;

                     wire G60_53;
                     wire P60_53;

                     wire G61_54;
                     wire P61_54;

                     wire G62_55;
                     wire P62_55;

                     wire G63_56;
                     wire P63_56;

                     wire G64_57;
                     wire P64_57;

                     wire G65_58;
                     wire P65_58;

                     wire G66_59;
                     wire P66_59;

                     wire G67_60;
                     wire P67_60;

                     wire G68_61;
                     wire P68_61;

                     wire G69_62;
                     wire P69_62;

                     wire G70_63;
                     wire P70_63;

                     wire G71_64;
                     wire P71_64;

                     wire G72_65;
                     wire P72_65;

                     wire G73_66;
                     wire P73_66;

                     wire G74_67;
                     wire P74_67;

                     wire G75_68;
                     wire P75_68;

                     wire G76_69;
                     wire P76_69;

                     wire G77_70;
                     wire P77_70;

                     wire G78_71;
                     wire P78_71;

                     wire G79_72;
                     wire P79_72;

                     wire G80_73;
                     wire P80_73;

                     wire G81_74;
                     wire P81_74;

                     wire G82_75;
                     wire P82_75;

                     wire G83_76;
                     wire P83_76;

                     wire G84_77;
                     wire P84_77;

                     wire G85_78;
                     wire P85_78;

                     wire G86_79;
                     wire P86_79;

                     wire G87_80;
                     wire P87_80;

                     wire G88_81;
                     wire P88_81;

                     wire G89_82;
                     wire P89_82;

                     wire G90_83;
                     wire P90_83;

                     wire G91_84;
                     wire P91_84;

                     wire G92_85;
                     wire P92_85;

                     wire G93_86;
                     wire P93_86;

                     wire G94_87;
                     wire P94_87;

                     wire G95_88;
                     wire P95_88;

                     wire G96_89;
                     wire P96_89;

                     wire G97_90;
                     wire P97_90;

                     wire G98_91;
                     wire P98_91;

                     wire G99_92;
                     wire P99_92;

                     wire G100_93;
                     wire P100_93;

                     wire G101_94;
                     wire P101_94;

                     wire G102_95;
                     wire P102_95;

                     wire G103_96;
                     wire P103_96;

                     wire G104_97;
                     wire P104_97;

                     wire G105_98;
                     wire P105_98;

                     wire G106_99;
                     wire P106_99;

                     wire G107_100;
                     wire P107_100;

                     wire G108_101;
                     wire P108_101;

                     wire G109_102;
                     wire P109_102;

                     wire G110_103;
                     wire P110_103;

                     wire G111_104;
                     wire P111_104;

                     wire G112_105;
                     wire P112_105;

                     wire G113_106;
                     wire P113_106;

                     wire G114_107;
                     wire P114_107;

                     wire G115_108;
                     wire P115_108;

                     wire G116_109;
                     wire P116_109;

                     wire G117_110;
                     wire P117_110;

                     wire G118_111;
                     wire P118_111;

                     wire G119_112;
                     wire P119_112;

                     wire G120_113;
                     wire P120_113;

                     wire G121_114;
                     wire P121_114;

                     wire G122_115;
                     wire P122_115;

                     wire G123_116;
                     wire P123_116;

                     wire G124_117;
                     wire P124_117;

                     wire G125_118;
                     wire P125_118;

                     wire G126_119;
                     wire P126_119;

                     wire G127_120;
                     wire P127_120;

                     wire G128_121;
                     wire P128_121;

                     wire G129_122;
                     wire P129_122;

                     wire G8_0;

                     wire G9_0;

                     wire G10_0;

                     wire G11_0;

                     wire G12_0;

                     wire G13_0;

                     wire G14_0;

                     wire G15_0;

                     wire G16_1;
                     wire P16_1;

                     wire G17_2;
                     wire P17_2;

                     wire G18_3;
                     wire P18_3;

                     wire G19_4;
                     wire P19_4;

                     wire G20_5;
                     wire P20_5;

                     wire G21_6;
                     wire P21_6;

                     wire G22_7;
                     wire P22_7;

                     wire G23_8;
                     wire P23_8;

                     wire G24_9;
                     wire P24_9;

                     wire G25_10;
                     wire P25_10;

                     wire G26_11;
                     wire P26_11;

                     wire G27_12;
                     wire P27_12;

                     wire G28_13;
                     wire P28_13;

                     wire G29_14;
                     wire P29_14;

                     wire G30_15;
                     wire P30_15;

                     wire G31_16;
                     wire P31_16;

                     wire G32_17;
                     wire P32_17;

                     wire G33_18;
                     wire P33_18;

                     wire G34_19;
                     wire P34_19;

                     wire G35_20;
                     wire P35_20;

                     wire G36_21;
                     wire P36_21;

                     wire G37_22;
                     wire P37_22;

                     wire G38_23;
                     wire P38_23;

                     wire G39_24;
                     wire P39_24;

                     wire G40_25;
                     wire P40_25;

                     wire G41_26;
                     wire P41_26;

                     wire G42_27;
                     wire P42_27;

                     wire G43_28;
                     wire P43_28;

                     wire G44_29;
                     wire P44_29;

                     wire G45_30;
                     wire P45_30;

                     wire G46_31;
                     wire P46_31;

                     wire G47_32;
                     wire P47_32;

                     wire G48_33;
                     wire P48_33;

                     wire G49_34;
                     wire P49_34;

                     wire G50_35;
                     wire P50_35;

                     wire G51_36;
                     wire P51_36;

                     wire G52_37;
                     wire P52_37;

                     wire G53_38;
                     wire P53_38;

                     wire G54_39;
                     wire P54_39;

                     wire G55_40;
                     wire P55_40;

                     wire G56_41;
                     wire P56_41;

                     wire G57_42;
                     wire P57_42;

                     wire G58_43;
                     wire P58_43;

                     wire G59_44;
                     wire P59_44;

                     wire G60_45;
                     wire P60_45;

                     wire G61_46;
                     wire P61_46;

                     wire G62_47;
                     wire P62_47;

                     wire G63_48;
                     wire P63_48;

                     wire G64_49;
                     wire P64_49;

                     wire G65_50;
                     wire P65_50;

                     wire G66_51;
                     wire P66_51;

                     wire G67_52;
                     wire P67_52;

                     wire G68_53;
                     wire P68_53;

                     wire G69_54;
                     wire P69_54;

                     wire G70_55;
                     wire P70_55;

                     wire G71_56;
                     wire P71_56;

                     wire G72_57;
                     wire P72_57;

                     wire G73_58;
                     wire P73_58;

                     wire G74_59;
                     wire P74_59;

                     wire G75_60;
                     wire P75_60;

                     wire G76_61;
                     wire P76_61;

                     wire G77_62;
                     wire P77_62;

                     wire G78_63;
                     wire P78_63;

                     wire G79_64;
                     wire P79_64;

                     wire G80_65;
                     wire P80_65;

                     wire G81_66;
                     wire P81_66;

                     wire G82_67;
                     wire P82_67;

                     wire G83_68;
                     wire P83_68;

                     wire G84_69;
                     wire P84_69;

                     wire G85_70;
                     wire P85_70;

                     wire G86_71;
                     wire P86_71;

                     wire G87_72;
                     wire P87_72;

                     wire G88_73;
                     wire P88_73;

                     wire G89_74;
                     wire P89_74;

                     wire G90_75;
                     wire P90_75;

                     wire G91_76;
                     wire P91_76;

                     wire G92_77;
                     wire P92_77;

                     wire G93_78;
                     wire P93_78;

                     wire G94_79;
                     wire P94_79;

                     wire G95_80;
                     wire P95_80;

                     wire G96_81;
                     wire P96_81;

                     wire G97_82;
                     wire P97_82;

                     wire G98_83;
                     wire P98_83;

                     wire G99_84;
                     wire P99_84;

                     wire G100_85;
                     wire P100_85;

                     wire G101_86;
                     wire P101_86;

                     wire G102_87;
                     wire P102_87;

                     wire G103_88;
                     wire P103_88;

                     wire G104_89;
                     wire P104_89;

                     wire G105_90;
                     wire P105_90;

                     wire G106_91;
                     wire P106_91;

                     wire G107_92;
                     wire P107_92;

                     wire G108_93;
                     wire P108_93;

                     wire G109_94;
                     wire P109_94;

                     wire G110_95;
                     wire P110_95;

                     wire G111_96;
                     wire P111_96;

                     wire G112_97;
                     wire P112_97;

                     wire G113_98;
                     wire P113_98;

                     wire G114_99;
                     wire P114_99;

                     wire G115_100;
                     wire P115_100;

                     wire G116_101;
                     wire P116_101;

                     wire G117_102;
                     wire P117_102;

                     wire G118_103;
                     wire P118_103;

                     wire G119_104;
                     wire P119_104;

                     wire G120_105;
                     wire P120_105;

                     wire G121_106;
                     wire P121_106;

                     wire G122_107;
                     wire P122_107;

                     wire G123_108;
                     wire P123_108;

                     wire G124_109;
                     wire P124_109;

                     wire G125_110;
                     wire P125_110;

                     wire G126_111;
                     wire P126_111;

                     wire G127_112;
                     wire P127_112;

                     wire G128_113;
                     wire P128_113;

                     wire G129_114;
                     wire P129_114;

                     wire G16_0;

                     wire G17_0;

                     wire G18_0;

                     wire G19_0;

                     wire G20_0;

                     wire G21_0;

                     wire G22_0;

                     wire G23_0;

                     wire G24_0;

                     wire G25_0;

                     wire G26_0;

                     wire G27_0;

                     wire G28_0;

                     wire G29_0;

                     wire G30_0;

                     wire G31_0;

                     wire G32_1;
                     wire P32_1;

                     wire G33_2;
                     wire P33_2;

                     wire G34_3;
                     wire P34_3;

                     wire G35_4;
                     wire P35_4;

                     wire G36_5;
                     wire P36_5;

                     wire G37_6;
                     wire P37_6;

                     wire G38_7;
                     wire P38_7;

                     wire G39_8;
                     wire P39_8;

                     wire G40_9;
                     wire P40_9;

                     wire G41_10;
                     wire P41_10;

                     wire G42_11;
                     wire P42_11;

                     wire G43_12;
                     wire P43_12;

                     wire G44_13;
                     wire P44_13;

                     wire G45_14;
                     wire P45_14;

                     wire G46_15;
                     wire P46_15;

                     wire G47_16;
                     wire P47_16;

                     wire G48_17;
                     wire P48_17;

                     wire G49_18;
                     wire P49_18;

                     wire G50_19;
                     wire P50_19;

                     wire G51_20;
                     wire P51_20;

                     wire G52_21;
                     wire P52_21;

                     wire G53_22;
                     wire P53_22;

                     wire G54_23;
                     wire P54_23;

                     wire G55_24;
                     wire P55_24;

                     wire G56_25;
                     wire P56_25;

                     wire G57_26;
                     wire P57_26;

                     wire G58_27;
                     wire P58_27;

                     wire G59_28;
                     wire P59_28;

                     wire G60_29;
                     wire P60_29;

                     wire G61_30;
                     wire P61_30;

                     wire G62_31;
                     wire P62_31;

                     wire G63_32;
                     wire P63_32;

                     wire G64_33;
                     wire P64_33;

                     wire G65_34;
                     wire P65_34;

                     wire G66_35;
                     wire P66_35;

                     wire G67_36;
                     wire P67_36;

                     wire G68_37;
                     wire P68_37;

                     wire G69_38;
                     wire P69_38;

                     wire G70_39;
                     wire P70_39;

                     wire G71_40;
                     wire P71_40;

                     wire G72_41;
                     wire P72_41;

                     wire G73_42;
                     wire P73_42;

                     wire G74_43;
                     wire P74_43;

                     wire G75_44;
                     wire P75_44;

                     wire G76_45;
                     wire P76_45;

                     wire G77_46;
                     wire P77_46;

                     wire G78_47;
                     wire P78_47;

                     wire G79_48;
                     wire P79_48;

                     wire G80_49;
                     wire P80_49;

                     wire G81_50;
                     wire P81_50;

                     wire G82_51;
                     wire P82_51;

                     wire G83_52;
                     wire P83_52;

                     wire G84_53;
                     wire P84_53;

                     wire G85_54;
                     wire P85_54;

                     wire G86_55;
                     wire P86_55;

                     wire G87_56;
                     wire P87_56;

                     wire G88_57;
                     wire P88_57;

                     wire G89_58;
                     wire P89_58;

                     wire G90_59;
                     wire P90_59;

                     wire G91_60;
                     wire P91_60;

                     wire G92_61;
                     wire P92_61;

                     wire G93_62;
                     wire P93_62;

                     wire G94_63;
                     wire P94_63;

                     wire G95_64;
                     wire P95_64;

                     wire G96_65;
                     wire P96_65;

                     wire G97_66;
                     wire P97_66;

                     wire G98_67;
                     wire P98_67;

                     wire G99_68;
                     wire P99_68;

                     wire G100_69;
                     wire P100_69;

                     wire G101_70;
                     wire P101_70;

                     wire G102_71;
                     wire P102_71;

                     wire G103_72;
                     wire P103_72;

                     wire G104_73;
                     wire P104_73;

                     wire G105_74;
                     wire P105_74;

                     wire G106_75;
                     wire P106_75;

                     wire G107_76;
                     wire P107_76;

                     wire G108_77;
                     wire P108_77;

                     wire G109_78;
                     wire P109_78;

                     wire G110_79;
                     wire P110_79;

                     wire G111_80;
                     wire P111_80;

                     wire G112_81;
                     wire P112_81;

                     wire G113_82;
                     wire P113_82;

                     wire G114_83;
                     wire P114_83;

                     wire G115_84;
                     wire P115_84;

                     wire G116_85;
                     wire P116_85;

                     wire G117_86;
                     wire P117_86;

                     wire G118_87;
                     wire P118_87;

                     wire G119_88;
                     wire P119_88;

                     wire G120_89;
                     wire P120_89;

                     wire G121_90;
                     wire P121_90;

                     wire G122_91;
                     wire P122_91;

                     wire G123_92;
                     wire P123_92;

                     wire G124_93;
                     wire P124_93;

                     wire G125_94;
                     wire P125_94;

                     wire G126_95;
                     wire P126_95;

                     wire G127_96;
                     wire P127_96;

                     wire G128_97;
                     wire P128_97;

                     wire G129_98;
                     wire P129_98;

                     wire G32_0;

                     wire G33_0;

                     wire G34_0;

                     wire G35_0;

                     wire G36_0;

                     wire G37_0;

                     wire G38_0;

                     wire G39_0;

                     wire G40_0;

                     wire G41_0;

                     wire G42_0;

                     wire G43_0;

                     wire G44_0;

                     wire G45_0;

                     wire G46_0;

                     wire G47_0;

                     wire G48_0;

                     wire G49_0;

                     wire G50_0;

                     wire G51_0;

                     wire G52_0;

                     wire G53_0;

                     wire G54_0;

                     wire G55_0;

                     wire G56_0;

                     wire G57_0;

                     wire G58_0;

                     wire G59_0;

                     wire G60_0;

                     wire G61_0;

                     wire G62_0;

                     wire G63_0;

                     wire G64_1;
                     wire P64_1;

                     wire G65_2;
                     wire P65_2;

                     wire G66_3;
                     wire P66_3;

                     wire G67_4;
                     wire P67_4;

                     wire G68_5;
                     wire P68_5;

                     wire G69_6;
                     wire P69_6;

                     wire G70_7;
                     wire P70_7;

                     wire G71_8;
                     wire P71_8;

                     wire G72_9;
                     wire P72_9;

                     wire G73_10;
                     wire P73_10;

                     wire G74_11;
                     wire P74_11;

                     wire G75_12;
                     wire P75_12;

                     wire G76_13;
                     wire P76_13;

                     wire G77_14;
                     wire P77_14;

                     wire G78_15;
                     wire P78_15;

                     wire G79_16;
                     wire P79_16;

                     wire G80_17;
                     wire P80_17;

                     wire G81_18;
                     wire P81_18;

                     wire G82_19;
                     wire P82_19;

                     wire G83_20;
                     wire P83_20;

                     wire G84_21;
                     wire P84_21;

                     wire G85_22;
                     wire P85_22;

                     wire G86_23;
                     wire P86_23;

                     wire G87_24;
                     wire P87_24;

                     wire G88_25;
                     wire P88_25;

                     wire G89_26;
                     wire P89_26;

                     wire G90_27;
                     wire P90_27;

                     wire G91_28;
                     wire P91_28;

                     wire G92_29;
                     wire P92_29;

                     wire G93_30;
                     wire P93_30;

                     wire G94_31;
                     wire P94_31;

                     wire G95_32;
                     wire P95_32;

                     wire G96_33;
                     wire P96_33;

                     wire G97_34;
                     wire P97_34;

                     wire G98_35;
                     wire P98_35;

                     wire G99_36;
                     wire P99_36;

                     wire G100_37;
                     wire P100_37;

                     wire G101_38;
                     wire P101_38;

                     wire G102_39;
                     wire P102_39;

                     wire G103_40;
                     wire P103_40;

                     wire G104_41;
                     wire P104_41;

                     wire G105_42;
                     wire P105_42;

                     wire G106_43;
                     wire P106_43;

                     wire G107_44;
                     wire P107_44;

                     wire G108_45;
                     wire P108_45;

                     wire G109_46;
                     wire P109_46;

                     wire G110_47;
                     wire P110_47;

                     wire G111_48;
                     wire P111_48;

                     wire G112_49;
                     wire P112_49;

                     wire G113_50;
                     wire P113_50;

                     wire G114_51;
                     wire P114_51;

                     wire G115_52;
                     wire P115_52;

                     wire G116_53;
                     wire P116_53;

                     wire G117_54;
                     wire P117_54;

                     wire G118_55;
                     wire P118_55;

                     wire G119_56;
                     wire P119_56;

                     wire G120_57;
                     wire P120_57;

                     wire G121_58;
                     wire P121_58;

                     wire G122_59;
                     wire P122_59;

                     wire G123_60;
                     wire P123_60;

                     wire G124_61;
                     wire P124_61;

                     wire G125_62;
                     wire P125_62;

                     wire G126_63;
                     wire P126_63;

                     wire G127_64;
                     wire P127_64;

                     wire G128_65;
                     wire P128_65;

                     wire G129_66;
                     wire P129_66;

                     wire G64_0;

                     wire G65_0;

                     wire G66_0;

                     wire G67_0;

                     wire G68_0;

                     wire G69_0;

                     wire G70_0;

                     wire G71_0;

                     wire G72_0;

                     wire G73_0;

                     wire G74_0;

                     wire G75_0;

                     wire G76_0;

                     wire G77_0;

                     wire G78_0;

                     wire G79_0;

                     wire G80_0;

                     wire G81_0;

                     wire G82_0;

                     wire G83_0;

                     wire G84_0;

                     wire G85_0;

                     wire G86_0;

                     wire G87_0;

                     wire G88_0;

                     wire G89_0;

                     wire G90_0;

                     wire G91_0;

                     wire G92_0;

                     wire G93_0;

                     wire G94_0;

                     wire G95_0;

                     wire G96_0;

                     wire G97_0;

                     wire G98_0;

                     wire G99_0;

                     wire G100_0;

                     wire G101_0;

                     wire G102_0;

                     wire G103_0;

                     wire G104_0;

                     wire G105_0;

                     wire G106_0;

                     wire G107_0;

                     wire G108_0;

                     wire G109_0;

                     wire G110_0;

                     wire G111_0;

                     wire G112_0;

                     wire G113_0;

                     wire G114_0;

                     wire G115_0;

                     wire G116_0;

                     wire G117_0;

                     wire G118_0;

                     wire G119_0;

                     wire G120_0;

                     wire G121_0;

                     wire G122_0;

                     wire G123_0;

                     wire G124_0;

                     wire G125_0;

                     wire G126_0;

                     wire G127_0;

                     wire G128_1;
                     wire P128_1;

                     wire G129_2;
                     wire P129_2;

                     wire G128_0;

                     wire G129_0;

//////////////////////////////////////////////////////////////////////
//-----------------------architecture-------------------------------//
                     xor(P0_0,A[0],B[0]);
                     and(G0_0,A[0],B[0]);

                     xor(P1_1,A[1],B[1]);
                     and(G1_1,A[1],B[1]);

                     xor(P2_2,A[2],B[2]);
                     and(G2_2,A[2],B[2]);

                     xor(P3_3,A[3],B[3]);
                     and(G3_3,A[3],B[3]);

                     xor(P4_4,A[4],B[4]);
                     and(G4_4,A[4],B[4]);

                     xor(P5_5,A[5],B[5]);
                     and(G5_5,A[5],B[5]);

                     xor(P6_6,A[6],B[6]);
                     and(G6_6,A[6],B[6]);

                     xor(P7_7,A[7],B[7]);
                     and(G7_7,A[7],B[7]);

                     xor(P8_8,A[8],B[8]);
                     and(G8_8,A[8],B[8]);

                     xor(P9_9,A[9],B[9]);
                     and(G9_9,A[9],B[9]);

                     xor(P10_10,A[10],B[10]);
                     and(G10_10,A[10],B[10]);

                     xor(P11_11,A[11],B[11]);
                     and(G11_11,A[11],B[11]);

                     xor(P12_12,A[12],B[12]);
                     and(G12_12,A[12],B[12]);

                     xor(P13_13,A[13],B[13]);
                     and(G13_13,A[13],B[13]);

                     xor(P14_14,A[14],B[14]);
                     and(G14_14,A[14],B[14]);

                     xor(P15_15,A[15],B[15]);
                     and(G15_15,A[15],B[15]);

                     xor(P16_16,A[16],B[16]);
                     and(G16_16,A[16],B[16]);

                     xor(P17_17,A[17],B[17]);
                     and(G17_17,A[17],B[17]);

                     xor(P18_18,A[18],B[18]);
                     and(G18_18,A[18],B[18]);

                     xor(P19_19,A[19],B[19]);
                     and(G19_19,A[19],B[19]);

                     xor(P20_20,A[20],B[20]);
                     and(G20_20,A[20],B[20]);

                     xor(P21_21,A[21],B[21]);
                     and(G21_21,A[21],B[21]);

                     xor(P22_22,A[22],B[22]);
                     and(G22_22,A[22],B[22]);

                     xor(P23_23,A[23],B[23]);
                     and(G23_23,A[23],B[23]);

                     xor(P24_24,A[24],B[24]);
                     and(G24_24,A[24],B[24]);

                     xor(P25_25,A[25],B[25]);
                     and(G25_25,A[25],B[25]);

                     xor(P26_26,A[26],B[26]);
                     and(G26_26,A[26],B[26]);

                     xor(P27_27,A[27],B[27]);
                     and(G27_27,A[27],B[27]);

                     xor(P28_28,A[28],B[28]);
                     and(G28_28,A[28],B[28]);

                     xor(P29_29,A[29],B[29]);
                     and(G29_29,A[29],B[29]);

                     xor(P30_30,A[30],B[30]);
                     and(G30_30,A[30],B[30]);

                     xor(P31_31,A[31],B[31]);
                     and(G31_31,A[31],B[31]);

                     xor(P32_32,A[32],B[32]);
                     and(G32_32,A[32],B[32]);

                     xor(P33_33,A[33],B[33]);
                     and(G33_33,A[33],B[33]);

                     xor(P34_34,A[34],B[34]);
                     and(G34_34,A[34],B[34]);

                     xor(P35_35,A[35],B[35]);
                     and(G35_35,A[35],B[35]);

                     xor(P36_36,A[36],B[36]);
                     and(G36_36,A[36],B[36]);

                     xor(P37_37,A[37],B[37]);
                     and(G37_37,A[37],B[37]);

                     xor(P38_38,A[38],B[38]);
                     and(G38_38,A[38],B[38]);

                     xor(P39_39,A[39],B[39]);
                     and(G39_39,A[39],B[39]);

                     xor(P40_40,A[40],B[40]);
                     and(G40_40,A[40],B[40]);

                     xor(P41_41,A[41],B[41]);
                     and(G41_41,A[41],B[41]);

                     xor(P42_42,A[42],B[42]);
                     and(G42_42,A[42],B[42]);

                     xor(P43_43,A[43],B[43]);
                     and(G43_43,A[43],B[43]);

                     xor(P44_44,A[44],B[44]);
                     and(G44_44,A[44],B[44]);

                     xor(P45_45,A[45],B[45]);
                     and(G45_45,A[45],B[45]);

                     xor(P46_46,A[46],B[46]);
                     and(G46_46,A[46],B[46]);

                     xor(P47_47,A[47],B[47]);
                     and(G47_47,A[47],B[47]);

                     xor(P48_48,A[48],B[48]);
                     and(G48_48,A[48],B[48]);

                     xor(P49_49,A[49],B[49]);
                     and(G49_49,A[49],B[49]);

                     xor(P50_50,A[50],B[50]);
                     and(G50_50,A[50],B[50]);

                     xor(P51_51,A[51],B[51]);
                     and(G51_51,A[51],B[51]);

                     xor(P52_52,A[52],B[52]);
                     and(G52_52,A[52],B[52]);

                     xor(P53_53,A[53],B[53]);
                     and(G53_53,A[53],B[53]);

                     xor(P54_54,A[54],B[54]);
                     and(G54_54,A[54],B[54]);

                     xor(P55_55,A[55],B[55]);
                     and(G55_55,A[55],B[55]);

                     xor(P56_56,A[56],B[56]);
                     and(G56_56,A[56],B[56]);

                     xor(P57_57,A[57],B[57]);
                     and(G57_57,A[57],B[57]);

                     xor(P58_58,A[58],B[58]);
                     and(G58_58,A[58],B[58]);

                     xor(P59_59,A[59],B[59]);
                     and(G59_59,A[59],B[59]);

                     xor(P60_60,A[60],B[60]);
                     and(G60_60,A[60],B[60]);

                     xor(P61_61,A[61],B[61]);
                     and(G61_61,A[61],B[61]);

                     xor(P62_62,A[62],B[62]);
                     and(G62_62,A[62],B[62]);

                     xor(P63_63,A[63],B[63]);
                     and(G63_63,A[63],B[63]);

                     xor(P64_64,A[64],B[64]);
                     and(G64_64,A[64],B[64]);

                     xor(P65_65,A[65],B[65]);
                     and(G65_65,A[65],B[65]);

                     xor(P66_66,A[66],B[66]);
                     and(G66_66,A[66],B[66]);

                     xor(P67_67,A[67],B[67]);
                     and(G67_67,A[67],B[67]);

                     xor(P68_68,A[68],B[68]);
                     and(G68_68,A[68],B[68]);

                     xor(P69_69,A[69],B[69]);
                     and(G69_69,A[69],B[69]);

                     xor(P70_70,A[70],B[70]);
                     and(G70_70,A[70],B[70]);

                     xor(P71_71,A[71],B[71]);
                     and(G71_71,A[71],B[71]);

                     xor(P72_72,A[72],B[72]);
                     and(G72_72,A[72],B[72]);

                     xor(P73_73,A[73],B[73]);
                     and(G73_73,A[73],B[73]);

                     xor(P74_74,A[74],B[74]);
                     and(G74_74,A[74],B[74]);

                     xor(P75_75,A[75],B[75]);
                     and(G75_75,A[75],B[75]);

                     xor(P76_76,A[76],B[76]);
                     and(G76_76,A[76],B[76]);

                     xor(P77_77,A[77],B[77]);
                     and(G77_77,A[77],B[77]);

                     xor(P78_78,A[78],B[78]);
                     and(G78_78,A[78],B[78]);

                     xor(P79_79,A[79],B[79]);
                     and(G79_79,A[79],B[79]);

                     xor(P80_80,A[80],B[80]);
                     and(G80_80,A[80],B[80]);

                     xor(P81_81,A[81],B[81]);
                     and(G81_81,A[81],B[81]);

                     xor(P82_82,A[82],B[82]);
                     and(G82_82,A[82],B[82]);

                     xor(P83_83,A[83],B[83]);
                     and(G83_83,A[83],B[83]);

                     xor(P84_84,A[84],B[84]);
                     and(G84_84,A[84],B[84]);

                     xor(P85_85,A[85],B[85]);
                     and(G85_85,A[85],B[85]);

                     xor(P86_86,A[86],B[86]);
                     and(G86_86,A[86],B[86]);

                     xor(P87_87,A[87],B[87]);
                     and(G87_87,A[87],B[87]);

                     xor(P88_88,A[88],B[88]);
                     and(G88_88,A[88],B[88]);

                     xor(P89_89,A[89],B[89]);
                     and(G89_89,A[89],B[89]);

                     xor(P90_90,A[90],B[90]);
                     and(G90_90,A[90],B[90]);

                     xor(P91_91,A[91],B[91]);
                     and(G91_91,A[91],B[91]);

                     xor(P92_92,A[92],B[92]);
                     and(G92_92,A[92],B[92]);

                     xor(P93_93,A[93],B[93]);
                     and(G93_93,A[93],B[93]);

                     xor(P94_94,A[94],B[94]);
                     and(G94_94,A[94],B[94]);

                     xor(P95_95,A[95],B[95]);
                     and(G95_95,A[95],B[95]);

                     xor(P96_96,A[96],B[96]);
                     and(G96_96,A[96],B[96]);

                     xor(P97_97,A[97],B[97]);
                     and(G97_97,A[97],B[97]);

                     xor(P98_98,A[98],B[98]);
                     and(G98_98,A[98],B[98]);

                     xor(P99_99,A[99],B[99]);
                     and(G99_99,A[99],B[99]);

                     xor(P100_100,A[100],B[100]);
                     and(G100_100,A[100],B[100]);

                     xor(P101_101,A[101],B[101]);
                     and(G101_101,A[101],B[101]);

                     xor(P102_102,A[102],B[102]);
                     and(G102_102,A[102],B[102]);

                     xor(P103_103,A[103],B[103]);
                     and(G103_103,A[103],B[103]);

                     xor(P104_104,A[104],B[104]);
                     and(G104_104,A[104],B[104]);

                     xor(P105_105,A[105],B[105]);
                     and(G105_105,A[105],B[105]);

                     xor(P106_106,A[106],B[106]);
                     and(G106_106,A[106],B[106]);

                     xor(P107_107,A[107],B[107]);
                     and(G107_107,A[107],B[107]);

                     xor(P108_108,A[108],B[108]);
                     and(G108_108,A[108],B[108]);

                     xor(P109_109,A[109],B[109]);
                     and(G109_109,A[109],B[109]);

                     xor(P110_110,A[110],B[110]);
                     and(G110_110,A[110],B[110]);

                     xor(P111_111,A[111],B[111]);
                     and(G111_111,A[111],B[111]);

                     xor(P112_112,A[112],B[112]);
                     and(G112_112,A[112],B[112]);

                     xor(P113_113,A[113],B[113]);
                     and(G113_113,A[113],B[113]);

                     xor(P114_114,A[114],B[114]);
                     and(G114_114,A[114],B[114]);

                     xor(P115_115,A[115],B[115]);
                     and(G115_115,A[115],B[115]);

                     xor(P116_116,A[116],B[116]);
                     and(G116_116,A[116],B[116]);

                     xor(P117_117,A[117],B[117]);
                     and(G117_117,A[117],B[117]);

                     xor(P118_118,A[118],B[118]);
                     and(G118_118,A[118],B[118]);

                     xor(P119_119,A[119],B[119]);
                     and(G119_119,A[119],B[119]);

                     xor(P120_120,A[120],B[120]);
                     and(G120_120,A[120],B[120]);

                     xor(P121_121,A[121],B[121]);
                     and(G121_121,A[121],B[121]);

                     xor(P122_122,A[122],B[122]);
                     and(G122_122,A[122],B[122]);

                     xor(P123_123,A[123],B[123]);
                     and(G123_123,A[123],B[123]);

                     xor(P124_124,A[124],B[124]);
                     and(G124_124,A[124],B[124]);

                     xor(P125_125,A[125],B[125]);
                     and(G125_125,A[125],B[125]);

                     xor(P126_126,A[126],B[126]);
                     and(G126_126,A[126],B[126]);

                     xor(P127_127,A[127],B[127]);
                     and(G127_127,A[127],B[127]);

                     xor(P128_128,A[128],B[128]);
                     and(G128_128,A[128],B[128]);

                     xor(P129_129,A[129],B[129]);
                     and(G129_129,A[129],B[129]);

                     xor(S[0],P0_0,0);
                     xor(S[1],P1_1,G0_0);
                     xor(S[2],P2_2,G1_0);
                     xor(S[3],P3_3,G2_0);
                     xor(S[4],P4_4,G3_0);
                     xor(S[5],P5_5,G4_0);
                     xor(S[6],P6_6,G5_0);
                     xor(S[7],P7_7,G6_0);
                     xor(S[8],P8_8,G7_0);
                     xor(S[9],P9_9,G8_0);
                     xor(S[10],P10_10,G9_0);
                     xor(S[11],P11_11,G10_0);
                     xor(S[12],P12_12,G11_0);
                     xor(S[13],P13_13,G12_0);
                     xor(S[14],P14_14,G13_0);
                     xor(S[15],P15_15,G14_0);
                     xor(S[16],P16_16,G15_0);
                     xor(S[17],P17_17,G16_0);
                     xor(S[18],P18_18,G17_0);
                     xor(S[19],P19_19,G18_0);
                     xor(S[20],P20_20,G19_0);
                     xor(S[21],P21_21,G20_0);
                     xor(S[22],P22_22,G21_0);
                     xor(S[23],P23_23,G22_0);
                     xor(S[24],P24_24,G23_0);
                     xor(S[25],P25_25,G24_0);
                     xor(S[26],P26_26,G25_0);
                     xor(S[27],P27_27,G26_0);
                     xor(S[28],P28_28,G27_0);
                     xor(S[29],P29_29,G28_0);
                     xor(S[30],P30_30,G29_0);
                     xor(S[31],P31_31,G30_0);
                     xor(S[32],P32_32,G31_0);
                     xor(S[33],P33_33,G32_0);
                     xor(S[34],P34_34,G33_0);
                     xor(S[35],P35_35,G34_0);
                     xor(S[36],P36_36,G35_0);
                     xor(S[37],P37_37,G36_0);
                     xor(S[38],P38_38,G37_0);
                     xor(S[39],P39_39,G38_0);
                     xor(S[40],P40_40,G39_0);
                     xor(S[41],P41_41,G40_0);
                     xor(S[42],P42_42,G41_0);
                     xor(S[43],P43_43,G42_0);
                     xor(S[44],P44_44,G43_0);
                     xor(S[45],P45_45,G44_0);
                     xor(S[46],P46_46,G45_0);
                     xor(S[47],P47_47,G46_0);
                     xor(S[48],P48_48,G47_0);
                     xor(S[49],P49_49,G48_0);
                     xor(S[50],P50_50,G49_0);
                     xor(S[51],P51_51,G50_0);
                     xor(S[52],P52_52,G51_0);
                     xor(S[53],P53_53,G52_0);
                     xor(S[54],P54_54,G53_0);
                     xor(S[55],P55_55,G54_0);
                     xor(S[56],P56_56,G55_0);
                     xor(S[57],P57_57,G56_0);
                     xor(S[58],P58_58,G57_0);
                     xor(S[59],P59_59,G58_0);
                     xor(S[60],P60_60,G59_0);
                     xor(S[61],P61_61,G60_0);
                     xor(S[62],P62_62,G61_0);
                     xor(S[63],P63_63,G62_0);
                     xor(S[64],P64_64,G63_0);
                     xor(S[65],P65_65,G64_0);
                     xor(S[66],P66_66,G65_0);
                     xor(S[67],P67_67,G66_0);
                     xor(S[68],P68_68,G67_0);
                     xor(S[69],P69_69,G68_0);
                     xor(S[70],P70_70,G69_0);
                     xor(S[71],P71_71,G70_0);
                     xor(S[72],P72_72,G71_0);
                     xor(S[73],P73_73,G72_0);
                     xor(S[74],P74_74,G73_0);
                     xor(S[75],P75_75,G74_0);
                     xor(S[76],P76_76,G75_0);
                     xor(S[77],P77_77,G76_0);
                     xor(S[78],P78_78,G77_0);
                     xor(S[79],P79_79,G78_0);
                     xor(S[80],P80_80,G79_0);
                     xor(S[81],P81_81,G80_0);
                     xor(S[82],P82_82,G81_0);
                     xor(S[83],P83_83,G82_0);
                     xor(S[84],P84_84,G83_0);
                     xor(S[85],P85_85,G84_0);
                     xor(S[86],P86_86,G85_0);
                     xor(S[87],P87_87,G86_0);
                     xor(S[88],P88_88,G87_0);
                     xor(S[89],P89_89,G88_0);
                     xor(S[90],P90_90,G89_0);
                     xor(S[91],P91_91,G90_0);
                     xor(S[92],P92_92,G91_0);
                     xor(S[93],P93_93,G92_0);
                     xor(S[94],P94_94,G93_0);
                     xor(S[95],P95_95,G94_0);
                     xor(S[96],P96_96,G95_0);
                     xor(S[97],P97_97,G96_0);
                     xor(S[98],P98_98,G97_0);
                     xor(S[99],P99_99,G98_0);
                     xor(S[100],P100_100,G99_0);
                     xor(S[101],P101_101,G100_0);
                     xor(S[102],P102_102,G101_0);
                     xor(S[103],P103_103,G102_0);
                     xor(S[104],P104_104,G103_0);
                     xor(S[105],P105_105,G104_0);
                     xor(S[106],P106_106,G105_0);
                     xor(S[107],P107_107,G106_0);
                     xor(S[108],P108_108,G107_0);
                     xor(S[109],P109_109,G108_0);
                     xor(S[110],P110_110,G109_0);
                     xor(S[111],P111_111,G110_0);
                     xor(S[112],P112_112,G111_0);
                     xor(S[113],P113_113,G112_0);
                     xor(S[114],P114_114,G113_0);
                     xor(S[115],P115_115,G114_0);
                     xor(S[116],P116_116,G115_0);
                     xor(S[117],P117_117,G116_0);
                     xor(S[118],P118_118,G117_0);
                     xor(S[119],P119_119,G118_0);
                     xor(S[120],P120_120,G119_0);
                     xor(S[121],P121_121,G120_0);
                     xor(S[122],P122_122,G121_0);
                     xor(S[123],P123_123,G122_0);
                     xor(S[124],P124_124,G123_0);
                     xor(S[125],P125_125,G124_0);
                     xor(S[126],P126_126,G125_0);
                     xor(S[127],P127_127,G126_0);
                     xor(S[128],P128_128,G127_0);
                     xor(S[129],P129_129,G128_0);
                     buf (C,G129_0);
//////////////////////////////////////////////////////////////////////
//-----------------------instantiation------------------------------//
            GRAY_CELL INS1_1(.Gi_k(G1_1),.Pi_k(P1_1),.Gk_1_j(G0_0),.Gi_j(G1_0));

            BLACK_CELL INS1_2(.Gi_k(G2_2),.Pi_k(P2_2),.Gk_1_j(G1_1),.Pk_1_j(P1_1),.Gi_j(G2_1),.Pi_j(P2_1));

            BLACK_CELL INS1_3(.Gi_k(G3_3),.Pi_k(P3_3),.Gk_1_j(G2_2),.Pk_1_j(P2_2),.Gi_j(G3_2),.Pi_j(P3_2));

            BLACK_CELL INS1_4(.Gi_k(G4_4),.Pi_k(P4_4),.Gk_1_j(G3_3),.Pk_1_j(P3_3),.Gi_j(G4_3),.Pi_j(P4_3));

            BLACK_CELL INS1_5(.Gi_k(G5_5),.Pi_k(P5_5),.Gk_1_j(G4_4),.Pk_1_j(P4_4),.Gi_j(G5_4),.Pi_j(P5_4));

            BLACK_CELL INS1_6(.Gi_k(G6_6),.Pi_k(P6_6),.Gk_1_j(G5_5),.Pk_1_j(P5_5),.Gi_j(G6_5),.Pi_j(P6_5));

            BLACK_CELL INS1_7(.Gi_k(G7_7),.Pi_k(P7_7),.Gk_1_j(G6_6),.Pk_1_j(P6_6),.Gi_j(G7_6),.Pi_j(P7_6));

            BLACK_CELL INS1_8(.Gi_k(G8_8),.Pi_k(P8_8),.Gk_1_j(G7_7),.Pk_1_j(P7_7),.Gi_j(G8_7),.Pi_j(P8_7));

            BLACK_CELL INS1_9(.Gi_k(G9_9),.Pi_k(P9_9),.Gk_1_j(G8_8),.Pk_1_j(P8_8),.Gi_j(G9_8),.Pi_j(P9_8));

            BLACK_CELL INS1_10(.Gi_k(G10_10),.Pi_k(P10_10),.Gk_1_j(G9_9),.Pk_1_j(P9_9),.Gi_j(G10_9),.Pi_j(P10_9));

            BLACK_CELL INS1_11(.Gi_k(G11_11),.Pi_k(P11_11),.Gk_1_j(G10_10),.Pk_1_j(P10_10),.Gi_j(G11_10),.Pi_j(P11_10));

            BLACK_CELL INS1_12(.Gi_k(G12_12),.Pi_k(P12_12),.Gk_1_j(G11_11),.Pk_1_j(P11_11),.Gi_j(G12_11),.Pi_j(P12_11));

            BLACK_CELL INS1_13(.Gi_k(G13_13),.Pi_k(P13_13),.Gk_1_j(G12_12),.Pk_1_j(P12_12),.Gi_j(G13_12),.Pi_j(P13_12));

            BLACK_CELL INS1_14(.Gi_k(G14_14),.Pi_k(P14_14),.Gk_1_j(G13_13),.Pk_1_j(P13_13),.Gi_j(G14_13),.Pi_j(P14_13));

            BLACK_CELL INS1_15(.Gi_k(G15_15),.Pi_k(P15_15),.Gk_1_j(G14_14),.Pk_1_j(P14_14),.Gi_j(G15_14),.Pi_j(P15_14));

            BLACK_CELL INS1_16(.Gi_k(G16_16),.Pi_k(P16_16),.Gk_1_j(G15_15),.Pk_1_j(P15_15),.Gi_j(G16_15),.Pi_j(P16_15));

            BLACK_CELL INS1_17(.Gi_k(G17_17),.Pi_k(P17_17),.Gk_1_j(G16_16),.Pk_1_j(P16_16),.Gi_j(G17_16),.Pi_j(P17_16));

            BLACK_CELL INS1_18(.Gi_k(G18_18),.Pi_k(P18_18),.Gk_1_j(G17_17),.Pk_1_j(P17_17),.Gi_j(G18_17),.Pi_j(P18_17));

            BLACK_CELL INS1_19(.Gi_k(G19_19),.Pi_k(P19_19),.Gk_1_j(G18_18),.Pk_1_j(P18_18),.Gi_j(G19_18),.Pi_j(P19_18));

            BLACK_CELL INS1_20(.Gi_k(G20_20),.Pi_k(P20_20),.Gk_1_j(G19_19),.Pk_1_j(P19_19),.Gi_j(G20_19),.Pi_j(P20_19));

            BLACK_CELL INS1_21(.Gi_k(G21_21),.Pi_k(P21_21),.Gk_1_j(G20_20),.Pk_1_j(P20_20),.Gi_j(G21_20),.Pi_j(P21_20));

            BLACK_CELL INS1_22(.Gi_k(G22_22),.Pi_k(P22_22),.Gk_1_j(G21_21),.Pk_1_j(P21_21),.Gi_j(G22_21),.Pi_j(P22_21));

            BLACK_CELL INS1_23(.Gi_k(G23_23),.Pi_k(P23_23),.Gk_1_j(G22_22),.Pk_1_j(P22_22),.Gi_j(G23_22),.Pi_j(P23_22));

            BLACK_CELL INS1_24(.Gi_k(G24_24),.Pi_k(P24_24),.Gk_1_j(G23_23),.Pk_1_j(P23_23),.Gi_j(G24_23),.Pi_j(P24_23));

            BLACK_CELL INS1_25(.Gi_k(G25_25),.Pi_k(P25_25),.Gk_1_j(G24_24),.Pk_1_j(P24_24),.Gi_j(G25_24),.Pi_j(P25_24));

            BLACK_CELL INS1_26(.Gi_k(G26_26),.Pi_k(P26_26),.Gk_1_j(G25_25),.Pk_1_j(P25_25),.Gi_j(G26_25),.Pi_j(P26_25));

            BLACK_CELL INS1_27(.Gi_k(G27_27),.Pi_k(P27_27),.Gk_1_j(G26_26),.Pk_1_j(P26_26),.Gi_j(G27_26),.Pi_j(P27_26));

            BLACK_CELL INS1_28(.Gi_k(G28_28),.Pi_k(P28_28),.Gk_1_j(G27_27),.Pk_1_j(P27_27),.Gi_j(G28_27),.Pi_j(P28_27));

            BLACK_CELL INS1_29(.Gi_k(G29_29),.Pi_k(P29_29),.Gk_1_j(G28_28),.Pk_1_j(P28_28),.Gi_j(G29_28),.Pi_j(P29_28));

            BLACK_CELL INS1_30(.Gi_k(G30_30),.Pi_k(P30_30),.Gk_1_j(G29_29),.Pk_1_j(P29_29),.Gi_j(G30_29),.Pi_j(P30_29));

            BLACK_CELL INS1_31(.Gi_k(G31_31),.Pi_k(P31_31),.Gk_1_j(G30_30),.Pk_1_j(P30_30),.Gi_j(G31_30),.Pi_j(P31_30));

            BLACK_CELL INS1_32(.Gi_k(G32_32),.Pi_k(P32_32),.Gk_1_j(G31_31),.Pk_1_j(P31_31),.Gi_j(G32_31),.Pi_j(P32_31));

            BLACK_CELL INS1_33(.Gi_k(G33_33),.Pi_k(P33_33),.Gk_1_j(G32_32),.Pk_1_j(P32_32),.Gi_j(G33_32),.Pi_j(P33_32));

            BLACK_CELL INS1_34(.Gi_k(G34_34),.Pi_k(P34_34),.Gk_1_j(G33_33),.Pk_1_j(P33_33),.Gi_j(G34_33),.Pi_j(P34_33));

            BLACK_CELL INS1_35(.Gi_k(G35_35),.Pi_k(P35_35),.Gk_1_j(G34_34),.Pk_1_j(P34_34),.Gi_j(G35_34),.Pi_j(P35_34));

            BLACK_CELL INS1_36(.Gi_k(G36_36),.Pi_k(P36_36),.Gk_1_j(G35_35),.Pk_1_j(P35_35),.Gi_j(G36_35),.Pi_j(P36_35));

            BLACK_CELL INS1_37(.Gi_k(G37_37),.Pi_k(P37_37),.Gk_1_j(G36_36),.Pk_1_j(P36_36),.Gi_j(G37_36),.Pi_j(P37_36));

            BLACK_CELL INS1_38(.Gi_k(G38_38),.Pi_k(P38_38),.Gk_1_j(G37_37),.Pk_1_j(P37_37),.Gi_j(G38_37),.Pi_j(P38_37));

            BLACK_CELL INS1_39(.Gi_k(G39_39),.Pi_k(P39_39),.Gk_1_j(G38_38),.Pk_1_j(P38_38),.Gi_j(G39_38),.Pi_j(P39_38));

            BLACK_CELL INS1_40(.Gi_k(G40_40),.Pi_k(P40_40),.Gk_1_j(G39_39),.Pk_1_j(P39_39),.Gi_j(G40_39),.Pi_j(P40_39));

            BLACK_CELL INS1_41(.Gi_k(G41_41),.Pi_k(P41_41),.Gk_1_j(G40_40),.Pk_1_j(P40_40),.Gi_j(G41_40),.Pi_j(P41_40));

            BLACK_CELL INS1_42(.Gi_k(G42_42),.Pi_k(P42_42),.Gk_1_j(G41_41),.Pk_1_j(P41_41),.Gi_j(G42_41),.Pi_j(P42_41));

            BLACK_CELL INS1_43(.Gi_k(G43_43),.Pi_k(P43_43),.Gk_1_j(G42_42),.Pk_1_j(P42_42),.Gi_j(G43_42),.Pi_j(P43_42));

            BLACK_CELL INS1_44(.Gi_k(G44_44),.Pi_k(P44_44),.Gk_1_j(G43_43),.Pk_1_j(P43_43),.Gi_j(G44_43),.Pi_j(P44_43));

            BLACK_CELL INS1_45(.Gi_k(G45_45),.Pi_k(P45_45),.Gk_1_j(G44_44),.Pk_1_j(P44_44),.Gi_j(G45_44),.Pi_j(P45_44));

            BLACK_CELL INS1_46(.Gi_k(G46_46),.Pi_k(P46_46),.Gk_1_j(G45_45),.Pk_1_j(P45_45),.Gi_j(G46_45),.Pi_j(P46_45));

            BLACK_CELL INS1_47(.Gi_k(G47_47),.Pi_k(P47_47),.Gk_1_j(G46_46),.Pk_1_j(P46_46),.Gi_j(G47_46),.Pi_j(P47_46));

            BLACK_CELL INS1_48(.Gi_k(G48_48),.Pi_k(P48_48),.Gk_1_j(G47_47),.Pk_1_j(P47_47),.Gi_j(G48_47),.Pi_j(P48_47));

            BLACK_CELL INS1_49(.Gi_k(G49_49),.Pi_k(P49_49),.Gk_1_j(G48_48),.Pk_1_j(P48_48),.Gi_j(G49_48),.Pi_j(P49_48));

            BLACK_CELL INS1_50(.Gi_k(G50_50),.Pi_k(P50_50),.Gk_1_j(G49_49),.Pk_1_j(P49_49),.Gi_j(G50_49),.Pi_j(P50_49));

            BLACK_CELL INS1_51(.Gi_k(G51_51),.Pi_k(P51_51),.Gk_1_j(G50_50),.Pk_1_j(P50_50),.Gi_j(G51_50),.Pi_j(P51_50));

            BLACK_CELL INS1_52(.Gi_k(G52_52),.Pi_k(P52_52),.Gk_1_j(G51_51),.Pk_1_j(P51_51),.Gi_j(G52_51),.Pi_j(P52_51));

            BLACK_CELL INS1_53(.Gi_k(G53_53),.Pi_k(P53_53),.Gk_1_j(G52_52),.Pk_1_j(P52_52),.Gi_j(G53_52),.Pi_j(P53_52));

            BLACK_CELL INS1_54(.Gi_k(G54_54),.Pi_k(P54_54),.Gk_1_j(G53_53),.Pk_1_j(P53_53),.Gi_j(G54_53),.Pi_j(P54_53));

            BLACK_CELL INS1_55(.Gi_k(G55_55),.Pi_k(P55_55),.Gk_1_j(G54_54),.Pk_1_j(P54_54),.Gi_j(G55_54),.Pi_j(P55_54));

            BLACK_CELL INS1_56(.Gi_k(G56_56),.Pi_k(P56_56),.Gk_1_j(G55_55),.Pk_1_j(P55_55),.Gi_j(G56_55),.Pi_j(P56_55));

            BLACK_CELL INS1_57(.Gi_k(G57_57),.Pi_k(P57_57),.Gk_1_j(G56_56),.Pk_1_j(P56_56),.Gi_j(G57_56),.Pi_j(P57_56));

            BLACK_CELL INS1_58(.Gi_k(G58_58),.Pi_k(P58_58),.Gk_1_j(G57_57),.Pk_1_j(P57_57),.Gi_j(G58_57),.Pi_j(P58_57));

            BLACK_CELL INS1_59(.Gi_k(G59_59),.Pi_k(P59_59),.Gk_1_j(G58_58),.Pk_1_j(P58_58),.Gi_j(G59_58),.Pi_j(P59_58));

            BLACK_CELL INS1_60(.Gi_k(G60_60),.Pi_k(P60_60),.Gk_1_j(G59_59),.Pk_1_j(P59_59),.Gi_j(G60_59),.Pi_j(P60_59));

            BLACK_CELL INS1_61(.Gi_k(G61_61),.Pi_k(P61_61),.Gk_1_j(G60_60),.Pk_1_j(P60_60),.Gi_j(G61_60),.Pi_j(P61_60));

            BLACK_CELL INS1_62(.Gi_k(G62_62),.Pi_k(P62_62),.Gk_1_j(G61_61),.Pk_1_j(P61_61),.Gi_j(G62_61),.Pi_j(P62_61));

            BLACK_CELL INS1_63(.Gi_k(G63_63),.Pi_k(P63_63),.Gk_1_j(G62_62),.Pk_1_j(P62_62),.Gi_j(G63_62),.Pi_j(P63_62));

            BLACK_CELL INS1_64(.Gi_k(G64_64),.Pi_k(P64_64),.Gk_1_j(G63_63),.Pk_1_j(P63_63),.Gi_j(G64_63),.Pi_j(P64_63));

            BLACK_CELL INS1_65(.Gi_k(G65_65),.Pi_k(P65_65),.Gk_1_j(G64_64),.Pk_1_j(P64_64),.Gi_j(G65_64),.Pi_j(P65_64));

            BLACK_CELL INS1_66(.Gi_k(G66_66),.Pi_k(P66_66),.Gk_1_j(G65_65),.Pk_1_j(P65_65),.Gi_j(G66_65),.Pi_j(P66_65));

            BLACK_CELL INS1_67(.Gi_k(G67_67),.Pi_k(P67_67),.Gk_1_j(G66_66),.Pk_1_j(P66_66),.Gi_j(G67_66),.Pi_j(P67_66));

            BLACK_CELL INS1_68(.Gi_k(G68_68),.Pi_k(P68_68),.Gk_1_j(G67_67),.Pk_1_j(P67_67),.Gi_j(G68_67),.Pi_j(P68_67));

            BLACK_CELL INS1_69(.Gi_k(G69_69),.Pi_k(P69_69),.Gk_1_j(G68_68),.Pk_1_j(P68_68),.Gi_j(G69_68),.Pi_j(P69_68));

            BLACK_CELL INS1_70(.Gi_k(G70_70),.Pi_k(P70_70),.Gk_1_j(G69_69),.Pk_1_j(P69_69),.Gi_j(G70_69),.Pi_j(P70_69));

            BLACK_CELL INS1_71(.Gi_k(G71_71),.Pi_k(P71_71),.Gk_1_j(G70_70),.Pk_1_j(P70_70),.Gi_j(G71_70),.Pi_j(P71_70));

            BLACK_CELL INS1_72(.Gi_k(G72_72),.Pi_k(P72_72),.Gk_1_j(G71_71),.Pk_1_j(P71_71),.Gi_j(G72_71),.Pi_j(P72_71));

            BLACK_CELL INS1_73(.Gi_k(G73_73),.Pi_k(P73_73),.Gk_1_j(G72_72),.Pk_1_j(P72_72),.Gi_j(G73_72),.Pi_j(P73_72));

            BLACK_CELL INS1_74(.Gi_k(G74_74),.Pi_k(P74_74),.Gk_1_j(G73_73),.Pk_1_j(P73_73),.Gi_j(G74_73),.Pi_j(P74_73));

            BLACK_CELL INS1_75(.Gi_k(G75_75),.Pi_k(P75_75),.Gk_1_j(G74_74),.Pk_1_j(P74_74),.Gi_j(G75_74),.Pi_j(P75_74));

            BLACK_CELL INS1_76(.Gi_k(G76_76),.Pi_k(P76_76),.Gk_1_j(G75_75),.Pk_1_j(P75_75),.Gi_j(G76_75),.Pi_j(P76_75));

            BLACK_CELL INS1_77(.Gi_k(G77_77),.Pi_k(P77_77),.Gk_1_j(G76_76),.Pk_1_j(P76_76),.Gi_j(G77_76),.Pi_j(P77_76));

            BLACK_CELL INS1_78(.Gi_k(G78_78),.Pi_k(P78_78),.Gk_1_j(G77_77),.Pk_1_j(P77_77),.Gi_j(G78_77),.Pi_j(P78_77));

            BLACK_CELL INS1_79(.Gi_k(G79_79),.Pi_k(P79_79),.Gk_1_j(G78_78),.Pk_1_j(P78_78),.Gi_j(G79_78),.Pi_j(P79_78));

            BLACK_CELL INS1_80(.Gi_k(G80_80),.Pi_k(P80_80),.Gk_1_j(G79_79),.Pk_1_j(P79_79),.Gi_j(G80_79),.Pi_j(P80_79));

            BLACK_CELL INS1_81(.Gi_k(G81_81),.Pi_k(P81_81),.Gk_1_j(G80_80),.Pk_1_j(P80_80),.Gi_j(G81_80),.Pi_j(P81_80));

            BLACK_CELL INS1_82(.Gi_k(G82_82),.Pi_k(P82_82),.Gk_1_j(G81_81),.Pk_1_j(P81_81),.Gi_j(G82_81),.Pi_j(P82_81));

            BLACK_CELL INS1_83(.Gi_k(G83_83),.Pi_k(P83_83),.Gk_1_j(G82_82),.Pk_1_j(P82_82),.Gi_j(G83_82),.Pi_j(P83_82));

            BLACK_CELL INS1_84(.Gi_k(G84_84),.Pi_k(P84_84),.Gk_1_j(G83_83),.Pk_1_j(P83_83),.Gi_j(G84_83),.Pi_j(P84_83));

            BLACK_CELL INS1_85(.Gi_k(G85_85),.Pi_k(P85_85),.Gk_1_j(G84_84),.Pk_1_j(P84_84),.Gi_j(G85_84),.Pi_j(P85_84));

            BLACK_CELL INS1_86(.Gi_k(G86_86),.Pi_k(P86_86),.Gk_1_j(G85_85),.Pk_1_j(P85_85),.Gi_j(G86_85),.Pi_j(P86_85));

            BLACK_CELL INS1_87(.Gi_k(G87_87),.Pi_k(P87_87),.Gk_1_j(G86_86),.Pk_1_j(P86_86),.Gi_j(G87_86),.Pi_j(P87_86));

            BLACK_CELL INS1_88(.Gi_k(G88_88),.Pi_k(P88_88),.Gk_1_j(G87_87),.Pk_1_j(P87_87),.Gi_j(G88_87),.Pi_j(P88_87));

            BLACK_CELL INS1_89(.Gi_k(G89_89),.Pi_k(P89_89),.Gk_1_j(G88_88),.Pk_1_j(P88_88),.Gi_j(G89_88),.Pi_j(P89_88));

            BLACK_CELL INS1_90(.Gi_k(G90_90),.Pi_k(P90_90),.Gk_1_j(G89_89),.Pk_1_j(P89_89),.Gi_j(G90_89),.Pi_j(P90_89));

            BLACK_CELL INS1_91(.Gi_k(G91_91),.Pi_k(P91_91),.Gk_1_j(G90_90),.Pk_1_j(P90_90),.Gi_j(G91_90),.Pi_j(P91_90));

            BLACK_CELL INS1_92(.Gi_k(G92_92),.Pi_k(P92_92),.Gk_1_j(G91_91),.Pk_1_j(P91_91),.Gi_j(G92_91),.Pi_j(P92_91));

            BLACK_CELL INS1_93(.Gi_k(G93_93),.Pi_k(P93_93),.Gk_1_j(G92_92),.Pk_1_j(P92_92),.Gi_j(G93_92),.Pi_j(P93_92));

            BLACK_CELL INS1_94(.Gi_k(G94_94),.Pi_k(P94_94),.Gk_1_j(G93_93),.Pk_1_j(P93_93),.Gi_j(G94_93),.Pi_j(P94_93));

            BLACK_CELL INS1_95(.Gi_k(G95_95),.Pi_k(P95_95),.Gk_1_j(G94_94),.Pk_1_j(P94_94),.Gi_j(G95_94),.Pi_j(P95_94));

            BLACK_CELL INS1_96(.Gi_k(G96_96),.Pi_k(P96_96),.Gk_1_j(G95_95),.Pk_1_j(P95_95),.Gi_j(G96_95),.Pi_j(P96_95));

            BLACK_CELL INS1_97(.Gi_k(G97_97),.Pi_k(P97_97),.Gk_1_j(G96_96),.Pk_1_j(P96_96),.Gi_j(G97_96),.Pi_j(P97_96));

            BLACK_CELL INS1_98(.Gi_k(G98_98),.Pi_k(P98_98),.Gk_1_j(G97_97),.Pk_1_j(P97_97),.Gi_j(G98_97),.Pi_j(P98_97));

            BLACK_CELL INS1_99(.Gi_k(G99_99),.Pi_k(P99_99),.Gk_1_j(G98_98),.Pk_1_j(P98_98),.Gi_j(G99_98),.Pi_j(P99_98));

            BLACK_CELL INS1_100(.Gi_k(G100_100),.Pi_k(P100_100),.Gk_1_j(G99_99),.Pk_1_j(P99_99),.Gi_j(G100_99),.Pi_j(P100_99));

            BLACK_CELL INS1_101(.Gi_k(G101_101),.Pi_k(P101_101),.Gk_1_j(G100_100),.Pk_1_j(P100_100),.Gi_j(G101_100),.Pi_j(P101_100));

            BLACK_CELL INS1_102(.Gi_k(G102_102),.Pi_k(P102_102),.Gk_1_j(G101_101),.Pk_1_j(P101_101),.Gi_j(G102_101),.Pi_j(P102_101));

            BLACK_CELL INS1_103(.Gi_k(G103_103),.Pi_k(P103_103),.Gk_1_j(G102_102),.Pk_1_j(P102_102),.Gi_j(G103_102),.Pi_j(P103_102));

            BLACK_CELL INS1_104(.Gi_k(G104_104),.Pi_k(P104_104),.Gk_1_j(G103_103),.Pk_1_j(P103_103),.Gi_j(G104_103),.Pi_j(P104_103));

            BLACK_CELL INS1_105(.Gi_k(G105_105),.Pi_k(P105_105),.Gk_1_j(G104_104),.Pk_1_j(P104_104),.Gi_j(G105_104),.Pi_j(P105_104));

            BLACK_CELL INS1_106(.Gi_k(G106_106),.Pi_k(P106_106),.Gk_1_j(G105_105),.Pk_1_j(P105_105),.Gi_j(G106_105),.Pi_j(P106_105));

            BLACK_CELL INS1_107(.Gi_k(G107_107),.Pi_k(P107_107),.Gk_1_j(G106_106),.Pk_1_j(P106_106),.Gi_j(G107_106),.Pi_j(P107_106));

            BLACK_CELL INS1_108(.Gi_k(G108_108),.Pi_k(P108_108),.Gk_1_j(G107_107),.Pk_1_j(P107_107),.Gi_j(G108_107),.Pi_j(P108_107));

            BLACK_CELL INS1_109(.Gi_k(G109_109),.Pi_k(P109_109),.Gk_1_j(G108_108),.Pk_1_j(P108_108),.Gi_j(G109_108),.Pi_j(P109_108));

            BLACK_CELL INS1_110(.Gi_k(G110_110),.Pi_k(P110_110),.Gk_1_j(G109_109),.Pk_1_j(P109_109),.Gi_j(G110_109),.Pi_j(P110_109));

            BLACK_CELL INS1_111(.Gi_k(G111_111),.Pi_k(P111_111),.Gk_1_j(G110_110),.Pk_1_j(P110_110),.Gi_j(G111_110),.Pi_j(P111_110));

            BLACK_CELL INS1_112(.Gi_k(G112_112),.Pi_k(P112_112),.Gk_1_j(G111_111),.Pk_1_j(P111_111),.Gi_j(G112_111),.Pi_j(P112_111));

            BLACK_CELL INS1_113(.Gi_k(G113_113),.Pi_k(P113_113),.Gk_1_j(G112_112),.Pk_1_j(P112_112),.Gi_j(G113_112),.Pi_j(P113_112));

            BLACK_CELL INS1_114(.Gi_k(G114_114),.Pi_k(P114_114),.Gk_1_j(G113_113),.Pk_1_j(P113_113),.Gi_j(G114_113),.Pi_j(P114_113));

            BLACK_CELL INS1_115(.Gi_k(G115_115),.Pi_k(P115_115),.Gk_1_j(G114_114),.Pk_1_j(P114_114),.Gi_j(G115_114),.Pi_j(P115_114));

            BLACK_CELL INS1_116(.Gi_k(G116_116),.Pi_k(P116_116),.Gk_1_j(G115_115),.Pk_1_j(P115_115),.Gi_j(G116_115),.Pi_j(P116_115));

            BLACK_CELL INS1_117(.Gi_k(G117_117),.Pi_k(P117_117),.Gk_1_j(G116_116),.Pk_1_j(P116_116),.Gi_j(G117_116),.Pi_j(P117_116));

            BLACK_CELL INS1_118(.Gi_k(G118_118),.Pi_k(P118_118),.Gk_1_j(G117_117),.Pk_1_j(P117_117),.Gi_j(G118_117),.Pi_j(P118_117));

            BLACK_CELL INS1_119(.Gi_k(G119_119),.Pi_k(P119_119),.Gk_1_j(G118_118),.Pk_1_j(P118_118),.Gi_j(G119_118),.Pi_j(P119_118));

            BLACK_CELL INS1_120(.Gi_k(G120_120),.Pi_k(P120_120),.Gk_1_j(G119_119),.Pk_1_j(P119_119),.Gi_j(G120_119),.Pi_j(P120_119));

            BLACK_CELL INS1_121(.Gi_k(G121_121),.Pi_k(P121_121),.Gk_1_j(G120_120),.Pk_1_j(P120_120),.Gi_j(G121_120),.Pi_j(P121_120));

            BLACK_CELL INS1_122(.Gi_k(G122_122),.Pi_k(P122_122),.Gk_1_j(G121_121),.Pk_1_j(P121_121),.Gi_j(G122_121),.Pi_j(P122_121));

            BLACK_CELL INS1_123(.Gi_k(G123_123),.Pi_k(P123_123),.Gk_1_j(G122_122),.Pk_1_j(P122_122),.Gi_j(G123_122),.Pi_j(P123_122));

            BLACK_CELL INS1_124(.Gi_k(G124_124),.Pi_k(P124_124),.Gk_1_j(G123_123),.Pk_1_j(P123_123),.Gi_j(G124_123),.Pi_j(P124_123));

            BLACK_CELL INS1_125(.Gi_k(G125_125),.Pi_k(P125_125),.Gk_1_j(G124_124),.Pk_1_j(P124_124),.Gi_j(G125_124),.Pi_j(P125_124));

            BLACK_CELL INS1_126(.Gi_k(G126_126),.Pi_k(P126_126),.Gk_1_j(G125_125),.Pk_1_j(P125_125),.Gi_j(G126_125),.Pi_j(P126_125));

            BLACK_CELL INS1_127(.Gi_k(G127_127),.Pi_k(P127_127),.Gk_1_j(G126_126),.Pk_1_j(P126_126),.Gi_j(G127_126),.Pi_j(P127_126));

            BLACK_CELL INS1_128(.Gi_k(G128_128),.Pi_k(P128_128),.Gk_1_j(G127_127),.Pk_1_j(P127_127),.Gi_j(G128_127),.Pi_j(P128_127));

            BLACK_CELL INS1_129(.Gi_k(G129_129),.Pi_k(P129_129),.Gk_1_j(G128_128),.Pk_1_j(P128_128),.Gi_j(G129_128),.Pi_j(P129_128));

            GRAY_CELL INS2_2(.Gi_k(G2_1),.Pi_k(P2_1),.Gk_1_j(G0_0),.Gi_j(G2_0));

            GRAY_CELL INS2_3(.Gi_k(G3_2),.Pi_k(P3_2),.Gk_1_j(G1_0),.Gi_j(G3_0));

            BLACK_CELL INS2_4(.Gi_k(G4_3),.Pi_k(P4_3),.Gk_1_j(G2_1),.Pk_1_j(P2_1),.Gi_j(G4_1),.Pi_j(P4_1));

            BLACK_CELL INS2_5(.Gi_k(G5_4),.Pi_k(P5_4),.Gk_1_j(G3_2),.Pk_1_j(P3_2),.Gi_j(G5_2),.Pi_j(P5_2));

            BLACK_CELL INS2_6(.Gi_k(G6_5),.Pi_k(P6_5),.Gk_1_j(G4_3),.Pk_1_j(P4_3),.Gi_j(G6_3),.Pi_j(P6_3));

            BLACK_CELL INS2_7(.Gi_k(G7_6),.Pi_k(P7_6),.Gk_1_j(G5_4),.Pk_1_j(P5_4),.Gi_j(G7_4),.Pi_j(P7_4));

            BLACK_CELL INS2_8(.Gi_k(G8_7),.Pi_k(P8_7),.Gk_1_j(G6_5),.Pk_1_j(P6_5),.Gi_j(G8_5),.Pi_j(P8_5));

            BLACK_CELL INS2_9(.Gi_k(G9_8),.Pi_k(P9_8),.Gk_1_j(G7_6),.Pk_1_j(P7_6),.Gi_j(G9_6),.Pi_j(P9_6));

            BLACK_CELL INS2_10(.Gi_k(G10_9),.Pi_k(P10_9),.Gk_1_j(G8_7),.Pk_1_j(P8_7),.Gi_j(G10_7),.Pi_j(P10_7));

            BLACK_CELL INS2_11(.Gi_k(G11_10),.Pi_k(P11_10),.Gk_1_j(G9_8),.Pk_1_j(P9_8),.Gi_j(G11_8),.Pi_j(P11_8));

            BLACK_CELL INS2_12(.Gi_k(G12_11),.Pi_k(P12_11),.Gk_1_j(G10_9),.Pk_1_j(P10_9),.Gi_j(G12_9),.Pi_j(P12_9));

            BLACK_CELL INS2_13(.Gi_k(G13_12),.Pi_k(P13_12),.Gk_1_j(G11_10),.Pk_1_j(P11_10),.Gi_j(G13_10),.Pi_j(P13_10));

            BLACK_CELL INS2_14(.Gi_k(G14_13),.Pi_k(P14_13),.Gk_1_j(G12_11),.Pk_1_j(P12_11),.Gi_j(G14_11),.Pi_j(P14_11));

            BLACK_CELL INS2_15(.Gi_k(G15_14),.Pi_k(P15_14),.Gk_1_j(G13_12),.Pk_1_j(P13_12),.Gi_j(G15_12),.Pi_j(P15_12));

            BLACK_CELL INS2_16(.Gi_k(G16_15),.Pi_k(P16_15),.Gk_1_j(G14_13),.Pk_1_j(P14_13),.Gi_j(G16_13),.Pi_j(P16_13));

            BLACK_CELL INS2_17(.Gi_k(G17_16),.Pi_k(P17_16),.Gk_1_j(G15_14),.Pk_1_j(P15_14),.Gi_j(G17_14),.Pi_j(P17_14));

            BLACK_CELL INS2_18(.Gi_k(G18_17),.Pi_k(P18_17),.Gk_1_j(G16_15),.Pk_1_j(P16_15),.Gi_j(G18_15),.Pi_j(P18_15));

            BLACK_CELL INS2_19(.Gi_k(G19_18),.Pi_k(P19_18),.Gk_1_j(G17_16),.Pk_1_j(P17_16),.Gi_j(G19_16),.Pi_j(P19_16));

            BLACK_CELL INS2_20(.Gi_k(G20_19),.Pi_k(P20_19),.Gk_1_j(G18_17),.Pk_1_j(P18_17),.Gi_j(G20_17),.Pi_j(P20_17));

            BLACK_CELL INS2_21(.Gi_k(G21_20),.Pi_k(P21_20),.Gk_1_j(G19_18),.Pk_1_j(P19_18),.Gi_j(G21_18),.Pi_j(P21_18));

            BLACK_CELL INS2_22(.Gi_k(G22_21),.Pi_k(P22_21),.Gk_1_j(G20_19),.Pk_1_j(P20_19),.Gi_j(G22_19),.Pi_j(P22_19));

            BLACK_CELL INS2_23(.Gi_k(G23_22),.Pi_k(P23_22),.Gk_1_j(G21_20),.Pk_1_j(P21_20),.Gi_j(G23_20),.Pi_j(P23_20));

            BLACK_CELL INS2_24(.Gi_k(G24_23),.Pi_k(P24_23),.Gk_1_j(G22_21),.Pk_1_j(P22_21),.Gi_j(G24_21),.Pi_j(P24_21));

            BLACK_CELL INS2_25(.Gi_k(G25_24),.Pi_k(P25_24),.Gk_1_j(G23_22),.Pk_1_j(P23_22),.Gi_j(G25_22),.Pi_j(P25_22));

            BLACK_CELL INS2_26(.Gi_k(G26_25),.Pi_k(P26_25),.Gk_1_j(G24_23),.Pk_1_j(P24_23),.Gi_j(G26_23),.Pi_j(P26_23));

            BLACK_CELL INS2_27(.Gi_k(G27_26),.Pi_k(P27_26),.Gk_1_j(G25_24),.Pk_1_j(P25_24),.Gi_j(G27_24),.Pi_j(P27_24));

            BLACK_CELL INS2_28(.Gi_k(G28_27),.Pi_k(P28_27),.Gk_1_j(G26_25),.Pk_1_j(P26_25),.Gi_j(G28_25),.Pi_j(P28_25));

            BLACK_CELL INS2_29(.Gi_k(G29_28),.Pi_k(P29_28),.Gk_1_j(G27_26),.Pk_1_j(P27_26),.Gi_j(G29_26),.Pi_j(P29_26));

            BLACK_CELL INS2_30(.Gi_k(G30_29),.Pi_k(P30_29),.Gk_1_j(G28_27),.Pk_1_j(P28_27),.Gi_j(G30_27),.Pi_j(P30_27));

            BLACK_CELL INS2_31(.Gi_k(G31_30),.Pi_k(P31_30),.Gk_1_j(G29_28),.Pk_1_j(P29_28),.Gi_j(G31_28),.Pi_j(P31_28));

            BLACK_CELL INS2_32(.Gi_k(G32_31),.Pi_k(P32_31),.Gk_1_j(G30_29),.Pk_1_j(P30_29),.Gi_j(G32_29),.Pi_j(P32_29));

            BLACK_CELL INS2_33(.Gi_k(G33_32),.Pi_k(P33_32),.Gk_1_j(G31_30),.Pk_1_j(P31_30),.Gi_j(G33_30),.Pi_j(P33_30));

            BLACK_CELL INS2_34(.Gi_k(G34_33),.Pi_k(P34_33),.Gk_1_j(G32_31),.Pk_1_j(P32_31),.Gi_j(G34_31),.Pi_j(P34_31));

            BLACK_CELL INS2_35(.Gi_k(G35_34),.Pi_k(P35_34),.Gk_1_j(G33_32),.Pk_1_j(P33_32),.Gi_j(G35_32),.Pi_j(P35_32));

            BLACK_CELL INS2_36(.Gi_k(G36_35),.Pi_k(P36_35),.Gk_1_j(G34_33),.Pk_1_j(P34_33),.Gi_j(G36_33),.Pi_j(P36_33));

            BLACK_CELL INS2_37(.Gi_k(G37_36),.Pi_k(P37_36),.Gk_1_j(G35_34),.Pk_1_j(P35_34),.Gi_j(G37_34),.Pi_j(P37_34));

            BLACK_CELL INS2_38(.Gi_k(G38_37),.Pi_k(P38_37),.Gk_1_j(G36_35),.Pk_1_j(P36_35),.Gi_j(G38_35),.Pi_j(P38_35));

            BLACK_CELL INS2_39(.Gi_k(G39_38),.Pi_k(P39_38),.Gk_1_j(G37_36),.Pk_1_j(P37_36),.Gi_j(G39_36),.Pi_j(P39_36));

            BLACK_CELL INS2_40(.Gi_k(G40_39),.Pi_k(P40_39),.Gk_1_j(G38_37),.Pk_1_j(P38_37),.Gi_j(G40_37),.Pi_j(P40_37));

            BLACK_CELL INS2_41(.Gi_k(G41_40),.Pi_k(P41_40),.Gk_1_j(G39_38),.Pk_1_j(P39_38),.Gi_j(G41_38),.Pi_j(P41_38));

            BLACK_CELL INS2_42(.Gi_k(G42_41),.Pi_k(P42_41),.Gk_1_j(G40_39),.Pk_1_j(P40_39),.Gi_j(G42_39),.Pi_j(P42_39));

            BLACK_CELL INS2_43(.Gi_k(G43_42),.Pi_k(P43_42),.Gk_1_j(G41_40),.Pk_1_j(P41_40),.Gi_j(G43_40),.Pi_j(P43_40));

            BLACK_CELL INS2_44(.Gi_k(G44_43),.Pi_k(P44_43),.Gk_1_j(G42_41),.Pk_1_j(P42_41),.Gi_j(G44_41),.Pi_j(P44_41));

            BLACK_CELL INS2_45(.Gi_k(G45_44),.Pi_k(P45_44),.Gk_1_j(G43_42),.Pk_1_j(P43_42),.Gi_j(G45_42),.Pi_j(P45_42));

            BLACK_CELL INS2_46(.Gi_k(G46_45),.Pi_k(P46_45),.Gk_1_j(G44_43),.Pk_1_j(P44_43),.Gi_j(G46_43),.Pi_j(P46_43));

            BLACK_CELL INS2_47(.Gi_k(G47_46),.Pi_k(P47_46),.Gk_1_j(G45_44),.Pk_1_j(P45_44),.Gi_j(G47_44),.Pi_j(P47_44));

            BLACK_CELL INS2_48(.Gi_k(G48_47),.Pi_k(P48_47),.Gk_1_j(G46_45),.Pk_1_j(P46_45),.Gi_j(G48_45),.Pi_j(P48_45));

            BLACK_CELL INS2_49(.Gi_k(G49_48),.Pi_k(P49_48),.Gk_1_j(G47_46),.Pk_1_j(P47_46),.Gi_j(G49_46),.Pi_j(P49_46));

            BLACK_CELL INS2_50(.Gi_k(G50_49),.Pi_k(P50_49),.Gk_1_j(G48_47),.Pk_1_j(P48_47),.Gi_j(G50_47),.Pi_j(P50_47));

            BLACK_CELL INS2_51(.Gi_k(G51_50),.Pi_k(P51_50),.Gk_1_j(G49_48),.Pk_1_j(P49_48),.Gi_j(G51_48),.Pi_j(P51_48));

            BLACK_CELL INS2_52(.Gi_k(G52_51),.Pi_k(P52_51),.Gk_1_j(G50_49),.Pk_1_j(P50_49),.Gi_j(G52_49),.Pi_j(P52_49));

            BLACK_CELL INS2_53(.Gi_k(G53_52),.Pi_k(P53_52),.Gk_1_j(G51_50),.Pk_1_j(P51_50),.Gi_j(G53_50),.Pi_j(P53_50));

            BLACK_CELL INS2_54(.Gi_k(G54_53),.Pi_k(P54_53),.Gk_1_j(G52_51),.Pk_1_j(P52_51),.Gi_j(G54_51),.Pi_j(P54_51));

            BLACK_CELL INS2_55(.Gi_k(G55_54),.Pi_k(P55_54),.Gk_1_j(G53_52),.Pk_1_j(P53_52),.Gi_j(G55_52),.Pi_j(P55_52));

            BLACK_CELL INS2_56(.Gi_k(G56_55),.Pi_k(P56_55),.Gk_1_j(G54_53),.Pk_1_j(P54_53),.Gi_j(G56_53),.Pi_j(P56_53));

            BLACK_CELL INS2_57(.Gi_k(G57_56),.Pi_k(P57_56),.Gk_1_j(G55_54),.Pk_1_j(P55_54),.Gi_j(G57_54),.Pi_j(P57_54));

            BLACK_CELL INS2_58(.Gi_k(G58_57),.Pi_k(P58_57),.Gk_1_j(G56_55),.Pk_1_j(P56_55),.Gi_j(G58_55),.Pi_j(P58_55));

            BLACK_CELL INS2_59(.Gi_k(G59_58),.Pi_k(P59_58),.Gk_1_j(G57_56),.Pk_1_j(P57_56),.Gi_j(G59_56),.Pi_j(P59_56));

            BLACK_CELL INS2_60(.Gi_k(G60_59),.Pi_k(P60_59),.Gk_1_j(G58_57),.Pk_1_j(P58_57),.Gi_j(G60_57),.Pi_j(P60_57));

            BLACK_CELL INS2_61(.Gi_k(G61_60),.Pi_k(P61_60),.Gk_1_j(G59_58),.Pk_1_j(P59_58),.Gi_j(G61_58),.Pi_j(P61_58));

            BLACK_CELL INS2_62(.Gi_k(G62_61),.Pi_k(P62_61),.Gk_1_j(G60_59),.Pk_1_j(P60_59),.Gi_j(G62_59),.Pi_j(P62_59));

            BLACK_CELL INS2_63(.Gi_k(G63_62),.Pi_k(P63_62),.Gk_1_j(G61_60),.Pk_1_j(P61_60),.Gi_j(G63_60),.Pi_j(P63_60));

            BLACK_CELL INS2_64(.Gi_k(G64_63),.Pi_k(P64_63),.Gk_1_j(G62_61),.Pk_1_j(P62_61),.Gi_j(G64_61),.Pi_j(P64_61));

            BLACK_CELL INS2_65(.Gi_k(G65_64),.Pi_k(P65_64),.Gk_1_j(G63_62),.Pk_1_j(P63_62),.Gi_j(G65_62),.Pi_j(P65_62));

            BLACK_CELL INS2_66(.Gi_k(G66_65),.Pi_k(P66_65),.Gk_1_j(G64_63),.Pk_1_j(P64_63),.Gi_j(G66_63),.Pi_j(P66_63));

            BLACK_CELL INS2_67(.Gi_k(G67_66),.Pi_k(P67_66),.Gk_1_j(G65_64),.Pk_1_j(P65_64),.Gi_j(G67_64),.Pi_j(P67_64));

            BLACK_CELL INS2_68(.Gi_k(G68_67),.Pi_k(P68_67),.Gk_1_j(G66_65),.Pk_1_j(P66_65),.Gi_j(G68_65),.Pi_j(P68_65));

            BLACK_CELL INS2_69(.Gi_k(G69_68),.Pi_k(P69_68),.Gk_1_j(G67_66),.Pk_1_j(P67_66),.Gi_j(G69_66),.Pi_j(P69_66));

            BLACK_CELL INS2_70(.Gi_k(G70_69),.Pi_k(P70_69),.Gk_1_j(G68_67),.Pk_1_j(P68_67),.Gi_j(G70_67),.Pi_j(P70_67));

            BLACK_CELL INS2_71(.Gi_k(G71_70),.Pi_k(P71_70),.Gk_1_j(G69_68),.Pk_1_j(P69_68),.Gi_j(G71_68),.Pi_j(P71_68));

            BLACK_CELL INS2_72(.Gi_k(G72_71),.Pi_k(P72_71),.Gk_1_j(G70_69),.Pk_1_j(P70_69),.Gi_j(G72_69),.Pi_j(P72_69));

            BLACK_CELL INS2_73(.Gi_k(G73_72),.Pi_k(P73_72),.Gk_1_j(G71_70),.Pk_1_j(P71_70),.Gi_j(G73_70),.Pi_j(P73_70));

            BLACK_CELL INS2_74(.Gi_k(G74_73),.Pi_k(P74_73),.Gk_1_j(G72_71),.Pk_1_j(P72_71),.Gi_j(G74_71),.Pi_j(P74_71));

            BLACK_CELL INS2_75(.Gi_k(G75_74),.Pi_k(P75_74),.Gk_1_j(G73_72),.Pk_1_j(P73_72),.Gi_j(G75_72),.Pi_j(P75_72));

            BLACK_CELL INS2_76(.Gi_k(G76_75),.Pi_k(P76_75),.Gk_1_j(G74_73),.Pk_1_j(P74_73),.Gi_j(G76_73),.Pi_j(P76_73));

            BLACK_CELL INS2_77(.Gi_k(G77_76),.Pi_k(P77_76),.Gk_1_j(G75_74),.Pk_1_j(P75_74),.Gi_j(G77_74),.Pi_j(P77_74));

            BLACK_CELL INS2_78(.Gi_k(G78_77),.Pi_k(P78_77),.Gk_1_j(G76_75),.Pk_1_j(P76_75),.Gi_j(G78_75),.Pi_j(P78_75));

            BLACK_CELL INS2_79(.Gi_k(G79_78),.Pi_k(P79_78),.Gk_1_j(G77_76),.Pk_1_j(P77_76),.Gi_j(G79_76),.Pi_j(P79_76));

            BLACK_CELL INS2_80(.Gi_k(G80_79),.Pi_k(P80_79),.Gk_1_j(G78_77),.Pk_1_j(P78_77),.Gi_j(G80_77),.Pi_j(P80_77));

            BLACK_CELL INS2_81(.Gi_k(G81_80),.Pi_k(P81_80),.Gk_1_j(G79_78),.Pk_1_j(P79_78),.Gi_j(G81_78),.Pi_j(P81_78));

            BLACK_CELL INS2_82(.Gi_k(G82_81),.Pi_k(P82_81),.Gk_1_j(G80_79),.Pk_1_j(P80_79),.Gi_j(G82_79),.Pi_j(P82_79));

            BLACK_CELL INS2_83(.Gi_k(G83_82),.Pi_k(P83_82),.Gk_1_j(G81_80),.Pk_1_j(P81_80),.Gi_j(G83_80),.Pi_j(P83_80));

            BLACK_CELL INS2_84(.Gi_k(G84_83),.Pi_k(P84_83),.Gk_1_j(G82_81),.Pk_1_j(P82_81),.Gi_j(G84_81),.Pi_j(P84_81));

            BLACK_CELL INS2_85(.Gi_k(G85_84),.Pi_k(P85_84),.Gk_1_j(G83_82),.Pk_1_j(P83_82),.Gi_j(G85_82),.Pi_j(P85_82));

            BLACK_CELL INS2_86(.Gi_k(G86_85),.Pi_k(P86_85),.Gk_1_j(G84_83),.Pk_1_j(P84_83),.Gi_j(G86_83),.Pi_j(P86_83));

            BLACK_CELL INS2_87(.Gi_k(G87_86),.Pi_k(P87_86),.Gk_1_j(G85_84),.Pk_1_j(P85_84),.Gi_j(G87_84),.Pi_j(P87_84));

            BLACK_CELL INS2_88(.Gi_k(G88_87),.Pi_k(P88_87),.Gk_1_j(G86_85),.Pk_1_j(P86_85),.Gi_j(G88_85),.Pi_j(P88_85));

            BLACK_CELL INS2_89(.Gi_k(G89_88),.Pi_k(P89_88),.Gk_1_j(G87_86),.Pk_1_j(P87_86),.Gi_j(G89_86),.Pi_j(P89_86));

            BLACK_CELL INS2_90(.Gi_k(G90_89),.Pi_k(P90_89),.Gk_1_j(G88_87),.Pk_1_j(P88_87),.Gi_j(G90_87),.Pi_j(P90_87));

            BLACK_CELL INS2_91(.Gi_k(G91_90),.Pi_k(P91_90),.Gk_1_j(G89_88),.Pk_1_j(P89_88),.Gi_j(G91_88),.Pi_j(P91_88));

            BLACK_CELL INS2_92(.Gi_k(G92_91),.Pi_k(P92_91),.Gk_1_j(G90_89),.Pk_1_j(P90_89),.Gi_j(G92_89),.Pi_j(P92_89));

            BLACK_CELL INS2_93(.Gi_k(G93_92),.Pi_k(P93_92),.Gk_1_j(G91_90),.Pk_1_j(P91_90),.Gi_j(G93_90),.Pi_j(P93_90));

            BLACK_CELL INS2_94(.Gi_k(G94_93),.Pi_k(P94_93),.Gk_1_j(G92_91),.Pk_1_j(P92_91),.Gi_j(G94_91),.Pi_j(P94_91));

            BLACK_CELL INS2_95(.Gi_k(G95_94),.Pi_k(P95_94),.Gk_1_j(G93_92),.Pk_1_j(P93_92),.Gi_j(G95_92),.Pi_j(P95_92));

            BLACK_CELL INS2_96(.Gi_k(G96_95),.Pi_k(P96_95),.Gk_1_j(G94_93),.Pk_1_j(P94_93),.Gi_j(G96_93),.Pi_j(P96_93));

            BLACK_CELL INS2_97(.Gi_k(G97_96),.Pi_k(P97_96),.Gk_1_j(G95_94),.Pk_1_j(P95_94),.Gi_j(G97_94),.Pi_j(P97_94));

            BLACK_CELL INS2_98(.Gi_k(G98_97),.Pi_k(P98_97),.Gk_1_j(G96_95),.Pk_1_j(P96_95),.Gi_j(G98_95),.Pi_j(P98_95));

            BLACK_CELL INS2_99(.Gi_k(G99_98),.Pi_k(P99_98),.Gk_1_j(G97_96),.Pk_1_j(P97_96),.Gi_j(G99_96),.Pi_j(P99_96));

            BLACK_CELL INS2_100(.Gi_k(G100_99),.Pi_k(P100_99),.Gk_1_j(G98_97),.Pk_1_j(P98_97),.Gi_j(G100_97),.Pi_j(P100_97));

            BLACK_CELL INS2_101(.Gi_k(G101_100),.Pi_k(P101_100),.Gk_1_j(G99_98),.Pk_1_j(P99_98),.Gi_j(G101_98),.Pi_j(P101_98));

            BLACK_CELL INS2_102(.Gi_k(G102_101),.Pi_k(P102_101),.Gk_1_j(G100_99),.Pk_1_j(P100_99),.Gi_j(G102_99),.Pi_j(P102_99));

            BLACK_CELL INS2_103(.Gi_k(G103_102),.Pi_k(P103_102),.Gk_1_j(G101_100),.Pk_1_j(P101_100),.Gi_j(G103_100),.Pi_j(P103_100));

            BLACK_CELL INS2_104(.Gi_k(G104_103),.Pi_k(P104_103),.Gk_1_j(G102_101),.Pk_1_j(P102_101),.Gi_j(G104_101),.Pi_j(P104_101));

            BLACK_CELL INS2_105(.Gi_k(G105_104),.Pi_k(P105_104),.Gk_1_j(G103_102),.Pk_1_j(P103_102),.Gi_j(G105_102),.Pi_j(P105_102));

            BLACK_CELL INS2_106(.Gi_k(G106_105),.Pi_k(P106_105),.Gk_1_j(G104_103),.Pk_1_j(P104_103),.Gi_j(G106_103),.Pi_j(P106_103));

            BLACK_CELL INS2_107(.Gi_k(G107_106),.Pi_k(P107_106),.Gk_1_j(G105_104),.Pk_1_j(P105_104),.Gi_j(G107_104),.Pi_j(P107_104));

            BLACK_CELL INS2_108(.Gi_k(G108_107),.Pi_k(P108_107),.Gk_1_j(G106_105),.Pk_1_j(P106_105),.Gi_j(G108_105),.Pi_j(P108_105));

            BLACK_CELL INS2_109(.Gi_k(G109_108),.Pi_k(P109_108),.Gk_1_j(G107_106),.Pk_1_j(P107_106),.Gi_j(G109_106),.Pi_j(P109_106));

            BLACK_CELL INS2_110(.Gi_k(G110_109),.Pi_k(P110_109),.Gk_1_j(G108_107),.Pk_1_j(P108_107),.Gi_j(G110_107),.Pi_j(P110_107));

            BLACK_CELL INS2_111(.Gi_k(G111_110),.Pi_k(P111_110),.Gk_1_j(G109_108),.Pk_1_j(P109_108),.Gi_j(G111_108),.Pi_j(P111_108));

            BLACK_CELL INS2_112(.Gi_k(G112_111),.Pi_k(P112_111),.Gk_1_j(G110_109),.Pk_1_j(P110_109),.Gi_j(G112_109),.Pi_j(P112_109));

            BLACK_CELL INS2_113(.Gi_k(G113_112),.Pi_k(P113_112),.Gk_1_j(G111_110),.Pk_1_j(P111_110),.Gi_j(G113_110),.Pi_j(P113_110));

            BLACK_CELL INS2_114(.Gi_k(G114_113),.Pi_k(P114_113),.Gk_1_j(G112_111),.Pk_1_j(P112_111),.Gi_j(G114_111),.Pi_j(P114_111));

            BLACK_CELL INS2_115(.Gi_k(G115_114),.Pi_k(P115_114),.Gk_1_j(G113_112),.Pk_1_j(P113_112),.Gi_j(G115_112),.Pi_j(P115_112));

            BLACK_CELL INS2_116(.Gi_k(G116_115),.Pi_k(P116_115),.Gk_1_j(G114_113),.Pk_1_j(P114_113),.Gi_j(G116_113),.Pi_j(P116_113));

            BLACK_CELL INS2_117(.Gi_k(G117_116),.Pi_k(P117_116),.Gk_1_j(G115_114),.Pk_1_j(P115_114),.Gi_j(G117_114),.Pi_j(P117_114));

            BLACK_CELL INS2_118(.Gi_k(G118_117),.Pi_k(P118_117),.Gk_1_j(G116_115),.Pk_1_j(P116_115),.Gi_j(G118_115),.Pi_j(P118_115));

            BLACK_CELL INS2_119(.Gi_k(G119_118),.Pi_k(P119_118),.Gk_1_j(G117_116),.Pk_1_j(P117_116),.Gi_j(G119_116),.Pi_j(P119_116));

            BLACK_CELL INS2_120(.Gi_k(G120_119),.Pi_k(P120_119),.Gk_1_j(G118_117),.Pk_1_j(P118_117),.Gi_j(G120_117),.Pi_j(P120_117));

            BLACK_CELL INS2_121(.Gi_k(G121_120),.Pi_k(P121_120),.Gk_1_j(G119_118),.Pk_1_j(P119_118),.Gi_j(G121_118),.Pi_j(P121_118));

            BLACK_CELL INS2_122(.Gi_k(G122_121),.Pi_k(P122_121),.Gk_1_j(G120_119),.Pk_1_j(P120_119),.Gi_j(G122_119),.Pi_j(P122_119));

            BLACK_CELL INS2_123(.Gi_k(G123_122),.Pi_k(P123_122),.Gk_1_j(G121_120),.Pk_1_j(P121_120),.Gi_j(G123_120),.Pi_j(P123_120));

            BLACK_CELL INS2_124(.Gi_k(G124_123),.Pi_k(P124_123),.Gk_1_j(G122_121),.Pk_1_j(P122_121),.Gi_j(G124_121),.Pi_j(P124_121));

            BLACK_CELL INS2_125(.Gi_k(G125_124),.Pi_k(P125_124),.Gk_1_j(G123_122),.Pk_1_j(P123_122),.Gi_j(G125_122),.Pi_j(P125_122));

            BLACK_CELL INS2_126(.Gi_k(G126_125),.Pi_k(P126_125),.Gk_1_j(G124_123),.Pk_1_j(P124_123),.Gi_j(G126_123),.Pi_j(P126_123));

            BLACK_CELL INS2_127(.Gi_k(G127_126),.Pi_k(P127_126),.Gk_1_j(G125_124),.Pk_1_j(P125_124),.Gi_j(G127_124),.Pi_j(P127_124));

            BLACK_CELL INS2_128(.Gi_k(G128_127),.Pi_k(P128_127),.Gk_1_j(G126_125),.Pk_1_j(P126_125),.Gi_j(G128_125),.Pi_j(P128_125));

            BLACK_CELL INS2_129(.Gi_k(G129_128),.Pi_k(P129_128),.Gk_1_j(G127_126),.Pk_1_j(P127_126),.Gi_j(G129_126),.Pi_j(P129_126));

            GRAY_CELL INS3_4(.Gi_k(G4_1),.Pi_k(P4_1),.Gk_1_j(G0_0),.Gi_j(G4_0));

            GRAY_CELL INS3_5(.Gi_k(G5_2),.Pi_k(P5_2),.Gk_1_j(G1_0),.Gi_j(G5_0));

            GRAY_CELL INS3_6(.Gi_k(G6_3),.Pi_k(P6_3),.Gk_1_j(G2_0),.Gi_j(G6_0));

            GRAY_CELL INS3_7(.Gi_k(G7_4),.Pi_k(P7_4),.Gk_1_j(G3_0),.Gi_j(G7_0));

            BLACK_CELL INS3_8(.Gi_k(G8_5),.Pi_k(P8_5),.Gk_1_j(G4_1),.Pk_1_j(P4_1),.Gi_j(G8_1),.Pi_j(P8_1));

            BLACK_CELL INS3_9(.Gi_k(G9_6),.Pi_k(P9_6),.Gk_1_j(G5_2),.Pk_1_j(P5_2),.Gi_j(G9_2),.Pi_j(P9_2));

            BLACK_CELL INS3_10(.Gi_k(G10_7),.Pi_k(P10_7),.Gk_1_j(G6_3),.Pk_1_j(P6_3),.Gi_j(G10_3),.Pi_j(P10_3));

            BLACK_CELL INS3_11(.Gi_k(G11_8),.Pi_k(P11_8),.Gk_1_j(G7_4),.Pk_1_j(P7_4),.Gi_j(G11_4),.Pi_j(P11_4));

            BLACK_CELL INS3_12(.Gi_k(G12_9),.Pi_k(P12_9),.Gk_1_j(G8_5),.Pk_1_j(P8_5),.Gi_j(G12_5),.Pi_j(P12_5));

            BLACK_CELL INS3_13(.Gi_k(G13_10),.Pi_k(P13_10),.Gk_1_j(G9_6),.Pk_1_j(P9_6),.Gi_j(G13_6),.Pi_j(P13_6));

            BLACK_CELL INS3_14(.Gi_k(G14_11),.Pi_k(P14_11),.Gk_1_j(G10_7),.Pk_1_j(P10_7),.Gi_j(G14_7),.Pi_j(P14_7));

            BLACK_CELL INS3_15(.Gi_k(G15_12),.Pi_k(P15_12),.Gk_1_j(G11_8),.Pk_1_j(P11_8),.Gi_j(G15_8),.Pi_j(P15_8));

            BLACK_CELL INS3_16(.Gi_k(G16_13),.Pi_k(P16_13),.Gk_1_j(G12_9),.Pk_1_j(P12_9),.Gi_j(G16_9),.Pi_j(P16_9));

            BLACK_CELL INS3_17(.Gi_k(G17_14),.Pi_k(P17_14),.Gk_1_j(G13_10),.Pk_1_j(P13_10),.Gi_j(G17_10),.Pi_j(P17_10));

            BLACK_CELL INS3_18(.Gi_k(G18_15),.Pi_k(P18_15),.Gk_1_j(G14_11),.Pk_1_j(P14_11),.Gi_j(G18_11),.Pi_j(P18_11));

            BLACK_CELL INS3_19(.Gi_k(G19_16),.Pi_k(P19_16),.Gk_1_j(G15_12),.Pk_1_j(P15_12),.Gi_j(G19_12),.Pi_j(P19_12));

            BLACK_CELL INS3_20(.Gi_k(G20_17),.Pi_k(P20_17),.Gk_1_j(G16_13),.Pk_1_j(P16_13),.Gi_j(G20_13),.Pi_j(P20_13));

            BLACK_CELL INS3_21(.Gi_k(G21_18),.Pi_k(P21_18),.Gk_1_j(G17_14),.Pk_1_j(P17_14),.Gi_j(G21_14),.Pi_j(P21_14));

            BLACK_CELL INS3_22(.Gi_k(G22_19),.Pi_k(P22_19),.Gk_1_j(G18_15),.Pk_1_j(P18_15),.Gi_j(G22_15),.Pi_j(P22_15));

            BLACK_CELL INS3_23(.Gi_k(G23_20),.Pi_k(P23_20),.Gk_1_j(G19_16),.Pk_1_j(P19_16),.Gi_j(G23_16),.Pi_j(P23_16));

            BLACK_CELL INS3_24(.Gi_k(G24_21),.Pi_k(P24_21),.Gk_1_j(G20_17),.Pk_1_j(P20_17),.Gi_j(G24_17),.Pi_j(P24_17));

            BLACK_CELL INS3_25(.Gi_k(G25_22),.Pi_k(P25_22),.Gk_1_j(G21_18),.Pk_1_j(P21_18),.Gi_j(G25_18),.Pi_j(P25_18));

            BLACK_CELL INS3_26(.Gi_k(G26_23),.Pi_k(P26_23),.Gk_1_j(G22_19),.Pk_1_j(P22_19),.Gi_j(G26_19),.Pi_j(P26_19));

            BLACK_CELL INS3_27(.Gi_k(G27_24),.Pi_k(P27_24),.Gk_1_j(G23_20),.Pk_1_j(P23_20),.Gi_j(G27_20),.Pi_j(P27_20));

            BLACK_CELL INS3_28(.Gi_k(G28_25),.Pi_k(P28_25),.Gk_1_j(G24_21),.Pk_1_j(P24_21),.Gi_j(G28_21),.Pi_j(P28_21));

            BLACK_CELL INS3_29(.Gi_k(G29_26),.Pi_k(P29_26),.Gk_1_j(G25_22),.Pk_1_j(P25_22),.Gi_j(G29_22),.Pi_j(P29_22));

            BLACK_CELL INS3_30(.Gi_k(G30_27),.Pi_k(P30_27),.Gk_1_j(G26_23),.Pk_1_j(P26_23),.Gi_j(G30_23),.Pi_j(P30_23));

            BLACK_CELL INS3_31(.Gi_k(G31_28),.Pi_k(P31_28),.Gk_1_j(G27_24),.Pk_1_j(P27_24),.Gi_j(G31_24),.Pi_j(P31_24));

            BLACK_CELL INS3_32(.Gi_k(G32_29),.Pi_k(P32_29),.Gk_1_j(G28_25),.Pk_1_j(P28_25),.Gi_j(G32_25),.Pi_j(P32_25));

            BLACK_CELL INS3_33(.Gi_k(G33_30),.Pi_k(P33_30),.Gk_1_j(G29_26),.Pk_1_j(P29_26),.Gi_j(G33_26),.Pi_j(P33_26));

            BLACK_CELL INS3_34(.Gi_k(G34_31),.Pi_k(P34_31),.Gk_1_j(G30_27),.Pk_1_j(P30_27),.Gi_j(G34_27),.Pi_j(P34_27));

            BLACK_CELL INS3_35(.Gi_k(G35_32),.Pi_k(P35_32),.Gk_1_j(G31_28),.Pk_1_j(P31_28),.Gi_j(G35_28),.Pi_j(P35_28));

            BLACK_CELL INS3_36(.Gi_k(G36_33),.Pi_k(P36_33),.Gk_1_j(G32_29),.Pk_1_j(P32_29),.Gi_j(G36_29),.Pi_j(P36_29));

            BLACK_CELL INS3_37(.Gi_k(G37_34),.Pi_k(P37_34),.Gk_1_j(G33_30),.Pk_1_j(P33_30),.Gi_j(G37_30),.Pi_j(P37_30));

            BLACK_CELL INS3_38(.Gi_k(G38_35),.Pi_k(P38_35),.Gk_1_j(G34_31),.Pk_1_j(P34_31),.Gi_j(G38_31),.Pi_j(P38_31));

            BLACK_CELL INS3_39(.Gi_k(G39_36),.Pi_k(P39_36),.Gk_1_j(G35_32),.Pk_1_j(P35_32),.Gi_j(G39_32),.Pi_j(P39_32));

            BLACK_CELL INS3_40(.Gi_k(G40_37),.Pi_k(P40_37),.Gk_1_j(G36_33),.Pk_1_j(P36_33),.Gi_j(G40_33),.Pi_j(P40_33));

            BLACK_CELL INS3_41(.Gi_k(G41_38),.Pi_k(P41_38),.Gk_1_j(G37_34),.Pk_1_j(P37_34),.Gi_j(G41_34),.Pi_j(P41_34));

            BLACK_CELL INS3_42(.Gi_k(G42_39),.Pi_k(P42_39),.Gk_1_j(G38_35),.Pk_1_j(P38_35),.Gi_j(G42_35),.Pi_j(P42_35));

            BLACK_CELL INS3_43(.Gi_k(G43_40),.Pi_k(P43_40),.Gk_1_j(G39_36),.Pk_1_j(P39_36),.Gi_j(G43_36),.Pi_j(P43_36));

            BLACK_CELL INS3_44(.Gi_k(G44_41),.Pi_k(P44_41),.Gk_1_j(G40_37),.Pk_1_j(P40_37),.Gi_j(G44_37),.Pi_j(P44_37));

            BLACK_CELL INS3_45(.Gi_k(G45_42),.Pi_k(P45_42),.Gk_1_j(G41_38),.Pk_1_j(P41_38),.Gi_j(G45_38),.Pi_j(P45_38));

            BLACK_CELL INS3_46(.Gi_k(G46_43),.Pi_k(P46_43),.Gk_1_j(G42_39),.Pk_1_j(P42_39),.Gi_j(G46_39),.Pi_j(P46_39));

            BLACK_CELL INS3_47(.Gi_k(G47_44),.Pi_k(P47_44),.Gk_1_j(G43_40),.Pk_1_j(P43_40),.Gi_j(G47_40),.Pi_j(P47_40));

            BLACK_CELL INS3_48(.Gi_k(G48_45),.Pi_k(P48_45),.Gk_1_j(G44_41),.Pk_1_j(P44_41),.Gi_j(G48_41),.Pi_j(P48_41));

            BLACK_CELL INS3_49(.Gi_k(G49_46),.Pi_k(P49_46),.Gk_1_j(G45_42),.Pk_1_j(P45_42),.Gi_j(G49_42),.Pi_j(P49_42));

            BLACK_CELL INS3_50(.Gi_k(G50_47),.Pi_k(P50_47),.Gk_1_j(G46_43),.Pk_1_j(P46_43),.Gi_j(G50_43),.Pi_j(P50_43));

            BLACK_CELL INS3_51(.Gi_k(G51_48),.Pi_k(P51_48),.Gk_1_j(G47_44),.Pk_1_j(P47_44),.Gi_j(G51_44),.Pi_j(P51_44));

            BLACK_CELL INS3_52(.Gi_k(G52_49),.Pi_k(P52_49),.Gk_1_j(G48_45),.Pk_1_j(P48_45),.Gi_j(G52_45),.Pi_j(P52_45));

            BLACK_CELL INS3_53(.Gi_k(G53_50),.Pi_k(P53_50),.Gk_1_j(G49_46),.Pk_1_j(P49_46),.Gi_j(G53_46),.Pi_j(P53_46));

            BLACK_CELL INS3_54(.Gi_k(G54_51),.Pi_k(P54_51),.Gk_1_j(G50_47),.Pk_1_j(P50_47),.Gi_j(G54_47),.Pi_j(P54_47));

            BLACK_CELL INS3_55(.Gi_k(G55_52),.Pi_k(P55_52),.Gk_1_j(G51_48),.Pk_1_j(P51_48),.Gi_j(G55_48),.Pi_j(P55_48));

            BLACK_CELL INS3_56(.Gi_k(G56_53),.Pi_k(P56_53),.Gk_1_j(G52_49),.Pk_1_j(P52_49),.Gi_j(G56_49),.Pi_j(P56_49));

            BLACK_CELL INS3_57(.Gi_k(G57_54),.Pi_k(P57_54),.Gk_1_j(G53_50),.Pk_1_j(P53_50),.Gi_j(G57_50),.Pi_j(P57_50));

            BLACK_CELL INS3_58(.Gi_k(G58_55),.Pi_k(P58_55),.Gk_1_j(G54_51),.Pk_1_j(P54_51),.Gi_j(G58_51),.Pi_j(P58_51));

            BLACK_CELL INS3_59(.Gi_k(G59_56),.Pi_k(P59_56),.Gk_1_j(G55_52),.Pk_1_j(P55_52),.Gi_j(G59_52),.Pi_j(P59_52));

            BLACK_CELL INS3_60(.Gi_k(G60_57),.Pi_k(P60_57),.Gk_1_j(G56_53),.Pk_1_j(P56_53),.Gi_j(G60_53),.Pi_j(P60_53));

            BLACK_CELL INS3_61(.Gi_k(G61_58),.Pi_k(P61_58),.Gk_1_j(G57_54),.Pk_1_j(P57_54),.Gi_j(G61_54),.Pi_j(P61_54));

            BLACK_CELL INS3_62(.Gi_k(G62_59),.Pi_k(P62_59),.Gk_1_j(G58_55),.Pk_1_j(P58_55),.Gi_j(G62_55),.Pi_j(P62_55));

            BLACK_CELL INS3_63(.Gi_k(G63_60),.Pi_k(P63_60),.Gk_1_j(G59_56),.Pk_1_j(P59_56),.Gi_j(G63_56),.Pi_j(P63_56));

            BLACK_CELL INS3_64(.Gi_k(G64_61),.Pi_k(P64_61),.Gk_1_j(G60_57),.Pk_1_j(P60_57),.Gi_j(G64_57),.Pi_j(P64_57));

            BLACK_CELL INS3_65(.Gi_k(G65_62),.Pi_k(P65_62),.Gk_1_j(G61_58),.Pk_1_j(P61_58),.Gi_j(G65_58),.Pi_j(P65_58));

            BLACK_CELL INS3_66(.Gi_k(G66_63),.Pi_k(P66_63),.Gk_1_j(G62_59),.Pk_1_j(P62_59),.Gi_j(G66_59),.Pi_j(P66_59));

            BLACK_CELL INS3_67(.Gi_k(G67_64),.Pi_k(P67_64),.Gk_1_j(G63_60),.Pk_1_j(P63_60),.Gi_j(G67_60),.Pi_j(P67_60));

            BLACK_CELL INS3_68(.Gi_k(G68_65),.Pi_k(P68_65),.Gk_1_j(G64_61),.Pk_1_j(P64_61),.Gi_j(G68_61),.Pi_j(P68_61));

            BLACK_CELL INS3_69(.Gi_k(G69_66),.Pi_k(P69_66),.Gk_1_j(G65_62),.Pk_1_j(P65_62),.Gi_j(G69_62),.Pi_j(P69_62));

            BLACK_CELL INS3_70(.Gi_k(G70_67),.Pi_k(P70_67),.Gk_1_j(G66_63),.Pk_1_j(P66_63),.Gi_j(G70_63),.Pi_j(P70_63));

            BLACK_CELL INS3_71(.Gi_k(G71_68),.Pi_k(P71_68),.Gk_1_j(G67_64),.Pk_1_j(P67_64),.Gi_j(G71_64),.Pi_j(P71_64));

            BLACK_CELL INS3_72(.Gi_k(G72_69),.Pi_k(P72_69),.Gk_1_j(G68_65),.Pk_1_j(P68_65),.Gi_j(G72_65),.Pi_j(P72_65));

            BLACK_CELL INS3_73(.Gi_k(G73_70),.Pi_k(P73_70),.Gk_1_j(G69_66),.Pk_1_j(P69_66),.Gi_j(G73_66),.Pi_j(P73_66));

            BLACK_CELL INS3_74(.Gi_k(G74_71),.Pi_k(P74_71),.Gk_1_j(G70_67),.Pk_1_j(P70_67),.Gi_j(G74_67),.Pi_j(P74_67));

            BLACK_CELL INS3_75(.Gi_k(G75_72),.Pi_k(P75_72),.Gk_1_j(G71_68),.Pk_1_j(P71_68),.Gi_j(G75_68),.Pi_j(P75_68));

            BLACK_CELL INS3_76(.Gi_k(G76_73),.Pi_k(P76_73),.Gk_1_j(G72_69),.Pk_1_j(P72_69),.Gi_j(G76_69),.Pi_j(P76_69));

            BLACK_CELL INS3_77(.Gi_k(G77_74),.Pi_k(P77_74),.Gk_1_j(G73_70),.Pk_1_j(P73_70),.Gi_j(G77_70),.Pi_j(P77_70));

            BLACK_CELL INS3_78(.Gi_k(G78_75),.Pi_k(P78_75),.Gk_1_j(G74_71),.Pk_1_j(P74_71),.Gi_j(G78_71),.Pi_j(P78_71));

            BLACK_CELL INS3_79(.Gi_k(G79_76),.Pi_k(P79_76),.Gk_1_j(G75_72),.Pk_1_j(P75_72),.Gi_j(G79_72),.Pi_j(P79_72));

            BLACK_CELL INS3_80(.Gi_k(G80_77),.Pi_k(P80_77),.Gk_1_j(G76_73),.Pk_1_j(P76_73),.Gi_j(G80_73),.Pi_j(P80_73));

            BLACK_CELL INS3_81(.Gi_k(G81_78),.Pi_k(P81_78),.Gk_1_j(G77_74),.Pk_1_j(P77_74),.Gi_j(G81_74),.Pi_j(P81_74));

            BLACK_CELL INS3_82(.Gi_k(G82_79),.Pi_k(P82_79),.Gk_1_j(G78_75),.Pk_1_j(P78_75),.Gi_j(G82_75),.Pi_j(P82_75));

            BLACK_CELL INS3_83(.Gi_k(G83_80),.Pi_k(P83_80),.Gk_1_j(G79_76),.Pk_1_j(P79_76),.Gi_j(G83_76),.Pi_j(P83_76));

            BLACK_CELL INS3_84(.Gi_k(G84_81),.Pi_k(P84_81),.Gk_1_j(G80_77),.Pk_1_j(P80_77),.Gi_j(G84_77),.Pi_j(P84_77));

            BLACK_CELL INS3_85(.Gi_k(G85_82),.Pi_k(P85_82),.Gk_1_j(G81_78),.Pk_1_j(P81_78),.Gi_j(G85_78),.Pi_j(P85_78));

            BLACK_CELL INS3_86(.Gi_k(G86_83),.Pi_k(P86_83),.Gk_1_j(G82_79),.Pk_1_j(P82_79),.Gi_j(G86_79),.Pi_j(P86_79));

            BLACK_CELL INS3_87(.Gi_k(G87_84),.Pi_k(P87_84),.Gk_1_j(G83_80),.Pk_1_j(P83_80),.Gi_j(G87_80),.Pi_j(P87_80));

            BLACK_CELL INS3_88(.Gi_k(G88_85),.Pi_k(P88_85),.Gk_1_j(G84_81),.Pk_1_j(P84_81),.Gi_j(G88_81),.Pi_j(P88_81));

            BLACK_CELL INS3_89(.Gi_k(G89_86),.Pi_k(P89_86),.Gk_1_j(G85_82),.Pk_1_j(P85_82),.Gi_j(G89_82),.Pi_j(P89_82));

            BLACK_CELL INS3_90(.Gi_k(G90_87),.Pi_k(P90_87),.Gk_1_j(G86_83),.Pk_1_j(P86_83),.Gi_j(G90_83),.Pi_j(P90_83));

            BLACK_CELL INS3_91(.Gi_k(G91_88),.Pi_k(P91_88),.Gk_1_j(G87_84),.Pk_1_j(P87_84),.Gi_j(G91_84),.Pi_j(P91_84));

            BLACK_CELL INS3_92(.Gi_k(G92_89),.Pi_k(P92_89),.Gk_1_j(G88_85),.Pk_1_j(P88_85),.Gi_j(G92_85),.Pi_j(P92_85));

            BLACK_CELL INS3_93(.Gi_k(G93_90),.Pi_k(P93_90),.Gk_1_j(G89_86),.Pk_1_j(P89_86),.Gi_j(G93_86),.Pi_j(P93_86));

            BLACK_CELL INS3_94(.Gi_k(G94_91),.Pi_k(P94_91),.Gk_1_j(G90_87),.Pk_1_j(P90_87),.Gi_j(G94_87),.Pi_j(P94_87));

            BLACK_CELL INS3_95(.Gi_k(G95_92),.Pi_k(P95_92),.Gk_1_j(G91_88),.Pk_1_j(P91_88),.Gi_j(G95_88),.Pi_j(P95_88));

            BLACK_CELL INS3_96(.Gi_k(G96_93),.Pi_k(P96_93),.Gk_1_j(G92_89),.Pk_1_j(P92_89),.Gi_j(G96_89),.Pi_j(P96_89));

            BLACK_CELL INS3_97(.Gi_k(G97_94),.Pi_k(P97_94),.Gk_1_j(G93_90),.Pk_1_j(P93_90),.Gi_j(G97_90),.Pi_j(P97_90));

            BLACK_CELL INS3_98(.Gi_k(G98_95),.Pi_k(P98_95),.Gk_1_j(G94_91),.Pk_1_j(P94_91),.Gi_j(G98_91),.Pi_j(P98_91));

            BLACK_CELL INS3_99(.Gi_k(G99_96),.Pi_k(P99_96),.Gk_1_j(G95_92),.Pk_1_j(P95_92),.Gi_j(G99_92),.Pi_j(P99_92));

            BLACK_CELL INS3_100(.Gi_k(G100_97),.Pi_k(P100_97),.Gk_1_j(G96_93),.Pk_1_j(P96_93),.Gi_j(G100_93),.Pi_j(P100_93));

            BLACK_CELL INS3_101(.Gi_k(G101_98),.Pi_k(P101_98),.Gk_1_j(G97_94),.Pk_1_j(P97_94),.Gi_j(G101_94),.Pi_j(P101_94));

            BLACK_CELL INS3_102(.Gi_k(G102_99),.Pi_k(P102_99),.Gk_1_j(G98_95),.Pk_1_j(P98_95),.Gi_j(G102_95),.Pi_j(P102_95));

            BLACK_CELL INS3_103(.Gi_k(G103_100),.Pi_k(P103_100),.Gk_1_j(G99_96),.Pk_1_j(P99_96),.Gi_j(G103_96),.Pi_j(P103_96));

            BLACK_CELL INS3_104(.Gi_k(G104_101),.Pi_k(P104_101),.Gk_1_j(G100_97),.Pk_1_j(P100_97),.Gi_j(G104_97),.Pi_j(P104_97));

            BLACK_CELL INS3_105(.Gi_k(G105_102),.Pi_k(P105_102),.Gk_1_j(G101_98),.Pk_1_j(P101_98),.Gi_j(G105_98),.Pi_j(P105_98));

            BLACK_CELL INS3_106(.Gi_k(G106_103),.Pi_k(P106_103),.Gk_1_j(G102_99),.Pk_1_j(P102_99),.Gi_j(G106_99),.Pi_j(P106_99));

            BLACK_CELL INS3_107(.Gi_k(G107_104),.Pi_k(P107_104),.Gk_1_j(G103_100),.Pk_1_j(P103_100),.Gi_j(G107_100),.Pi_j(P107_100));

            BLACK_CELL INS3_108(.Gi_k(G108_105),.Pi_k(P108_105),.Gk_1_j(G104_101),.Pk_1_j(P104_101),.Gi_j(G108_101),.Pi_j(P108_101));

            BLACK_CELL INS3_109(.Gi_k(G109_106),.Pi_k(P109_106),.Gk_1_j(G105_102),.Pk_1_j(P105_102),.Gi_j(G109_102),.Pi_j(P109_102));

            BLACK_CELL INS3_110(.Gi_k(G110_107),.Pi_k(P110_107),.Gk_1_j(G106_103),.Pk_1_j(P106_103),.Gi_j(G110_103),.Pi_j(P110_103));

            BLACK_CELL INS3_111(.Gi_k(G111_108),.Pi_k(P111_108),.Gk_1_j(G107_104),.Pk_1_j(P107_104),.Gi_j(G111_104),.Pi_j(P111_104));

            BLACK_CELL INS3_112(.Gi_k(G112_109),.Pi_k(P112_109),.Gk_1_j(G108_105),.Pk_1_j(P108_105),.Gi_j(G112_105),.Pi_j(P112_105));

            BLACK_CELL INS3_113(.Gi_k(G113_110),.Pi_k(P113_110),.Gk_1_j(G109_106),.Pk_1_j(P109_106),.Gi_j(G113_106),.Pi_j(P113_106));

            BLACK_CELL INS3_114(.Gi_k(G114_111),.Pi_k(P114_111),.Gk_1_j(G110_107),.Pk_1_j(P110_107),.Gi_j(G114_107),.Pi_j(P114_107));

            BLACK_CELL INS3_115(.Gi_k(G115_112),.Pi_k(P115_112),.Gk_1_j(G111_108),.Pk_1_j(P111_108),.Gi_j(G115_108),.Pi_j(P115_108));

            BLACK_CELL INS3_116(.Gi_k(G116_113),.Pi_k(P116_113),.Gk_1_j(G112_109),.Pk_1_j(P112_109),.Gi_j(G116_109),.Pi_j(P116_109));

            BLACK_CELL INS3_117(.Gi_k(G117_114),.Pi_k(P117_114),.Gk_1_j(G113_110),.Pk_1_j(P113_110),.Gi_j(G117_110),.Pi_j(P117_110));

            BLACK_CELL INS3_118(.Gi_k(G118_115),.Pi_k(P118_115),.Gk_1_j(G114_111),.Pk_1_j(P114_111),.Gi_j(G118_111),.Pi_j(P118_111));

            BLACK_CELL INS3_119(.Gi_k(G119_116),.Pi_k(P119_116),.Gk_1_j(G115_112),.Pk_1_j(P115_112),.Gi_j(G119_112),.Pi_j(P119_112));

            BLACK_CELL INS3_120(.Gi_k(G120_117),.Pi_k(P120_117),.Gk_1_j(G116_113),.Pk_1_j(P116_113),.Gi_j(G120_113),.Pi_j(P120_113));

            BLACK_CELL INS3_121(.Gi_k(G121_118),.Pi_k(P121_118),.Gk_1_j(G117_114),.Pk_1_j(P117_114),.Gi_j(G121_114),.Pi_j(P121_114));

            BLACK_CELL INS3_122(.Gi_k(G122_119),.Pi_k(P122_119),.Gk_1_j(G118_115),.Pk_1_j(P118_115),.Gi_j(G122_115),.Pi_j(P122_115));

            BLACK_CELL INS3_123(.Gi_k(G123_120),.Pi_k(P123_120),.Gk_1_j(G119_116),.Pk_1_j(P119_116),.Gi_j(G123_116),.Pi_j(P123_116));

            BLACK_CELL INS3_124(.Gi_k(G124_121),.Pi_k(P124_121),.Gk_1_j(G120_117),.Pk_1_j(P120_117),.Gi_j(G124_117),.Pi_j(P124_117));

            BLACK_CELL INS3_125(.Gi_k(G125_122),.Pi_k(P125_122),.Gk_1_j(G121_118),.Pk_1_j(P121_118),.Gi_j(G125_118),.Pi_j(P125_118));

            BLACK_CELL INS3_126(.Gi_k(G126_123),.Pi_k(P126_123),.Gk_1_j(G122_119),.Pk_1_j(P122_119),.Gi_j(G126_119),.Pi_j(P126_119));

            BLACK_CELL INS3_127(.Gi_k(G127_124),.Pi_k(P127_124),.Gk_1_j(G123_120),.Pk_1_j(P123_120),.Gi_j(G127_120),.Pi_j(P127_120));

            BLACK_CELL INS3_128(.Gi_k(G128_125),.Pi_k(P128_125),.Gk_1_j(G124_121),.Pk_1_j(P124_121),.Gi_j(G128_121),.Pi_j(P128_121));

            BLACK_CELL INS3_129(.Gi_k(G129_126),.Pi_k(P129_126),.Gk_1_j(G125_122),.Pk_1_j(P125_122),.Gi_j(G129_122),.Pi_j(P129_122));

            GRAY_CELL INS4_8(.Gi_k(G8_1),.Pi_k(P8_1),.Gk_1_j(G0_0),.Gi_j(G8_0));

            GRAY_CELL INS4_9(.Gi_k(G9_2),.Pi_k(P9_2),.Gk_1_j(G1_0),.Gi_j(G9_0));

            GRAY_CELL INS4_10(.Gi_k(G10_3),.Pi_k(P10_3),.Gk_1_j(G2_0),.Gi_j(G10_0));

            GRAY_CELL INS4_11(.Gi_k(G11_4),.Pi_k(P11_4),.Gk_1_j(G3_0),.Gi_j(G11_0));

            GRAY_CELL INS4_12(.Gi_k(G12_5),.Pi_k(P12_5),.Gk_1_j(G4_0),.Gi_j(G12_0));

            GRAY_CELL INS4_13(.Gi_k(G13_6),.Pi_k(P13_6),.Gk_1_j(G5_0),.Gi_j(G13_0));

            GRAY_CELL INS4_14(.Gi_k(G14_7),.Pi_k(P14_7),.Gk_1_j(G6_0),.Gi_j(G14_0));

            GRAY_CELL INS4_15(.Gi_k(G15_8),.Pi_k(P15_8),.Gk_1_j(G7_0),.Gi_j(G15_0));

            BLACK_CELL INS4_16(.Gi_k(G16_9),.Pi_k(P16_9),.Gk_1_j(G8_1),.Pk_1_j(P8_1),.Gi_j(G16_1),.Pi_j(P16_1));

            BLACK_CELL INS4_17(.Gi_k(G17_10),.Pi_k(P17_10),.Gk_1_j(G9_2),.Pk_1_j(P9_2),.Gi_j(G17_2),.Pi_j(P17_2));

            BLACK_CELL INS4_18(.Gi_k(G18_11),.Pi_k(P18_11),.Gk_1_j(G10_3),.Pk_1_j(P10_3),.Gi_j(G18_3),.Pi_j(P18_3));

            BLACK_CELL INS4_19(.Gi_k(G19_12),.Pi_k(P19_12),.Gk_1_j(G11_4),.Pk_1_j(P11_4),.Gi_j(G19_4),.Pi_j(P19_4));

            BLACK_CELL INS4_20(.Gi_k(G20_13),.Pi_k(P20_13),.Gk_1_j(G12_5),.Pk_1_j(P12_5),.Gi_j(G20_5),.Pi_j(P20_5));

            BLACK_CELL INS4_21(.Gi_k(G21_14),.Pi_k(P21_14),.Gk_1_j(G13_6),.Pk_1_j(P13_6),.Gi_j(G21_6),.Pi_j(P21_6));

            BLACK_CELL INS4_22(.Gi_k(G22_15),.Pi_k(P22_15),.Gk_1_j(G14_7),.Pk_1_j(P14_7),.Gi_j(G22_7),.Pi_j(P22_7));

            BLACK_CELL INS4_23(.Gi_k(G23_16),.Pi_k(P23_16),.Gk_1_j(G15_8),.Pk_1_j(P15_8),.Gi_j(G23_8),.Pi_j(P23_8));

            BLACK_CELL INS4_24(.Gi_k(G24_17),.Pi_k(P24_17),.Gk_1_j(G16_9),.Pk_1_j(P16_9),.Gi_j(G24_9),.Pi_j(P24_9));

            BLACK_CELL INS4_25(.Gi_k(G25_18),.Pi_k(P25_18),.Gk_1_j(G17_10),.Pk_1_j(P17_10),.Gi_j(G25_10),.Pi_j(P25_10));

            BLACK_CELL INS4_26(.Gi_k(G26_19),.Pi_k(P26_19),.Gk_1_j(G18_11),.Pk_1_j(P18_11),.Gi_j(G26_11),.Pi_j(P26_11));

            BLACK_CELL INS4_27(.Gi_k(G27_20),.Pi_k(P27_20),.Gk_1_j(G19_12),.Pk_1_j(P19_12),.Gi_j(G27_12),.Pi_j(P27_12));

            BLACK_CELL INS4_28(.Gi_k(G28_21),.Pi_k(P28_21),.Gk_1_j(G20_13),.Pk_1_j(P20_13),.Gi_j(G28_13),.Pi_j(P28_13));

            BLACK_CELL INS4_29(.Gi_k(G29_22),.Pi_k(P29_22),.Gk_1_j(G21_14),.Pk_1_j(P21_14),.Gi_j(G29_14),.Pi_j(P29_14));

            BLACK_CELL INS4_30(.Gi_k(G30_23),.Pi_k(P30_23),.Gk_1_j(G22_15),.Pk_1_j(P22_15),.Gi_j(G30_15),.Pi_j(P30_15));

            BLACK_CELL INS4_31(.Gi_k(G31_24),.Pi_k(P31_24),.Gk_1_j(G23_16),.Pk_1_j(P23_16),.Gi_j(G31_16),.Pi_j(P31_16));

            BLACK_CELL INS4_32(.Gi_k(G32_25),.Pi_k(P32_25),.Gk_1_j(G24_17),.Pk_1_j(P24_17),.Gi_j(G32_17),.Pi_j(P32_17));

            BLACK_CELL INS4_33(.Gi_k(G33_26),.Pi_k(P33_26),.Gk_1_j(G25_18),.Pk_1_j(P25_18),.Gi_j(G33_18),.Pi_j(P33_18));

            BLACK_CELL INS4_34(.Gi_k(G34_27),.Pi_k(P34_27),.Gk_1_j(G26_19),.Pk_1_j(P26_19),.Gi_j(G34_19),.Pi_j(P34_19));

            BLACK_CELL INS4_35(.Gi_k(G35_28),.Pi_k(P35_28),.Gk_1_j(G27_20),.Pk_1_j(P27_20),.Gi_j(G35_20),.Pi_j(P35_20));

            BLACK_CELL INS4_36(.Gi_k(G36_29),.Pi_k(P36_29),.Gk_1_j(G28_21),.Pk_1_j(P28_21),.Gi_j(G36_21),.Pi_j(P36_21));

            BLACK_CELL INS4_37(.Gi_k(G37_30),.Pi_k(P37_30),.Gk_1_j(G29_22),.Pk_1_j(P29_22),.Gi_j(G37_22),.Pi_j(P37_22));

            BLACK_CELL INS4_38(.Gi_k(G38_31),.Pi_k(P38_31),.Gk_1_j(G30_23),.Pk_1_j(P30_23),.Gi_j(G38_23),.Pi_j(P38_23));

            BLACK_CELL INS4_39(.Gi_k(G39_32),.Pi_k(P39_32),.Gk_1_j(G31_24),.Pk_1_j(P31_24),.Gi_j(G39_24),.Pi_j(P39_24));

            BLACK_CELL INS4_40(.Gi_k(G40_33),.Pi_k(P40_33),.Gk_1_j(G32_25),.Pk_1_j(P32_25),.Gi_j(G40_25),.Pi_j(P40_25));

            BLACK_CELL INS4_41(.Gi_k(G41_34),.Pi_k(P41_34),.Gk_1_j(G33_26),.Pk_1_j(P33_26),.Gi_j(G41_26),.Pi_j(P41_26));

            BLACK_CELL INS4_42(.Gi_k(G42_35),.Pi_k(P42_35),.Gk_1_j(G34_27),.Pk_1_j(P34_27),.Gi_j(G42_27),.Pi_j(P42_27));

            BLACK_CELL INS4_43(.Gi_k(G43_36),.Pi_k(P43_36),.Gk_1_j(G35_28),.Pk_1_j(P35_28),.Gi_j(G43_28),.Pi_j(P43_28));

            BLACK_CELL INS4_44(.Gi_k(G44_37),.Pi_k(P44_37),.Gk_1_j(G36_29),.Pk_1_j(P36_29),.Gi_j(G44_29),.Pi_j(P44_29));

            BLACK_CELL INS4_45(.Gi_k(G45_38),.Pi_k(P45_38),.Gk_1_j(G37_30),.Pk_1_j(P37_30),.Gi_j(G45_30),.Pi_j(P45_30));

            BLACK_CELL INS4_46(.Gi_k(G46_39),.Pi_k(P46_39),.Gk_1_j(G38_31),.Pk_1_j(P38_31),.Gi_j(G46_31),.Pi_j(P46_31));

            BLACK_CELL INS4_47(.Gi_k(G47_40),.Pi_k(P47_40),.Gk_1_j(G39_32),.Pk_1_j(P39_32),.Gi_j(G47_32),.Pi_j(P47_32));

            BLACK_CELL INS4_48(.Gi_k(G48_41),.Pi_k(P48_41),.Gk_1_j(G40_33),.Pk_1_j(P40_33),.Gi_j(G48_33),.Pi_j(P48_33));

            BLACK_CELL INS4_49(.Gi_k(G49_42),.Pi_k(P49_42),.Gk_1_j(G41_34),.Pk_1_j(P41_34),.Gi_j(G49_34),.Pi_j(P49_34));

            BLACK_CELL INS4_50(.Gi_k(G50_43),.Pi_k(P50_43),.Gk_1_j(G42_35),.Pk_1_j(P42_35),.Gi_j(G50_35),.Pi_j(P50_35));

            BLACK_CELL INS4_51(.Gi_k(G51_44),.Pi_k(P51_44),.Gk_1_j(G43_36),.Pk_1_j(P43_36),.Gi_j(G51_36),.Pi_j(P51_36));

            BLACK_CELL INS4_52(.Gi_k(G52_45),.Pi_k(P52_45),.Gk_1_j(G44_37),.Pk_1_j(P44_37),.Gi_j(G52_37),.Pi_j(P52_37));

            BLACK_CELL INS4_53(.Gi_k(G53_46),.Pi_k(P53_46),.Gk_1_j(G45_38),.Pk_1_j(P45_38),.Gi_j(G53_38),.Pi_j(P53_38));

            BLACK_CELL INS4_54(.Gi_k(G54_47),.Pi_k(P54_47),.Gk_1_j(G46_39),.Pk_1_j(P46_39),.Gi_j(G54_39),.Pi_j(P54_39));

            BLACK_CELL INS4_55(.Gi_k(G55_48),.Pi_k(P55_48),.Gk_1_j(G47_40),.Pk_1_j(P47_40),.Gi_j(G55_40),.Pi_j(P55_40));

            BLACK_CELL INS4_56(.Gi_k(G56_49),.Pi_k(P56_49),.Gk_1_j(G48_41),.Pk_1_j(P48_41),.Gi_j(G56_41),.Pi_j(P56_41));

            BLACK_CELL INS4_57(.Gi_k(G57_50),.Pi_k(P57_50),.Gk_1_j(G49_42),.Pk_1_j(P49_42),.Gi_j(G57_42),.Pi_j(P57_42));

            BLACK_CELL INS4_58(.Gi_k(G58_51),.Pi_k(P58_51),.Gk_1_j(G50_43),.Pk_1_j(P50_43),.Gi_j(G58_43),.Pi_j(P58_43));

            BLACK_CELL INS4_59(.Gi_k(G59_52),.Pi_k(P59_52),.Gk_1_j(G51_44),.Pk_1_j(P51_44),.Gi_j(G59_44),.Pi_j(P59_44));

            BLACK_CELL INS4_60(.Gi_k(G60_53),.Pi_k(P60_53),.Gk_1_j(G52_45),.Pk_1_j(P52_45),.Gi_j(G60_45),.Pi_j(P60_45));

            BLACK_CELL INS4_61(.Gi_k(G61_54),.Pi_k(P61_54),.Gk_1_j(G53_46),.Pk_1_j(P53_46),.Gi_j(G61_46),.Pi_j(P61_46));

            BLACK_CELL INS4_62(.Gi_k(G62_55),.Pi_k(P62_55),.Gk_1_j(G54_47),.Pk_1_j(P54_47),.Gi_j(G62_47),.Pi_j(P62_47));

            BLACK_CELL INS4_63(.Gi_k(G63_56),.Pi_k(P63_56),.Gk_1_j(G55_48),.Pk_1_j(P55_48),.Gi_j(G63_48),.Pi_j(P63_48));

            BLACK_CELL INS4_64(.Gi_k(G64_57),.Pi_k(P64_57),.Gk_1_j(G56_49),.Pk_1_j(P56_49),.Gi_j(G64_49),.Pi_j(P64_49));

            BLACK_CELL INS4_65(.Gi_k(G65_58),.Pi_k(P65_58),.Gk_1_j(G57_50),.Pk_1_j(P57_50),.Gi_j(G65_50),.Pi_j(P65_50));

            BLACK_CELL INS4_66(.Gi_k(G66_59),.Pi_k(P66_59),.Gk_1_j(G58_51),.Pk_1_j(P58_51),.Gi_j(G66_51),.Pi_j(P66_51));

            BLACK_CELL INS4_67(.Gi_k(G67_60),.Pi_k(P67_60),.Gk_1_j(G59_52),.Pk_1_j(P59_52),.Gi_j(G67_52),.Pi_j(P67_52));

            BLACK_CELL INS4_68(.Gi_k(G68_61),.Pi_k(P68_61),.Gk_1_j(G60_53),.Pk_1_j(P60_53),.Gi_j(G68_53),.Pi_j(P68_53));

            BLACK_CELL INS4_69(.Gi_k(G69_62),.Pi_k(P69_62),.Gk_1_j(G61_54),.Pk_1_j(P61_54),.Gi_j(G69_54),.Pi_j(P69_54));

            BLACK_CELL INS4_70(.Gi_k(G70_63),.Pi_k(P70_63),.Gk_1_j(G62_55),.Pk_1_j(P62_55),.Gi_j(G70_55),.Pi_j(P70_55));

            BLACK_CELL INS4_71(.Gi_k(G71_64),.Pi_k(P71_64),.Gk_1_j(G63_56),.Pk_1_j(P63_56),.Gi_j(G71_56),.Pi_j(P71_56));

            BLACK_CELL INS4_72(.Gi_k(G72_65),.Pi_k(P72_65),.Gk_1_j(G64_57),.Pk_1_j(P64_57),.Gi_j(G72_57),.Pi_j(P72_57));

            BLACK_CELL INS4_73(.Gi_k(G73_66),.Pi_k(P73_66),.Gk_1_j(G65_58),.Pk_1_j(P65_58),.Gi_j(G73_58),.Pi_j(P73_58));

            BLACK_CELL INS4_74(.Gi_k(G74_67),.Pi_k(P74_67),.Gk_1_j(G66_59),.Pk_1_j(P66_59),.Gi_j(G74_59),.Pi_j(P74_59));

            BLACK_CELL INS4_75(.Gi_k(G75_68),.Pi_k(P75_68),.Gk_1_j(G67_60),.Pk_1_j(P67_60),.Gi_j(G75_60),.Pi_j(P75_60));

            BLACK_CELL INS4_76(.Gi_k(G76_69),.Pi_k(P76_69),.Gk_1_j(G68_61),.Pk_1_j(P68_61),.Gi_j(G76_61),.Pi_j(P76_61));

            BLACK_CELL INS4_77(.Gi_k(G77_70),.Pi_k(P77_70),.Gk_1_j(G69_62),.Pk_1_j(P69_62),.Gi_j(G77_62),.Pi_j(P77_62));

            BLACK_CELL INS4_78(.Gi_k(G78_71),.Pi_k(P78_71),.Gk_1_j(G70_63),.Pk_1_j(P70_63),.Gi_j(G78_63),.Pi_j(P78_63));

            BLACK_CELL INS4_79(.Gi_k(G79_72),.Pi_k(P79_72),.Gk_1_j(G71_64),.Pk_1_j(P71_64),.Gi_j(G79_64),.Pi_j(P79_64));

            BLACK_CELL INS4_80(.Gi_k(G80_73),.Pi_k(P80_73),.Gk_1_j(G72_65),.Pk_1_j(P72_65),.Gi_j(G80_65),.Pi_j(P80_65));

            BLACK_CELL INS4_81(.Gi_k(G81_74),.Pi_k(P81_74),.Gk_1_j(G73_66),.Pk_1_j(P73_66),.Gi_j(G81_66),.Pi_j(P81_66));

            BLACK_CELL INS4_82(.Gi_k(G82_75),.Pi_k(P82_75),.Gk_1_j(G74_67),.Pk_1_j(P74_67),.Gi_j(G82_67),.Pi_j(P82_67));

            BLACK_CELL INS4_83(.Gi_k(G83_76),.Pi_k(P83_76),.Gk_1_j(G75_68),.Pk_1_j(P75_68),.Gi_j(G83_68),.Pi_j(P83_68));

            BLACK_CELL INS4_84(.Gi_k(G84_77),.Pi_k(P84_77),.Gk_1_j(G76_69),.Pk_1_j(P76_69),.Gi_j(G84_69),.Pi_j(P84_69));

            BLACK_CELL INS4_85(.Gi_k(G85_78),.Pi_k(P85_78),.Gk_1_j(G77_70),.Pk_1_j(P77_70),.Gi_j(G85_70),.Pi_j(P85_70));

            BLACK_CELL INS4_86(.Gi_k(G86_79),.Pi_k(P86_79),.Gk_1_j(G78_71),.Pk_1_j(P78_71),.Gi_j(G86_71),.Pi_j(P86_71));

            BLACK_CELL INS4_87(.Gi_k(G87_80),.Pi_k(P87_80),.Gk_1_j(G79_72),.Pk_1_j(P79_72),.Gi_j(G87_72),.Pi_j(P87_72));

            BLACK_CELL INS4_88(.Gi_k(G88_81),.Pi_k(P88_81),.Gk_1_j(G80_73),.Pk_1_j(P80_73),.Gi_j(G88_73),.Pi_j(P88_73));

            BLACK_CELL INS4_89(.Gi_k(G89_82),.Pi_k(P89_82),.Gk_1_j(G81_74),.Pk_1_j(P81_74),.Gi_j(G89_74),.Pi_j(P89_74));

            BLACK_CELL INS4_90(.Gi_k(G90_83),.Pi_k(P90_83),.Gk_1_j(G82_75),.Pk_1_j(P82_75),.Gi_j(G90_75),.Pi_j(P90_75));

            BLACK_CELL INS4_91(.Gi_k(G91_84),.Pi_k(P91_84),.Gk_1_j(G83_76),.Pk_1_j(P83_76),.Gi_j(G91_76),.Pi_j(P91_76));

            BLACK_CELL INS4_92(.Gi_k(G92_85),.Pi_k(P92_85),.Gk_1_j(G84_77),.Pk_1_j(P84_77),.Gi_j(G92_77),.Pi_j(P92_77));

            BLACK_CELL INS4_93(.Gi_k(G93_86),.Pi_k(P93_86),.Gk_1_j(G85_78),.Pk_1_j(P85_78),.Gi_j(G93_78),.Pi_j(P93_78));

            BLACK_CELL INS4_94(.Gi_k(G94_87),.Pi_k(P94_87),.Gk_1_j(G86_79),.Pk_1_j(P86_79),.Gi_j(G94_79),.Pi_j(P94_79));

            BLACK_CELL INS4_95(.Gi_k(G95_88),.Pi_k(P95_88),.Gk_1_j(G87_80),.Pk_1_j(P87_80),.Gi_j(G95_80),.Pi_j(P95_80));

            BLACK_CELL INS4_96(.Gi_k(G96_89),.Pi_k(P96_89),.Gk_1_j(G88_81),.Pk_1_j(P88_81),.Gi_j(G96_81),.Pi_j(P96_81));

            BLACK_CELL INS4_97(.Gi_k(G97_90),.Pi_k(P97_90),.Gk_1_j(G89_82),.Pk_1_j(P89_82),.Gi_j(G97_82),.Pi_j(P97_82));

            BLACK_CELL INS4_98(.Gi_k(G98_91),.Pi_k(P98_91),.Gk_1_j(G90_83),.Pk_1_j(P90_83),.Gi_j(G98_83),.Pi_j(P98_83));

            BLACK_CELL INS4_99(.Gi_k(G99_92),.Pi_k(P99_92),.Gk_1_j(G91_84),.Pk_1_j(P91_84),.Gi_j(G99_84),.Pi_j(P99_84));

            BLACK_CELL INS4_100(.Gi_k(G100_93),.Pi_k(P100_93),.Gk_1_j(G92_85),.Pk_1_j(P92_85),.Gi_j(G100_85),.Pi_j(P100_85));

            BLACK_CELL INS4_101(.Gi_k(G101_94),.Pi_k(P101_94),.Gk_1_j(G93_86),.Pk_1_j(P93_86),.Gi_j(G101_86),.Pi_j(P101_86));

            BLACK_CELL INS4_102(.Gi_k(G102_95),.Pi_k(P102_95),.Gk_1_j(G94_87),.Pk_1_j(P94_87),.Gi_j(G102_87),.Pi_j(P102_87));

            BLACK_CELL INS4_103(.Gi_k(G103_96),.Pi_k(P103_96),.Gk_1_j(G95_88),.Pk_1_j(P95_88),.Gi_j(G103_88),.Pi_j(P103_88));

            BLACK_CELL INS4_104(.Gi_k(G104_97),.Pi_k(P104_97),.Gk_1_j(G96_89),.Pk_1_j(P96_89),.Gi_j(G104_89),.Pi_j(P104_89));

            BLACK_CELL INS4_105(.Gi_k(G105_98),.Pi_k(P105_98),.Gk_1_j(G97_90),.Pk_1_j(P97_90),.Gi_j(G105_90),.Pi_j(P105_90));

            BLACK_CELL INS4_106(.Gi_k(G106_99),.Pi_k(P106_99),.Gk_1_j(G98_91),.Pk_1_j(P98_91),.Gi_j(G106_91),.Pi_j(P106_91));

            BLACK_CELL INS4_107(.Gi_k(G107_100),.Pi_k(P107_100),.Gk_1_j(G99_92),.Pk_1_j(P99_92),.Gi_j(G107_92),.Pi_j(P107_92));

            BLACK_CELL INS4_108(.Gi_k(G108_101),.Pi_k(P108_101),.Gk_1_j(G100_93),.Pk_1_j(P100_93),.Gi_j(G108_93),.Pi_j(P108_93));

            BLACK_CELL INS4_109(.Gi_k(G109_102),.Pi_k(P109_102),.Gk_1_j(G101_94),.Pk_1_j(P101_94),.Gi_j(G109_94),.Pi_j(P109_94));

            BLACK_CELL INS4_110(.Gi_k(G110_103),.Pi_k(P110_103),.Gk_1_j(G102_95),.Pk_1_j(P102_95),.Gi_j(G110_95),.Pi_j(P110_95));

            BLACK_CELL INS4_111(.Gi_k(G111_104),.Pi_k(P111_104),.Gk_1_j(G103_96),.Pk_1_j(P103_96),.Gi_j(G111_96),.Pi_j(P111_96));

            BLACK_CELL INS4_112(.Gi_k(G112_105),.Pi_k(P112_105),.Gk_1_j(G104_97),.Pk_1_j(P104_97),.Gi_j(G112_97),.Pi_j(P112_97));

            BLACK_CELL INS4_113(.Gi_k(G113_106),.Pi_k(P113_106),.Gk_1_j(G105_98),.Pk_1_j(P105_98),.Gi_j(G113_98),.Pi_j(P113_98));

            BLACK_CELL INS4_114(.Gi_k(G114_107),.Pi_k(P114_107),.Gk_1_j(G106_99),.Pk_1_j(P106_99),.Gi_j(G114_99),.Pi_j(P114_99));

            BLACK_CELL INS4_115(.Gi_k(G115_108),.Pi_k(P115_108),.Gk_1_j(G107_100),.Pk_1_j(P107_100),.Gi_j(G115_100),.Pi_j(P115_100));

            BLACK_CELL INS4_116(.Gi_k(G116_109),.Pi_k(P116_109),.Gk_1_j(G108_101),.Pk_1_j(P108_101),.Gi_j(G116_101),.Pi_j(P116_101));

            BLACK_CELL INS4_117(.Gi_k(G117_110),.Pi_k(P117_110),.Gk_1_j(G109_102),.Pk_1_j(P109_102),.Gi_j(G117_102),.Pi_j(P117_102));

            BLACK_CELL INS4_118(.Gi_k(G118_111),.Pi_k(P118_111),.Gk_1_j(G110_103),.Pk_1_j(P110_103),.Gi_j(G118_103),.Pi_j(P118_103));

            BLACK_CELL INS4_119(.Gi_k(G119_112),.Pi_k(P119_112),.Gk_1_j(G111_104),.Pk_1_j(P111_104),.Gi_j(G119_104),.Pi_j(P119_104));

            BLACK_CELL INS4_120(.Gi_k(G120_113),.Pi_k(P120_113),.Gk_1_j(G112_105),.Pk_1_j(P112_105),.Gi_j(G120_105),.Pi_j(P120_105));

            BLACK_CELL INS4_121(.Gi_k(G121_114),.Pi_k(P121_114),.Gk_1_j(G113_106),.Pk_1_j(P113_106),.Gi_j(G121_106),.Pi_j(P121_106));

            BLACK_CELL INS4_122(.Gi_k(G122_115),.Pi_k(P122_115),.Gk_1_j(G114_107),.Pk_1_j(P114_107),.Gi_j(G122_107),.Pi_j(P122_107));

            BLACK_CELL INS4_123(.Gi_k(G123_116),.Pi_k(P123_116),.Gk_1_j(G115_108),.Pk_1_j(P115_108),.Gi_j(G123_108),.Pi_j(P123_108));

            BLACK_CELL INS4_124(.Gi_k(G124_117),.Pi_k(P124_117),.Gk_1_j(G116_109),.Pk_1_j(P116_109),.Gi_j(G124_109),.Pi_j(P124_109));

            BLACK_CELL INS4_125(.Gi_k(G125_118),.Pi_k(P125_118),.Gk_1_j(G117_110),.Pk_1_j(P117_110),.Gi_j(G125_110),.Pi_j(P125_110));

            BLACK_CELL INS4_126(.Gi_k(G126_119),.Pi_k(P126_119),.Gk_1_j(G118_111),.Pk_1_j(P118_111),.Gi_j(G126_111),.Pi_j(P126_111));

            BLACK_CELL INS4_127(.Gi_k(G127_120),.Pi_k(P127_120),.Gk_1_j(G119_112),.Pk_1_j(P119_112),.Gi_j(G127_112),.Pi_j(P127_112));

            BLACK_CELL INS4_128(.Gi_k(G128_121),.Pi_k(P128_121),.Gk_1_j(G120_113),.Pk_1_j(P120_113),.Gi_j(G128_113),.Pi_j(P128_113));

            BLACK_CELL INS4_129(.Gi_k(G129_122),.Pi_k(P129_122),.Gk_1_j(G121_114),.Pk_1_j(P121_114),.Gi_j(G129_114),.Pi_j(P129_114));

            GRAY_CELL INS5_16(.Gi_k(G16_1),.Pi_k(P16_1),.Gk_1_j(G0_0),.Gi_j(G16_0));

            GRAY_CELL INS5_17(.Gi_k(G17_2),.Pi_k(P17_2),.Gk_1_j(G1_0),.Gi_j(G17_0));

            GRAY_CELL INS5_18(.Gi_k(G18_3),.Pi_k(P18_3),.Gk_1_j(G2_0),.Gi_j(G18_0));

            GRAY_CELL INS5_19(.Gi_k(G19_4),.Pi_k(P19_4),.Gk_1_j(G3_0),.Gi_j(G19_0));

            GRAY_CELL INS5_20(.Gi_k(G20_5),.Pi_k(P20_5),.Gk_1_j(G4_0),.Gi_j(G20_0));

            GRAY_CELL INS5_21(.Gi_k(G21_6),.Pi_k(P21_6),.Gk_1_j(G5_0),.Gi_j(G21_0));

            GRAY_CELL INS5_22(.Gi_k(G22_7),.Pi_k(P22_7),.Gk_1_j(G6_0),.Gi_j(G22_0));

            GRAY_CELL INS5_23(.Gi_k(G23_8),.Pi_k(P23_8),.Gk_1_j(G7_0),.Gi_j(G23_0));

            GRAY_CELL INS5_24(.Gi_k(G24_9),.Pi_k(P24_9),.Gk_1_j(G8_0),.Gi_j(G24_0));

            GRAY_CELL INS5_25(.Gi_k(G25_10),.Pi_k(P25_10),.Gk_1_j(G9_0),.Gi_j(G25_0));

            GRAY_CELL INS5_26(.Gi_k(G26_11),.Pi_k(P26_11),.Gk_1_j(G10_0),.Gi_j(G26_0));

            GRAY_CELL INS5_27(.Gi_k(G27_12),.Pi_k(P27_12),.Gk_1_j(G11_0),.Gi_j(G27_0));

            GRAY_CELL INS5_28(.Gi_k(G28_13),.Pi_k(P28_13),.Gk_1_j(G12_0),.Gi_j(G28_0));

            GRAY_CELL INS5_29(.Gi_k(G29_14),.Pi_k(P29_14),.Gk_1_j(G13_0),.Gi_j(G29_0));

            GRAY_CELL INS5_30(.Gi_k(G30_15),.Pi_k(P30_15),.Gk_1_j(G14_0),.Gi_j(G30_0));

            GRAY_CELL INS5_31(.Gi_k(G31_16),.Pi_k(P31_16),.Gk_1_j(G15_0),.Gi_j(G31_0));

            BLACK_CELL INS5_32(.Gi_k(G32_17),.Pi_k(P32_17),.Gk_1_j(G16_1),.Pk_1_j(P16_1),.Gi_j(G32_1),.Pi_j(P32_1));

            BLACK_CELL INS5_33(.Gi_k(G33_18),.Pi_k(P33_18),.Gk_1_j(G17_2),.Pk_1_j(P17_2),.Gi_j(G33_2),.Pi_j(P33_2));

            BLACK_CELL INS5_34(.Gi_k(G34_19),.Pi_k(P34_19),.Gk_1_j(G18_3),.Pk_1_j(P18_3),.Gi_j(G34_3),.Pi_j(P34_3));

            BLACK_CELL INS5_35(.Gi_k(G35_20),.Pi_k(P35_20),.Gk_1_j(G19_4),.Pk_1_j(P19_4),.Gi_j(G35_4),.Pi_j(P35_4));

            BLACK_CELL INS5_36(.Gi_k(G36_21),.Pi_k(P36_21),.Gk_1_j(G20_5),.Pk_1_j(P20_5),.Gi_j(G36_5),.Pi_j(P36_5));

            BLACK_CELL INS5_37(.Gi_k(G37_22),.Pi_k(P37_22),.Gk_1_j(G21_6),.Pk_1_j(P21_6),.Gi_j(G37_6),.Pi_j(P37_6));

            BLACK_CELL INS5_38(.Gi_k(G38_23),.Pi_k(P38_23),.Gk_1_j(G22_7),.Pk_1_j(P22_7),.Gi_j(G38_7),.Pi_j(P38_7));

            BLACK_CELL INS5_39(.Gi_k(G39_24),.Pi_k(P39_24),.Gk_1_j(G23_8),.Pk_1_j(P23_8),.Gi_j(G39_8),.Pi_j(P39_8));

            BLACK_CELL INS5_40(.Gi_k(G40_25),.Pi_k(P40_25),.Gk_1_j(G24_9),.Pk_1_j(P24_9),.Gi_j(G40_9),.Pi_j(P40_9));

            BLACK_CELL INS5_41(.Gi_k(G41_26),.Pi_k(P41_26),.Gk_1_j(G25_10),.Pk_1_j(P25_10),.Gi_j(G41_10),.Pi_j(P41_10));

            BLACK_CELL INS5_42(.Gi_k(G42_27),.Pi_k(P42_27),.Gk_1_j(G26_11),.Pk_1_j(P26_11),.Gi_j(G42_11),.Pi_j(P42_11));

            BLACK_CELL INS5_43(.Gi_k(G43_28),.Pi_k(P43_28),.Gk_1_j(G27_12),.Pk_1_j(P27_12),.Gi_j(G43_12),.Pi_j(P43_12));

            BLACK_CELL INS5_44(.Gi_k(G44_29),.Pi_k(P44_29),.Gk_1_j(G28_13),.Pk_1_j(P28_13),.Gi_j(G44_13),.Pi_j(P44_13));

            BLACK_CELL INS5_45(.Gi_k(G45_30),.Pi_k(P45_30),.Gk_1_j(G29_14),.Pk_1_j(P29_14),.Gi_j(G45_14),.Pi_j(P45_14));

            BLACK_CELL INS5_46(.Gi_k(G46_31),.Pi_k(P46_31),.Gk_1_j(G30_15),.Pk_1_j(P30_15),.Gi_j(G46_15),.Pi_j(P46_15));

            BLACK_CELL INS5_47(.Gi_k(G47_32),.Pi_k(P47_32),.Gk_1_j(G31_16),.Pk_1_j(P31_16),.Gi_j(G47_16),.Pi_j(P47_16));

            BLACK_CELL INS5_48(.Gi_k(G48_33),.Pi_k(P48_33),.Gk_1_j(G32_17),.Pk_1_j(P32_17),.Gi_j(G48_17),.Pi_j(P48_17));

            BLACK_CELL INS5_49(.Gi_k(G49_34),.Pi_k(P49_34),.Gk_1_j(G33_18),.Pk_1_j(P33_18),.Gi_j(G49_18),.Pi_j(P49_18));

            BLACK_CELL INS5_50(.Gi_k(G50_35),.Pi_k(P50_35),.Gk_1_j(G34_19),.Pk_1_j(P34_19),.Gi_j(G50_19),.Pi_j(P50_19));

            BLACK_CELL INS5_51(.Gi_k(G51_36),.Pi_k(P51_36),.Gk_1_j(G35_20),.Pk_1_j(P35_20),.Gi_j(G51_20),.Pi_j(P51_20));

            BLACK_CELL INS5_52(.Gi_k(G52_37),.Pi_k(P52_37),.Gk_1_j(G36_21),.Pk_1_j(P36_21),.Gi_j(G52_21),.Pi_j(P52_21));

            BLACK_CELL INS5_53(.Gi_k(G53_38),.Pi_k(P53_38),.Gk_1_j(G37_22),.Pk_1_j(P37_22),.Gi_j(G53_22),.Pi_j(P53_22));

            BLACK_CELL INS5_54(.Gi_k(G54_39),.Pi_k(P54_39),.Gk_1_j(G38_23),.Pk_1_j(P38_23),.Gi_j(G54_23),.Pi_j(P54_23));

            BLACK_CELL INS5_55(.Gi_k(G55_40),.Pi_k(P55_40),.Gk_1_j(G39_24),.Pk_1_j(P39_24),.Gi_j(G55_24),.Pi_j(P55_24));

            BLACK_CELL INS5_56(.Gi_k(G56_41),.Pi_k(P56_41),.Gk_1_j(G40_25),.Pk_1_j(P40_25),.Gi_j(G56_25),.Pi_j(P56_25));

            BLACK_CELL INS5_57(.Gi_k(G57_42),.Pi_k(P57_42),.Gk_1_j(G41_26),.Pk_1_j(P41_26),.Gi_j(G57_26),.Pi_j(P57_26));

            BLACK_CELL INS5_58(.Gi_k(G58_43),.Pi_k(P58_43),.Gk_1_j(G42_27),.Pk_1_j(P42_27),.Gi_j(G58_27),.Pi_j(P58_27));

            BLACK_CELL INS5_59(.Gi_k(G59_44),.Pi_k(P59_44),.Gk_1_j(G43_28),.Pk_1_j(P43_28),.Gi_j(G59_28),.Pi_j(P59_28));

            BLACK_CELL INS5_60(.Gi_k(G60_45),.Pi_k(P60_45),.Gk_1_j(G44_29),.Pk_1_j(P44_29),.Gi_j(G60_29),.Pi_j(P60_29));

            BLACK_CELL INS5_61(.Gi_k(G61_46),.Pi_k(P61_46),.Gk_1_j(G45_30),.Pk_1_j(P45_30),.Gi_j(G61_30),.Pi_j(P61_30));

            BLACK_CELL INS5_62(.Gi_k(G62_47),.Pi_k(P62_47),.Gk_1_j(G46_31),.Pk_1_j(P46_31),.Gi_j(G62_31),.Pi_j(P62_31));

            BLACK_CELL INS5_63(.Gi_k(G63_48),.Pi_k(P63_48),.Gk_1_j(G47_32),.Pk_1_j(P47_32),.Gi_j(G63_32),.Pi_j(P63_32));

            BLACK_CELL INS5_64(.Gi_k(G64_49),.Pi_k(P64_49),.Gk_1_j(G48_33),.Pk_1_j(P48_33),.Gi_j(G64_33),.Pi_j(P64_33));

            BLACK_CELL INS5_65(.Gi_k(G65_50),.Pi_k(P65_50),.Gk_1_j(G49_34),.Pk_1_j(P49_34),.Gi_j(G65_34),.Pi_j(P65_34));

            BLACK_CELL INS5_66(.Gi_k(G66_51),.Pi_k(P66_51),.Gk_1_j(G50_35),.Pk_1_j(P50_35),.Gi_j(G66_35),.Pi_j(P66_35));

            BLACK_CELL INS5_67(.Gi_k(G67_52),.Pi_k(P67_52),.Gk_1_j(G51_36),.Pk_1_j(P51_36),.Gi_j(G67_36),.Pi_j(P67_36));

            BLACK_CELL INS5_68(.Gi_k(G68_53),.Pi_k(P68_53),.Gk_1_j(G52_37),.Pk_1_j(P52_37),.Gi_j(G68_37),.Pi_j(P68_37));

            BLACK_CELL INS5_69(.Gi_k(G69_54),.Pi_k(P69_54),.Gk_1_j(G53_38),.Pk_1_j(P53_38),.Gi_j(G69_38),.Pi_j(P69_38));

            BLACK_CELL INS5_70(.Gi_k(G70_55),.Pi_k(P70_55),.Gk_1_j(G54_39),.Pk_1_j(P54_39),.Gi_j(G70_39),.Pi_j(P70_39));

            BLACK_CELL INS5_71(.Gi_k(G71_56),.Pi_k(P71_56),.Gk_1_j(G55_40),.Pk_1_j(P55_40),.Gi_j(G71_40),.Pi_j(P71_40));

            BLACK_CELL INS5_72(.Gi_k(G72_57),.Pi_k(P72_57),.Gk_1_j(G56_41),.Pk_1_j(P56_41),.Gi_j(G72_41),.Pi_j(P72_41));

            BLACK_CELL INS5_73(.Gi_k(G73_58),.Pi_k(P73_58),.Gk_1_j(G57_42),.Pk_1_j(P57_42),.Gi_j(G73_42),.Pi_j(P73_42));

            BLACK_CELL INS5_74(.Gi_k(G74_59),.Pi_k(P74_59),.Gk_1_j(G58_43),.Pk_1_j(P58_43),.Gi_j(G74_43),.Pi_j(P74_43));

            BLACK_CELL INS5_75(.Gi_k(G75_60),.Pi_k(P75_60),.Gk_1_j(G59_44),.Pk_1_j(P59_44),.Gi_j(G75_44),.Pi_j(P75_44));

            BLACK_CELL INS5_76(.Gi_k(G76_61),.Pi_k(P76_61),.Gk_1_j(G60_45),.Pk_1_j(P60_45),.Gi_j(G76_45),.Pi_j(P76_45));

            BLACK_CELL INS5_77(.Gi_k(G77_62),.Pi_k(P77_62),.Gk_1_j(G61_46),.Pk_1_j(P61_46),.Gi_j(G77_46),.Pi_j(P77_46));

            BLACK_CELL INS5_78(.Gi_k(G78_63),.Pi_k(P78_63),.Gk_1_j(G62_47),.Pk_1_j(P62_47),.Gi_j(G78_47),.Pi_j(P78_47));

            BLACK_CELL INS5_79(.Gi_k(G79_64),.Pi_k(P79_64),.Gk_1_j(G63_48),.Pk_1_j(P63_48),.Gi_j(G79_48),.Pi_j(P79_48));

            BLACK_CELL INS5_80(.Gi_k(G80_65),.Pi_k(P80_65),.Gk_1_j(G64_49),.Pk_1_j(P64_49),.Gi_j(G80_49),.Pi_j(P80_49));

            BLACK_CELL INS5_81(.Gi_k(G81_66),.Pi_k(P81_66),.Gk_1_j(G65_50),.Pk_1_j(P65_50),.Gi_j(G81_50),.Pi_j(P81_50));

            BLACK_CELL INS5_82(.Gi_k(G82_67),.Pi_k(P82_67),.Gk_1_j(G66_51),.Pk_1_j(P66_51),.Gi_j(G82_51),.Pi_j(P82_51));

            BLACK_CELL INS5_83(.Gi_k(G83_68),.Pi_k(P83_68),.Gk_1_j(G67_52),.Pk_1_j(P67_52),.Gi_j(G83_52),.Pi_j(P83_52));

            BLACK_CELL INS5_84(.Gi_k(G84_69),.Pi_k(P84_69),.Gk_1_j(G68_53),.Pk_1_j(P68_53),.Gi_j(G84_53),.Pi_j(P84_53));

            BLACK_CELL INS5_85(.Gi_k(G85_70),.Pi_k(P85_70),.Gk_1_j(G69_54),.Pk_1_j(P69_54),.Gi_j(G85_54),.Pi_j(P85_54));

            BLACK_CELL INS5_86(.Gi_k(G86_71),.Pi_k(P86_71),.Gk_1_j(G70_55),.Pk_1_j(P70_55),.Gi_j(G86_55),.Pi_j(P86_55));

            BLACK_CELL INS5_87(.Gi_k(G87_72),.Pi_k(P87_72),.Gk_1_j(G71_56),.Pk_1_j(P71_56),.Gi_j(G87_56),.Pi_j(P87_56));

            BLACK_CELL INS5_88(.Gi_k(G88_73),.Pi_k(P88_73),.Gk_1_j(G72_57),.Pk_1_j(P72_57),.Gi_j(G88_57),.Pi_j(P88_57));

            BLACK_CELL INS5_89(.Gi_k(G89_74),.Pi_k(P89_74),.Gk_1_j(G73_58),.Pk_1_j(P73_58),.Gi_j(G89_58),.Pi_j(P89_58));

            BLACK_CELL INS5_90(.Gi_k(G90_75),.Pi_k(P90_75),.Gk_1_j(G74_59),.Pk_1_j(P74_59),.Gi_j(G90_59),.Pi_j(P90_59));

            BLACK_CELL INS5_91(.Gi_k(G91_76),.Pi_k(P91_76),.Gk_1_j(G75_60),.Pk_1_j(P75_60),.Gi_j(G91_60),.Pi_j(P91_60));

            BLACK_CELL INS5_92(.Gi_k(G92_77),.Pi_k(P92_77),.Gk_1_j(G76_61),.Pk_1_j(P76_61),.Gi_j(G92_61),.Pi_j(P92_61));

            BLACK_CELL INS5_93(.Gi_k(G93_78),.Pi_k(P93_78),.Gk_1_j(G77_62),.Pk_1_j(P77_62),.Gi_j(G93_62),.Pi_j(P93_62));

            BLACK_CELL INS5_94(.Gi_k(G94_79),.Pi_k(P94_79),.Gk_1_j(G78_63),.Pk_1_j(P78_63),.Gi_j(G94_63),.Pi_j(P94_63));

            BLACK_CELL INS5_95(.Gi_k(G95_80),.Pi_k(P95_80),.Gk_1_j(G79_64),.Pk_1_j(P79_64),.Gi_j(G95_64),.Pi_j(P95_64));

            BLACK_CELL INS5_96(.Gi_k(G96_81),.Pi_k(P96_81),.Gk_1_j(G80_65),.Pk_1_j(P80_65),.Gi_j(G96_65),.Pi_j(P96_65));

            BLACK_CELL INS5_97(.Gi_k(G97_82),.Pi_k(P97_82),.Gk_1_j(G81_66),.Pk_1_j(P81_66),.Gi_j(G97_66),.Pi_j(P97_66));

            BLACK_CELL INS5_98(.Gi_k(G98_83),.Pi_k(P98_83),.Gk_1_j(G82_67),.Pk_1_j(P82_67),.Gi_j(G98_67),.Pi_j(P98_67));

            BLACK_CELL INS5_99(.Gi_k(G99_84),.Pi_k(P99_84),.Gk_1_j(G83_68),.Pk_1_j(P83_68),.Gi_j(G99_68),.Pi_j(P99_68));

            BLACK_CELL INS5_100(.Gi_k(G100_85),.Pi_k(P100_85),.Gk_1_j(G84_69),.Pk_1_j(P84_69),.Gi_j(G100_69),.Pi_j(P100_69));

            BLACK_CELL INS5_101(.Gi_k(G101_86),.Pi_k(P101_86),.Gk_1_j(G85_70),.Pk_1_j(P85_70),.Gi_j(G101_70),.Pi_j(P101_70));

            BLACK_CELL INS5_102(.Gi_k(G102_87),.Pi_k(P102_87),.Gk_1_j(G86_71),.Pk_1_j(P86_71),.Gi_j(G102_71),.Pi_j(P102_71));

            BLACK_CELL INS5_103(.Gi_k(G103_88),.Pi_k(P103_88),.Gk_1_j(G87_72),.Pk_1_j(P87_72),.Gi_j(G103_72),.Pi_j(P103_72));

            BLACK_CELL INS5_104(.Gi_k(G104_89),.Pi_k(P104_89),.Gk_1_j(G88_73),.Pk_1_j(P88_73),.Gi_j(G104_73),.Pi_j(P104_73));

            BLACK_CELL INS5_105(.Gi_k(G105_90),.Pi_k(P105_90),.Gk_1_j(G89_74),.Pk_1_j(P89_74),.Gi_j(G105_74),.Pi_j(P105_74));

            BLACK_CELL INS5_106(.Gi_k(G106_91),.Pi_k(P106_91),.Gk_1_j(G90_75),.Pk_1_j(P90_75),.Gi_j(G106_75),.Pi_j(P106_75));

            BLACK_CELL INS5_107(.Gi_k(G107_92),.Pi_k(P107_92),.Gk_1_j(G91_76),.Pk_1_j(P91_76),.Gi_j(G107_76),.Pi_j(P107_76));

            BLACK_CELL INS5_108(.Gi_k(G108_93),.Pi_k(P108_93),.Gk_1_j(G92_77),.Pk_1_j(P92_77),.Gi_j(G108_77),.Pi_j(P108_77));

            BLACK_CELL INS5_109(.Gi_k(G109_94),.Pi_k(P109_94),.Gk_1_j(G93_78),.Pk_1_j(P93_78),.Gi_j(G109_78),.Pi_j(P109_78));

            BLACK_CELL INS5_110(.Gi_k(G110_95),.Pi_k(P110_95),.Gk_1_j(G94_79),.Pk_1_j(P94_79),.Gi_j(G110_79),.Pi_j(P110_79));

            BLACK_CELL INS5_111(.Gi_k(G111_96),.Pi_k(P111_96),.Gk_1_j(G95_80),.Pk_1_j(P95_80),.Gi_j(G111_80),.Pi_j(P111_80));

            BLACK_CELL INS5_112(.Gi_k(G112_97),.Pi_k(P112_97),.Gk_1_j(G96_81),.Pk_1_j(P96_81),.Gi_j(G112_81),.Pi_j(P112_81));

            BLACK_CELL INS5_113(.Gi_k(G113_98),.Pi_k(P113_98),.Gk_1_j(G97_82),.Pk_1_j(P97_82),.Gi_j(G113_82),.Pi_j(P113_82));

            BLACK_CELL INS5_114(.Gi_k(G114_99),.Pi_k(P114_99),.Gk_1_j(G98_83),.Pk_1_j(P98_83),.Gi_j(G114_83),.Pi_j(P114_83));

            BLACK_CELL INS5_115(.Gi_k(G115_100),.Pi_k(P115_100),.Gk_1_j(G99_84),.Pk_1_j(P99_84),.Gi_j(G115_84),.Pi_j(P115_84));

            BLACK_CELL INS5_116(.Gi_k(G116_101),.Pi_k(P116_101),.Gk_1_j(G100_85),.Pk_1_j(P100_85),.Gi_j(G116_85),.Pi_j(P116_85));

            BLACK_CELL INS5_117(.Gi_k(G117_102),.Pi_k(P117_102),.Gk_1_j(G101_86),.Pk_1_j(P101_86),.Gi_j(G117_86),.Pi_j(P117_86));

            BLACK_CELL INS5_118(.Gi_k(G118_103),.Pi_k(P118_103),.Gk_1_j(G102_87),.Pk_1_j(P102_87),.Gi_j(G118_87),.Pi_j(P118_87));

            BLACK_CELL INS5_119(.Gi_k(G119_104),.Pi_k(P119_104),.Gk_1_j(G103_88),.Pk_1_j(P103_88),.Gi_j(G119_88),.Pi_j(P119_88));

            BLACK_CELL INS5_120(.Gi_k(G120_105),.Pi_k(P120_105),.Gk_1_j(G104_89),.Pk_1_j(P104_89),.Gi_j(G120_89),.Pi_j(P120_89));

            BLACK_CELL INS5_121(.Gi_k(G121_106),.Pi_k(P121_106),.Gk_1_j(G105_90),.Pk_1_j(P105_90),.Gi_j(G121_90),.Pi_j(P121_90));

            BLACK_CELL INS5_122(.Gi_k(G122_107),.Pi_k(P122_107),.Gk_1_j(G106_91),.Pk_1_j(P106_91),.Gi_j(G122_91),.Pi_j(P122_91));

            BLACK_CELL INS5_123(.Gi_k(G123_108),.Pi_k(P123_108),.Gk_1_j(G107_92),.Pk_1_j(P107_92),.Gi_j(G123_92),.Pi_j(P123_92));

            BLACK_CELL INS5_124(.Gi_k(G124_109),.Pi_k(P124_109),.Gk_1_j(G108_93),.Pk_1_j(P108_93),.Gi_j(G124_93),.Pi_j(P124_93));

            BLACK_CELL INS5_125(.Gi_k(G125_110),.Pi_k(P125_110),.Gk_1_j(G109_94),.Pk_1_j(P109_94),.Gi_j(G125_94),.Pi_j(P125_94));

            BLACK_CELL INS5_126(.Gi_k(G126_111),.Pi_k(P126_111),.Gk_1_j(G110_95),.Pk_1_j(P110_95),.Gi_j(G126_95),.Pi_j(P126_95));

            BLACK_CELL INS5_127(.Gi_k(G127_112),.Pi_k(P127_112),.Gk_1_j(G111_96),.Pk_1_j(P111_96),.Gi_j(G127_96),.Pi_j(P127_96));

            BLACK_CELL INS5_128(.Gi_k(G128_113),.Pi_k(P128_113),.Gk_1_j(G112_97),.Pk_1_j(P112_97),.Gi_j(G128_97),.Pi_j(P128_97));

            BLACK_CELL INS5_129(.Gi_k(G129_114),.Pi_k(P129_114),.Gk_1_j(G113_98),.Pk_1_j(P113_98),.Gi_j(G129_98),.Pi_j(P129_98));

            GRAY_CELL INS6_32(.Gi_k(G32_1),.Pi_k(P32_1),.Gk_1_j(G0_0),.Gi_j(G32_0));

            GRAY_CELL INS6_33(.Gi_k(G33_2),.Pi_k(P33_2),.Gk_1_j(G1_0),.Gi_j(G33_0));

            GRAY_CELL INS6_34(.Gi_k(G34_3),.Pi_k(P34_3),.Gk_1_j(G2_0),.Gi_j(G34_0));

            GRAY_CELL INS6_35(.Gi_k(G35_4),.Pi_k(P35_4),.Gk_1_j(G3_0),.Gi_j(G35_0));

            GRAY_CELL INS6_36(.Gi_k(G36_5),.Pi_k(P36_5),.Gk_1_j(G4_0),.Gi_j(G36_0));

            GRAY_CELL INS6_37(.Gi_k(G37_6),.Pi_k(P37_6),.Gk_1_j(G5_0),.Gi_j(G37_0));

            GRAY_CELL INS6_38(.Gi_k(G38_7),.Pi_k(P38_7),.Gk_1_j(G6_0),.Gi_j(G38_0));

            GRAY_CELL INS6_39(.Gi_k(G39_8),.Pi_k(P39_8),.Gk_1_j(G7_0),.Gi_j(G39_0));

            GRAY_CELL INS6_40(.Gi_k(G40_9),.Pi_k(P40_9),.Gk_1_j(G8_0),.Gi_j(G40_0));

            GRAY_CELL INS6_41(.Gi_k(G41_10),.Pi_k(P41_10),.Gk_1_j(G9_0),.Gi_j(G41_0));

            GRAY_CELL INS6_42(.Gi_k(G42_11),.Pi_k(P42_11),.Gk_1_j(G10_0),.Gi_j(G42_0));

            GRAY_CELL INS6_43(.Gi_k(G43_12),.Pi_k(P43_12),.Gk_1_j(G11_0),.Gi_j(G43_0));

            GRAY_CELL INS6_44(.Gi_k(G44_13),.Pi_k(P44_13),.Gk_1_j(G12_0),.Gi_j(G44_0));

            GRAY_CELL INS6_45(.Gi_k(G45_14),.Pi_k(P45_14),.Gk_1_j(G13_0),.Gi_j(G45_0));

            GRAY_CELL INS6_46(.Gi_k(G46_15),.Pi_k(P46_15),.Gk_1_j(G14_0),.Gi_j(G46_0));

            GRAY_CELL INS6_47(.Gi_k(G47_16),.Pi_k(P47_16),.Gk_1_j(G15_0),.Gi_j(G47_0));

            GRAY_CELL INS6_48(.Gi_k(G48_17),.Pi_k(P48_17),.Gk_1_j(G16_0),.Gi_j(G48_0));

            GRAY_CELL INS6_49(.Gi_k(G49_18),.Pi_k(P49_18),.Gk_1_j(G17_0),.Gi_j(G49_0));

            GRAY_CELL INS6_50(.Gi_k(G50_19),.Pi_k(P50_19),.Gk_1_j(G18_0),.Gi_j(G50_0));

            GRAY_CELL INS6_51(.Gi_k(G51_20),.Pi_k(P51_20),.Gk_1_j(G19_0),.Gi_j(G51_0));

            GRAY_CELL INS6_52(.Gi_k(G52_21),.Pi_k(P52_21),.Gk_1_j(G20_0),.Gi_j(G52_0));

            GRAY_CELL INS6_53(.Gi_k(G53_22),.Pi_k(P53_22),.Gk_1_j(G21_0),.Gi_j(G53_0));

            GRAY_CELL INS6_54(.Gi_k(G54_23),.Pi_k(P54_23),.Gk_1_j(G22_0),.Gi_j(G54_0));

            GRAY_CELL INS6_55(.Gi_k(G55_24),.Pi_k(P55_24),.Gk_1_j(G23_0),.Gi_j(G55_0));

            GRAY_CELL INS6_56(.Gi_k(G56_25),.Pi_k(P56_25),.Gk_1_j(G24_0),.Gi_j(G56_0));

            GRAY_CELL INS6_57(.Gi_k(G57_26),.Pi_k(P57_26),.Gk_1_j(G25_0),.Gi_j(G57_0));

            GRAY_CELL INS6_58(.Gi_k(G58_27),.Pi_k(P58_27),.Gk_1_j(G26_0),.Gi_j(G58_0));

            GRAY_CELL INS6_59(.Gi_k(G59_28),.Pi_k(P59_28),.Gk_1_j(G27_0),.Gi_j(G59_0));

            GRAY_CELL INS6_60(.Gi_k(G60_29),.Pi_k(P60_29),.Gk_1_j(G28_0),.Gi_j(G60_0));

            GRAY_CELL INS6_61(.Gi_k(G61_30),.Pi_k(P61_30),.Gk_1_j(G29_0),.Gi_j(G61_0));

            GRAY_CELL INS6_62(.Gi_k(G62_31),.Pi_k(P62_31),.Gk_1_j(G30_0),.Gi_j(G62_0));

            GRAY_CELL INS6_63(.Gi_k(G63_32),.Pi_k(P63_32),.Gk_1_j(G31_0),.Gi_j(G63_0));

            BLACK_CELL INS6_64(.Gi_k(G64_33),.Pi_k(P64_33),.Gk_1_j(G32_1),.Pk_1_j(P32_1),.Gi_j(G64_1),.Pi_j(P64_1));

            BLACK_CELL INS6_65(.Gi_k(G65_34),.Pi_k(P65_34),.Gk_1_j(G33_2),.Pk_1_j(P33_2),.Gi_j(G65_2),.Pi_j(P65_2));

            BLACK_CELL INS6_66(.Gi_k(G66_35),.Pi_k(P66_35),.Gk_1_j(G34_3),.Pk_1_j(P34_3),.Gi_j(G66_3),.Pi_j(P66_3));

            BLACK_CELL INS6_67(.Gi_k(G67_36),.Pi_k(P67_36),.Gk_1_j(G35_4),.Pk_1_j(P35_4),.Gi_j(G67_4),.Pi_j(P67_4));

            BLACK_CELL INS6_68(.Gi_k(G68_37),.Pi_k(P68_37),.Gk_1_j(G36_5),.Pk_1_j(P36_5),.Gi_j(G68_5),.Pi_j(P68_5));

            BLACK_CELL INS6_69(.Gi_k(G69_38),.Pi_k(P69_38),.Gk_1_j(G37_6),.Pk_1_j(P37_6),.Gi_j(G69_6),.Pi_j(P69_6));

            BLACK_CELL INS6_70(.Gi_k(G70_39),.Pi_k(P70_39),.Gk_1_j(G38_7),.Pk_1_j(P38_7),.Gi_j(G70_7),.Pi_j(P70_7));

            BLACK_CELL INS6_71(.Gi_k(G71_40),.Pi_k(P71_40),.Gk_1_j(G39_8),.Pk_1_j(P39_8),.Gi_j(G71_8),.Pi_j(P71_8));

            BLACK_CELL INS6_72(.Gi_k(G72_41),.Pi_k(P72_41),.Gk_1_j(G40_9),.Pk_1_j(P40_9),.Gi_j(G72_9),.Pi_j(P72_9));

            BLACK_CELL INS6_73(.Gi_k(G73_42),.Pi_k(P73_42),.Gk_1_j(G41_10),.Pk_1_j(P41_10),.Gi_j(G73_10),.Pi_j(P73_10));

            BLACK_CELL INS6_74(.Gi_k(G74_43),.Pi_k(P74_43),.Gk_1_j(G42_11),.Pk_1_j(P42_11),.Gi_j(G74_11),.Pi_j(P74_11));

            BLACK_CELL INS6_75(.Gi_k(G75_44),.Pi_k(P75_44),.Gk_1_j(G43_12),.Pk_1_j(P43_12),.Gi_j(G75_12),.Pi_j(P75_12));

            BLACK_CELL INS6_76(.Gi_k(G76_45),.Pi_k(P76_45),.Gk_1_j(G44_13),.Pk_1_j(P44_13),.Gi_j(G76_13),.Pi_j(P76_13));

            BLACK_CELL INS6_77(.Gi_k(G77_46),.Pi_k(P77_46),.Gk_1_j(G45_14),.Pk_1_j(P45_14),.Gi_j(G77_14),.Pi_j(P77_14));

            BLACK_CELL INS6_78(.Gi_k(G78_47),.Pi_k(P78_47),.Gk_1_j(G46_15),.Pk_1_j(P46_15),.Gi_j(G78_15),.Pi_j(P78_15));

            BLACK_CELL INS6_79(.Gi_k(G79_48),.Pi_k(P79_48),.Gk_1_j(G47_16),.Pk_1_j(P47_16),.Gi_j(G79_16),.Pi_j(P79_16));

            BLACK_CELL INS6_80(.Gi_k(G80_49),.Pi_k(P80_49),.Gk_1_j(G48_17),.Pk_1_j(P48_17),.Gi_j(G80_17),.Pi_j(P80_17));

            BLACK_CELL INS6_81(.Gi_k(G81_50),.Pi_k(P81_50),.Gk_1_j(G49_18),.Pk_1_j(P49_18),.Gi_j(G81_18),.Pi_j(P81_18));

            BLACK_CELL INS6_82(.Gi_k(G82_51),.Pi_k(P82_51),.Gk_1_j(G50_19),.Pk_1_j(P50_19),.Gi_j(G82_19),.Pi_j(P82_19));

            BLACK_CELL INS6_83(.Gi_k(G83_52),.Pi_k(P83_52),.Gk_1_j(G51_20),.Pk_1_j(P51_20),.Gi_j(G83_20),.Pi_j(P83_20));

            BLACK_CELL INS6_84(.Gi_k(G84_53),.Pi_k(P84_53),.Gk_1_j(G52_21),.Pk_1_j(P52_21),.Gi_j(G84_21),.Pi_j(P84_21));

            BLACK_CELL INS6_85(.Gi_k(G85_54),.Pi_k(P85_54),.Gk_1_j(G53_22),.Pk_1_j(P53_22),.Gi_j(G85_22),.Pi_j(P85_22));

            BLACK_CELL INS6_86(.Gi_k(G86_55),.Pi_k(P86_55),.Gk_1_j(G54_23),.Pk_1_j(P54_23),.Gi_j(G86_23),.Pi_j(P86_23));

            BLACK_CELL INS6_87(.Gi_k(G87_56),.Pi_k(P87_56),.Gk_1_j(G55_24),.Pk_1_j(P55_24),.Gi_j(G87_24),.Pi_j(P87_24));

            BLACK_CELL INS6_88(.Gi_k(G88_57),.Pi_k(P88_57),.Gk_1_j(G56_25),.Pk_1_j(P56_25),.Gi_j(G88_25),.Pi_j(P88_25));

            BLACK_CELL INS6_89(.Gi_k(G89_58),.Pi_k(P89_58),.Gk_1_j(G57_26),.Pk_1_j(P57_26),.Gi_j(G89_26),.Pi_j(P89_26));

            BLACK_CELL INS6_90(.Gi_k(G90_59),.Pi_k(P90_59),.Gk_1_j(G58_27),.Pk_1_j(P58_27),.Gi_j(G90_27),.Pi_j(P90_27));

            BLACK_CELL INS6_91(.Gi_k(G91_60),.Pi_k(P91_60),.Gk_1_j(G59_28),.Pk_1_j(P59_28),.Gi_j(G91_28),.Pi_j(P91_28));

            BLACK_CELL INS6_92(.Gi_k(G92_61),.Pi_k(P92_61),.Gk_1_j(G60_29),.Pk_1_j(P60_29),.Gi_j(G92_29),.Pi_j(P92_29));

            BLACK_CELL INS6_93(.Gi_k(G93_62),.Pi_k(P93_62),.Gk_1_j(G61_30),.Pk_1_j(P61_30),.Gi_j(G93_30),.Pi_j(P93_30));

            BLACK_CELL INS6_94(.Gi_k(G94_63),.Pi_k(P94_63),.Gk_1_j(G62_31),.Pk_1_j(P62_31),.Gi_j(G94_31),.Pi_j(P94_31));

            BLACK_CELL INS6_95(.Gi_k(G95_64),.Pi_k(P95_64),.Gk_1_j(G63_32),.Pk_1_j(P63_32),.Gi_j(G95_32),.Pi_j(P95_32));

            BLACK_CELL INS6_96(.Gi_k(G96_65),.Pi_k(P96_65),.Gk_1_j(G64_33),.Pk_1_j(P64_33),.Gi_j(G96_33),.Pi_j(P96_33));

            BLACK_CELL INS6_97(.Gi_k(G97_66),.Pi_k(P97_66),.Gk_1_j(G65_34),.Pk_1_j(P65_34),.Gi_j(G97_34),.Pi_j(P97_34));

            BLACK_CELL INS6_98(.Gi_k(G98_67),.Pi_k(P98_67),.Gk_1_j(G66_35),.Pk_1_j(P66_35),.Gi_j(G98_35),.Pi_j(P98_35));

            BLACK_CELL INS6_99(.Gi_k(G99_68),.Pi_k(P99_68),.Gk_1_j(G67_36),.Pk_1_j(P67_36),.Gi_j(G99_36),.Pi_j(P99_36));

            BLACK_CELL INS6_100(.Gi_k(G100_69),.Pi_k(P100_69),.Gk_1_j(G68_37),.Pk_1_j(P68_37),.Gi_j(G100_37),.Pi_j(P100_37));

            BLACK_CELL INS6_101(.Gi_k(G101_70),.Pi_k(P101_70),.Gk_1_j(G69_38),.Pk_1_j(P69_38),.Gi_j(G101_38),.Pi_j(P101_38));

            BLACK_CELL INS6_102(.Gi_k(G102_71),.Pi_k(P102_71),.Gk_1_j(G70_39),.Pk_1_j(P70_39),.Gi_j(G102_39),.Pi_j(P102_39));

            BLACK_CELL INS6_103(.Gi_k(G103_72),.Pi_k(P103_72),.Gk_1_j(G71_40),.Pk_1_j(P71_40),.Gi_j(G103_40),.Pi_j(P103_40));

            BLACK_CELL INS6_104(.Gi_k(G104_73),.Pi_k(P104_73),.Gk_1_j(G72_41),.Pk_1_j(P72_41),.Gi_j(G104_41),.Pi_j(P104_41));

            BLACK_CELL INS6_105(.Gi_k(G105_74),.Pi_k(P105_74),.Gk_1_j(G73_42),.Pk_1_j(P73_42),.Gi_j(G105_42),.Pi_j(P105_42));

            BLACK_CELL INS6_106(.Gi_k(G106_75),.Pi_k(P106_75),.Gk_1_j(G74_43),.Pk_1_j(P74_43),.Gi_j(G106_43),.Pi_j(P106_43));

            BLACK_CELL INS6_107(.Gi_k(G107_76),.Pi_k(P107_76),.Gk_1_j(G75_44),.Pk_1_j(P75_44),.Gi_j(G107_44),.Pi_j(P107_44));

            BLACK_CELL INS6_108(.Gi_k(G108_77),.Pi_k(P108_77),.Gk_1_j(G76_45),.Pk_1_j(P76_45),.Gi_j(G108_45),.Pi_j(P108_45));

            BLACK_CELL INS6_109(.Gi_k(G109_78),.Pi_k(P109_78),.Gk_1_j(G77_46),.Pk_1_j(P77_46),.Gi_j(G109_46),.Pi_j(P109_46));

            BLACK_CELL INS6_110(.Gi_k(G110_79),.Pi_k(P110_79),.Gk_1_j(G78_47),.Pk_1_j(P78_47),.Gi_j(G110_47),.Pi_j(P110_47));

            BLACK_CELL INS6_111(.Gi_k(G111_80),.Pi_k(P111_80),.Gk_1_j(G79_48),.Pk_1_j(P79_48),.Gi_j(G111_48),.Pi_j(P111_48));

            BLACK_CELL INS6_112(.Gi_k(G112_81),.Pi_k(P112_81),.Gk_1_j(G80_49),.Pk_1_j(P80_49),.Gi_j(G112_49),.Pi_j(P112_49));

            BLACK_CELL INS6_113(.Gi_k(G113_82),.Pi_k(P113_82),.Gk_1_j(G81_50),.Pk_1_j(P81_50),.Gi_j(G113_50),.Pi_j(P113_50));

            BLACK_CELL INS6_114(.Gi_k(G114_83),.Pi_k(P114_83),.Gk_1_j(G82_51),.Pk_1_j(P82_51),.Gi_j(G114_51),.Pi_j(P114_51));

            BLACK_CELL INS6_115(.Gi_k(G115_84),.Pi_k(P115_84),.Gk_1_j(G83_52),.Pk_1_j(P83_52),.Gi_j(G115_52),.Pi_j(P115_52));

            BLACK_CELL INS6_116(.Gi_k(G116_85),.Pi_k(P116_85),.Gk_1_j(G84_53),.Pk_1_j(P84_53),.Gi_j(G116_53),.Pi_j(P116_53));

            BLACK_CELL INS6_117(.Gi_k(G117_86),.Pi_k(P117_86),.Gk_1_j(G85_54),.Pk_1_j(P85_54),.Gi_j(G117_54),.Pi_j(P117_54));

            BLACK_CELL INS6_118(.Gi_k(G118_87),.Pi_k(P118_87),.Gk_1_j(G86_55),.Pk_1_j(P86_55),.Gi_j(G118_55),.Pi_j(P118_55));

            BLACK_CELL INS6_119(.Gi_k(G119_88),.Pi_k(P119_88),.Gk_1_j(G87_56),.Pk_1_j(P87_56),.Gi_j(G119_56),.Pi_j(P119_56));

            BLACK_CELL INS6_120(.Gi_k(G120_89),.Pi_k(P120_89),.Gk_1_j(G88_57),.Pk_1_j(P88_57),.Gi_j(G120_57),.Pi_j(P120_57));

            BLACK_CELL INS6_121(.Gi_k(G121_90),.Pi_k(P121_90),.Gk_1_j(G89_58),.Pk_1_j(P89_58),.Gi_j(G121_58),.Pi_j(P121_58));

            BLACK_CELL INS6_122(.Gi_k(G122_91),.Pi_k(P122_91),.Gk_1_j(G90_59),.Pk_1_j(P90_59),.Gi_j(G122_59),.Pi_j(P122_59));

            BLACK_CELL INS6_123(.Gi_k(G123_92),.Pi_k(P123_92),.Gk_1_j(G91_60),.Pk_1_j(P91_60),.Gi_j(G123_60),.Pi_j(P123_60));

            BLACK_CELL INS6_124(.Gi_k(G124_93),.Pi_k(P124_93),.Gk_1_j(G92_61),.Pk_1_j(P92_61),.Gi_j(G124_61),.Pi_j(P124_61));

            BLACK_CELL INS6_125(.Gi_k(G125_94),.Pi_k(P125_94),.Gk_1_j(G93_62),.Pk_1_j(P93_62),.Gi_j(G125_62),.Pi_j(P125_62));

            BLACK_CELL INS6_126(.Gi_k(G126_95),.Pi_k(P126_95),.Gk_1_j(G94_63),.Pk_1_j(P94_63),.Gi_j(G126_63),.Pi_j(P126_63));

            BLACK_CELL INS6_127(.Gi_k(G127_96),.Pi_k(P127_96),.Gk_1_j(G95_64),.Pk_1_j(P95_64),.Gi_j(G127_64),.Pi_j(P127_64));

            BLACK_CELL INS6_128(.Gi_k(G128_97),.Pi_k(P128_97),.Gk_1_j(G96_65),.Pk_1_j(P96_65),.Gi_j(G128_65),.Pi_j(P128_65));

            BLACK_CELL INS6_129(.Gi_k(G129_98),.Pi_k(P129_98),.Gk_1_j(G97_66),.Pk_1_j(P97_66),.Gi_j(G129_66),.Pi_j(P129_66));

            GRAY_CELL INS7_64(.Gi_k(G64_1),.Pi_k(P64_1),.Gk_1_j(G0_0),.Gi_j(G64_0));

            GRAY_CELL INS7_65(.Gi_k(G65_2),.Pi_k(P65_2),.Gk_1_j(G1_0),.Gi_j(G65_0));

            GRAY_CELL INS7_66(.Gi_k(G66_3),.Pi_k(P66_3),.Gk_1_j(G2_0),.Gi_j(G66_0));

            GRAY_CELL INS7_67(.Gi_k(G67_4),.Pi_k(P67_4),.Gk_1_j(G3_0),.Gi_j(G67_0));

            GRAY_CELL INS7_68(.Gi_k(G68_5),.Pi_k(P68_5),.Gk_1_j(G4_0),.Gi_j(G68_0));

            GRAY_CELL INS7_69(.Gi_k(G69_6),.Pi_k(P69_6),.Gk_1_j(G5_0),.Gi_j(G69_0));

            GRAY_CELL INS7_70(.Gi_k(G70_7),.Pi_k(P70_7),.Gk_1_j(G6_0),.Gi_j(G70_0));

            GRAY_CELL INS7_71(.Gi_k(G71_8),.Pi_k(P71_8),.Gk_1_j(G7_0),.Gi_j(G71_0));

            GRAY_CELL INS7_72(.Gi_k(G72_9),.Pi_k(P72_9),.Gk_1_j(G8_0),.Gi_j(G72_0));

            GRAY_CELL INS7_73(.Gi_k(G73_10),.Pi_k(P73_10),.Gk_1_j(G9_0),.Gi_j(G73_0));

            GRAY_CELL INS7_74(.Gi_k(G74_11),.Pi_k(P74_11),.Gk_1_j(G10_0),.Gi_j(G74_0));

            GRAY_CELL INS7_75(.Gi_k(G75_12),.Pi_k(P75_12),.Gk_1_j(G11_0),.Gi_j(G75_0));

            GRAY_CELL INS7_76(.Gi_k(G76_13),.Pi_k(P76_13),.Gk_1_j(G12_0),.Gi_j(G76_0));

            GRAY_CELL INS7_77(.Gi_k(G77_14),.Pi_k(P77_14),.Gk_1_j(G13_0),.Gi_j(G77_0));

            GRAY_CELL INS7_78(.Gi_k(G78_15),.Pi_k(P78_15),.Gk_1_j(G14_0),.Gi_j(G78_0));

            GRAY_CELL INS7_79(.Gi_k(G79_16),.Pi_k(P79_16),.Gk_1_j(G15_0),.Gi_j(G79_0));

            GRAY_CELL INS7_80(.Gi_k(G80_17),.Pi_k(P80_17),.Gk_1_j(G16_0),.Gi_j(G80_0));

            GRAY_CELL INS7_81(.Gi_k(G81_18),.Pi_k(P81_18),.Gk_1_j(G17_0),.Gi_j(G81_0));

            GRAY_CELL INS7_82(.Gi_k(G82_19),.Pi_k(P82_19),.Gk_1_j(G18_0),.Gi_j(G82_0));

            GRAY_CELL INS7_83(.Gi_k(G83_20),.Pi_k(P83_20),.Gk_1_j(G19_0),.Gi_j(G83_0));

            GRAY_CELL INS7_84(.Gi_k(G84_21),.Pi_k(P84_21),.Gk_1_j(G20_0),.Gi_j(G84_0));

            GRAY_CELL INS7_85(.Gi_k(G85_22),.Pi_k(P85_22),.Gk_1_j(G21_0),.Gi_j(G85_0));

            GRAY_CELL INS7_86(.Gi_k(G86_23),.Pi_k(P86_23),.Gk_1_j(G22_0),.Gi_j(G86_0));

            GRAY_CELL INS7_87(.Gi_k(G87_24),.Pi_k(P87_24),.Gk_1_j(G23_0),.Gi_j(G87_0));

            GRAY_CELL INS7_88(.Gi_k(G88_25),.Pi_k(P88_25),.Gk_1_j(G24_0),.Gi_j(G88_0));

            GRAY_CELL INS7_89(.Gi_k(G89_26),.Pi_k(P89_26),.Gk_1_j(G25_0),.Gi_j(G89_0));

            GRAY_CELL INS7_90(.Gi_k(G90_27),.Pi_k(P90_27),.Gk_1_j(G26_0),.Gi_j(G90_0));

            GRAY_CELL INS7_91(.Gi_k(G91_28),.Pi_k(P91_28),.Gk_1_j(G27_0),.Gi_j(G91_0));

            GRAY_CELL INS7_92(.Gi_k(G92_29),.Pi_k(P92_29),.Gk_1_j(G28_0),.Gi_j(G92_0));

            GRAY_CELL INS7_93(.Gi_k(G93_30),.Pi_k(P93_30),.Gk_1_j(G29_0),.Gi_j(G93_0));

            GRAY_CELL INS7_94(.Gi_k(G94_31),.Pi_k(P94_31),.Gk_1_j(G30_0),.Gi_j(G94_0));

            GRAY_CELL INS7_95(.Gi_k(G95_32),.Pi_k(P95_32),.Gk_1_j(G31_0),.Gi_j(G95_0));

            GRAY_CELL INS7_96(.Gi_k(G96_33),.Pi_k(P96_33),.Gk_1_j(G32_0),.Gi_j(G96_0));

            GRAY_CELL INS7_97(.Gi_k(G97_34),.Pi_k(P97_34),.Gk_1_j(G33_0),.Gi_j(G97_0));

            GRAY_CELL INS7_98(.Gi_k(G98_35),.Pi_k(P98_35),.Gk_1_j(G34_0),.Gi_j(G98_0));

            GRAY_CELL INS7_99(.Gi_k(G99_36),.Pi_k(P99_36),.Gk_1_j(G35_0),.Gi_j(G99_0));

            GRAY_CELL INS7_100(.Gi_k(G100_37),.Pi_k(P100_37),.Gk_1_j(G36_0),.Gi_j(G100_0));

            GRAY_CELL INS7_101(.Gi_k(G101_38),.Pi_k(P101_38),.Gk_1_j(G37_0),.Gi_j(G101_0));

            GRAY_CELL INS7_102(.Gi_k(G102_39),.Pi_k(P102_39),.Gk_1_j(G38_0),.Gi_j(G102_0));

            GRAY_CELL INS7_103(.Gi_k(G103_40),.Pi_k(P103_40),.Gk_1_j(G39_0),.Gi_j(G103_0));

            GRAY_CELL INS7_104(.Gi_k(G104_41),.Pi_k(P104_41),.Gk_1_j(G40_0),.Gi_j(G104_0));

            GRAY_CELL INS7_105(.Gi_k(G105_42),.Pi_k(P105_42),.Gk_1_j(G41_0),.Gi_j(G105_0));

            GRAY_CELL INS7_106(.Gi_k(G106_43),.Pi_k(P106_43),.Gk_1_j(G42_0),.Gi_j(G106_0));

            GRAY_CELL INS7_107(.Gi_k(G107_44),.Pi_k(P107_44),.Gk_1_j(G43_0),.Gi_j(G107_0));

            GRAY_CELL INS7_108(.Gi_k(G108_45),.Pi_k(P108_45),.Gk_1_j(G44_0),.Gi_j(G108_0));

            GRAY_CELL INS7_109(.Gi_k(G109_46),.Pi_k(P109_46),.Gk_1_j(G45_0),.Gi_j(G109_0));

            GRAY_CELL INS7_110(.Gi_k(G110_47),.Pi_k(P110_47),.Gk_1_j(G46_0),.Gi_j(G110_0));

            GRAY_CELL INS7_111(.Gi_k(G111_48),.Pi_k(P111_48),.Gk_1_j(G47_0),.Gi_j(G111_0));

            GRAY_CELL INS7_112(.Gi_k(G112_49),.Pi_k(P112_49),.Gk_1_j(G48_0),.Gi_j(G112_0));

            GRAY_CELL INS7_113(.Gi_k(G113_50),.Pi_k(P113_50),.Gk_1_j(G49_0),.Gi_j(G113_0));

            GRAY_CELL INS7_114(.Gi_k(G114_51),.Pi_k(P114_51),.Gk_1_j(G50_0),.Gi_j(G114_0));

            GRAY_CELL INS7_115(.Gi_k(G115_52),.Pi_k(P115_52),.Gk_1_j(G51_0),.Gi_j(G115_0));

            GRAY_CELL INS7_116(.Gi_k(G116_53),.Pi_k(P116_53),.Gk_1_j(G52_0),.Gi_j(G116_0));

            GRAY_CELL INS7_117(.Gi_k(G117_54),.Pi_k(P117_54),.Gk_1_j(G53_0),.Gi_j(G117_0));

            GRAY_CELL INS7_118(.Gi_k(G118_55),.Pi_k(P118_55),.Gk_1_j(G54_0),.Gi_j(G118_0));

            GRAY_CELL INS7_119(.Gi_k(G119_56),.Pi_k(P119_56),.Gk_1_j(G55_0),.Gi_j(G119_0));

            GRAY_CELL INS7_120(.Gi_k(G120_57),.Pi_k(P120_57),.Gk_1_j(G56_0),.Gi_j(G120_0));

            GRAY_CELL INS7_121(.Gi_k(G121_58),.Pi_k(P121_58),.Gk_1_j(G57_0),.Gi_j(G121_0));

            GRAY_CELL INS7_122(.Gi_k(G122_59),.Pi_k(P122_59),.Gk_1_j(G58_0),.Gi_j(G122_0));

            GRAY_CELL INS7_123(.Gi_k(G123_60),.Pi_k(P123_60),.Gk_1_j(G59_0),.Gi_j(G123_0));

            GRAY_CELL INS7_124(.Gi_k(G124_61),.Pi_k(P124_61),.Gk_1_j(G60_0),.Gi_j(G124_0));

            GRAY_CELL INS7_125(.Gi_k(G125_62),.Pi_k(P125_62),.Gk_1_j(G61_0),.Gi_j(G125_0));

            GRAY_CELL INS7_126(.Gi_k(G126_63),.Pi_k(P126_63),.Gk_1_j(G62_0),.Gi_j(G126_0));

            GRAY_CELL INS7_127(.Gi_k(G127_64),.Pi_k(P127_64),.Gk_1_j(G63_0),.Gi_j(G127_0));

            BLACK_CELL INS7_128(.Gi_k(G128_65),.Pi_k(P128_65),.Gk_1_j(G64_1),.Pk_1_j(P64_1),.Gi_j(G128_1),.Pi_j(P128_1));

            BLACK_CELL INS7_129(.Gi_k(G129_66),.Pi_k(P129_66),.Gk_1_j(G65_2),.Pk_1_j(P65_2),.Gi_j(G129_2),.Pi_j(P129_2));

            GRAY_CELL INS8_128(.Gi_k(G128_1),.Pi_k(P128_1),.Gk_1_j(G0_0),.Gi_j(G128_0));

            GRAY_CELL INS8_129(.Gi_k(G129_2),.Pi_k(P129_2),.Gk_1_j(G1_0),.Gi_j(G129_0));

//////////////////////////////////////////////////////////////////////
endmodule
