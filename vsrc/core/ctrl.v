`include "params.v"

module ctrl (
	input [`INST_BUS]           instr           ,
	output     [`CTRL_SIG_BUS]  ctrl_sig        ,
	output     [`OP_TYPE_BUS]   op_type         ,
	output     [`INST_TYPE_BUS] instr_type      ,
	output                      wdata_en        ,
	output                      wcsr_en         ,
	`ifdef RV64
	output                      is_word_op      ,
	`endif

	`ifdef M_EXTENSION
	output reg [`MUL_TYPE_BUS]  mul_type        ,
	output reg [`MUL_TYPE_BUS]  div_type        ,
	`endif

	`ifdef C_EXTENSION
	output reg [`XLEN_BUS]      cimm            ,
	`endif

	output reg [`REG_INDEX_BUS] rs1             ,
	output reg [`REG_INDEX_BUS] rs2             ,
	output reg [`REG_INDEX_BUS] rd              ,
	output                      is_ecall_instr  ,
	output                      is_mret_instr   ,
`ifndef PROC_BRANCH_IN_DC
	output                      is_branch_instr ,
`endif
`ifdef A_EXTENSION
	output                      is_amo_instr    ,
	output                      is_lr           ,
	output                      is_sc           ,
`endif
	output                      is_fencei       ,
	output                      is_store_instr  ,
	output reg [`RLEN_BUS]      rlen            ,
	output reg [`WLEN_BUS]      wlen                 
);

	assign is_fencei = (instr == 32'h0000100f);
	assign is_ecall_instr = (instr == `ECALL)? `IS_ECALL_INSTR : !`IS_ECALL_INSTR;
	assign is_mret_instr = (instr == `MRET)? `IS_MRET_INSTR : !`IS_MRET_INSTR;

`ifndef PROC_BRANCH_IN_DC
	assign is_branch_instr = ((instr_type[`CBTYPE_INDEX]) || (instr_type[`BTYPE_INDEX]))? `IS_BRANCH_INSTR : !`IS_BRANCH_INSTR;
`endif

	assign is_store_instr = (is_stype || is_cstype || is_csstype);

	wire [`INSTR_OPCODE_FIELD] opcode;
	wire [`FUNC3_BUS] func3;
	wire [`FUNC7_BUS] func7;
	wire [`FUNC6_BUS] func6; // srai / srli
`ifdef A_EXTENSION
	wire [`FUNC5_BUS] func5;
`endif

	assign opcode = instr[`INSTR_OPCODE_FIELD];
	assign func3 = instr[`FUNC3_FIELD];
	assign func7 = instr[`FUNC7_FIELD];
	assign func6 = instr[`FUNC6_FIELD];
`ifdef A_EXTENSION
	assign func5 = instr[`FUNC5_FIELD];
	`ifdef RV64
	assign is_amo_instr = ((func3[2:1] == 2'b01) && ((opcode == 7'b0101111) && (func5 == 5'b00011)) || (((opcode == 7'b0101111) && (func5 == 5'b00000)) || ((opcode == 7'b0101111) && (func5 == 5'b01100)) || ((opcode == 7'b0101111) && (func5 == 5'b00100)) || ((opcode == 7'b0101111) && (func5 == 5'b01000)) || ((opcode == 7'b0101111) && (func5 == 5'b10000)) || ((opcode == 7'b0101111) && (func5 == 5'b11000)) || ((opcode == 7'b0101111) && (func5 == 5'b10100)) || ((opcode == 7'b0101111) && (func5 == 5'b11100)) || ((opcode == 7'b0101111) && (func5 == 5'b00001)) || ((opcode == 7'b0101111) && (func5 == 5'b00010) && (instr[24:20] == 5'b00000))))? `IS_AMO_INSTR : !`IS_AMO_INSTR;
	assign is_lr = ((opcode == 7'b0101111) && (func3[2:1] == 2'b01) && (func5 == 5'b00010) && (instr[24:20] == 5'b00000));
	assign is_sc = ((opcode == 7'b0101111) && (func3[2:1] == 2'b01) && (func5 == 5'b00011));
	`else
	assign is_amo_instr = ((func3 == 3'b010) && ((opcode == 7'b0101111) && (func5 == 5'b00011)) || (((opcode == 7'b0101111) && (func5 == 5'b00000)) || ((opcode == 7'b0101111) && (func5 == 5'b01100)) || ((opcode == 7'b0101111) && (func5 == 5'b00100)) || ((opcode == 7'b0101111) && (func5 == 5'b01000)) || ((opcode == 7'b0101111) && (func5 == 5'b10000)) || ((opcode == 7'b0101111) && (func5 == 5'b11000)) || ((opcode == 7'b0101111) && (func5 == 5'b10100)) || ((opcode == 7'b0101111) && (func5 == 5'b11100)) || ((opcode == 7'b0101111) && (func5 == 5'b00001)) || ((opcode == 7'b0101111) && (func5 == 5'b00010) && (instr[24:20] == 5'b00000))))? `IS_AMO_INSTR : !`IS_AMO_INSTR;
	assign is_lr = ((opcode == 7'b0101111) && (func3 == 3'b010) && (func5 == 5'b00010) && (instr[24:20] == 5'b00000));
	assign is_sc = ((opcode == 7'b0101111) && (func3 == 3'b010) && (func5 == 5'b00011));
	`endif
`endif

    wire w_reg_en;
	wire is_from_alu;
	wire op_sel_rs1;
	wire op_sel_rs2;
	wire is_load_or_store_instr;
	wire is_jalr;

`ifdef RV64
	assign w_reg_en = (opcode == 7'b0110011) || (opcode == 7'b0010011) || (opcode == 7'b0000011) || (opcode == 7'b1101111) || (opcode == 7'b1100111) || (opcode == 7'b0110111) || (opcode == 7'b0010111) || (opcode == 7'b0011011) || (opcode == 7'b0111011) || ((opcode == 7'b1110011) && (func3 == 3'b001)) || ((opcode == 7'b1110011) && (func3 == 3'b010)) || ((opcode == 7'b1110011) && (func3 == 3'b011)) || ((opcode == 7'b1110011) && (func3 == 3'b101)) || ((opcode == 7'b1110011) && (func3 == 3'b110)) || ((opcode == 7'b1110011) && (func3 == 3'b111)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b001) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b11) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] != 5'd2)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] == 5'd2)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1001) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1000) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1001) && (instr[11:7] != 5'b00000) && (instr[6:2] == 5'b00000) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1000) && (instr[11:7] != 5'b00000) && (instr[6:2] == 5'b00000) && (instr[1:0] == 2'b10));
`else
	assign w_reg_en = (opcode == 7'b0110011) || (opcode == 7'b0010011) || (opcode == 7'b0000011) || ((instr[15:13] == 3'b001) && (instr[1:0] == 2'b01)) || (opcode == 7'b1101111) || (opcode == 7'b1100111) || (opcode == 7'b0110111) || (opcode == 7'b0010111) || (opcode == 7'b0011011) || (opcode == 7'b0111011) || ((opcode == 7'b1110011) && (func3 == 3'b001)) || ((opcode == 7'b1110011) && (func3 == 3'b010)) || ((opcode == 7'b1110011) && (func3 == 3'b011)) || ((opcode == 7'b1110011) && (func3 == 3'b101)) || ((opcode == 7'b1110011) && (func3 == 3'b110)) || ((opcode == 7'b1110011) && (func3 == 3'b111)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b11) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] != 5'd2)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] == 5'd2)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1001) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1000) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1001) && (instr[11:7] != 5'b00000) && (instr[6:2] == 5'b00000) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1000) && (instr[11:7] != 5'b00000) && (instr[6:2] == 5'b00000) && (instr[1:0] == 2'b10));
