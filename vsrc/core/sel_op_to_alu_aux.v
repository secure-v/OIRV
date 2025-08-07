`include "params.v"

module sel_op_to_alu_aux (
	input [`XLEN_BUS]       reg_data0 ,
	input [`XLEN_BUS]       reg_data1 ,
	input                   op0_sel   ,
    input                   op1_sel   ,
	input [`INSTR_ADDR_BUS] pc        ,
    input [`XLEN_BUS]       sext_imm  ,
	`ifdef C_EXTENSION
	input                   is_cinstr ,
	input [`XLEN_BUS]       cimm      ,
	`endif
	output reg [`XLEN_BUS]  op0       ,
	output reg [`XLEN_BUS]  op1       
);
	
	always@(*) begin
		if (op0_sel == `OP_SEL_RS1)
            op0 = reg_data0;
        else
		`ifdef RV64
            op0 = {`ADDR_TO_XLEN_ZEXT, pc};
		`else
			op0 = pc;
		`endif
	end

    always@(*) begin
		if (op1_sel == `OP_SEL_RS2)
            op1 = reg_data1;
		`ifdef C_EXTENSION
		else if ((op1_sel != `OP_SEL_RS2) && (is_cinstr == `IS_CINSTR))
			op1 = cimm;     
		`endif
        else
            op1 = sext_imm;
	end

endmodule
