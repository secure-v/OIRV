`include "params.v"

module instr_sign_ext (
	input     [`INST_BUS]      instr           ,
	input     [`INST_TYPE_BUS] instr_type      ,
	output reg [`XLEN_BUS]     sext_imm        
);
	
	// always@(*) begin
	// 	if (instr[`IMM_SIGN_BIT] == `BOOL_TRUE)
	// 		sext_imm = {~`ITYPE_IMM_HIGH_ZEXT, instr[`IMM_FIELD]};
	// 	else
	// 		sext_imm = {`ITYPE_IMM_HIGH_ZEXT, instr[`IMM_FIELD]};
	// end

	wire sign_flag;
	wire [`XLEN_BUS] btype_zext_imm;
	wire [`XLEN_BUS] itype_zext_imm;
	wire [`XLEN_BUS] jtype_zext_imm;
	wire [`XLEN_BUS] stype_zext_imm;
	wire [`XLEN_BUS] utype_zext_imm;
	wire [`XLEN_BUS] btype_sext_imm;
	wire [`XLEN_BUS] itype_sext_imm;
	wire [`XLEN_BUS] jtype_sext_imm;
	wire [`XLEN_BUS] stype_sext_imm;
	wire [`XLEN_BUS] utype_sext_imm;

	assign sign_flag = (instr[`IMM_SIGN_BIT] == `BOOL_TRUE);
	assign btype_zext_imm = {`BTYPE_IMM_HIGH_ZEXT, instr[`BTYPE_IMM_FIELD0], instr[`BTYPE_IMM_FIELD1], instr[`BTYPE_IMM_FIELD2], instr[`BTYPE_IMM_FIELD3], `BTYPE_IMM_LOW_ZEXT};
	assign itype_zext_imm = {`ITYPE_IMM_HIGH_ZEXT, instr[`ITYPE_IMM_FIELD]};
	assign jtype_zext_imm = {`JTYPE_IMM_HIGH_ZEXT, instr[`JTYPE_IMM_FIELD0], instr[`JTYPE_IMM_FIELD1], instr[`JTYPE_IMM_FIELD2], instr[`JTYPE_IMM_FIELD3], `JTYPE_IMM_LOW_ZEXT};
	assign stype_zext_imm = {`STYPE_IMM_HIGH_ZEXT, instr[`STYPE_IMM_FIELD0], instr[`STYPE_IMM_FIELD1]};
`ifdef RV64
	assign utype_zext_imm = {`UTYPE_IMM_HIGH_ZEXT, instr[`UTYPE_IMM_FIELD], `UTYPE_IMM_LOW_ZEXT};
`else
	assign utype_zext_imm = {instr[`UTYPE_IMM_FIELD], `UTYPE_IMM_LOW_ZEXT};
`endif
	assign btype_sext_imm = (sign_flag == `BOOL_FALSE)? btype_zext_imm : {~`BTYPE_IMM_HIGH_ZEXT, instr[`BTYPE_IMM_FIELD0], instr[`BTYPE_IMM_FIELD1], instr[`BTYPE_IMM_FIELD2], instr[`BTYPE_IMM_FIELD3], `BTYPE_IMM_LOW_ZEXT};
	assign itype_sext_imm = (sign_flag == `BOOL_FALSE)? itype_zext_imm : {~`ITYPE_IMM_HIGH_ZEXT, instr[`ITYPE_IMM_FIELD]};
	assign jtype_sext_imm = (sign_flag == `BOOL_FALSE)? jtype_zext_imm : {~`JTYPE_IMM_HIGH_ZEXT, instr[`JTYPE_IMM_FIELD0], instr[`JTYPE_IMM_FIELD1], instr[`JTYPE_IMM_FIELD2], instr[`JTYPE_IMM_FIELD3], `JTYPE_IMM_LOW_ZEXT};
	assign stype_sext_imm = (sign_flag == `BOOL_FALSE)? stype_zext_imm : {~`STYPE_IMM_HIGH_ZEXT, instr[`STYPE_IMM_FIELD0], instr[`STYPE_IMM_FIELD1]};
`ifdef RV64
	assign utype_sext_imm = (sign_flag == `BOOL_FALSE)? utype_zext_imm : {~`UTYPE_IMM_HIGH_ZEXT, instr[`UTYPE_IMM_FIELD], `UTYPE_IMM_LOW_ZEXT};
`else
	assign utype_sext_imm = utype_zext_imm;
`endif

	wire [`XLEN_BUS] or_btype_sext_imm;
	wire [`XLEN_BUS] or_itype_sext_imm;
	wire [`XLEN_BUS] or_jtype_sext_imm;
	wire [`XLEN_BUS] or_stype_sext_imm;
	wire [`XLEN_BUS] or_utype_sext_imm;

	assign or_btype_sext_imm = (instr_type[`BTYPE_INDEX])? btype_sext_imm : `ZERO;
	assign or_itype_sext_imm = (instr_type[`ITYPE_INDEX])? itype_sext_imm : `ZERO;
	assign or_jtype_sext_imm = (instr_type[`JTYPE_INDEX])? jtype_sext_imm : `ZERO;
	assign or_stype_sext_imm = (instr_type[`STYPE_INDEX])? stype_sext_imm : `ZERO;
	assign or_utype_sext_imm = (instr_type[`UTYPE_INDEX])? utype_sext_imm : `ZERO;
   
	always@(*) begin
		sext_imm = or_btype_sext_imm | or_itype_sext_imm | or_jtype_sext_imm | or_stype_sext_imm | or_utype_sext_imm;
	end

	// always@(*) begin
	// 	case(instr_type)
	// 		`BTYPE : sext_imm = btype_sext_imm;
	// 		`ITYPE : sext_imm = itype_sext_imm;
	// 		`JTYPE : sext_imm = jtype_sext_imm;
	// 		`STYPE : sext_imm = stype_sext_imm;
	// 		`UTYPE : sext_imm = utype_sext_imm;				
	// 	    default: sext_imm = `XLEN'd`ZERO;
	// 	endcase
	// end

endmodule
