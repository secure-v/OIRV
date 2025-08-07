`include "params.v"

module decode_execute (
	input                                   clk                     ,
	input                                   rstn                    ,
	input                                   hold                    ,
	input                                   is_fencei_dc            ,
	input [`CTRL_SIG_BUS]                   ctrl_sig_dc             ,
	input [`OP_TYPE_BUS]                    op_type_dc              ,
	`ifdef RV64
	input                                   is_word_op_dc           ,
	`endif
	`ifdef M_EXTENSION
	input [`MUL_TYPE_BUS]                   mul_type_dc             ,
	input [`MUL_TYPE_BUS]                   div_type_dc             ,
	`endif
	input [`INST_TYPE_BUS]                  instr_type_dc           ,
	input                                   wdata_en_dc             ,
	input [`WLEN_BUS]                       wlen_dc                 ,
	input [`RLEN_BUS]                       rlen_dc                 ,
	input [`INST_BUS]                       instr_dc                ,
	input [`INSTR_ADDR_BUS]                 instr_addr_dc           ,
	input [`XLEN_BUS]                       reg_data0_dc            ,
	input [`XLEN_BUS]                       reg_data1_dc            ,
	input [`XLEN_BUS]                       op0_dc_aux              ,
	input [`XLEN_BUS]                       op1_dc_aux              ,
	input                                   cancel_instr_dc         ,
	input                                   cancel_instr_dc_aux     ,
	input [`XLEN_BUS]                       sext_imm_dc             ,
	input                                   wcsr_en_dc              ,
	input [`REG_INDEX_BUS]                  rs1_dc                  ,
	input [`REG_INDEX_BUS]                  rs2_dc                  ,
	input [`REG_INDEX_BUS]                  rd_dc                   ,
