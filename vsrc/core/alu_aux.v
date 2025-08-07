`include "params.v"

module alu_aux (
	input[`OP_TYPE_BUS]          op_type               ,
	input[`XLEN_BUS]             op0                   ,
	input[`XLEN_BUS]             op1                   ,
	`ifdef RV64
	input                        is_word_op            ,
	`endif
	output reg [`XLEN_BUS]       alu_res                
);

	wire [`XLEN_BUS] mask_for_sra;
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

	assign unsigned_less_cmp_res = (op_type[`OP_LU_INDEX])? ((((!op0[`XLEN - 1]) && op1[`XLEN - 1]) || ((op0[`XLEN - 1] == op1[`XLEN - 1]) && sub_temp[`XLEN - 1]))? `TAKE_BRANCH : `NTTK_BRANCH) : `NTTK_BRANCH;
	assign signed_less_cmp_res = ((op0[`XLEN - 1] ^ op1[`XLEN - 1]) && (op_type[`OP_L_INDEX]))? ((op0[`XLEN - 1])? `TAKE_BRANCH : `NTTK_BRANCH) : ((sub_temp[`XLEN - 1] && (op_type[`OP_L_INDEX]))? `TAKE_BRANCH : `NTTK_BRANCH);
	assign op_eq = ((sub_temp == `ZERO) && (op_type[`OP_EQ_INDEX]))? `TAKE_BRANCH : `NTTK_BRANCH;
	assign op_ne = ((!(sub_temp == `ZERO)) && (op_type[`OP_NE_INDEX]))? `TAKE_BRANCH : `NTTK_BRANCH;
	assign op_ge = (op_type[`OP_GE_INDEX])? (((op0[`XLEN - 1] && (!op1[`XLEN - 1])) || ((op0[`XLEN - 1] == op1[`XLEN - 1]) && sub_temp[`XLEN - 1]))? `NTTK_BRANCH : `TAKE_BRANCH) : `NTTK_BRANCH;
	assign op_geu = (op_type[`OP_GEU_INDEX])? (((!op0[`XLEN - 1] && op1[`XLEN - 1]) || ((op0[`XLEN - 1] == op1[`XLEN - 1]) && sub_temp[`XLEN - 1]))? `NTTK_BRANCH : `TAKE_BRANCH) : `NTTK_BRANCH;
	assign lui_res = (op_type[`OP_LUI_INDEX])? op1 : `ZERO;

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
`ifdef RV64
	assign shamt = (is_word_op == `IS_WORD_OP)? (op1[`SHIFT_BITS_BUS] & (`SHAMT_WORD_MASK)) : op1[`SHIFT_BITS_BUS];
	assign mask_for_sra = ((!op_type[`OP_SRA_INDEX]) || ((!(is_word_op == `IS_WORD_OP)) && (!op0[`DWORD_SIGN_BIT])) || ((is_word_op == `IS_WORD_OP) && (!op0[`WORD_SIGN_BIT])))? `MASK_FULL_ZERO : (~((((is_word_op == `IS_WORD_OP) && op0[`WORD_SIGN_BIT])? {`WORD_ZEXT, ~`WORD_ZEXT} : {~`WORD_ZEXT, ~`WORD_ZEXT}) >> shamt));
`else
	assign shamt = op1[`SHIFT_BITS_BUS];
	assign mask_for_sra = ((!op_type[`OP_SRA_INDEX]) || (!op0[`WORD_SIGN_BIT]))? `MASK_FULL_ZERO : (~({~`WORD_ZEXT} >> shamt));
`endif

	assign adder_op0 = ((op_type[`OP_ADD_INDEX]) || (op_type[`OP_AUIPC_INDEX]))? {add_op0, 1'b0} : { sub_op0, 1'b1};
	assign adder_op1 = ((op_type[`OP_ADD_INDEX]) || (op_type[`OP_AUIPC_INDEX]))? {add_op1, 1'b0} : {~sub_op1, 1'b1};
	assign adder_val = adder_op0 + adder_op1;
	assign add_temp = ((op_type[`OP_ADD_INDEX]) || (op_type[`OP_AUIPC_INDEX]))? adder_val[`XLEN:1] : `ZERO;// add_op0 + add_op1;
	assign sub_temp = ((op_type[`OP_SUB_INDEX]) || (op_type[`OP_GE_INDEX]) || (op_type[`OP_L_INDEX]) || (op_type[`OP_GEU_INDEX]) || (op_type[`OP_LU_INDEX]) || (op_type[`OP_EQ_INDEX]) || (op_type[`OP_NE_INDEX]))? adder_val[`XLEN:1] : `ZERO;// sub_op0 - sub_op1;
`ifdef RV64
	assign rev_op0 = {op0[0], op0[1], op0[2], op0[3], op0[4], op0[5], op0[6], op0[7], op0[8], op0[9], op0[10], op0[11], op0[12], op0[13], op0[14], op0[15], op0[16], op0[17], op0[18], op0[19], op0[20], op0[21], op0[22], op0[23], op0[24], op0[25], op0[26], op0[27], op0[28], op0[29], op0[30], op0[31], op0[32], op0[33], op0[34], op0[35], op0[36], op0[37], op0[38], op0[39], op0[40], op0[41], op0[42], op0[43], op0[44], op0[45], op0[46], op0[47], op0[48], op0[49], op0[50], op0[51], op0[52], op0[53], op0[54], op0[55], op0[56], op0[57], op0[58], op0[59], op0[60], op0[61], op0[62], op0[63]};
`else
	assign rev_op0 = {op0[0], op0[1], op0[2], op0[3], op0[4], op0[5], op0[6], op0[7], op0[8], op0[9], op0[10], op0[11], op0[12], op0[13], op0[14], op0[15], op0[16], op0[17], op0[18], op0[19], op0[20], op0[21], op0[22], op0[23], op0[24], op0[25], op0[26], op0[27], op0[28], op0[29], op0[30], op0[31]};
`endif
`ifdef RV64
	assign shift_op0 = ((op_type[`OP_SRA_INDEX]) || (op_type[`OP_SRL_INDEX]))? ((is_word_op == `IS_WORD_OP)? (op0 & {`WORD_ZEXT, ~`WORD_ZEXT}) : op0) : ((op_type[`OP_SLL_INDEX])? rev_op0 : `ZERO);
`else
	assign shift_op0 = ((op_type[`OP_SRA_INDEX]) || (op_type[`OP_SRL_INDEX]))? op0 : ((op_type[`OP_SLL_INDEX])? rev_op0 : `ZERO);
`endif

	assign sll_rev_temp = shift_op0 >> shamt;
`ifdef RV64
	assign sll_temp = {sll_rev_temp[0], sll_rev_temp[1], sll_rev_temp[2], sll_rev_temp[3], sll_rev_temp[4], sll_rev_temp[5], sll_rev_temp[6], sll_rev_temp[7], sll_rev_temp[8], sll_rev_temp[9], sll_rev_temp[10], sll_rev_temp[11], sll_rev_temp[12], sll_rev_temp[13], sll_rev_temp[14], sll_rev_temp[15], sll_rev_temp[16], sll_rev_temp[17], sll_rev_temp[18], sll_rev_temp[19], sll_rev_temp[20], sll_rev_temp[21], sll_rev_temp[22], sll_rev_temp[23], sll_rev_temp[24], sll_rev_temp[25], sll_rev_temp[26], sll_rev_temp[27], sll_rev_temp[28], sll_rev_temp[29], sll_rev_temp[30], sll_rev_temp[31], sll_rev_temp[32], sll_rev_temp[33], sll_rev_temp[34], sll_rev_temp[35], sll_rev_temp[36], sll_rev_temp[37], sll_rev_temp[38], sll_rev_temp[39], sll_rev_temp[40], sll_rev_temp[41], sll_rev_temp[42], sll_rev_temp[43], sll_rev_temp[44], sll_rev_temp[45], sll_rev_temp[46], sll_rev_temp[47], sll_rev_temp[48], sll_rev_temp[49], sll_rev_temp[50], sll_rev_temp[51], sll_rev_temp[52], sll_rev_temp[53], sll_rev_temp[54], sll_rev_temp[55], sll_rev_temp[56], sll_rev_temp[57], sll_rev_temp[58], sll_rev_temp[59], sll_rev_temp[60], sll_rev_temp[61], sll_rev_temp[62], sll_rev_temp[63]};
`else
	assign sll_temp = {sll_rev_temp[0], sll_rev_temp[1], sll_rev_temp[2], sll_rev_temp[3], sll_rev_temp[4], sll_rev_temp[5], sll_rev_temp[6], sll_rev_temp[7], sll_rev_temp[8], sll_rev_temp[9], sll_rev_temp[10], sll_rev_temp[11], sll_rev_temp[12], sll_rev_temp[13], sll_rev_temp[14], sll_rev_temp[15], sll_rev_temp[16], sll_rev_temp[17], sll_rev_temp[18], sll_rev_temp[19], sll_rev_temp[20], sll_rev_temp[21], sll_rev_temp[22], sll_rev_temp[23], sll_rev_temp[24], sll_rev_temp[25], sll_rev_temp[26], sll_rev_temp[27], sll_rev_temp[28], sll_rev_temp[29], sll_rev_temp[30], sll_rev_temp[31]};
`endif
	assign srl_temp = sll_rev_temp;

	assign auipc_res = (op_type[`OP_AUIPC_INDEX])? add_temp : `ZERO;

`ifdef RV64
	assign add_res = (is_word_op == `IS_WORD_OP)? ((add_temp[`WORD_SIGN_BIT] == `BOOL_TRUE)? {~`WORD_ZEXT, add_temp[`WORD_BUS]} : {`WORD_ZEXT, add_temp[`WORD_BUS]}) : add_temp;
	assign sub_res = (op_type[`OP_SUB_INDEX])? ((is_word_op == `IS_WORD_OP)? ((sub_temp[`WORD_SIGN_BIT] == `BOOL_TRUE)? {~`WORD_ZEXT, sub_temp[`WORD_BUS]} : {`WORD_ZEXT, sub_temp[`WORD_BUS]}) : sub_temp) : `ZERO;
	assign sll_res = (op_type[`OP_SLL_INDEX])? ((is_word_op == `IS_WORD_OP)? ((sll_temp[`WORD_SIGN_BIT] == `BOOL_TRUE)? {~`WORD_ZEXT, sll_temp[`WORD_BUS]} : {`WORD_ZEXT, sll_temp[`WORD_BUS]}) : sll_temp) : `ZERO;
	assign srl_res = (op_type[`OP_SRL_INDEX])? ((is_word_op == `IS_WORD_OP)? ((srl_temp[`WORD_SIGN_BIT] == `BOOL_TRUE)? {~`WORD_ZEXT, srl_temp[`WORD_BUS]} : {`WORD_ZEXT, srl_temp[`WORD_BUS]}) : srl_temp) : `ZERO;
	assign sra_res = (op_type[`OP_SRA_INDEX])? (((is_word_op == `IS_WORD_OP)? ((srl_temp[`WORD_SIGN_BIT] == `BOOL_TRUE)? {~`WORD_ZEXT, srl_temp[`WORD_BUS]} : {`WORD_ZEXT, srl_temp[`WORD_BUS]}) : srl_temp) | mask_for_sra) : `ZERO;
`else
	assign add_res = add_temp;//(0)? ((add_temp[`WORD_SIGN_BIT] == `BOOL_TRUE)? {~`WORD_ZEXT, add_temp[`WORD_BUS]} : {`WORD_ZEXT, add_temp[`WORD_BUS]}) : add_temp;
	assign sub_res = (op_type[`OP_SUB_INDEX])? sub_temp : `ZERO;
	assign sll_res = (op_type[`OP_SLL_INDEX])? sll_temp : `ZERO;
	assign srl_res = (op_type[`OP_SRL_INDEX])? srl_temp : `ZERO;
	assign sra_res = (op_type[`OP_SRA_INDEX])? (srl_temp | mask_for_sra) : `ZERO;
`endif
	

	always@ (*) begin
		alu_res = add_res | sub_res | and_res | or_res | xor_res | sll_res | sra_res | srl_res | signed_less_cmp_res | unsigned_less_cmp_res | auipc_res | lui_res | op_eq | op_ne | op_ge | op_geu;
	end

endmodule