`endif

`ifdef RV64
	assign op_sel_rs1 = ((opcode == 7'b0110011) || (opcode == 7'b0010011) || (opcode == 7'b0000011) || (opcode == 7'b0100011) || (opcode == 7'b1100011) || (opcode == 7'b0110111) || (opcode == 7'b0011011) || (opcode == 7'b0111011) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b001) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b11) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] != 5'd2)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] == 5'd2)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1001) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1000) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b01)))? `OP_SEL_RS1:!`OP_SEL_RS1;
`else
	assign op_sel_rs1 = ((opcode == 7'b0110011) || (opcode == 7'b0010011) || (opcode == 7'b0000011) || (opcode == 7'b0100011) || (opcode == 7'b1100011) || (opcode == 7'b0110111) || (opcode == 7'b0011011) || (opcode == 7'b0111011) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b11) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] != 5'd2)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] == 5'd2)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1001) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1000) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b01)))? `OP_SEL_RS1:!`OP_SEL_RS1;
`endif

`ifdef A_EXTENSION
	assign is_load_or_store_instr = (is_amo_instr == `IS_AMO_INSTR) || (opcode == 7'b0000011) || (opcode == 7'b0100011) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b10));
`else
	assign is_load_or_store_instr = (opcode == 7'b0000011) || (opcode == 7'b0100011) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b10));
`endif
`ifdef A_EXTENSION
	assign wdata_en = (is_amo_instr == `IS_AMO_INSTR) || (opcode == 7'b0100011) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b10));
`else
	assign wdata_en = (opcode == 7'b0100011) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b10));
`endif
	assign op_sel_rs2 = ((opcode == 7'b0110011) || (opcode == 7'b1100011) || (opcode == 7'b0111011) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b11) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:12] == 4'b1001) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1000) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b01)))? `OP_SEL_RS2:!`OP_SEL_RS2;
