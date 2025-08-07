`include "params.v"

module data_bypass2 (
	input [`REG_INDEX_BUS]             rd_ex                    ,
	input [`REG_INDEX_BUS]             rd_ex2                   ,
	input [`REG_INDEX_BUS]             rd_mem                   ,
	input [`REG_INDEX_BUS]             rs1_dc                   ,
	input [`REG_INDEX_BUS]             rs2_dc                   ,
	input [`REG_INDEX_BUS]             rs1_dc_aux               ,
	input [`REG_INDEX_BUS]             rs2_dc_aux               ,
	input [`REG_INDEX_BUS]             rs2_mem                  ,
	input                              wreg_en_ex               ,
	input                              wreg_en_ex2              ,
	input                              wreg_en_mem              ,
	input                              op_sel_rs1_ex            ,
	input                              op_sel_rs2_ex            ,
	input                              is_load_or_store_instr_ex,
	input [`XLEN_BUS]                  alu_res_ex               ,
	input [`XLEN_BUS]                  op0_ex                   ,
	input [`XLEN_BUS]                  op1_ex                   ,
	input [`XLEN_BUS]                  wreg_data_ex2            ,
	input [`XLEN_BUS]                  wreg_data_mem            ,
	input [`REG_INDEX_BUS]             rd_wb                    ,
	input                              wreg_en_wb               ,
	input [`XLEN_BUS]                  wreg_data_wb             ,
	input [`XLEN_BUS]                  ext_rdata                ,
	input [`XLEN_BUS]                  reg_data0                ,
	input [`XLEN_BUS]                  reg_data1                ,
	input                              flush_ex                 ,
	input                              flush_ex2                ,
	input                              flush_mem                ,
	input                              cancel_instr_dc          ,
	input                              cancel_instr_dc_aux      ,
	input                              op_sel_rs1               ,
	input                              op_sel_rs2               ,
	input                              op_sel_rs1_dc_aux        ,
	input                              op_sel_rs2_dc_aux        ,
	input                              is_jalr_dc               ,
	input                              is_store_instr           ,
	input                              cancel_instr_ex          ,
	input                              cancel_instr_ex2         ,
	input                              cancel_instr_mem         ,
	output                             is_branch_ex_hazard0     , // (reg_data0) hazard between dc and ex
	output                             is_branch_ex_hazard1     , // (reg_data1) hazard between dc and ex
	output                             is_branch_ex2_hazard0    , // (reg_data0) hazard between dc and ex2
	output                             is_branch_ex2_hazard1    , // (reg_data1) hazard between dc and ex2
	output                             is_branch_mem_hazard0    , // (reg_data0) hazard between dc and mem
	output                             is_branch_mem_hazard1    , // (reg_data1) hazard between dc and mem
	output reg [`XLEN_BUS]             bypassed_reg_data0       ,
	output reg [`XLEN_BUS]             bypassed_reg_data1       
);

	assign is_branch_ex_hazard0 = ((flush_ex != `FLUSH_PIPELINE) && (cancel_instr_ex != `CANCEL_INSTR) && (wreg_en_ex == `W_REG_EN) && (((rd_ex == rs1_dc) && ((op_sel_rs1 == `OP_SEL_RS1) || (is_jalr_dc == `IS_JALR))) || ((rd_ex == rs1_dc_aux) && (op_sel_rs1_dc_aux == `OP_SEL_RS1))) && (rd_ex != `ZERO));
	assign is_branch_ex_hazard1 = ((flush_ex != `FLUSH_PIPELINE) && (cancel_instr_ex != `CANCEL_INSTR) && (wreg_en_ex == `W_REG_EN) && (((rd_ex == rs2_dc) && ((op_sel_rs2 == `OP_SEL_RS2) || (is_store_instr))) || ((rd_ex == rs2_dc_aux) && (op_sel_rs2_dc_aux == `OP_SEL_RS2))) && (rd_ex != `ZERO));
	assign is_branch_ex2_hazard0 = ((flush_ex2 != `FLUSH_PIPELINE) && (cancel_instr_ex2 != `CANCEL_INSTR) && (wreg_en_ex2 == `W_REG_EN) && (((rd_ex2 == rs1_dc) && ((op_sel_rs1 == `OP_SEL_RS1) || (is_jalr_dc == `IS_JALR))) || ((rd_ex2 == rs1_dc_aux) && (op_sel_rs1_dc_aux == `OP_SEL_RS1))) && (rd_ex2 != `ZERO));
	assign is_branch_ex2_hazard1 = ((flush_ex2 != `FLUSH_PIPELINE) && (cancel_instr_ex2 != `CANCEL_INSTR) && (wreg_en_ex2 == `W_REG_EN) && (((rd_ex2 == rs2_dc) && ((op_sel_rs2 == `OP_SEL_RS2) || (is_store_instr))) || ((rd_ex2 == rs2_dc_aux) && (op_sel_rs2_dc_aux == `OP_SEL_RS2))) && (rd_ex2 != `ZERO));
	assign is_branch_mem_hazard0 = ((flush_mem != `FLUSH_PIPELINE) && (cancel_instr_mem != `CANCEL_INSTR) && (wreg_en_mem == `W_REG_EN) && (((rd_mem == rs1_dc) && ((op_sel_rs1 == `OP_SEL_RS1) || (is_jalr_dc == `IS_JALR))) || ((rd_mem == rs1_dc_aux) && (op_sel_rs1_dc_aux == `OP_SEL_RS1))) && (rd_mem != `ZERO));
	assign is_branch_mem_hazard1 = ((flush_mem != `FLUSH_PIPELINE) && (cancel_instr_mem != `CANCEL_INSTR) && (wreg_en_mem == `W_REG_EN) && (((rd_mem == rs2_dc) && ((op_sel_rs2 == `OP_SEL_RS2) || (is_store_instr))) || ((rd_mem == rs2_dc_aux) && (op_sel_rs2_dc_aux == `OP_SEL_RS2))) && (rd_mem != `ZERO));
	
	always@(*) begin
		if (is_branch_ex_hazard0 && (is_load_or_store_instr_ex != `IS_LOAD_OR_STORE_INSTR))
			bypassed_reg_data0 = alu_res_ex;
		else if ((wreg_en_ex2 == `W_REG_EN) && (rd_ex2 == rs1_dc) && (rd_ex2 != `ZERO))
			bypassed_reg_data0 = wreg_data_ex2;
		else if ((wreg_en_mem == `W_REG_EN) && (rd_mem == rs1_dc) && (rd_mem != `ZERO))
			bypassed_reg_data0 = wreg_data_mem;
		else if ((wreg_en_wb == `W_REG_EN) && (rd_wb == rs1_dc) && (rd_wb != `ZERO))
			bypassed_reg_data0 = wreg_data_wb;
		else
			bypassed_reg_data0 = reg_data0;	
	end

	always@(*) begin
		if (is_branch_ex_hazard1 && (is_load_or_store_instr_ex != `IS_LOAD_OR_STORE_INSTR))
			bypassed_reg_data1 = alu_res_ex;
		else if ((wreg_en_ex2 == `W_REG_EN) && (rd_ex2 == rs2_dc) && (rd_ex2 != `ZERO))
			bypassed_reg_data1 = wreg_data_ex2;
		else if ((wreg_en_mem == `W_REG_EN) && (rd_mem == rs2_dc) && (rd_mem != `ZERO))
			bypassed_reg_data1 = wreg_data_mem;
		else if ((wreg_en_wb == `W_REG_EN) && (rd_wb == rs2_dc) && (rd_wb != `ZERO))
			bypassed_reg_data1 = wreg_data_wb;
		else
			bypassed_reg_data1 = reg_data1;	
	end

endmodule
