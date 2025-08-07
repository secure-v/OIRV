`include "params.v"

module data_bypass (
	input [`REG_INDEX_BUS]             rd_ex2               ,
	input [`REG_INDEX_BUS]             rd_mem               ,
	input [`REG_INDEX_BUS]             rs1_dc               ,
	input [`REG_INDEX_BUS]             rs2_dc               ,
	input [`REG_INDEX_BUS]             rs1_dc_aux           ,
	input [`REG_INDEX_BUS]             rs2_dc_aux           ,
	input                              op_sel_rs1_dc_aux    ,
	input                              op_sel_rs2_dc_aux    ,
	input                              wreg_en_ex_aux       ,
	input                              wreg_en_ex2_aux      ,
	input                              wreg_en_mem_aux      ,
	input                              wreg_en_wb_aux       ,
	input [`REG_INDEX_BUS]             rd_ex_aux            ,
	input [`REG_INDEX_BUS]             rd_ex2_aux           ,
	input [`REG_INDEX_BUS]             rd_mem_aux           ,
	input [`REG_INDEX_BUS]             rd_wb_aux            ,
	input [`XLEN_BUS]                  wreg_data_ex_aux     ,
	input [`XLEN_BUS]                  wreg_data_ex2_aux    ,
	input [`XLEN_BUS]                  wreg_data_mem_aux    ,
	input [`XLEN_BUS]                  wreg_data_wb_aux     ,
	input                              wreg_en_ex           ,
	input [`REG_INDEX_BUS]             rd_ex                ,
	input [`XLEN_BUS]                  wreg_data_ex         ,
	input [`REG_INDEX_BUS]             rs1_ex               ,
	input [`REG_INDEX_BUS]             rs2_ex               ,
	input [`REG_INDEX_BUS]             rs2_mem              ,
	input                              wreg_en_ex2          ,
	input                              wreg_en_mem          ,
	input                              op_sel_rs1_ex        ,
	input                              op_sel_rs2_ex        ,
	input [`XLEN_BUS]                  op0_ex               ,
	input [`XLEN_BUS]                  op1_ex               ,
	input [`XLEN_BUS]                  op0_ex_aux           ,
	input [`XLEN_BUS]                  op1_ex_aux           ,
	input                              op_sel_rs1_ex_aux    ,
	input                              op_sel_rs2_ex_aux    ,
	input [`REG_INDEX_BUS]             rs1_ex_aux           ,
	input [`REG_INDEX_BUS]             rs2_ex_aux           ,
	input [`XLEN_BUS]                  wreg_data_ex2        ,
	input [`XLEN_BUS]                  alu_res_mem          ,
	input [`XLEN_BUS]                  wreg_data_mem        ,
	input [`REG_INDEX_BUS]             rd_wb                ,
	input                              wreg_en_wb           ,
	input [`XLEN_BUS]                  wdata_no_bypass      ,
	input [`XLEN_BUS]                  wreg_data_wb         ,
	input [`XLEN_BUS]                  ext_rdata            ,
	input [`XLEN_BUS]                  reg_data0            ,
	input [`XLEN_BUS]                  reg_data1            ,
	input [`XLEN_BUS]                  op0_aux              ,
	input [`XLEN_BUS]                  op1_aux              ,
	input [`XLEN_BUS]                  reg_data1_ex         ,
`ifdef A_EXTENSION
	input                              is_amo_instr_ex      ,
	input [`XLEN_BUS]          		   alu_res_ex           ,
`endif
	output reg [`XLEN_BUS]             reg_data0_dc         ,
	output reg [`XLEN_BUS]             reg_data1_dc         ,
	output reg [`XLEN_BUS]             op0_may_bypass_aux   ,
	output reg [`XLEN_BUS]             op1_may_bypass_aux   ,
`ifndef PROC_BRANCH_IN_DC
	input                              is_jalr_ex           ,
	input [`XLEN_BUS]                  reg_data0_ex         ,
	output reg [`XLEN_BUS]             bypassed_reg_data0_ex,
`endif
	output reg [`XLEN_BUS]             op0_may_bypass       ,
	output reg [`XLEN_BUS]             op1_may_bypass       ,
	output reg [`XLEN_BUS]             op0_ex_aux_may_bypass,
	output reg [`XLEN_BUS]             op1_ex_aux_may_bypass,
	output reg [`XLEN_BUS]             wdata_ex             
	// output reg [`XLEN_BUS]             wdata_may_bypass       
);

