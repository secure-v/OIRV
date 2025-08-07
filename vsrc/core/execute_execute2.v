`include "params.v"

module execute_execute2 (
	input                                   clk                       ,
	input                                   rstn                      ,
	input                                   hold                      ,
	input                                   flush_ex                  ,
	input [`CTRL_SIG_BUS]                   ctrl_sig_ex               ,
	input                                   is_fencei_ex              ,
	input [`OP_TYPE_BUS]                    op_type_ex                ,
	`ifdef M_EXTENSION
	input [`MUL_TYPE_BUS]                   mul_type_ex               ,
	`endif
	input [`INST_BUS]                       instr_ex                  ,
	input [`INSTR_ADDR_BUS]                 instr_addr_ex             ,
	input [`XLEN_BUS]                       rs2_data_ex               ,
	input                                   wdata_en_ex               ,
	input                                   cancel_instr_ex           ,
	input                                   cancel_instr_ex_aux       ,
	input                                   wcsr_en_ex                ,
	input [`REG_INDEX_BUS]                  rs1_ex                    ,
	input [`REG_INDEX_BUS]                  rs2_ex                    ,
	input [`REG_INDEX_BUS]                  rd_ex                     ,
	input                                   is_ecall_instr_ex         ,
	input                                   is_mret_instr_ex          ,
`ifndef PROC_BRANCH_IN_DC
	input                                   branch_taken_ex           ,
	input [`INSTR_ADDR_BUS]                 branch_jalr_target_pc_ex  ,
`endif
`ifdef A_EXTENSION
	input                                   is_amo_instr_ex           ,
	input                                   is_lr_ex                  ,
	input                                   is_sc_ex                  ,
	input [`XLEN_BUS]                       reg_data0_ex              ,
	input [`XLEN_BUS]                       reg_data1_ex              ,
`endif
`ifdef C_EXTENSION
	input                                   is_cinstr_ex              ,
`endif
	input [`WLEN_BUS]                       wlen_ex                   ,
	input [`RLEN_BUS]                       rlen_ex                   ,
	input [`XLEN_BUS]                       wdata_ex                  , 
	input [`CTRL_SIG_BUS]                   ctrl_sig_ex_aux           ,
	input [`INSTR_ADDR_BUS]                 instr_addr_ex_aux         ,
	input [`INST_BUS]                       instr_ex_aux              ,
	input [`REG_INDEX_BUS]                  rd_ex_aux                 ,
	input [`XLEN_BUS]                       wreg_data_ex_aux          , 
	output reg [`CTRL_SIG_BUS]              ctrl_sig_ex2              ,
	output reg                              is_fencei_ex2             ,
	output reg [`OP_TYPE_BUS]               op_type_ex2               ,
	`ifdef M_EXTENSION
	output reg [`MUL_TYPE_BUS]              mul_type_ex2              ,
	`endif
	output reg [`INST_BUS]                  instr_ex2                 ,
	output reg [`INSTR_ADDR_BUS]            instr_addr_ex2            ,
	output reg [`XLEN_BUS]                  rs2_data_ex2              ,
	output reg                              wdata_en_ex2              ,
	output reg                              cancel_instr_ex2          ,
	output reg                              cancel_instr_ex2_aux      ,
	output reg                              wcsr_en_ex2               ,
	output reg [`REG_INDEX_BUS]             rs1_ex2                   ,
	output reg [`REG_INDEX_BUS]             rs2_ex2                   ,
	output reg [`REG_INDEX_BUS]             rd_ex2                    ,
	output reg                              is_ecall_instr_ex2        ,
	output reg                              is_mret_instr_ex2         ,
`ifndef PROC_BRANCH_IN_DC
	output reg                              branch_taken_ex2          ,
	output reg [`INSTR_ADDR_BUS]            branch_jalr_target_pc_ex2 ,
`endif
`ifdef A_EXTENSION
	output reg                              is_amo_instr_ex2          ,
	output reg                              is_lr_ex2                 ,
	output reg                              is_sc_ex2                 ,
`endif
`ifdef C_EXTENSION
	output reg                              is_cinstr_ex2             ,
`endif
	output reg [`CTRL_SIG_BUS]              ctrl_sig_ex2_aux          ,
	output reg [`INSTR_ADDR_BUS]            instr_addr_ex2_aux        ,
	output reg [`INST_BUS]                  instr_ex2_aux             ,
	output reg [`REG_INDEX_BUS]             rd_ex2_aux                ,
	output reg [`XLEN_BUS]                  wreg_data_ex2_aux         , 
	output reg [`XLEN_BUS]                  wdata_ex2                 ,
	output reg                              rdata_en_ex2              ,
	output reg [`RLEN_BUS]                  rlen_ex2                  ,
	output reg [`WLEN_BUS]                  wlen_ex2                  
);

	always@(posedge clk) begin
		if(rstn == `RESET_EN) begin
			ctrl_sig_ex2              <= {!`IS_JALR, !`IS_LOAD_OR_STORE_INSTR, !`OP_SEL_RS2, !`OP_SEL_RS1, !`IS_FROM_ALU, !`W_REG_EN};
			op_type_ex2               <= `OP_NOP                   ;
	`ifdef M_EXTENSION
			mul_type_ex2              <= `NOT_MUL_TYPE             ;
	`endif
		`ifdef VERILATOR_SIM
			instr_ex2                 <= `ZERO                     ;
			instr_addr_ex2            <= `ZERO                     ;
		`endif
			rs2_data_ex2              <= `ZERO                     ;
			wdata_en_ex2              <= !`WDATA_EN                ;
			cancel_instr_ex2          <= `CANCEL_INSTR             ;
			wcsr_en_ex2               <= !`W_CSR_EN                ;
			rs1_ex2                   <= `ZERO                     ;
			rs2_ex2                   <= `ZERO                     ;
			rd_ex2                    <= `ZERO                     ;
			is_ecall_instr_ex2        <= !`IS_ECALL_INSTR          ;
			is_mret_instr_ex2         <= !`IS_MRET_INSTR           ;
	`ifndef PROC_BRANCH_IN_DC
			branch_taken_ex2          <= `BOOL_FALSE               ;
			branch_jalr_target_pc_ex2 <= `ZERO                     ;
	`endif
	`ifdef A_EXTENSION
			is_amo_instr_ex2          <= !`IS_AMO_INSTR            ;
			is_lr_ex2                 <= `BOOL_FALSE               ;
			is_sc_ex2                 <= `BOOL_FALSE               ;
	`endif
	`ifdef C_EXTENSION
			is_cinstr_ex2             <= !`IS_CINSTR               ;
	`endif
			wlen_ex2                  <= `WLEN_BYTE                ;
			rlen_ex2                  <= `RLEN_BYTE                ;
			rdata_en_ex2              <= !`RDATA_EN                ;

			wdata_ex2                 <= `ZERO                     ;
			ctrl_sig_ex2_aux          <= {!`IS_JALR, !`IS_LOAD_OR_STORE_INSTR, !`OP_SEL_RS2, !`OP_SEL_RS1, !`IS_FROM_ALU, !`W_REG_EN}; 
		`ifdef VERILATOR_SIM
			instr_addr_ex2_aux        <= `ZERO                     ;
			instr_ex2_aux             <= `ZERO                     ;
		`endif
			rd_ex2_aux                <= `ZERO                     ;
			wreg_data_ex2_aux         <= `ZERO                     ;
			cancel_instr_ex2_aux      <= `CANCEL_INSTR             ;
			is_fencei_ex2             <= `ZERO                     ;
		end
		else if (hold == `HOLD) begin
			ctrl_sig_ex2              <= ctrl_sig_ex2              ;
			op_type_ex2               <= op_type_ex2               ;
	`ifdef M_EXTENSION
			mul_type_ex2              <= mul_type_ex2              ;
	`endif
			instr_ex2                 <= instr_ex2                 ;
			instr_addr_ex2            <= instr_addr_ex2            ;
			rs2_data_ex2              <= rs2_data_ex2              ;
			wdata_en_ex2              <= wdata_en_ex2              ;
			cancel_instr_ex2          <= cancel_instr_ex2          ;
			wcsr_en_ex2               <= wcsr_en_ex2               ;
			rs1_ex2                   <= rs1_ex2                   ;
			rs2_ex2                   <= rs2_ex2                   ;
			rd_ex2                    <= rd_ex2                    ;
			is_ecall_instr_ex2        <= is_ecall_instr_ex2        ;
			is_mret_instr_ex2         <= is_mret_instr_ex2         ;
	`ifndef PROC_BRANCH_IN_DC
			branch_taken_ex2          <= branch_taken_ex2          ;
			branch_jalr_target_pc_ex2 <= branch_jalr_target_pc_ex2 ;
	`endif
	`ifdef A_EXTENSION
			is_amo_instr_ex2          <= is_amo_instr_ex2          ;
			is_lr_ex2                 <= is_lr_ex2                 ;
			is_sc_ex2                 <= is_sc_ex2                 ;
	`endif
	`ifdef C_EXTENSION
			is_cinstr_ex2             <= is_cinstr_ex2             ;
	`endif
			wlen_ex2                  <= wlen_ex2                  ;
			rlen_ex2                  <= rlen_ex2                  ;
			rdata_en_ex2              <= rdata_en_ex2              ;

			wdata_ex2                   <= wdata_ex2               ;
			ctrl_sig_ex2_aux            <= ctrl_sig_ex2_aux        ;
		`ifdef VERILATOR_SIM
			instr_addr_ex2_aux          <= instr_addr_ex2_aux      ;
			instr_ex2_aux               <= instr_ex2_aux           ;
		`endif
			rd_ex2_aux                  <= rd_ex2_aux              ;
			wreg_data_ex2_aux           <= wreg_data_ex2_aux       ;
			cancel_instr_ex2_aux        <= cancel_instr_ex2_aux    ; 
			is_fencei_ex2               <= is_fencei_ex2           ;
		end
		else begin
			if ((flush_ex == `FLUSH_PIPELINE) || (cancel_instr_ex == `CANCEL_INSTR))
				ctrl_sig_ex2            <= {ctrl_sig_ex[`IS_JALR_INDEX], ctrl_sig_ex[`IS_LOAD_OR_STORE_INSTR_INDEX], ctrl_sig_ex[`OP_SEL_RS2_INDEX], ctrl_sig_ex[`OP_SEL_RS1_INDEX], ctrl_sig_ex[`W_REG_SRC_INDEX], !`W_REG_EN};
			else
				ctrl_sig_ex2            <= ctrl_sig_ex            ;
	
			if ((flush_ex == `FLUSH_PIPELINE) || (cancel_instr_ex == `CANCEL_INSTR))
				wdata_en_ex2            <= !`WDATA_EN             ;
			else
				wdata_en_ex2            <= wdata_en_ex            ;

			if ((flush_ex == `FLUSH_PIPELINE) || (cancel_instr_ex == `CANCEL_INSTR))
				cancel_instr_ex2          <= `CANCEL_INSTR        ;
			else
				cancel_instr_ex2          <= cancel_instr_ex      ;
			
			op_type_ex2               <= op_type_ex               ;
	`ifdef M_EXTENSION
			mul_type_ex2              <= mul_type_ex              ;
	`endif
			instr_ex2                 <= instr_ex                 ;
			instr_addr_ex2            <= instr_addr_ex            ;
			rs2_data_ex2              <= rs2_data_ex              ;
			wcsr_en_ex2               <= wcsr_en_ex               ;
			rs1_ex2                   <= rs1_ex                   ;
			rs2_ex2                   <= rs2_ex                   ;
			rd_ex2                    <= rd_ex                    ;
			is_ecall_instr_ex2        <= is_ecall_instr_ex        ;
			is_mret_instr_ex2         <= is_mret_instr_ex         ;
			// rd_ex2_aux                    <= rd_ex_aux                    ;
			// wreg_data_ex2_aux             <= wreg_data_ex_wb              ;
	`ifndef PROC_BRANCH_IN_DC
			if ((flush_ex == `FLUSH_PIPELINE) || (cancel_instr_ex == `CANCEL_INSTR))
				branch_taken_ex2      <= `BOOL_FALSE              ;
			else
				branch_taken_ex2      <= branch_taken_ex          ;
			branch_jalr_target_pc_ex2 <= branch_jalr_target_pc_ex ;
	`endif
	`ifdef A_EXTENSION
			is_amo_instr_ex2          <= is_amo_instr_ex          ;
			is_lr_ex2                 <= is_lr_ex                 ;
			is_sc_ex2                 <= is_sc_ex                 ;
	`endif
	`ifdef C_EXTENSION
			is_cinstr_ex2             <= is_cinstr_ex             ;
	`endif
			wlen_ex2                  <= wlen_ex                  ;
			rlen_ex2                  <= rlen_ex                  ;

			if ((flush_ex == `FLUSH_PIPELINE) || (cancel_instr_ex == `CANCEL_INSTR))
				rdata_en_ex2                    <= !`RDATA_EN                ;
			else if ((ctrl_sig_ex[`IS_LOAD_OR_STORE_INSTR_INDEX] == `IS_LOAD_OR_STORE_INSTR) && (ctrl_sig_ex[`W_REG_INDEX] == `W_REG_EN))
				rdata_en_ex2                    <= `RDATA_EN                 ;
			else
				rdata_en_ex2                    <= !`RDATA_EN                ;

			if ((flush_ex == `FLUSH_PIPELINE) || (cancel_instr_ex_aux == `CANCEL_INSTR) || is_fencei_ex)
				ctrl_sig_ex2_aux <= {ctrl_sig_ex_aux[`IS_JALR_INDEX], ctrl_sig_ex_aux[`IS_LOAD_OR_STORE_INSTR_INDEX], ctrl_sig_ex_aux[`OP_SEL_RS2_INDEX], ctrl_sig_ex_aux[`OP_SEL_RS1_INDEX], ctrl_sig_ex_aux[`W_REG_SRC_INDEX], !`W_REG_EN};
			else
				ctrl_sig_ex2_aux <= ctrl_sig_ex_aux  ;

		`ifdef A_EXTENSION
			wdata_ex2            <= (is_sc_ex)? reg_data1_ex : wdata_ex;
		`else
			wdata_ex2            <= wdata_ex               ;
		`endif

			instr_addr_ex2_aux   <= instr_addr_ex_aux      ;
			instr_ex2_aux        <= instr_ex_aux           ;
			rd_ex2_aux           <= rd_ex_aux              ;
		`ifdef A_EXTENSION
			if ((is_amo_instr_ex == `IS_AMO_INSTR) && (cancel_instr_ex != `CANCEL_INSTR))
				wreg_data_ex2_aux    <= reg_data0_ex           ; // amo write address
			else
				wreg_data_ex2_aux    <= wreg_data_ex_aux       ;
		`else
			wreg_data_ex2_aux    <= wreg_data_ex_aux       ;
		`endif

			if ((flush_ex == `FLUSH_PIPELINE) || is_fencei_ex)
				cancel_instr_ex2_aux <= `CANCEL_INSTR          ;
			else
				cancel_instr_ex2_aux <= cancel_instr_ex_aux    ;
			
			is_fencei_ex2        <= is_fencei_ex           ;
		end
	end

endmodule