`ifndef PROC_BRANCH_IN_DC
	input                                   is_branch_instr_dc      ,
`endif
`ifdef A_EXTENSION
	input                                   is_amo_instr_dc         ,
	input                                   is_lr_dc                ,
	input                                   is_sc_dc                ,
`endif
	`ifdef C_EXTENSION
	input                                   is_cinstr_dc            ,
	input [`XLEN_BUS]                       cimm_dc                 ,
	`endif
	input                                   is_ecall_instr_dc       ,
	input                                   is_mret_instr_dc        ,
	input [`MXLEN_BUS]                      csr_data_dc             ,
	input                                   flush_dc                ,
	input                                   ci_for_branch_after_load,
	input [`INST_BUS]                       instr_dc_aux            ,
	input [`INSTR_ADDR_BUS]                 instr_addr_dc_aux       ,
	input [`CTRL_SIG_BUS]                   ctrl_sig_dc_aux         ,
	input [`OP_TYPE_BUS]                    op_type_dc_aux          ,
	input [`INST_TYPE_BUS]                  instr_type_dc_aux       ,
	`ifdef RV64
	input                                   is_word_op_dc_aux       ,
	`endif
	`ifdef C_EXTENSION
	input [`XLEN_BUS]                       cimm_dc_aux             ,
	`endif
	input [`REG_INDEX_BUS]                  rs1_dc_aux              ,
	input [`REG_INDEX_BUS]                  rs2_dc_aux              ,
	input [`REG_INDEX_BUS]                  rd_dc_aux               ,
	input                                   aux_can_issue_dc_aux    ,
	output reg [`CTRL_SIG_BUS]              ctrl_sig_ex             ,
	output reg [`OP_TYPE_BUS]               op_type_ex              ,
	`ifdef RV64
	output reg                              is_word_op_ex           ,
	`endif
	`ifdef M_EXTENSION
	output reg [`MUL_TYPE_BUS]              mul_type_ex             ,
	output reg [`MUL_TYPE_BUS]              div_type_ex             ,
	`endif
	output reg [`INST_TYPE_BUS]             instr_type_ex           ,
	output reg                              wdata_en_ex             ,
	output reg [`WLEN_BUS]                  wlen_ex                 ,
	output reg [`RLEN_BUS]                  rlen_ex                 ,
	output reg [`INST_BUS]                  instr_ex                ,
	output reg [`INSTR_ADDR_BUS]            instr_addr_ex           ,
	output reg [`XLEN_BUS]                  reg_data0_ex            ,
	output reg [`XLEN_BUS]                  reg_data1_ex            ,
	output reg [`XLEN_BUS]                  op0_ex_aux              ,
	output reg [`XLEN_BUS]                  op1_ex_aux              ,
	output reg                              cancel_instr_ex         ,
	output reg                              cancel_instr_ex_aux     ,
	output reg [`XLEN_BUS]                  sext_imm_ex             ,
	output reg [`REG_INDEX_BUS]             rs1_ex                  ,
	output reg [`REG_INDEX_BUS]             rs2_ex                  ,
	output reg [`REG_INDEX_BUS]             rd_ex                   ,
`ifndef PROC_BRANCH_IN_DC
	output reg                              is_branch_instr_ex      ,
`endif
`ifdef A_EXTENSION
	output reg                              is_amo_instr_ex         ,
	output reg                              is_lr_ex                ,
	output reg                              is_sc_ex                ,
`endif
	output reg                              is_fencei_ex            ,
	`ifdef C_EXTENSION
	output reg                              is_cinstr_ex            ,
	output reg [`XLEN_BUS]                  cimm_ex                 ,
	`endif
	output reg                              wcsr_en_ex              ,
	output reg                              is_ecall_instr_ex       ,
	output reg                              is_mret_instr_ex        ,
	output reg [`MXLEN_BUS]                 csr_data_ex             ,
	output reg [`INST_BUS]                  instr_ex_aux            ,
	output reg [`INSTR_ADDR_BUS]            instr_addr_ex_aux       ,
	output reg [`CTRL_SIG_BUS]              ctrl_sig_ex_aux         ,
	output reg [`OP_TYPE_BUS]               op_type_ex_aux          ,
	output reg [`INST_TYPE_BUS]             instr_type_ex_aux       ,
	`ifdef RV64
	output reg                              is_word_op_ex_aux       ,
	`endif
	`ifdef C_EXTENSION
	output reg [`XLEN_BUS]                  cimm_ex_aux             ,
	`endif
	output reg [`REG_INDEX_BUS]             rs1_ex_aux              ,
	output reg [`REG_INDEX_BUS]             rs2_ex_aux              ,
	output reg [`REG_INDEX_BUS]             rd_ex_aux               
);

	always@(posedge clk) begin
		if(rstn == `RESET_EN) begin
			ctrl_sig_ex           <= {!`IS_JALR, !`IS_LOAD_OR_STORE_INSTR, !`OP_SEL_RS2, !`OP_SEL_RS1, !`IS_FROM_ALU, !`W_REG_EN};
	        op_type_ex            <= `OP_NOP;
			`ifdef RV64
			is_word_op_ex         <= !`IS_WORD_OP;
			`endif
			`ifdef M_EXTENSION
			mul_type_ex           <= `NOT_MUL_TYPE;
			div_type_ex           <= `DIV_DIV_TYPE;
			`endif
			instr_type_ex         <= `UKTYPE;
			wdata_en_ex           <= !`WDATA_EN;
			wlen_ex               <= `WLEN_HALF; // don't care
			rlen_ex               <= `RLEN_HALF; // don't care
			instr_ex              <= `ZERO;
			instr_addr_ex         <= `PC_RESET_ADDR;
			reg_data0_ex          <= `ZERO;
			reg_data1_ex          <= `ZERO;
			cancel_instr_ex       <= `CANCEL_INSTR;
			sext_imm_ex           <= `ZERO;
			wcsr_en_ex            <= !`W_CSR_EN;
			rs1_ex                <= `ZERO;
			rs2_ex                <= `ZERO;
			rd_ex                 <= `ZERO;
			`ifndef PROC_BRANCH_IN_DC
			is_branch_instr_ex    <= !`IS_BRANCH_INSTR;
			`endif
			`ifdef A_EXTENSION
			is_amo_instr_ex       <= !`IS_AMO_INSTR;
			is_lr_ex              <= `BOOL_FALSE;
			is_sc_ex              <= `BOOL_FALSE;
			`endif
			`ifdef C_EXTENSION
			is_cinstr_ex          <= !`IS_CINSTR;
			cimm_ex               <= `ZERO;
			`endif
			csr_data_ex           <= `ZERO;
			is_ecall_instr_ex     <= !`IS_ECALL_INSTR;
			is_mret_instr_ex      <= !`IS_MRET_INSTR ;

		`ifdef VERILATOR_SIM
			instr_ex_aux            <= `ZERO       ;
			instr_addr_ex_aux       <= `ZERO       ;
		`endif
			ctrl_sig_ex_aux         <= {!`IS_JALR, !`IS_LOAD_OR_STORE_INSTR, !`OP_SEL_RS2, !`OP_SEL_RS1, !`IS_FROM_ALU, !`W_REG_EN};
			op_type_ex_aux          <= `OP_NOP;
			instr_type_ex_aux       <= `UKTYPE;
			`ifdef RV64
			is_word_op_ex_aux       <= !`IS_WORD_OP;
			`endif
			`ifdef C_EXTENSION
			cimm_ex_aux             <= `ZERO;
			`endif
			rs1_ex_aux              <= `ZERO;
			rs2_ex_aux              <= `ZERO;
			rd_ex_aux               <= `ZERO;
			op0_ex_aux              <= `ZERO;
			op1_ex_aux              <= `ZERO;
			cancel_instr_ex_aux     <= `CANCEL_INSTR;
			is_fencei_ex            <= `ZERO;
		end
		else if (hold == `HOLD) begin
			ctrl_sig_ex           <= ctrl_sig_ex              ;
	        op_type_ex            <= op_type_ex               ;
			`ifdef RV64
			is_word_op_ex         <= is_word_op_ex            ;
			`endif
			`ifdef M_EXTENSION
			mul_type_ex           <= mul_type_ex              ;
			div_type_ex           <= div_type_ex              ;
			`endif
			instr_type_ex         <= instr_type_ex            ;
			wdata_en_ex           <= wdata_en_ex              ;
			wlen_ex               <= wlen_ex                  ;
			rlen_ex               <= rlen_ex                  ;
			instr_ex              <= instr_ex                 ;
			instr_addr_ex         <= instr_addr_ex            ;
			reg_data0_ex          <= reg_data0_ex             ;
			reg_data1_ex          <= reg_data1_ex             ;
			cancel_instr_ex       <= cancel_instr_ex          ;
			sext_imm_ex           <= sext_imm_ex              ;
			wcsr_en_ex            <= wcsr_en_ex               ;
			rs1_ex                <= rs1_ex                   ;
			rs2_ex                <= rs2_ex                   ;
			rd_ex                 <= rd_ex                    ;
			`ifndef PROC_BRANCH_IN_DC
			is_branch_instr_ex    <= is_branch_instr_ex       ;
			`endif
			`ifdef A_EXTENSION
			is_amo_instr_ex       <= is_amo_instr_ex          ;
			is_lr_ex              <= is_lr_ex                 ;
			is_sc_ex              <= is_sc_ex                 ;
			`endif
			`ifdef C_EXTENSION
			is_cinstr_ex          <= is_cinstr_ex             ;
			cimm_ex               <= cimm_ex                  ;
			`endif
			csr_data_ex           <= csr_data_ex              ;
			is_ecall_instr_ex     <= is_ecall_instr_ex        ;
			is_mret_instr_ex      <= is_mret_instr_ex         ;

		`ifdef VERILATOR_SIM
			instr_ex_aux            <= instr_ex_aux           ;
			instr_addr_ex_aux       <= instr_addr_ex_aux      ;
		`endif
			ctrl_sig_ex_aux         <= ctrl_sig_ex_aux        ;
			op_type_ex_aux          <= op_type_ex_aux         ;
			instr_type_ex_aux       <= instr_type_ex_aux      ;
			`ifdef RV64
			is_word_op_ex_aux       <= is_word_op_ex_aux      ;
			`endif
			`ifdef C_EXTENSION
			cimm_ex_aux             <= cimm_ex_aux            ;
			`endif
			rs1_ex_aux              <= rs1_ex_aux             ;
			rs2_ex_aux              <= rs2_ex_aux             ;
			rd_ex_aux               <= rd_ex_aux              ;
			op0_ex_aux              <= op0_ex_aux             ;
			op1_ex_aux              <= op1_ex_aux             ;
			cancel_instr_ex_aux     <= cancel_instr_ex_aux    ;
			is_fencei_ex            <= is_fencei_ex           ;
		end
		else begin
			if ((cancel_instr_dc == `CANCEL_INSTR) || (ci_for_branch_after_load == `CANCEL_INSTR))
				ctrl_sig_ex       <= {ctrl_sig_dc[`IS_JALR_INDEX], ctrl_sig_dc[`IS_LOAD_OR_STORE_INSTR_INDEX], ctrl_sig_dc[`OP_SEL_RS2_INDEX], ctrl_sig_dc[`OP_SEL_RS1_INDEX], ctrl_sig_dc[`W_REG_SRC_INDEX], !`W_REG_EN};
			else
				ctrl_sig_ex       <= ctrl_sig_dc                  ;

	        op_type_ex            <= op_type_dc                   ;
			`ifdef RV64
			is_word_op_ex         <= is_word_op_dc                ;
			`endif
			`ifdef M_EXTENSION
			mul_type_ex           <= mul_type_dc                  ;
			div_type_ex           <= div_type_dc                  ;
			`endif
			instr_type_ex         <= instr_type_dc                ;

			if ((cancel_instr_dc == `CANCEL_INSTR) || (ci_for_branch_after_load == `CANCEL_INSTR) || (flush_dc == `FLUSH_PIPELINE))
				wdata_en_ex       <= !`WDATA_EN                   ;
			else
				wdata_en_ex       <= wdata_en_dc                  ;

			wlen_ex               <= wlen_dc                      ;
			rlen_ex               <= rlen_dc                      ;
			instr_ex              <= instr_dc                     ;
			instr_addr_ex         <= instr_addr_dc                ;
			reg_data0_ex          <= reg_data0_dc                 ;
			reg_data1_ex          <= reg_data1_dc                 ;

			if ((ci_for_branch_after_load == `CANCEL_INSTR) || (flush_dc == `FLUSH_PIPELINE))
				cancel_instr_ex     <= `CANCEL_INSTR                 ;
			else
				cancel_instr_ex     <= cancel_instr_dc               ;

			sext_imm_ex           <= sext_imm_dc                  ;
			wcsr_en_ex            <= wcsr_en_dc                   ;
			rs1_ex                <= rs1_dc                       ;
			rs2_ex                <= rs2_dc                       ;
			rd_ex                 <= rd_dc                        ;
			`ifndef PROC_BRANCH_IN_DC
			is_branch_instr_ex    <= is_branch_instr_dc           ;
			`endif
			`ifdef A_EXTENSION
			is_amo_instr_ex       <= is_amo_instr_dc              ;
			is_lr_ex              <= is_lr_dc                     ;
			is_sc_ex              <= is_sc_dc                     ;
			`endif
			`ifdef C_EXTENSION
			is_cinstr_ex          <= is_cinstr_dc                 ;
			cimm_ex               <= cimm_dc                      ;
			`endif
			csr_data_ex           <= csr_data_dc                  ;
			is_ecall_instr_ex     <= is_ecall_instr_dc            ;
			is_mret_instr_ex      <= is_mret_instr_dc             ;

		`ifdef VERILATOR_SIM
			instr_ex_aux            <= instr_dc_aux               ;
			instr_addr_ex_aux       <= instr_addr_dc_aux          ;
		`endif

			// if ((aux_can_issue_dc_aux == !`AUX_CAN_ISSUE) || (flush_dc == `FLUSH_PIPELINE) || (cancel_instr_dc_aux == `CANCEL_INSTR) || (ci_for_branch_after_load == `CANCEL_INSTR))
			// if ((aux_can_issue_dc_aux == !`AUX_CAN_ISSUE) || (ctrl_sig_dc[`IS_JALR_INDEX]) || (flush_dc == `FLUSH_PIPELINE) || (cancel_instr_dc_aux == `CANCEL_INSTR) || (ci_for_branch_after_load == `CANCEL_INSTR) || (instr_type_dc[`JTYPE_INDEX]) || (instr_type_dc[`CJTYPE_INDEX]) || (is_branch_instr_dc == `IS_BRANCH_INSTR))
			if ((aux_can_issue_dc_aux == !`AUX_CAN_ISSUE) || (ctrl_sig_dc[`IS_JALR_INDEX]) || (flush_dc == `FLUSH_PIPELINE) || (cancel_instr_dc_aux == `CANCEL_INSTR) || (ci_for_branch_after_load == `CANCEL_INSTR) || (instr_type_dc[`JTYPE_INDEX]) || (instr_type_dc[`CJTYPE_INDEX]))
				ctrl_sig_ex_aux     <= {!`IS_JALR, !`IS_LOAD_OR_STORE_INSTR, !`OP_SEL_RS2, !`OP_SEL_RS2, `IS_FROM_ALU, !`W_REG_EN};
			else
				ctrl_sig_ex_aux     <= ctrl_sig_dc_aux            ;

			op_type_ex_aux          <= op_type_dc_aux             ;
			instr_type_ex_aux       <= instr_type_dc_aux          ;
			`ifdef RV64
			is_word_op_ex_aux       <= is_word_op_dc_aux          ;
			`endif
			`ifdef C_EXTENSION
			cimm_ex_aux             <= cimm_dc_aux                ;
			`endif
			rs1_ex_aux              <= rs1_dc_aux                 ;
			rs2_ex_aux              <= rs2_dc_aux                 ;
			rd_ex_aux               <= rd_dc_aux                  ;
			op0_ex_aux              <= op0_dc_aux                 ;
			op1_ex_aux              <= op1_dc_aux                 ;

			// if ((aux_can_issue_dc_aux == !`AUX_CAN_ISSUE) || (ci_for_branch_after_load == `CANCEL_INSTR) || (flush_dc == `FLUSH_PIPELINE) || (instr_type_dc == `JTYPE) || (instr_type_dc == `CJTYPE))
			// if ((aux_can_issue_dc_aux == !`AUX_CAN_ISSUE) || (ctrl_sig_dc[`IS_JALR_INDEX]) || (ci_for_branch_after_load == `CANCEL_INSTR) || (flush_dc == `FLUSH_PIPELINE) || (instr_type_dc[`JTYPE_INDEX]) || (instr_type_dc[`CJTYPE_INDEX]) || (is_branch_instr_dc == `IS_BRANCH_INSTR))
			if ((aux_can_issue_dc_aux == !`AUX_CAN_ISSUE) || (ctrl_sig_dc[`IS_JALR_INDEX]) || (ci_for_branch_after_load == `CANCEL_INSTR) || (flush_dc == `FLUSH_PIPELINE) || (instr_type_dc[`JTYPE_INDEX]) || (instr_type_dc[`CJTYPE_INDEX]))
				cancel_instr_ex_aux     <= `CANCEL_INSTR          ;
			else
				cancel_instr_ex_aux     <= cancel_instr_dc_aux    ;
			
			is_fencei_ex            <= is_fencei_dc               ;
		end
	end
endmodule