/////////////////////////////////////////////////////////////////////////////////////

	always@(*) begin
		if (op_sel_rs1_ex == `OP_SEL_RS1) begin
			if ((wreg_en_ex2_aux == `W_REG_EN) && (rd_ex2_aux == rs1_ex) && (rs1_ex != `ZERO))
				op0_may_bypass = op0_ex;
			else if ((wreg_en_ex2 == `W_REG_EN) && (rd_ex2 == rs1_ex) && (rs1_ex != `ZERO))
				op0_may_bypass = wreg_data_ex2; // op0_ex
			else if ((wreg_en_mem_aux == `W_REG_EN) && (rd_mem_aux == rs1_ex) && (rs1_ex != `ZERO))
				op0_may_bypass = op0_ex;
			else if ((wreg_en_mem == `W_REG_EN) && (rd_mem == rs1_ex) && (rs1_ex != `ZERO))
				op0_may_bypass = op0_ex;
			else if ((wreg_en_wb_aux == `W_REG_EN) && (rd_wb_aux == rs1_ex) && (rs1_ex != `ZERO))
				op0_may_bypass = op0_ex;
			else if ((wreg_en_wb == `W_REG_EN) && (rd_wb == rs1_ex) && (rs1_ex != `ZERO))
				op0_may_bypass = wreg_data_wb; // op0_ex
			else
				op0_may_bypass = op0_ex;
		end
		else
			op0_may_bypass = op0_ex;	
	end

	always@(*) begin
		if (op_sel_rs2_ex == `OP_SEL_RS2) begin
			if ((wreg_en_ex2_aux == `W_REG_EN) && (rd_ex2_aux == rs2_ex) && (rs2_ex != `ZERO))
				op1_may_bypass = op1_ex;
			else if ((wreg_en_ex2 == `W_REG_EN) && (rd_ex2 == rs2_ex) && (rs2_ex != `ZERO))
				op1_may_bypass = wreg_data_ex2; // op1_ex
			else if ((wreg_en_mem_aux == `W_REG_EN) && (rd_mem_aux == rs2_ex) && (rs2_ex != `ZERO))
				op1_may_bypass = op1_ex;
			else if ((wreg_en_mem == `W_REG_EN) && (rd_mem == rs2_ex) && (rs2_ex != `ZERO))
				op1_may_bypass = op1_ex;
			else if ((wreg_en_wb_aux == `W_REG_EN) && (rd_wb_aux == rs2_ex) && (rs2_ex != `ZERO))
				op1_may_bypass = op1_ex;
			else if ((wreg_en_wb == `W_REG_EN) && (rd_wb == rs2_ex) && (rs2_ex != `ZERO))
				op1_may_bypass = wreg_data_wb; // op1_ex
			else
				op1_may_bypass = op1_ex;
		end
		else
			op1_may_bypass = op1_ex;	
	end

	always @(*) begin
    	if ((wreg_en_ex_aux == `W_REG_EN) && (rd_ex_aux == rs1_dc) && (rs1_dc != `ZERO))
		    reg_data0_dc = wreg_data_ex_aux;
    	else if ((wreg_en_ex == `W_REG_EN) && (rd_ex == rs1_dc) && (rs1_dc != `ZERO))
		    reg_data0_dc = wreg_data_ex;
    	else if ((wreg_en_ex2_aux == `W_REG_EN) && (rd_ex2_aux == rs1_dc) && (rs1_dc != `ZERO))
    		reg_data0_dc = wreg_data_ex2_aux;
    	else if ((wreg_en_ex2 == `W_REG_EN) && (rd_ex2 == rs1_dc) && (rs1_dc != `ZERO))
    		reg_data0_dc = wreg_data_ex2;
    	else if ((wreg_en_mem_aux == `W_REG_EN) && (rd_mem_aux == rs1_dc) && (rs1_dc != `ZERO))
			reg_data0_dc = wreg_data_mem_aux;
    	else if ((wreg_en_mem == `W_REG_EN) && (rd_mem == rs1_dc) && (rs1_dc != `ZERO))
			reg_data0_dc = alu_res_mem; // wreg_data_mem;
		else if ((wreg_en_wb_aux == `W_REG_EN) && (rd_wb_aux == rs1_dc) && (rs1_dc != `ZERO))
			reg_data0_dc = wreg_data_wb_aux;
		else if ((wreg_en_wb == `W_REG_EN) && (rd_wb == rs1_dc) && (rs1_dc != `ZERO))
			reg_data0_dc = wreg_data_wb;
		else
			reg_data0_dc = reg_data0;
	end

	always @(*) begin
		if ((wreg_en_ex_aux == `W_REG_EN) && (rd_ex_aux == rs2_dc) && (rs2_dc != `ZERO))
			reg_data1_dc = wreg_data_ex_aux;
		else if ((wreg_en_ex == `W_REG_EN) && (rd_ex == rs2_dc) && (rs2_dc != `ZERO))
			reg_data1_dc = wreg_data_ex;
		else if ((wreg_en_ex2_aux == `W_REG_EN) && (rd_ex2_aux == rs2_dc) && (rs2_dc != `ZERO))
			reg_data1_dc = wreg_data_ex2_aux;
		else if ((wreg_en_ex2 == `W_REG_EN) && (rd_ex2 == rs2_dc) && (rs2_dc != `ZERO))
			reg_data1_dc = wreg_data_ex2;
		else if ((wreg_en_mem_aux == `W_REG_EN) && (rd_mem_aux == rs2_dc) && (rs2_dc != `ZERO))
			reg_data1_dc = wreg_data_mem_aux;
		else if ((wreg_en_mem == `W_REG_EN) && (rd_mem == rs2_dc) && (rs2_dc != `ZERO))
			reg_data1_dc = alu_res_mem; // wreg_data_mem;
		else if ((wreg_en_wb_aux == `W_REG_EN) && (rd_wb_aux == rs2_dc) && (rs2_dc != `ZERO))
			reg_data1_dc = wreg_data_wb_aux;
		else if ((wreg_en_wb == `W_REG_EN) && (rd_wb == rs2_dc) && (rs2_dc != `ZERO))
			reg_data1_dc = wreg_data_wb;
		else
			reg_data1_dc = reg_data1;
	end

