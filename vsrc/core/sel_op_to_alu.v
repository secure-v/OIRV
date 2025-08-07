`include "params.v"

module sel_op_to_alu (
	input [`XLEN_BUS]       reg_data0 ,
	input [`XLEN_BUS]       reg_data1 ,
	input                   op0_sel   ,
    input                   op1_sel   ,
	input [`INSTR_ADDR_BUS] pc        ,
    input [`XLEN_BUS]       sext_imm  ,
	input [`INST_TYPE_BUS]  instr_type,
	input                   is_jalr   ,
	`ifdef C_EXTENSION
	input                   is_cinstr ,
	input [`XLEN_BUS]       cimm      ,
	`endif
	`ifdef A_EXTENSION
	input [`XLEN_BUS]       amo_val   ,
	input                   sel_amo_op,
	`endif
	output reg [`XLEN_BUS]  op0       ,
	output reg [`XLEN_BUS]  op1       
);
	
	always@(*) begin
	`ifdef A_EXTENSION
		if (sel_amo_op)
			op0 = reg_data1;
		else if (op0_sel == `OP_SEL_RS1)
	`else
		if (op0_sel == `OP_SEL_RS1)
    `endif
        	op0 = reg_data0;
        else
		`ifdef RV64
            op0 = {`ADDR_TO_XLEN_ZEXT, pc};
		`else
			op0 = pc;
		`endif
	end

    always@(*) begin
		if ((instr_type[`JTYPE_INDEX]) || (is_jalr == `IS_JALR) || (instr_type[`CJTYPE_INDEX]))
		`ifdef C_EXTENSION
			op1 = (is_cinstr == `IS_CINSTR)? `CINSTR_BYTE_NUM : `INSTR_BYTE_NUM;
		`else
			op1 = `INSTR_BYTE_NUM;
		`endif
		`ifdef A_EXTENSION
		else if (sel_amo_op)
			op1 = amo_val;
		`endif
		else if (op1_sel == `OP_SEL_RS2)
            op1 = reg_data1;
		else if (instr_type[`SYSTYPE_INDEX])
			op1 = `ZERO;
		`ifdef C_EXTENSION
		else if ((op1_sel != `OP_SEL_RS2) && (is_cinstr == `IS_CINSTR))
			op1 = cimm;     
		`endif
        else
            op1 = sext_imm;
	end

endmodule
