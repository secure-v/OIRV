`include "params.v"

module alu(
	input[`OP_TYPE_BUS]          op_type               , // one hot encoded
	input[`XLEN_BUS]             op0                   ,
	input[`XLEN_BUS]             op1                   ,
	`ifdef RV64
	input                        is_word_op            ,
	`endif
	`ifdef M_EXTENSION
	input [`MUL_TYPE_BUS]        mul_type              ,
	input [`DIV_TYPE_BUS]        div_type              ,
	input                        clk                   ,
	input                        rstn                  ,
	output                       div_fin               ,
	input                        hold                  ,
	// input [`XLEN * 2 - 1:0]      part_mul_res0_ex2     ,
	// input [`XLEN * 2 - 1:0]      part_mul_res1_ex2     ,
	// output [`XLEN * 2 - 1:0]     part_mul_res0         ,
	// output [`XLEN * 2 - 1:0]     part_mul_res1         ,
	input [`MUL_TYPE_BUS]        mul_type_ex2          ,
	output reg [`XLEN_BUS]       alu_res_ex2           ,
	`endif
	`ifdef A_EXTENSION
	input                        is_amo_instr          ,
	`endif
	`ifdef C_EXTENSION
	input                        is_cinstr             ,
	input [`XLEN_BUS]            cimm                  ,
	`endif
`ifndef PROC_BRANCH_IN_DC
	input [`INSTR_ADDR_BUS]      pc                    ,
	input [`XLEN_BUS]            sext_imm              ,
	input                        is_branch_instr       ,
	input                        is_jalr               ,
	input [`XLEN_BUS]            reg_data0             ,
	output reg                   branch_taken          ,
	output reg [`INSTR_ADDR_BUS] branch_jalr_target_pc ,
`endif
	output [`DATA_ADDR_BUS]      data_addr_ex2         ,
	output reg [`XLEN_BUS]       alu_res                    
);

	wire [`XLEN_BUS] mask_for_sra /*verilator public_flat_rd*/;
	wire [`XLEN_BUS] add_res;
	wire [`XLEN_BUS] sub_res;
	wire [`XLEN_BUS] unsigned_less_cmp_res;
	wire [`XLEN_BUS] signed_less_cmp_res;
	wire [`XLEN_BUS] sll_res;
	wire [`XLEN_BUS] sra_res;
	wire [`XLEN_BUS] srl_res;
	wire [`XLEN_BUS] and_res;
	wire [`XLEN_BUS] or_res;
	wire [`XLEN_BUS] xor_res;
	wire [`XLEN_BUS] lui_res;
	wire [`XLEN_BUS] op_eq;
	wire [`XLEN_BUS] op_ne;
	wire [`XLEN_BUS] op_ge;
	wire [`XLEN_BUS] op_geu;
	wire [`XLEN_BUS] and_op0;
	wire [`XLEN_BUS] or_op0;
	wire [`XLEN_BUS] xor_op0;
	wire [`XLEN_BUS] and_op1;
	wire [`XLEN_BUS] or_op1;
	wire [`XLEN_BUS] xor_op1;

	assign and_op0 = (op_type[`OP_AND_INDEX])? op0 : `ZERO;
	assign or_op0 = (op_type[`OP_OR_INDEX])? op0 : `ZERO;
	assign xor_op0 = (op_type[`OP_XOR_INDEX])? op0 : `ZERO;
	assign and_op1 = (op_type[`OP_AND_INDEX])? op1 : `ZERO;
	assign or_op1 = (op_type[`OP_OR_INDEX])? op1 : `ZERO;
	assign xor_op1 = (op_type[`OP_XOR_INDEX])? op1 : `ZERO;

	assign and_res = and_op0 & and_op1;
	assign or_res = or_op0 | or_op1;
	assign xor_res = xor_op0 ^ xor_op1;

`ifdef A_EXTENSION
	wire [`XLEN_BUS] unsigned_less_val0;
	wire [`XLEN_BUS] unsigned_less_val1;
	wire [`XLEN_BUS] signed_less_val0;
	wire [`XLEN_BUS] signed_less_val1;
	wire [`XLEN_BUS] unsigned_great_val0;
	wire [`XLEN_BUS] unsigned_great_val1;
	wire [`XLEN_BUS] signed_great_val0;
	wire [`XLEN_BUS] signed_great_val1;

	assign unsigned_less_val0 = ((is_amo_instr == `IS_AMO_INSTR) && (op_type[`OP_LU_INDEX]))? op0 : `TAKE_BRANCH;
	assign unsigned_less_val1 = ((is_amo_instr == `IS_AMO_INSTR) && (op_type[`OP_LU_INDEX]))? op1 : `NTTK_BRANCH;
	assign signed_less_val0 = ((is_amo_instr == `IS_AMO_INSTR) && (op_type[`OP_L_INDEX]))? op0 : `TAKE_BRANCH;
	assign signed_less_val1 = ((is_amo_instr == `IS_AMO_INSTR) && (op_type[`OP_L_INDEX]))? op1 : `NTTK_BRANCH;
	assign unsigned_great_val0 = ((is_amo_instr == `IS_AMO_INSTR) && (op_type[`OP_GEU_INDEX]))? op0 : `TAKE_BRANCH;
	assign unsigned_great_val1 = ((is_amo_instr == `IS_AMO_INSTR) && (op_type[`OP_GEU_INDEX]))? op1 : `NTTK_BRANCH;
	assign signed_great_val0 = ((is_amo_instr == `IS_AMO_INSTR) && (op_type[`OP_GE_INDEX]))? op0 : `TAKE_BRANCH;
	assign signed_great_val1 = ((is_amo_instr == `IS_AMO_INSTR) && (op_type[`OP_GE_INDEX]))? op1 : `NTTK_BRANCH;

	wire op0_sign_bit;
	wire op1_sign_bit;
	wire sub_res_sign_bit;

	`ifdef RV64
		assign op0_sign_bit = (is_word_op != `IS_WORD_OP)? op0[`DWORD_SIGN_BIT] : op0[`WORD_SIGN_BIT];
		assign op1_sign_bit = (is_word_op != `IS_WORD_OP)? op1[`DWORD_SIGN_BIT] : op1[`WORD_SIGN_BIT];;
		assign sub_res_sign_bit = (is_word_op != `IS_WORD_OP)? sub_temp[`DWORD_SIGN_BIT] : sub_temp[`WORD_SIGN_BIT];
	`else
		assign op0_sign_bit = op0[`WORD_SIGN_BIT];
		assign op1_sign_bit = op1[`WORD_SIGN_BIT];
		assign sub_res_sign_bit = sub_temp[`WORD_SIGN_BIT];
	`endif 

	assign unsigned_less_cmp_res = (op_type[`OP_LU_INDEX])? ((((!op0_sign_bit) && op1_sign_bit) || ((op0_sign_bit == op1_sign_bit) && sub_res_sign_bit))? unsigned_less_val0 : unsigned_less_val1) : unsigned_less_val1;
	assign signed_less_cmp_res = ((op0_sign_bit ^ op1_sign_bit) && (op_type[`OP_L_INDEX]))? ((op0_sign_bit)? signed_less_val0 : signed_less_val1) : ((sub_res_sign_bit && (op_type[`OP_L_INDEX]))? signed_less_val0 : signed_less_val1);
	assign op_ge = (op_type[`OP_GE_INDEX])? (((op0_sign_bit && (!op1_sign_bit)) || ((op0_sign_bit == op1_sign_bit) && sub_res_sign_bit))? signed_great_val1 : signed_great_val0) : signed_great_val1;
	assign op_geu = (op_type[`OP_GEU_INDEX])? (((!op0_sign_bit && op1_sign_bit) || ((op0_sign_bit == op1_sign_bit) && sub_res_sign_bit))? unsigned_great_val1 : unsigned_great_val0) : unsigned_great_val1;

	wire[`XLEN_BUS] swap_res;

	assign swap_res = (op_type[`OP_SWAP_INDEX])? op0 : `ZERO;
`else
	assign unsigned_less_cmp_res = (op_type[`OP_LU_INDEX])? ((((!op0[`XLEN - 1]) && op1[`XLEN - 1]) || ((op0[`XLEN - 1] == op1[`XLEN - 1]) && sub_temp[`XLEN - 1]))? `TAKE_BRANCH : `NTTK_BRANCH) : `NTTK_BRANCH;
	assign signed_less_cmp_res = ((op0[`XLEN - 1] ^ op1[`XLEN - 1]) && (op_type[`OP_L_INDEX]))? ((op0[`XLEN - 1])? `TAKE_BRANCH : `NTTK_BRANCH) : ((sub_temp[`XLEN - 1] && (op_type[`OP_L_INDEX]))? `TAKE_BRANCH : `NTTK_BRANCH);
	assign op_ge = (op_type[`OP_GE_INDEX])? (((op0[`XLEN - 1] && (!op1[`XLEN - 1])) || ((op0[`XLEN - 1] == op1[`XLEN - 1]) && sub_temp[`XLEN - 1]))? `NTTK_BRANCH : `TAKE_BRANCH) : `NTTK_BRANCH;
	assign op_geu = (op_type[`OP_GEU_INDEX])? (((!op0[`XLEN - 1] && op1[`XLEN - 1]) || ((op0[`XLEN - 1] == op1[`XLEN - 1]) && sub_temp[`XLEN - 1]))? `NTTK_BRANCH : `TAKE_BRANCH) : `NTTK_BRANCH;
`endif
	assign op_eq = ((sub_temp == `ZERO) && (op_type[`OP_EQ_INDEX]))? `TAKE_BRANCH : `NTTK_BRANCH;
	assign op_ne = ((!(sub_temp == `ZERO)) && (op_type[`OP_NE_INDEX]))? `TAKE_BRANCH : `NTTK_BRANCH;
	assign lui_res = (op_type[`OP_LUI_INDEX])? op1 : `ZERO;


	`ifdef RV64
		wire [`XLEN:0] adder_op0;
		wire [`XLEN:0] adder_op1;
		wire [`XLEN:0] adder_val;
		wire [`XLEN_BUS] rev_op0;
		wire [`XLEN_BUS] sll_rev_temp;
		wire [`XLEN_BUS] add_op0;
		wire [`XLEN_BUS] sub_op0;
		wire [`XLEN_BUS] add_op1;
		wire [`XLEN_BUS] sub_op1;
		wire [`XLEN_BUS] add_temp;
		wire [`XLEN_BUS] sub_temp;
		wire [`XLEN_BUS] sll_temp;
		wire [`XLEN_BUS] srl_temp;
		wire [`SHIFT_BITS_BUS] shamt;
		wire [`XLEN_BUS] shift_op0;
		wire [`XLEN_BUS] auipc_res;

		assign add_op0 = ((op_type[`OP_ADD_INDEX]) || (op_type[`OP_AUIPC_INDEX]))? op0 : `ZERO;
		assign sub_op0 = ((op_type[`OP_SUB_INDEX]) || (op_type[`OP_GE_INDEX]) || (op_type[`OP_L_INDEX]) || (op_type[`OP_GEU_INDEX]) || (op_type[`OP_LU_INDEX]) || (op_type[`OP_EQ_INDEX]) || (op_type[`OP_NE_INDEX]))? op0 : `ZERO;
		assign add_op1 = ((op_type[`OP_ADD_INDEX]) || (op_type[`OP_AUIPC_INDEX]))? op1 : `ZERO;
		assign sub_op1 = ((op_type[`OP_SUB_INDEX]) || (op_type[`OP_GE_INDEX]) || (op_type[`OP_L_INDEX]) || (op_type[`OP_GEU_INDEX]) || (op_type[`OP_LU_INDEX]) || (op_type[`OP_EQ_INDEX]) || (op_type[`OP_NE_INDEX]))? op1 : `ZERO;
		assign shamt = (is_word_op == `IS_WORD_OP)? (op1[`SHIFT_BITS_BUS] & (`SHAMT_WORD_MASK)) : op1[`SHIFT_BITS_BUS];
		assign mask_for_sra = ((!op_type[`OP_SRA_INDEX]) || ((!(is_word_op == `IS_WORD_OP)) && (!op0[`DWORD_SIGN_BIT])) || ((is_word_op == `IS_WORD_OP) && (!op0[`WORD_SIGN_BIT])))? `MASK_FULL_ZERO : (~((((is_word_op == `IS_WORD_OP) && op0[`WORD_SIGN_BIT])? {`WORD_ZEXT, ~`WORD_ZEXT} : {~`WORD_ZEXT, ~`WORD_ZEXT}) >> shamt));
		assign adder_op0 = ((op_type[`OP_ADD_INDEX]) || (op_type[`OP_AUIPC_INDEX]))? {add_op0, 1'b0} : { sub_op0, 1'b1};
		assign adder_op1 = ((op_type[`OP_ADD_INDEX]) || (op_type[`OP_AUIPC_INDEX]))? {add_op1, 1'b0} : {~sub_op1, 1'b1};
		assign adder_val = adder_op0 + adder_op1;
		assign add_temp = ((op_type[`OP_ADD_INDEX]) || (op_type[`OP_AUIPC_INDEX]))? adder_val[`XLEN:1] : `ZERO;// add_op0 + add_op1;
		assign sub_temp = ((op_type[`OP_SUB_INDEX]) || (op_type[`OP_GE_INDEX]) || (op_type[`OP_L_INDEX]) || (op_type[`OP_GEU_INDEX]) || (op_type[`OP_LU_INDEX]) || (op_type[`OP_EQ_INDEX]) || (op_type[`OP_NE_INDEX]))? adder_val[`XLEN:1] : `ZERO;// sub_op0 - sub_op1;
		assign rev_op0 = {op0[0], op0[1], op0[2], op0[3], op0[4], op0[5], op0[6], op0[7], op0[8], op0[9], op0[10], op0[11], op0[12], op0[13], op0[14], op0[15], op0[16], op0[17], op0[18], op0[19], op0[20], op0[21], op0[22], op0[23], op0[24], op0[25], op0[26], op0[27], op0[28], op0[29], op0[30], op0[31], op0[32], op0[33], op0[34], op0[35], op0[36], op0[37], op0[38], op0[39], op0[40], op0[41], op0[42], op0[43], op0[44], op0[45], op0[46], op0[47], op0[48], op0[49], op0[50], op0[51], op0[52], op0[53], op0[54], op0[55], op0[56], op0[57], op0[58], op0[59], op0[60], op0[61], op0[62], op0[63]};
		assign shift_op0 = ((op_type[`OP_SRA_INDEX]) || (op_type[`OP_SRL_INDEX]))? ((is_word_op == `IS_WORD_OP)? (op0 & {`WORD_ZEXT, ~`WORD_ZEXT}) : op0) : ((op_type[`OP_SLL_INDEX])? rev_op0 : `ZERO);
		assign sll_rev_temp = shift_op0 >> shamt;
		assign sll_temp = {sll_rev_temp[0], sll_rev_temp[1], sll_rev_temp[2], sll_rev_temp[3], sll_rev_temp[4], sll_rev_temp[5], sll_rev_temp[6], sll_rev_temp[7], sll_rev_temp[8], sll_rev_temp[9], sll_rev_temp[10], sll_rev_temp[11], sll_rev_temp[12], sll_rev_temp[13], sll_rev_temp[14], sll_rev_temp[15], sll_rev_temp[16], sll_rev_temp[17], sll_rev_temp[18], sll_rev_temp[19], sll_rev_temp[20], sll_rev_temp[21], sll_rev_temp[22], sll_rev_temp[23], sll_rev_temp[24], sll_rev_temp[25], sll_rev_temp[26], sll_rev_temp[27], sll_rev_temp[28], sll_rev_temp[29], sll_rev_temp[30], sll_rev_temp[31], sll_rev_temp[32], sll_rev_temp[33], sll_rev_temp[34], sll_rev_temp[35], sll_rev_temp[36], sll_rev_temp[37], sll_rev_temp[38], sll_rev_temp[39], sll_rev_temp[40], sll_rev_temp[41], sll_rev_temp[42], sll_rev_temp[43], sll_rev_temp[44], sll_rev_temp[45], sll_rev_temp[46], sll_rev_temp[47], sll_rev_temp[48], sll_rev_temp[49], sll_rev_temp[50], sll_rev_temp[51], sll_rev_temp[52], sll_rev_temp[53], sll_rev_temp[54], sll_rev_temp[55], sll_rev_temp[56], sll_rev_temp[57], sll_rev_temp[58], sll_rev_temp[59], sll_rev_temp[60], sll_rev_temp[61], sll_rev_temp[62], sll_rev_temp[63]};
		assign srl_temp = sll_rev_temp;

		assign auipc_res = (op_type[`OP_AUIPC_INDEX])? add_temp : `ZERO;
		assign add_res = (is_word_op == `IS_WORD_OP)? ((add_temp[`WORD_SIGN_BIT] == `BOOL_TRUE)? {~`WORD_ZEXT, add_temp[`WORD_BUS]} : {`WORD_ZEXT, add_temp[`WORD_BUS]}) : add_temp;
		assign sub_res = (op_type[`OP_SUB_INDEX])? ((is_word_op == `IS_WORD_OP)? ((sub_temp[`WORD_SIGN_BIT] == `BOOL_TRUE)? {~`WORD_ZEXT, sub_temp[`WORD_BUS]} : {`WORD_ZEXT, sub_temp[`WORD_BUS]}) : sub_temp) : `ZERO;
		assign sll_res = (op_type[`OP_SLL_INDEX])? ((is_word_op == `IS_WORD_OP)? ((sll_temp[`WORD_SIGN_BIT] == `BOOL_TRUE)? {~`WORD_ZEXT, sll_temp[`WORD_BUS]} : {`WORD_ZEXT, sll_temp[`WORD_BUS]}) : sll_temp) : `ZERO;
		assign srl_res = (op_type[`OP_SRL_INDEX])? ((is_word_op == `IS_WORD_OP)? ((srl_temp[`WORD_SIGN_BIT] == `BOOL_TRUE)? {~`WORD_ZEXT, srl_temp[`WORD_BUS]} : {`WORD_ZEXT, srl_temp[`WORD_BUS]}) : srl_temp) : `ZERO;
		assign sra_res = (op_type[`OP_SRA_INDEX])? (((is_word_op == `IS_WORD_OP)? ((srl_temp[`WORD_SIGN_BIT] == `BOOL_TRUE)? {~`WORD_ZEXT, srl_temp[`WORD_BUS]} : {`WORD_ZEXT, srl_temp[`WORD_BUS]}) : srl_temp) | mask_for_sra) : `ZERO;
	`else
		wire [`XLEN:0] adder_op0;
		wire [`XLEN:0] adder_op1;
		wire [`XLEN:0] adder_val;
		wire [`XLEN_BUS] rev_op0;
		wire [`XLEN_BUS] sll_rev_temp;
		wire [`XLEN_BUS] add_op0;
		wire [`XLEN_BUS] sub_op0;
		wire [`XLEN_BUS] add_op1;
		wire [`XLEN_BUS] sub_op1;
		wire [`XLEN_BUS] add_temp;
		wire [`XLEN_BUS] sub_temp;
		wire [`XLEN_BUS] sll_temp;
		wire [`XLEN_BUS] srl_temp;
		wire [`SHIFT_BITS_BUS] shamt;
		wire [`XLEN_BUS] shift_op0;
		wire [`XLEN_BUS] auipc_res;

		assign add_op0 = ((op_type[`OP_ADD_INDEX]) || (op_type[`OP_AUIPC_INDEX]))? op0 : `ZERO;
		assign sub_op0 = ((op_type[`OP_SUB_INDEX]) || (op_type[`OP_GE_INDEX]) || (op_type[`OP_L_INDEX]) || (op_type[`OP_GEU_INDEX]) || (op_type[`OP_LU_INDEX]) || (op_type[`OP_EQ_INDEX]) || (op_type[`OP_NE_INDEX]))? op0 : `ZERO;
		assign add_op1 = ((op_type[`OP_ADD_INDEX]) || (op_type[`OP_AUIPC_INDEX]))? op1 : `ZERO;
		assign sub_op1 = ((op_type[`OP_SUB_INDEX]) || (op_type[`OP_GE_INDEX]) || (op_type[`OP_L_INDEX]) || (op_type[`OP_GEU_INDEX]) || (op_type[`OP_LU_INDEX]) || (op_type[`OP_EQ_INDEX]) || (op_type[`OP_NE_INDEX]))? op1 : `ZERO;
		assign shamt = op1[`SHIFT_BITS_BUS];
		assign mask_for_sra = ((!op_type[`OP_SRA_INDEX]) || (!op0[`WORD_SIGN_BIT]))? `MASK_FULL_ZERO : (~({~`WORD_ZEXT} >> shamt));
		assign adder_op0 = ((op_type[`OP_ADD_INDEX]) || (op_type[`OP_AUIPC_INDEX]))? {add_op0, 1'b0} : { sub_op0, 1'b1};
		assign adder_op1 = ((op_type[`OP_ADD_INDEX]) || (op_type[`OP_AUIPC_INDEX]))? {add_op1, 1'b0} : {~sub_op1, 1'b1};
		assign adder_val = adder_op0 + adder_op1;
		assign add_temp = ((op_type[`OP_ADD_INDEX]) || (op_type[`OP_AUIPC_INDEX]))? adder_val[`XLEN:1] : `ZERO;// add_op0 + add_op1;
		assign sub_temp = ((op_type[`OP_SUB_INDEX]) || (op_type[`OP_GE_INDEX]) || (op_type[`OP_L_INDEX]) || (op_type[`OP_GEU_INDEX]) || (op_type[`OP_LU_INDEX]) || (op_type[`OP_EQ_INDEX]) || (op_type[`OP_NE_INDEX]))? adder_val[`XLEN:1] : `ZERO;// sub_op0 - sub_op1;
		assign rev_op0 = {op0[0], op0[1], op0[2], op0[3], op0[4], op0[5], op0[6], op0[7], op0[8], op0[9], op0[10], op0[11], op0[12], op0[13], op0[14], op0[15], op0[16], op0[17], op0[18], op0[19], op0[20], op0[21], op0[22], op0[23], op0[24], op0[25], op0[26], op0[27], op0[28], op0[29], op0[30], op0[31]};
		assign shift_op0 = ((op_type[`OP_SRA_INDEX]) || (op_type[`OP_SRL_INDEX]))? op0 : ((op_type[`OP_SLL_INDEX])? rev_op0 : `ZERO);
		assign sll_rev_temp = shift_op0 >> shamt;
		assign sll_temp = {sll_rev_temp[0], sll_rev_temp[1], sll_rev_temp[2], sll_rev_temp[3], sll_rev_temp[4], sll_rev_temp[5], sll_rev_temp[6], sll_rev_temp[7], sll_rev_temp[8], sll_rev_temp[9], sll_rev_temp[10], sll_rev_temp[11], sll_rev_temp[12], sll_rev_temp[13], sll_rev_temp[14], sll_rev_temp[15], sll_rev_temp[16], sll_rev_temp[17], sll_rev_temp[18], sll_rev_temp[19], sll_rev_temp[20], sll_rev_temp[21], sll_rev_temp[22], sll_rev_temp[23], sll_rev_temp[24], sll_rev_temp[25], sll_rev_temp[26], sll_rev_temp[27], sll_rev_temp[28], sll_rev_temp[29], sll_rev_temp[30], sll_rev_temp[31]};
		assign srl_temp = sll_rev_temp;

		assign auipc_res = (op_type[`OP_AUIPC_INDEX])? add_temp : `ZERO;
		assign add_res = add_temp;
		assign sub_res = (op_type[`OP_SUB_INDEX])? sub_temp : `ZERO;
		assign sll_res = (op_type[`OP_SLL_INDEX])? sll_temp : `ZERO;
		assign srl_res = (op_type[`OP_SRL_INDEX])? srl_temp : `ZERO;
		assign sra_res = (op_type[`OP_SRA_INDEX])? (srl_temp | mask_for_sra) : `ZERO;
	`endif

	always@ (*) begin
	`ifdef A_EXTENSION
		alu_res = add_res | sub_res | and_res | or_res | xor_res | sll_res | sra_res | srl_res | signed_less_cmp_res | unsigned_less_cmp_res | auipc_res | lui_res | op_eq | op_ne | op_ge | op_geu | div_res | swap_res;
	`else
		alu_res = add_res | sub_res | and_res | or_res | xor_res | sll_res | sra_res | srl_res | signed_less_cmp_res | unsigned_less_cmp_res | auipc_res | lui_res | op_eq | op_ne | op_ge | op_geu | div_res;
	`endif
	end

`ifdef M_EXTENSION
	// ====================== ex stage ==========================
	wire [`XLEN_BUS] mul_op0;
	wire [`XLEN_BUS] mul_op1;

	wire [`XLEN * 2 - 1:0]     part_mul_res0       ;
	wire [`XLEN * 2 - 1:0]     part_mul_res1       ;

	assign mul_op0 = (mul_type != `NOT_MUL_TYPE)? op0 : `ZERO;
	assign mul_op1 = (mul_type != `NOT_MUL_TYPE)? op1 : `ZERO;

	rv_mul rv_mul_inst0 (
		.clk          (clk           ),
	    .mul_type     (mul_type      ),
	    .rs1_data     (mul_op0       ),
	    .rs2_data     (mul_op1       ),
		.part_mul_res0(part_mul_res0 ),
		.part_mul_res1(part_mul_res1 )
	);
	// ==========================================================

	// ===================== ex2 stage ==========================
	reg [`XLEN * 2 - 1:0]      part_mul_res0_ex2   ;
	reg [`XLEN * 2 - 1:0]      part_mul_res1_ex2   ;
    wire [`XLEN_BUS]           mul_res_ex2         ;
    wire [`XLEN * 2 - 1:0] mul_res_tmp = part_mul_res0_ex2 + part_mul_res1_ex2; // big adder
    wire [`XLEN_BUS] word_sext_mul;

    parameter WORD_ZEXT = 32'd0         ;
`ifdef RV64
    assign word_sext_mul = (mul_res_tmp[`WORD_SIGN_BIT] == `BOOL_TRUE)? {~WORD_ZEXT, mul_res_tmp[`WORD_FIELD]} : {WORD_ZEXT, mul_res_tmp[`WORD_FIELD]};
	assign mul_res_ex2 = ((mul_type_ex2 == `MUL_MULH_TYPE) || (mul_type_ex2 == `MUL_MULHU_TYPE) || (mul_type_ex2 == `MUL_MULHSU_TYPE))? mul_res_tmp[`XLEN * 2 - 1:`XLEN] : ((mul_type_ex2 == `MUL_MUL_TYPE)? mul_res_tmp[`XLEN_BUS] : ((mul_type_ex2 == `MUL_MULW_TYPE)? word_sext_mul : `ZERO));
`else
	assign word_sext_mul = {mul_res_tmp[`WORD_FIELD]};
	assign mul_res_ex2 = ((mul_type_ex2 == `MUL_MULH_TYPE) || (mul_type_ex2 == `MUL_MULHU_TYPE) || (mul_type_ex2 == `MUL_MULHSU_TYPE))? mul_res_tmp[`XLEN * 2 - 1:`XLEN] : ((mul_type_ex2 == `MUL_MUL_TYPE)? mul_res_tmp[`XLEN_BUS] : `ZERO);
`endif

	always@(posedge clk) begin
		if(rstn == `RESET_EN) begin
			part_mul_res0_ex2 <= `ZERO;
			part_mul_res1_ex2 <= `ZERO;
		end
		else if (hold == `HOLD) begin
			part_mul_res0_ex2 <= part_mul_res0_ex2;
			part_mul_res1_ex2 <= part_mul_res1_ex2;
		end
		else begin
			part_mul_res0_ex2 <= part_mul_res0    ;
			part_mul_res1_ex2 <= part_mul_res1    ;
		end
	end

	reg [`XLEN - 1:0]      alu_res_reg;

	always@(posedge clk) begin
		if(rstn == `RESET_EN)
			alu_res_reg <= `ZERO;
		else if (hold == `HOLD)
			alu_res_reg <= alu_res_reg;
		else
			alu_res_reg <= alu_res    ;
	end

	assign data_addr_ex2 = alu_res_reg[`DATA_ADDR_BUS];
	assign alu_res_ex2 = alu_res_reg | mul_res_ex2;
	// ==========================================================

    wire [`XLEN_BUS] div_res_tmp ;
	wire [`XLEN_BUS] div_res     ;
	wire             div_valid   ;
	wire             is_op_div   ;
	assign           is_op_div = (op_type[`OP_DIV_INDEX])? `IS_OP_DIV : !`IS_OP_DIV;
	assign           div_fin = (((div_valid == `DATA_VALID) && (is_op_div == `IS_OP_DIV)) || (is_op_div != `IS_OP_DIV))? `DIV_FIN : !`DIV_FIN;
	assign           div_res = (op_type[`OP_DIV_INDEX])? div_res_tmp : `ZERO;

	rv_div rv_div_inst0 (
    .clk      (clk          ),
    .rstn     (rstn         ),
	.hold     (hold         ),
	.is_op_div(is_op_div    ),
    .div_type (div_type     ),
    .rs1_data (op0          ),
    .rs2_data (op1          ),
    .valid    (div_valid    ),
    .div_res  (div_res_tmp  )
);

`endif


// branch / jal / jalr
`ifndef PROC_BRANCH_IN_DC

`ifdef C_EXTENSION
	always@(*) begin
		if (is_cinstr == `IS_CINSTR)
			branch_taken = (is_jalr == `IS_JALR) || ((is_branch_instr == `IS_BRANCH_INSTR) && (op_eq[0] | op_ne[0]));
			// branch_taken = (is_jalr == `IS_JALR) || ((is_branch_instr == `IS_BRANCH_INSTR) && (!(op_eq[0] | op_ne[0])));
		else
			branch_taken = (is_jalr == `IS_JALR) || ((is_branch_instr == `IS_BRANCH_INSTR) && (unsigned_less_cmp_res[0] | signed_less_cmp_res[0] | op_eq[0] | op_ne[0] | op_ge[0] | op_geu[0]));
			// branch_taken = (is_jalr == `IS_JALR) || ((is_branch_instr == `IS_BRANCH_INSTR) && (!(unsigned_less_cmp_res[0] | signed_less_cmp_res[0] | op_eq[0] | op_ne[0] | op_ge[0] | op_geu[0])));
	end

	always@(*) begin
		if (is_branch_instr == `IS_BRANCH_INSTR)
			branch_jalr_target_pc = pc + ((is_cinstr == `IS_CINSTR)? cimm[`INSTR_ADDR_BUS] : sext_imm[`INSTR_ADDR_BUS]); // vvvvvvvvvvvvvvvvvvvvvvvvvv
			// branch_jalr_target_pc = pc + ((is_cinstr == `IS_CINSTR)? `CINSTR_BYTE_NUM : `INSTR_BYTE_NUM);
		else if (is_jalr == `IS_JALR)
			branch_jalr_target_pc = (is_cinstr == `IS_CINSTR)? ((reg_data0[`INSTR_ADDR_BUS]) & `INSTR_ADDR_ALIGN_MASK) : ((reg_data0[`INSTR_ADDR_BUS] + sext_imm[`INSTR_ADDR_BUS]) & `INSTR_ADDR_ALIGN_MASK);
		else
			branch_jalr_target_pc = `ZERO;
	end

`else
	always@(*) begin
		branch_taken = (is_jalr == `IS_JALR) || ((is_branch_instr == `IS_BRANCH_INSTR) && (unsigned_less_cmp_res[0] | signed_less_cmp_res[0] | op_eq[0] | op_ne[0] | op_ge[0] | op_geu[0]));
		// branch_taken = (is_jalr == `IS_JALR) || ((is_branch_instr == `IS_BRANCH_INSTR) && (!(unsigned_less_cmp_res[0] | signed_less_cmp_res[0] | op_eq[0] | op_ne[0] | op_ge[0] | op_geu[0])));
	end

	always@(*) begin
		if (is_branch_instr == `IS_BRANCH_INSTR)
			branch_jalr_target_pc = pc + sext_imm; // vvvvvvvvvvvvvvvvvvvvvvvvvv
			// branch_jalr_target_pc = pc + `INSTR_BYTE_NUM;
		else if (is_jalr == `IS_JALR)
			branch_jalr_target_pc = (reg_data0 + sext_imm[`INSTR_ADDR_BUS]) & `INSTR_ADDR_ALIGN_MASK;
		else
			branch_jalr_target_pc = `ZERO;
	end
`endif

`endif

endmodule