/////////////////////////////////////////////////////////////////////////////////////
	always@(*) begin
		if ((op_sel_rs1_dc_aux == `OP_SEL_RS1)) begin
			if ((wreg_en_ex_aux == `W_REG_EN) && (rd_ex_aux == rs1_dc_aux) && (rs1_dc_aux != `ZERO))
				op0_may_bypass_aux = wreg_data_ex_aux;
			else if ((wreg_en_ex == `W_REG_EN) && (rd_ex == rs1_dc_aux) && (rs1_dc_aux != `ZERO))
				op0_may_bypass_aux = wreg_data_ex;
			else if ((wreg_en_ex2_aux == `W_REG_EN) && (rd_ex2_aux == rs1_dc_aux) && (rs1_dc_aux != `ZERO))
				op0_may_bypass_aux = wreg_data_ex2_aux;
			else if ((wreg_en_ex2 == `W_REG_EN) && (rd_ex2 == rs1_dc_aux) && (rs1_dc_aux != `ZERO))
				op0_may_bypass_aux = wreg_data_ex2;
			else if ((wreg_en_mem_aux == `W_REG_EN) && (rd_mem_aux == rs1_dc_aux) && (rs1_dc_aux != `ZERO))
				op0_may_bypass_aux = wreg_data_mem_aux;
			else if ((wreg_en_mem == `W_REG_EN) && (rd_mem == rs1_dc_aux) && (rs1_dc_aux != `ZERO))
				op0_may_bypass_aux = alu_res_mem;//wreg_data_mem;
			else if ((wreg_en_wb_aux == `W_REG_EN) && (rd_wb_aux == rs1_dc_aux) && (rs1_dc_aux != `ZERO))
				op0_may_bypass_aux = wreg_data_wb_aux;
			else if ((wreg_en_wb == `W_REG_EN) && (rd_wb == rs1_dc_aux) && (rs1_dc_aux != `ZERO))
				op0_may_bypass_aux = wreg_data_wb;
			else
				op0_may_bypass_aux = op0_aux;
		end
		else
			op0_may_bypass_aux = op0_aux;	
	end

/////////////////////////////////////////////////////////////////////////////////////
	always@(*) begin
		if ((op_sel_rs2_dc_aux == `OP_SEL_RS2)) begin
			if ((wreg_en_ex_aux == `W_REG_EN) && (rd_ex_aux == rs2_dc_aux) && (rs2_dc_aux != `ZERO))
				op1_may_bypass_aux = wreg_data_ex_aux;
			else if ((wreg_en_ex == `W_REG_EN) && (rd_ex == rs2_dc_aux) && (rs2_dc_aux != `ZERO))
				op1_may_bypass_aux = wreg_data_ex;
			else if ((wreg_en_ex2_aux == `W_REG_EN) && (rd_ex2_aux == rs2_dc_aux) && (rs2_dc_aux != `ZERO))
				op1_may_bypass_aux = wreg_data_ex2_aux;
			else if ((wreg_en_ex2 == `W_REG_EN) && (rd_ex2 == rs2_dc_aux) && (rs2_dc_aux != `ZERO))
				op1_may_bypass_aux = wreg_data_ex2;
			else if ((wreg_en_mem_aux == `W_REG_EN) && (rd_mem_aux == rs2_dc_aux) && (rs2_dc_aux != `ZERO))
				op1_may_bypass_aux = wreg_data_mem_aux;
			else if ((wreg_en_mem == `W_REG_EN) && (rd_mem == rs2_dc_aux) && (rs2_dc_aux != `ZERO))
				op1_may_bypass_aux = alu_res_mem; // wreg_data_mem;
			else if ((wreg_en_wb_aux == `W_REG_EN) && (rd_wb_aux == rs2_dc_aux) && (rs2_dc_aux != `ZERO))
				op1_may_bypass_aux = wreg_data_wb_aux;
			else if ((wreg_en_wb == `W_REG_EN) && (rd_wb == rs2_dc_aux) && (rs2_dc_aux != `ZERO))
				op1_may_bypass_aux = wreg_data_wb;
			else
				op1_may_bypass_aux = op1_aux;
		end
		else
			op1_may_bypass_aux = op1_aux;
	end

