`include "params.v"

module instr_sign_ext_aux (
	input     [`INST_BUS]      instr     ,
	input     [`INST_TYPE_BUS] instr_type,
	output reg [`XLEN_BUS]     sext_imm  
);

	wire sign_flag;

	wire [`XLEN_BUS] itype_zext_imm;
	wire [`XLEN_BUS] utype_zext_imm;
	wire [`XLEN_BUS] itype_sext_imm;
	wire [`XLEN_BUS] utype_sext_imm;

	assign sign_flag = (instr[`IMM_SIGN_BIT] == `BOOL_TRUE);
	assign itype_zext_imm = {`ITYPE_IMM_HIGH_ZEXT, instr[`ITYPE_IMM_FIELD]};
`ifdef RV64
	assign utype_zext_imm = {`UTYPE_IMM_HIGH_ZEXT, instr[`UTYPE_IMM_FIELD], `UTYPE_IMM_LOW_ZEXT};
`else
	assign utype_zext_imm = {instr[`UTYPE_IMM_FIELD], `UTYPE_IMM_LOW_ZEXT};
`endif
	assign itype_sext_imm = (sign_flag == `BOOL_FALSE)? itype_zext_imm : {~`ITYPE_IMM_HIGH_ZEXT, instr[`ITYPE_IMM_FIELD]};
`ifdef RV64
	assign utype_sext_imm = (sign_flag == `BOOL_FALSE)? utype_zext_imm : {~`UTYPE_IMM_HIGH_ZEXT, instr[`UTYPE_IMM_FIELD], `UTYPE_IMM_LOW_ZEXT};
`else
	assign utype_sext_imm = utype_zext_imm;
`endif

	wire [`XLEN_BUS] or_itype_sext_imm;
	wire [`XLEN_BUS] or_utype_sext_imm;

	assign or_itype_sext_imm = (instr_type[`ITYPE_INDEX])? itype_sext_imm : `ZERO;
	assign or_utype_sext_imm = (instr_type[`UTYPE_INDEX])? utype_sext_imm : `ZERO;

	always@(*) begin
		sext_imm = or_itype_sext_imm | or_utype_sext_imm;
	end

endmodule