`ifdef RV64
	assign is_from_alu = (opcode == 7'b0110011) || (opcode == 7'b0010011) || (opcode == 7'b0100011) || (opcode == 7'b1101111) || (opcode == 7'b1100111) || (opcode == 7'b1100011) || (opcode == 7'b0110111) || (opcode == 7'b0010111) || (opcode == 7'b0011011) || (opcode == 7'b0111011) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b001) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b01) && (instr[1:0] == 2'b01))  || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b11) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] != 5'd2)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] == 5'd2)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b00)) || ((instr[15:12] == 4'b1001) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1000) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1001) && (instr[11:7] != 5'b00000) && (instr[6:2] == 5'b00000) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1000) && (instr[11:7] != 5'b00000) && (instr[6:2] == 5'b00000) && (instr[1:0] == 2'b10));
`else
	assign is_from_alu = (opcode == 7'b0110011) || (opcode == 7'b0010011) || (opcode == 7'b0100011) || ((instr[15:13] == 3'b001) && (instr[1:0] == 2'b01)) || (opcode == 7'b1101111) || (opcode == 7'b1100111) || (opcode == 7'b1100011) || (opcode == 7'b0110111) || (opcode == 7'b0010111) || (opcode == 7'b0011011) || (opcode == 7'b0111011) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b01) && (instr[1:0] == 2'b01))  || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b11) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] != 5'd2)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] == 5'd2)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b00)) || ((instr[15:12] == 4'b1001) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1000) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1001) && (instr[11:7] != 5'b00000) && (instr[6:2] == 5'b00000) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1000) && (instr[11:7] != 5'b00000) && (instr[6:2] == 5'b00000) && (instr[1:0] == 2'b10));
`endif
	assign is_jalr = (opcode == 7'b1100111) || ((instr[15:12] == 4'b1001) && (instr[11:7] != 5'b00000) && (instr[6:2] == 5'b00000) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1000) && (instr[11:7] != 5'b00000) && (instr[6:2] == 5'b00000) && (instr[1:0] == 2'b10));
	assign wcsr_en = ((opcode == 7'b1110011) && (func3 == 3'b001)) || ((opcode == 7'b1110011) && (func3 == 3'b010)) || ((opcode == 7'b1110011) && (func3 == 3'b011)) || ((opcode == 7'b1110011) && (func3 == 3'b101)) || ((opcode == 7'b1110011) && (func3 == 3'b110)) || ((opcode == 7'b1110011) && (func3 == 3'b111));
`ifdef RV64
	`ifdef A_EXTENSION
	assign is_word_op = ((opcode == 7'b0101111) && (func3 == 3'b010)) || (opcode == 7'b0011011) || (opcode == 7'b0111011) || ((instr[15:13] == 3'b001) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01));
	`else
	assign is_word_op = (opcode == 7'b0011011) || (opcode == 7'b0111011) || ((instr[15:13] == 3'b001) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01));
	`endif
`endif
	assign ctrl_sig = {is_jalr, is_load_or_store_instr, op_sel_rs2, op_sel_rs1, is_from_alu, w_reg_en};


    wire    is_add_op  ;
    wire    is_sub_op  ;
    wire    is_nop_op  ;
    wire    is_le_op   ;
    wire    is_l_op    ;
    wire    is_lu_op   ;
    wire    is_xor_op  ;
    wire    is_and_op  ;
    wire    is_or_op   ;
    wire    is_sll_op  ;
    wire    is_sra_op  ;
    wire    is_srl_op  ;
    wire    is_auipc_op;
    wire    is_lui_op  ;
    wire    is_eq_op   ;
    wire    is_ne_op   ;
    wire    is_ge_op   ;
    wire    is_geu_op  ;
    wire    is_mul_op  ;
    wire    is_div_op  ;

`ifdef RV64
    assign is_add_op   = ((opcode == 7'b0101111) && (func3[2:1] == 2'b01) && (func5 == 5'b00000)) || (wcsr_en) || (opcode == 7'b0000011) || (opcode == 7'b0100011) || (opcode == 7'b1101111) || ((opcode == 7'b1100111) && (func3 == 3'b000)) || ((((opcode == 7'b0110011) && func7 == 7'b0000000) || (opcode == 7'b0010011) || (opcode == 7'b0011011) || ((opcode == 7'b0111011) && func7 == 7'b0000000)) && (func3 == 3'b000)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b001) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] != 5'd2)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] == 5'd2)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1001) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1000) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1001) && (instr[11:7] != 5'b00000) && (instr[6:2] == 5'b00000) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1000) && (instr[11:7] != 5'b00000) && (instr[6:2] == 5'b00000) && (instr[1:0] == 2'b10));
`else
	assign is_add_op   = ((opcode == 7'b0101111) && (func3 == 3'b010) && (func5 == 5'b00000)) || (wcsr_en) || (opcode == 7'b0000011) || (opcode == 7'b0100011) || ((instr[15:13] == 3'b001) && (instr[1:0] == 2'b01)) || (opcode == 7'b1101111) || ((opcode == 7'b1100111) && (func3 == 3'b000)) || ((((opcode == 7'b0110011) && func7 == 7'b0000000) || (opcode == 7'b0010011) || (opcode == 7'b0011011) || ((opcode == 7'b0111011) && func7 == 7'b0000000)) && (func3 == 3'b000)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b001) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] != 5'd2)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] == 5'd2)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1001) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1000) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1001) && (instr[11:7] != 5'b00000) && (instr[6:2] == 5'b00000) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1000) && (instr[11:7] != 5'b00000) && (instr[6:2] == 5'b00000) && (instr[1:0] == 2'b10));
`endif
    assign is_sub_op   = ((opcode == 7'b0111011) && (func7 == 7'b0100000) && (func3 == 3'b000)) || ((opcode == 7'b0110011) && (func7 == 7'b0100000) && (func3 == 3'b000)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01));
    assign is_nop_op   = !(is_add_op | is_sub_op | is_le_op | is_l_op | is_lu_op | is_xor_op | is_and_op | is_or_op | is_sll_op | is_sra_op | is_srl_op | is_auipc_op | is_lui_op | is_eq_op | is_ne_op | is_ge_op | is_geu_op | is_mul_op | is_div_op | is_swap_op);
    assign is_le_op    = 1'b0;
`ifdef A_EXTENSION
	`ifdef RV64
	assign is_l_op     = ((opcode == 7'b0101111) && (func3[2:1] == 2'b01) && (func5 == 5'b10000)) || ((opcode == 7'b1100011) && (func3 == 3'b100)) || ((opcode == 7'b0010011) && (func3 == 3'b010)) || ((opcode == 7'b0110011) && (func3 == 3'b010) && (func7 == 7'b0000000));
    assign is_lu_op    = ((opcode == 7'b0101111) && (func3[2:1] == 2'b01) && (func5 == 5'b11000)) || ((opcode == 7'b1100011) && (func3 == 3'b110)) || ((opcode == 7'b0010011) && (func3 == 3'b011)) || ((opcode == 7'b0110011) && (func3 == 3'b011) && (func7 == 7'b0000000));
	assign is_xor_op   = ((opcode == 7'b0101111) && (func3[2:1] == 2'b01) && (func5 == 5'b00100)) || ((opcode == 7'b0110011) && (func7 == 7'b0000000) && (func3 == 3'b100)) || ((opcode == 7'b0010011) && (func3 == 3'b100)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01));
	assign is_and_op   = ((opcode == 7'b0101111) && (func3[2:1] == 2'b01) && (func5 == 5'b01100)) || ((opcode == 7'b0110011) && (func7 == 7'b0000000) && (func3 == 3'b111)) || ((opcode == 7'b0010011) && (func3 == 3'b111)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b11) && (instr[1:0] == 2'b01));
	assign is_or_op    = ((opcode == 7'b0101111) && (func3[2:1] == 2'b01) && (func5 == 5'b01000)) || ((opcode == 7'b0110011) && (func7 == 7'b0000000) && (func3 == 3'b110)) || ((opcode == 7'b0010011) && (func3 == 3'b110)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b10) && (instr[1:0] == 2'b01));
	assign is_ge_op    = ((opcode == 7'b0101111) && (func3[2:1] == 2'b01) && (func5 == 5'b10100)) || ((opcode == 7'b1100011) && (func3 == 3'b101));
    assign is_geu_op   = ((opcode == 7'b0101111) && (func3[2:1] == 2'b01) && (func5 == 5'b11100)) || ((opcode == 7'b1100011) && (func3 == 3'b111));
	`else
	assign is_l_op     = ((opcode == 7'b0101111) && (func3 == 3'b010) && (func5 == 5'b10000)) || ((opcode == 7'b1100011) && (func3 == 3'b100)) || ((opcode == 7'b0010011) && (func3 == 3'b010)) || ((opcode == 7'b0110011) && (func3 == 3'b010) && (func7 == 7'b0000000));
    assign is_lu_op    = ((opcode == 7'b0101111) && (func3 == 3'b010) && (func5 == 5'b11000)) || ((opcode == 7'b1100011) && (func3 == 3'b110)) || ((opcode == 7'b0010011) && (func3 == 3'b011)) || ((opcode == 7'b0110011) && (func3 == 3'b011) && (func7 == 7'b0000000));
	assign is_xor_op   = ((opcode == 7'b0101111) && (func3 == 3'b010) && (func5 == 5'b00100)) || ((opcode == 7'b0110011) && (func7 == 7'b0000000) && (func3 == 3'b100)) || ((opcode == 7'b0010011) && (func3 == 3'b100)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01));
	assign is_and_op   = ((opcode == 7'b0101111) && (func3 == 3'b010) && (func5 == 5'b01100)) || ((opcode == 7'b0110011) && (func7 == 7'b0000000) && (func3 == 3'b111)) || ((opcode == 7'b0010011) && (func3 == 3'b111)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b11) && (instr[1:0] == 2'b01));
	assign is_or_op    = ((opcode == 7'b0101111) && (func3 == 3'b010) && (func5 == 5'b01000)) || ((opcode == 7'b0110011) && (func7 == 7'b0000000) && (func3 == 3'b110)) || ((opcode == 7'b0010011) && (func3 == 3'b110)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b10) && (instr[1:0] == 2'b01));
	assign is_ge_op    = ((opcode == 7'b0101111) && (func3 == 3'b010) && (func5 == 5'b10100)) || ((opcode == 7'b1100011) && (func3 == 3'b101));
    assign is_geu_op   = ((opcode == 7'b0101111) && (func3 == 3'b010) && (func5 == 5'b11100)) || ((opcode == 7'b1100011) && (func3 == 3'b111));
	`endif
`else
	assign is_l_op     = ((opcode == 7'b1100011) && (func3 == 3'b100)) || ((opcode == 7'b0010011) && (func3 == 3'b010)) || ((opcode == 7'b0110011) && (func3 == 3'b010) && (func7 == 7'b0000000));
    assign is_lu_op    = ((opcode == 7'b1100011) && (func3 == 3'b110)) || ((opcode == 7'b0010011) && (func3 == 3'b011)) || ((opcode == 7'b0110011) && (func3 == 3'b011) && (func7 == 7'b0000000));
	assign is_xor_op   = ((opcode == 7'b0110011) && (func7 == 7'b0000000) && (func3 == 3'b100)) || ((opcode == 7'b0010011) && (func3 == 3'b100)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01));
	assign is_and_op   = ((opcode == 7'b0110011) && (func7 == 7'b0000000) && (func3 == 3'b111)) || ((opcode == 7'b0010011) && (func3 == 3'b111)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b11) && (instr[1:0] == 2'b01));
	assign is_or_op    = ((opcode == 7'b0110011) && (func7 == 7'b0000000) && (func3 == 3'b110)) || ((opcode == 7'b0010011) && (func3 == 3'b110)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b10) && (instr[1:0] == 2'b01));
	assign is_ge_op    = ((opcode == 7'b1100011) && (func3 == 3'b101));
    assign is_geu_op   = ((opcode == 7'b1100011) && (func3 == 3'b111));
`endif
    assign is_sll_op   = ((((opcode == 7'b0110011) && (func7 == 7'b0000000)) || ((opcode == 7'b0010011) && (func6 == 6'b000000)) || ((opcode == 7'b0011011) && (func7 == 7'b0000000)) || ((opcode == 7'b0111011) && (func7 == 7'b0000000))) && (func3 == 3'b001)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b10));
    assign is_sra_op   = ((((opcode == 7'b0110011) && (func7 == 7'b0100000)) || ((opcode == 7'b0010011) && (func6 == 6'b010000)) || ((opcode == 7'b0011011) && (func7 == 7'b0100000)) || ((opcode == 7'b0111011) && (func7 == 7'b0100000))) && (func3 == 3'b101)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b01) && (instr[1:0] == 2'b01));
    assign is_srl_op   = ((((opcode == 7'b0110011) && (func7 == 7'b0000000)) || ((opcode == 7'b0010011) && (func6 == 6'b000000)) || ((opcode == 7'b0011011) && (func7 == 7'b0000000)) || ((opcode == 7'b0111011) && (func7 == 7'b0000000))) && (func3 == 3'b101)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b00) && (instr[1:0] == 2'b01));
    assign is_auipc_op = (opcode == 7'b0010111);
    assign is_lui_op   = (opcode == 7'b0110111);
    assign is_eq_op    = ((opcode == 7'b1100011) && (func3 == 3'b000)) || (is_cbtype && (!instr[13]));
    assign is_ne_op    = ((opcode == 7'b1100011) && (func3 == 3'b001)) || (is_cbtype && instr[13]);
    assign is_mul_op   = ((opcode == 7'b0110011) && (func7 == 7'b0000001) && (!func3[2])) || ((opcode == 7'b0111011) && (func7 == 7'b0000001) && (func3 == 3'b000));
    assign is_div_op   = ((opcode == 7'b0110011) && (func7 == 7'b0000001) && func3[2]) || ((opcode == 7'b0111011) && (func7 == 7'b0000001) && func3[2]);

`ifdef A_EXTENSION
	`ifdef RV64
	wire is_swap_op = ((opcode == 7'b0101111) && (func3[2:1] == 2'b01) && (func5 == 5'b00001));
	`else
	wire is_swap_op = ((opcode == 7'b0101111) && (func3 == 3'b010) && (func5 == 5'b00001));
	`endif
`endif 

    assign op_type = {is_swap_op, is_div_op, is_mul_op, is_geu_op, is_ge_op, is_ne_op, is_eq_op, is_lui_op, is_auipc_op, is_srl_op, is_sra_op, is_sll_op, is_or_op, is_and_op, is_xor_op, is_lu_op, is_l_op, is_le_op, is_nop_op, is_sub_op, is_add_op};


    wire is_btype  ;
    wire is_itype  ;
    wire is_jtype  ;
    wire is_rtype  ;
    wire is_stype  ;
    wire is_utype  ;
    wire is_systype;
    wire is_uktype ;

	`ifdef C_EXTENSION
	wire is_crtype  ;
    wire is_citype  ;
    wire is_csstype ;
    wire is_ciwtype ;
    wire is_cltype  ;
    wire is_cstype  ;
    wire is_catype  ;
	wire is_cbtype  ;
	wire is_cjtype  ;
	`endif

    assign is_btype   = (opcode == 7'b1100011);
    assign is_itype   = (opcode == 7'b0011011) || (opcode == 7'b0000011) || (opcode == 7'b1100111) || (opcode == 7'b0010011);
    assign is_jtype   = (opcode == 7'b1101111);
    assign is_rtype   = (opcode == 7'b0111011) || (opcode == 7'b0110011);
    assign is_stype   = (opcode == 7'b0100011);
    assign is_utype   = (opcode == 7'b0110111) || (opcode == 7'b0010111);
    assign is_systype = (opcode == 7'b1110011);

	`ifdef C_EXTENSION
	assign is_crtype  = ((instr[15:12] == 4'b1001) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1000) && (instr[11:7] != 5'd0) && (instr[6:2] != 5'd0) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1001) && (instr[11:7] != 5'b00000) && (instr[6:2] == 5'b00000) && (instr[1:0] == 2'b10)) || ((instr[15:12] == 4'b1000) && (instr[11:7] != 5'b00000) && (instr[6:2] == 5'b00000) && (instr[1:0] == 2'b10));
`ifdef RV64
	assign is_citype  = ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b001) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] != 5'd2)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] == 5'd2)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b10));
`else
	assign is_citype  = ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b100) && (instr[11:10] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] != 5'd2)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] == 5'd2)) || ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b10));
`endif
    assign is_csstype = ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b10)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b10));
    assign is_ciwtype = ((instr[15:13] == 3'b000) && (instr[1:0] == 2'b00));
    assign is_cltype  = ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b00)); // c.lw/c.ld
    assign is_cstype  = ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b00)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b00));
    assign is_catype  = ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b10) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100011) && (instr[6:5] == 2'b11) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b01) && (instr[1:0] == 2'b01)) || ((instr[15:10] == 6'b100111) && (instr[6:5] == 2'b00) && (instr[1:0] == 2'b01));
	assign is_cbtype  = ((instr[15:13] == 3'b110) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b111) && (instr[1:0] == 2'b01));
`ifdef RV64
	assign is_cjtype  = ((instr[15:13] == 3'b101) && (instr[1:0] == 2'b01));
`else
	assign is_cjtype  = ((instr[15:13] == 3'b101) && (instr[1:0] == 2'b01)) || ((instr[15:13] == 3'b001) && (instr[1:0] == 2'b01));
`endif	
	`endif
 
	assign is_uktype  = !(is_crtype | is_citype | is_csstype | is_ciwtype | is_cltype | is_cstype | is_catype | is_cbtype | is_cjtype | is_systype | is_utype | is_stype | is_rtype | is_jtype | is_itype | is_btype);
    assign instr_type = {is_crtype, is_citype, is_csstype, is_ciwtype, is_cltype, is_cstype, is_catype, is_cbtype, is_cjtype, is_uktype, is_systype, is_utype, is_stype, is_rtype, is_jtype, is_itype, is_btype};
    

	`ifdef M_EXTENSION
		always@(*) begin
			if ((func7 == `FUNC7_MEXT) && (opcode == `OPCODE_RTYPE0)) begin
				case (func3)
					`FUNC3_000: mul_type = `MUL_MUL_TYPE   ;
					`FUNC3_001: mul_type = `MUL_MULH_TYPE  ;
					`FUNC3_010: mul_type = `MUL_MULHSU_TYPE;
					`FUNC3_011: mul_type = `MUL_MULHU_TYPE ;
					default   : mul_type = `NOT_MUL_TYPE   ;
				endcase
			end
		`ifdef RV64
			else if ((func7 == `FUNC7_MEXT) && (opcode == `OPCODE_RTYPE1) && (func3 == `FUNC3_000))
				mul_type = `MUL_MULW_TYPE;
		`endif
			else
				mul_type = `NOT_MUL_TYPE ;
		end

		always@(*) begin
			if ((func7 == `FUNC7_MEXT) && (opcode == `OPCODE_RTYPE0)) begin
				case (func3)
					`FUNC3_100: div_type = `DIV_DIV_TYPE   ;
					`FUNC3_101: div_type = `DIV_DIVU_TYPE  ;
					`FUNC3_110: div_type = `DIV_REM_TYPE   ;
					`FUNC3_111: div_type = `DIV_REMU_TYPE  ;
					default   : div_type = `DIV_DIV_TYPE   ;
				endcase
			end
		`ifdef RV64
			else if ((func7 == `FUNC7_MEXT) && (opcode == `OPCODE_RTYPE1)) begin
				case (func3)
					`FUNC3_100: div_type = `DIV_DIVW_TYPE  ;
					`FUNC3_101: div_type = `DIV_DIVUW_TYPE ;
					`FUNC3_110: div_type = `DIV_REMW_TYPE  ;
					`FUNC3_111: div_type = `DIV_REMUW_TYPE ;
					default   : div_type = `DIV_DIV_TYPE   ;
				endcase
			end
		`endif
			else
				div_type = `DIV_DIV_TYPE ;
		end
	`endif

	always@(*) begin
		if (opcode == 7'b0100011) begin
			case (func3)
				`FUNC3_000: wlen = `WLEN_BYTE ;
				`FUNC3_001: wlen = `WLEN_HALF ;
				`FUNC3_010: wlen = `WLEN_WORD ;
			`ifdef RV64
				`FUNC3_011: wlen = `WLEN_DWORD;
			`endif
				default   : wlen = `WLEN_BYTE ;
			endcase
		end
	`ifdef A_EXTENSION
		else if (opcode == 7'b0101111) begin
			wlen = (instr[12])? `WLEN_DWORD : `WLEN_WORD;
		end	
	`endif
	`ifdef C_EXTENSION
		else if (is_cstype || is_csstype) begin // c.sw/c.sd/c.swsp/c.sdsp
			case (instr[13])
				1'b0   : wlen = `WLEN_WORD ;
			`ifdef RV64
				1'b1   : wlen = `WLEN_DWORD;
			`endif
				default: wlen = `WLEN_BYTE ;
			endcase
		end
	`endif
		else
			wlen = `WLEN_BYTE;
	end

	always@(*) begin
		if (opcode == 7'b0000011) begin
			case (func3)
				`FUNC3_000: rlen = `RLEN_BYTE ;
				`FUNC3_001: rlen = `RLEN_HALF ;
				`FUNC3_010: rlen = `RLEN_WORD ;
			`ifdef RV64
				`FUNC3_011: rlen = `RLEN_DWORD;
			`endif
				`FUNC3_100: rlen = `RLEN_BYTE ;
				`FUNC3_101: rlen = `RLEN_HALF ;
				`FUNC3_110: rlen = `RLEN_WORD ;
				default   : rlen = `RLEN_BYTE ;
			endcase
		end
	`ifdef C_EXTENSION
		else if (is_cltype || is_citype) begin // c.lw/c.ld/c.lwsp/c.ldsp
			case (instr[13])
				1'b0   : rlen = `RLEN_WORD ;
			`ifdef RV64
				1'b1   : rlen = `RLEN_DWORD;
			`endif
				default: rlen = `RLEN_BYTE ;
			endcase
		end
	`endif
		else
			rlen = `RLEN_BYTE;
	end

	`ifdef C_EXTENSION

	reg [`XLEN_BUS] cimm_or_val0 ;
    reg [`XLEN_BUS] cimm_or_val1 ;
    reg [`XLEN_BUS] cimm_or_val2 ;
    reg [`XLEN_BUS] cimm_or_val3 ;
    reg [`XLEN_BUS] cimm_or_val4 ;
    reg [`XLEN_BUS] cimm_or_val5 ;
    reg [`XLEN_BUS] cimm_or_val6 ;
    reg [`XLEN_BUS] cimm_or_val7 ;
    reg [`XLEN_BUS] cimm_or_val8 ;
    reg [`XLEN_BUS] cimm_or_val9 ;
    reg [`XLEN_BUS] cimm_or_val10;


    always@(*) begin
        if (is_citype && (instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] != 5'd2)) // c.lui
		`ifdef RV64
            cimm_or_val0 = (instr[12])? {~(46'b`ZERO), instr[12], instr[6:2], 12'b`ZERO} : {46'b`ZERO, instr[12], instr[6:2], 12'b`ZERO};
		`else
			cimm_or_val0 = (instr[12])? {~(14'b`ZERO), instr[12], instr[6:2], 12'b`ZERO} : {14'b`ZERO, instr[12], instr[6:2], 12'b`ZERO};
		`endif
        else
            cimm_or_val0 = `ZERO;
    end

    always@(*) begin
        if (is_citype && (instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] == 5'd2)) // c.addi16sp
        `ifdef RV64
            cimm_or_val1 = (instr[12])? {~(54'b`ZERO), instr[12], instr[4:3], instr[5], instr[2], instr[6], 4'b`ZERO} : {54'b`ZERO, instr[12], instr[4:3], instr[5], instr[2], instr[6], 4'b`ZERO};
		`else
			cimm_or_val1 = (instr[12])? {~(22'b`ZERO), instr[12], instr[4:3], instr[5], instr[2], instr[6], 4'b`ZERO} : {22'b`ZERO, instr[12], instr[4:3], instr[5], instr[2], instr[6], 4'b`ZERO};
		`endif
		else
            cimm_or_val1 = `ZERO;
    end

    always@(*) begin
        if (is_citype && (instr[15:13] == 3'b010) && (instr[1:0] == 2'b10)) // c.lwsp
		`ifdef RV64
            cimm_or_val2 = {(56'b`ZERO), instr[3:2], instr[12], instr[6:4], 2'b`ZERO};
		`else
			cimm_or_val2 = {(24'b`ZERO), instr[3:2], instr[12], instr[6:4], 2'b`ZERO};
		`endif
        else
            cimm_or_val2 = `ZERO;
    end

    always@(*) begin
        if (is_citype && (instr[15:13] == 3'b011) && (instr[1:0] == 2'b10)) // c.ldsp
		`ifdef RV64
            cimm_or_val3 = {(55'b`ZERO), instr[4:2], instr[12], instr[6:5], 3'b`ZERO};
		`else
			cimm_or_val3 = {(23'b`ZERO), instr[4:2], instr[12], instr[6:5], 3'b`ZERO};
		`endif
        else
            cimm_or_val3 = `ZERO;
    end

    always@(*) begin
        if (is_citype && (is_sll_op || is_srl_op || is_sra_op))
		`ifdef RV64
            cimm_or_val4 = {58'b`ZERO, instr[12], instr[6:2]};
		`else
			cimm_or_val4 = {26'b`ZERO, instr[12], instr[6:2]};
		`endif
        else
            cimm_or_val4 = `ZERO;
    end

    always@(*) begin
        if (is_citype && ((!(is_sll_op || is_srl_op || is_sra_op)) && (!((instr[15:14] == 2'b01) && (instr[1:0] == 2'b10))) && (!((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01)))))
		`ifdef RV64
            cimm_or_val5 = (instr[12])? {~(58'b`ZERO), instr[12], instr[6:2]} : {58'b`ZERO, instr[12], instr[6:2]};
		`else
			cimm_or_val5 = (instr[12])? {~(26'b`ZERO), instr[12], instr[6:2]} : {26'b`ZERO, instr[12], instr[6:2]};
		`endif
        else
            cimm_or_val5 = `ZERO;
    end

    always@(*) begin
        if (is_ciwtype) // c.addi4spn
		`ifdef RV64
            cimm_or_val6 = {(54'b`ZERO), instr[10:7], instr[12:11], instr[5], instr[6], 2'b00};
		`else
			cimm_or_val6 = {(22'b`ZERO), instr[10:7], instr[12:11], instr[5], instr[6], 2'b00};
		`endif
        else
            cimm_or_val6 = `ZERO;
    end

    always@(*) begin
        if (is_cltype || is_cstype) // c.lw / c.ld /// s.sw / c.sd
		`ifdef RV64
            cimm_or_val7 = (instr[13])? {(56'b`ZERO), instr[6:5], instr[12:10], 3'b000} : {(57'b`ZERO), instr[5], instr[12:10], instr[6], 2'b00};
		`else
			cimm_or_val7 = (instr[13])? {(24'b`ZERO), instr[6:5], instr[12:10], 3'b000} : {(25'b`ZERO), instr[5], instr[12:10], instr[6], 2'b00};
		`endif
        else
            cimm_or_val7 = `ZERO;
    end

    always@(*) begin
        if (is_csstype) // c.swsp / c.sdsp
		`ifdef RV64
            cimm_or_val8 = (instr[13])? {(55'b`ZERO), instr[9:7], instr[12:10], 3'b000} : {(56'b`ZERO), instr[8:7], instr[12:9], 2'b00};
		`else
			cimm_or_val8 = (instr[13])? {(23'b`ZERO), instr[9:7], instr[12:10], 3'b000} : {(24'b`ZERO), instr[8:7], instr[12:9], 2'b00};
		`endif
        else
            cimm_or_val8 = `ZERO;
    end

    always@(*) begin
        if (is_cjtype)
        `ifdef RV64
            cimm_or_val9 = (instr[12])? {~(52'b`ZERO), instr[12], instr[8], instr[10:9], instr[6], instr[7], instr[2], instr[11], instr[5:3], 1'b0} : {(52'b`ZERO), instr[12], instr[8], instr[10:9], instr[6], instr[7], instr[2], instr[11], instr[5:3], 1'b0};
		`else
			cimm_or_val9 = (instr[12])? {~(20'b`ZERO), instr[12], instr[8], instr[10:9], instr[6], instr[7], instr[2], instr[11], instr[5:3], 1'b0} : {(20'b`ZERO), instr[12], instr[8], instr[10:9], instr[6], instr[7], instr[2], instr[11], instr[5:3], 1'b0};
		`endif
		else
            cimm_or_val9 = `ZERO;
    end

    always@(*) begin
        if (is_cbtype)
		`ifdef RV64
			cimm_or_val10 = (instr[12])? {~(55'b`ZERO), instr[12], instr[6:5], instr[2], instr[11:10], instr[4:3], 1'b0} : {(55'b`ZERO), instr[12], instr[6:5], instr[2], instr[11:10], instr[4:3], 1'b0};
		`else
			cimm_or_val10 = (instr[12])? {~(23'b`ZERO), instr[12], instr[6:5], instr[2], instr[11:10], instr[4:3], 1'b0} : {(23'b`ZERO), instr[12], instr[6:5], instr[2], instr[11:10], instr[4:3], 1'b0};
		`endif
        else
            cimm_or_val10 = `ZERO;
    end

    always@(*) begin
        cimm = cimm_or_val0 | cimm_or_val1 | cimm_or_val2 | cimm_or_val3 | cimm_or_val4 | cimm_or_val5 | cimm_or_val6 | cimm_or_val7 | cimm_or_val8 | cimm_or_val9 | cimm_or_val10;
    end

	// always@(*) begin
	// 	if (is_citype)
	// 		if ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] != 5'd2)) // c.lui
	// 			cimm = (instr[12])? {~(46'b`ZERO), instr[12], instr[6:2], 12'b`ZERO} : {46'b`ZERO, instr[12], instr[6:2], 12'b`ZERO};
	// 		else if ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] == 5'd2)) // c.addi16sp
	// 			cimm = (instr[12])? {~(54'b`ZERO), instr[12], instr[4:3], instr[5], instr[2], instr[6], 4'b`ZERO} : {54'b`ZERO, instr[12], instr[4:3], instr[5], instr[2], instr[6], 4'b`ZERO};
	// 		else if ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b10)) // c.lwsp
	// 			cimm = {(56'b`ZERO), instr[3:2], instr[12], instr[6:4], 2'b`ZERO};
	// 		else if ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b10)) // c.ldsp
	// 			cimm = {(55'b`ZERO), instr[4:2], instr[12], instr[6:5], 3'b`ZERO};
	// 		else if (is_sll_op || is_srl_op || is_sra_op)
	// 			cimm = {58'b`ZERO, instr[12], instr[6:2]};
	// 		else
	// 			cimm = (instr[12])? {~(58'b`ZERO), instr[12], instr[6:2]} : {58'b`ZERO, instr[12], instr[6:2]};
	// 	else if (is_ciwtype) // c.addi4spn
	// 		cimm = {(54'b`ZERO), instr[10:7], instr[12:11], instr[5], instr[6], 2'b00};
	// 	else if (is_cltype) begin // c.lw / c.ld
	// 		case (instr[13])
	// 			1'b0   : cimm = {(57'b`ZERO), instr[5], instr[12:10], instr[6], 2'b00};
	// 			1'b1   : cimm = {(56'b`ZERO), instr[6:5], instr[12:10], 3'b000};
	// 			default: cimm = {(57'b`ZERO), instr[5], instr[12:10], instr[6], 2'b00};
	// 		endcase
	// 	end
	// 	else if (is_cstype) begin // s.sw / c.sd
	// 		case (instr[13])
	// 			1'b0   : cimm = {(57'b`ZERO), instr[5], instr[12:10], instr[6], 2'b00};
	// 			1'b1   : cimm = {(56'b`ZERO), instr[6:5], instr[12:10], 3'b000};
	// 			default: cimm = {(57'b`ZERO), instr[5], instr[12:10], instr[6], 2'b00};
	// 		endcase
	// 	end
	// 	else if (is_csstype) begin // c.swsp / c.sdsp
	// 		case (instr[13])
	// 			1'b0   : cimm = {(56'b`ZERO), instr[8:7], instr[12:9], 2'b00};
	// 			1'b1   : cimm = {(55'b`ZERO), instr[9:7], instr[12:10], 3'b000};
	// 			default: cimm = {(56'b`ZERO), instr[8:7], instr[12:9], 2'b00};
	// 		endcase
	// 	end
	// 	else if (is_cjtype) begin
	// 		cimm = (instr[12])? {~(52'b`ZERO), instr[12], instr[8], instr[10:9], instr[6], instr[7], instr[2], instr[11], instr[5:3], 1'b0} : {(52'b`ZERO), instr[12], instr[8], instr[10:9], instr[6], instr[7], instr[2], instr[11], instr[5:3], 1'b0};
	// 	end
	// 	else if (is_cbtype) begin
	// 		cimm = (instr[12])? {~(55'b`ZERO), instr[12], instr[6:5], instr[2], instr[11:10], instr[4:3], 1'b0} : {(55'b`ZERO), instr[12], instr[6:5], instr[2], instr[11:10], instr[4:3], 1'b0};
	// 	end
	// 	else
	// 		cimm = `ZERO;
	// end

	`endif

	// always@(*) begin
	// 	if (is_citype) begin
	// 		if (is_srl_op || is_and_op)
	// 			rs1 = {2'b01, instr[9:7]};
	// 		else if ((instr[15:13] == 3'b010) && (instr[1:0] == 2'b01) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] != 5'd2))) // c.li
	// 			rs1 = `ZERO;
	// 		else if ((instr[15:14] == 2'b01) && (instr[1:0] == 2'b10)) // c.lwsp/c.ldsp
	// 			rs1 = 5'd2; // sp
	// 		else
	// 			rs1 = instr[`RD_FIELD];
	// 	end
	// 	else if (is_catype || is_cltype || is_cstype || is_cbtype)
	// 		rs1 = {2'b01, instr[9:7]};
	// 	else if (is_ciwtype || is_csstype)
	// 		rs1 = 5'd2;
	// 	else if (is_crtype) begin
	// 		if ((instr[12] == 1'b1) || (instr[6:2] == 5'd0)) // c.add/c.jalr/c.jr
	// 			rs1 = instr[`RD_FIELD];
	// 		else                                             // c.mv
	// 			rs1 = `ZERO;
	// 	end
	// 	else
	// 		rs1 = instr[`RS1_FIELD];
	// end

	always@(*) begin
		if ((is_citype && (is_srl_op || is_and_op)) || is_catype || is_cltype || is_cstype || is_cbtype)
			rs1 = {2'b01, instr[9:7]};
		else if ((is_citype && (instr[15:14] == 2'b01) && (instr[1:0] == 2'b10)) || is_ciwtype || is_csstype)
			rs1 = 5'd2;
		else if (is_citype && (instr[15:13] == 3'b010) && (instr[1:0] == 2'b01) || ((instr[15:13] == 3'b011) && (instr[1:0] == 2'b01) && (instr[11:7] != 5'd2)))
			rs1 = `ZERO;
		else if (is_crtype) begin
			if ((instr[12] == 1'b1) || (instr[6:2] == 5'd0)) // c.add/c.jalr/c.jr
				rs1 = instr[`RD_FIELD];
			else                                             // c.mv
				rs1 = `ZERO;
		end
		else if (is_citype)
			rs1 = instr[`RD_FIELD];
		else
			rs1 = instr[`RS1_FIELD];
	end

	always@(*) begin
		if (is_citype || is_ciwtype || is_cltype)
			rs2 = `ZERO; // do not care
		else if (is_catype || is_cstype)
				rs2 = {2'b01, instr[4:2]};
		else if (is_csstype || is_crtype)
				rs2 = instr[6:2];
		else if (is_cbtype)
			rs2 = `ZERO; // necessary rs1 <> x0
		else
			rs2 = instr[`RS2_FIELD];
	end

	always@(*) begin
		if ((is_jalr == `IS_JALR) && (instr[1:0] == 2'b10)) begin
			if (instr[12] == 1'b1) // c.jalr
				rd = 5'd1;
			else                   // c.jr
				rd = 5'd0;
		end
	`ifndef RV64
		else if ((instr[15:13] == 3'b001) && (instr[1:0] == 2'b01)) begin
			rd = 5'd1;
		end
	`endif
		else if (is_citype) begin
			if (is_srl_op || is_and_op)
				rd = {2'b01, instr[9:7]};
			else
				rd = instr[`RD_FIELD];
		end
		else if (is_catype)
			rd = {2'b01, instr[9:7]};
		else if (is_ciwtype || is_cltype)
			rd = {2'b01, instr[4:2]};
		else if (is_cstype || is_csstype)
			rd = `ZERO;
		else if (is_crtype)
			rd = instr[`RD_FIELD];
		else
			rd = instr[`RD_FIELD];
	end

endmodule