/////////////////////////////////////////////////////////////////////////////////////

	always@(*) begin
		if ((op_sel_rs1_ex_aux == `OP_SEL_RS1) && (wreg_en_ex == `W_REG_EN) && (rd_ex == rs1_ex_aux) && (rs1_ex_aux != `ZERO))
			op0_ex_aux_may_bypass = wreg_data_ex;
		else if ((op_sel_rs1_ex_aux == `OP_SEL_RS1) && (wreg_en_ex2_aux == `W_REG_EN) && (rd_ex2_aux == rs1_ex_aux) && (rs1_ex_aux != `ZERO))
			op0_ex_aux_may_bypass = op0_ex_aux; // bypassed in dc stage
		else if ((op_sel_rs1_ex_aux == `OP_SEL_RS1) && (wreg_en_ex2 == `W_REG_EN) && (rd_ex2 == rs1_ex_aux) && (rs1_ex_aux != `ZERO))
			op0_ex_aux_may_bypass = wreg_data_ex2;
		else if ((wreg_en_mem_aux == `W_REG_EN) && (rd_mem_aux == rs1_ex_aux) && (rs1_ex_aux != `ZERO))
			op0_ex_aux_may_bypass = op0_ex_aux;
		else if ((wreg_en_mem == `W_REG_EN) && (rd_mem == rs1_ex_aux) && (rs1_ex_aux != `ZERO))
			op0_ex_aux_may_bypass = op0_ex_aux;
		else if ((wreg_en_wb_aux == `W_REG_EN) && (rd_wb_aux == rs1_ex_aux) && (rs1_ex_aux != `ZERO))
			op0_ex_aux_may_bypass = op0_ex_aux;
		else if ((op_sel_rs1_ex_aux == `OP_SEL_RS1) && (wreg_en_wb == `W_REG_EN) && (rd_wb == rs1_ex_aux) && (rs1_ex_aux != `ZERO))
			op0_ex_aux_may_bypass = wreg_data_wb;
		else
			op0_ex_aux_may_bypass = op0_ex_aux;	
	end
	
/////////////////////////////////////////////////////////////////////////////////////

	always@(*) begin
		if ((op_sel_rs2_ex_aux == `OP_SEL_RS2) && (wreg_en_ex == `W_REG_EN) && (rd_ex == rs2_ex_aux) && (rs2_ex_aux != `ZERO))
			op1_ex_aux_may_bypass = wreg_data_ex;
		else if ((op_sel_rs2_ex_aux == `OP_SEL_RS2) && (wreg_en_ex2_aux == `W_REG_EN) && (rd_ex2_aux == rs2_ex_aux) && (rs2_ex_aux != `ZERO))
			op1_ex_aux_may_bypass = op1_ex_aux; // bypassed in dc stage
		else if ((op_sel_rs2_ex_aux == `OP_SEL_RS2) && (wreg_en_ex2 == `W_REG_EN) && (rd_ex2 == rs2_ex_aux) && (rs2_ex_aux != `ZERO))
			op1_ex_aux_may_bypass = wreg_data_ex2;
		else if ((wreg_en_mem_aux == `W_REG_EN) && (rd_mem_aux == rs2_ex_aux) && (rs2_ex_aux != `ZERO))
			op1_ex_aux_may_bypass = op1_ex_aux;
		else if ((wreg_en_mem == `W_REG_EN) && (rd_mem == rs2_ex_aux) && (rs2_ex_aux != `ZERO))
			op1_ex_aux_may_bypass = op1_ex_aux;
		else if ((wreg_en_wb_aux == `W_REG_EN) && (rd_wb_aux == rs2_ex_aux) && (rs2_ex_aux != `ZERO))
			op1_ex_aux_may_bypass = op1_ex_aux;
		else if ((op_sel_rs2_ex_aux == `OP_SEL_RS2) && (wreg_en_wb == `W_REG_EN) && (rd_wb == rs2_ex_aux) && (rs2_ex_aux != `ZERO))
			op1_ex_aux_may_bypass = wreg_data_wb;
		else
			op1_ex_aux_may_bypass = op1_ex_aux;	
	end

////////////////////////////////////////////////////////////////////////////////////

	// always@(*) begin
	// 	if ((wreg_en_wb_aux == `W_REG_EN) && (rd_wb_aux == rs2_mem) && (rd_wb_aux != `ZERO)) // the data wrote to memory
	// 		wdata_may_bypass = wreg_data_wb_aux;
	// 	else if ((wreg_en_wb == `W_REG_EN) && (rd_wb == rs2_mem) && (rd_wb != `ZERO)) // the data wrote to memory
	// 		wdata_may_bypass = wreg_data_wb;
	// 	else
	// 		wdata_may_bypass = wdata_no_bypass;
	// end

	always@(*) begin
		if ((wreg_en_ex2_aux == `W_REG_EN) && (rd_ex2_aux == rs2_ex) && (rs2_ex != `ZERO))
			wdata_ex = reg_data1_ex;
		else if ((wreg_en_ex2 == `W_REG_EN) && (rd_ex2 == rs2_ex) && (rs2_ex != `ZERO))
			wdata_ex = wreg_data_ex2; // mul result
		else if ((wreg_en_mem_aux == `W_REG_EN) && (rd_mem_aux == rs2_ex) && (rs2_ex != `ZERO))
			wdata_ex = reg_data1_ex;
		else if ((wreg_en_mem == `W_REG_EN) && (rd_mem == rs2_ex) && (rs2_ex != `ZERO))
			wdata_ex = reg_data1_ex;
		else if ((wreg_en_wb_aux == `W_REG_EN) && (rd_wb_aux == rs2_ex) && (rs2_ex != `ZERO))
			wdata_ex = reg_data1_ex;
		else if ((wreg_en_wb == `W_REG_EN) && (rd_wb == rs2_ex) && (rs2_ex != `ZERO))
			wdata_ex = wreg_data_wb;
	`ifdef A_EXTENSION
		else if (is_amo_instr_ex == `IS_AMO_INSTR)
			wdata_ex = alu_res_ex;
	`endif
		else
			wdata_ex = reg_data1_ex;	
	end

`ifndef PROC_BRANCH_IN_DC

	always@(*) begin
		if (is_jalr_ex == `IS_JALR) begin
			if ((wreg_en_ex2_aux == `W_REG_EN) && (rd_ex2_aux == rs1_ex) && (rs1_ex != `ZERO))
				bypassed_reg_data0_ex = wreg_data_ex2_aux;
			else if ((wreg_en_ex2 == `W_REG_EN) && (rd_ex2 == rs1_ex) && (rs1_ex != `ZERO))
				bypassed_reg_data0_ex = wreg_data_ex2;
			else if ((wreg_en_mem_aux == `W_REG_EN) && (rd_mem_aux == rs1_ex) && (rs1_ex != `ZERO))
				bypassed_reg_data0_ex = wreg_data_mem_aux;
			else if ((wreg_en_mem == `W_REG_EN) && (rd_mem == rs1_ex) && (rs1_ex != `ZERO))
				bypassed_reg_data0_ex = alu_res_mem; // wreg_data_mem;
			else if ((wreg_en_wb_aux == `W_REG_EN) && (rd_wb_aux == rs1_ex) && (rs1_ex != `ZERO))
				bypassed_reg_data0_ex = wreg_data_wb_aux;
			else if ((wreg_en_wb == `W_REG_EN) && (rd_wb == rs1_ex) && (rs1_ex != `ZERO))  // for jalr
				bypassed_reg_data0_ex = wreg_data_wb;
			else
				bypassed_reg_data0_ex = reg_data0_ex;
		end
		else
			bypassed_reg_data0_ex = `ZERO;
	end
`endif

endmodule
