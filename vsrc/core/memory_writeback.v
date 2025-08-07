`include "params.v"

module memory_writeback (
	input                                   clk                    ,
	input                                   rstn                   ,
	input                                   hold                   ,
`ifdef A_EXTENSION
	input		                            is_amo_instr_mem       ,
	input                                   amo_val_lockup         ,
	input                                   is_sc_mem              ,
	input                                   is_fail_sc_mem         ,
`endif
	input                                   is_fencei_mem          ,
	input                                   interrupt_taken        ,
	input [`CTRL_SIG_BUS]                   ctrl_sig_mem           ,
	input [`INSTR_ADDR_BUS]                 instr_addr_mem         ,
	input [`INST_BUS]                       instr_mem              ,
	input                                   cancel_instr_mem       ,
	input                                   cancel_instr_mem_aux   ,
	input                                   wcsr_en_mem            ,
	input [`REG_INDEX_BUS]                  rs1_mem                ,
	input [`REG_INDEX_BUS]                  rs2_mem                ,
	input [`REG_INDEX_BUS]                  rd_mem                 ,
	input                                   is_ecall_instr_mem     ,
	input                                   is_mret_instr_mem      ,
	input                                   mtime_interrupt_mem    ,
	input                                   external_interrupt_mem ,
	input [`XLEN_BUS]                       wreg_data_mem          ,
	input                                   flush_mem              ,  
	input                                   flush_mem_aux          ,
	input [`CTRL_SIG_BUS]                   ctrl_sig_mem_aux       ,
	input [`INSTR_ADDR_BUS]                 instr_addr_mem_aux     ,
	input [`INST_BUS]                       instr_mem_aux          ,
	input [`REG_INDEX_BUS]                  rd_mem_aux             ,
	input [`XLEN_BUS]                       wreg_data_mem_aux      ,   
	output reg [`CTRL_SIG_BUS]              ctrl_sig_wb            ,
	output reg [`INSTR_ADDR_BUS]            instr_addr_wb          ,
	output reg [`INST_BUS]                  instr_wb               ,
	output reg                              cancel_instr_wb        ,
	output reg                              cancel_instr_wb_aux    ,
	output reg                              wcsr_en_wb             ,
	output reg [`REG_INDEX_BUS]             rs1_wb                 ,
	output reg [`REG_INDEX_BUS]             rs2_wb                 ,
	output reg [`REG_INDEX_BUS]             rd_wb                  ,
	output reg                              is_ecall_instr_wb      ,
	output reg                              is_mret_instr_wb       ,
	output reg                              mtime_interrupt_wb     ,
	output reg                              external_interrupt_wb  ,
	output reg [`XLEN_BUS]                  wreg_data_wb           ,
`ifdef A_EXTENSION
	output reg		                        is_amo_instr_wb        ,
`endif
	output reg                              is_fencei_wb           ,
	output reg [`CTRL_SIG_BUS]              ctrl_sig_wb_aux        ,
	output reg [`INSTR_ADDR_BUS]            instr_addr_wb_aux      ,
	output reg [`INST_BUS]                  instr_wb_aux           ,
	output reg [`REG_INDEX_BUS]             rd_wb_aux              ,
	output reg [`XLEN_BUS]                  wreg_data_wb_aux       ,
	output                                  commit                 ,
	output                                  commit_aux             
);

	reg commit_wb    ;
	reg commit_aux_wb;

	assign commit     = (interrupt_taken == `INTERRUPT_TAKEN)? !`COMMIT_INSTR : commit_wb    ;
	assign commit_aux = (interrupt_taken == `INTERRUPT_TAKEN)? !`COMMIT_INSTR : commit_aux_wb;

	always@(posedge clk) begin
		if(rstn == `RESET_EN) begin
			ctrl_sig_wb        <= {!`IS_JALR, !`IS_LOAD_OR_STORE_INSTR, !`OP_SEL_RS2, !`OP_SEL_RS1, !`IS_FROM_ALU, !`W_REG_EN}; 
			instr_addr_wb      <= `ZERO;
			instr_wb           <= `ZERO;
			cancel_instr_wb    <= `CANCEL_INSTR;
			wreg_data_wb       <= `ZERO;
			wcsr_en_wb         <= !`W_CSR_EN;
			rs1_wb             <= `ZERO;    
			rs2_wb             <= `ZERO;
			rd_wb              <= `ZERO;
			is_ecall_instr_wb  <= !`IS_ECALL_INSTR;
			is_mret_instr_wb   <= !`IS_MRET_INSTR;
			mtime_interrupt_wb <= !`TIME_INTERRUPT;
			external_interrupt_wb <= !`EXTERNAL_INTERRUPT;
			commit_wb          <= !`COMMIT_INSTR;

			ctrl_sig_wb_aux     <= {!`IS_JALR, !`IS_LOAD_OR_STORE_INSTR, !`OP_SEL_RS2, !`OP_SEL_RS1, !`IS_FROM_ALU, !`W_REG_EN}; 
		`ifdef VERILATOR_SIM
			instr_addr_wb_aux   <= `ZERO              ;
			instr_wb_aux        <= `ZERO              ;
		`endif
			rd_wb_aux           <= `ZERO              ;
			wreg_data_wb_aux    <= `ZERO              ;
			cancel_instr_wb_aux <= `CANCEL_INSTR      ;
			commit_aux_wb       <= !`COMMIT_INSTR     ;
		`ifdef A_EXTENSION
			is_amo_instr_wb     <= !`IS_AMO_INSTR     ;
		`endif
			is_fencei_wb        <= `ZERO              ;
		end
		else if (hold == `HOLD) begin
			// ctrl_sig_wb     <= {ctrl_sig_wb[`IS_JALR_INDEX], ctrl_sig_wb[`IS_LOAD_OR_STORE_INSTR_INDEX], ctrl_sig_wb[`OP_SEL_RS2_INDEX], ctrl_sig_wb[`OP_SEL_RS1_INDEX], ctrl_sig_wb[`W_REG_SRC_INDEX], !`W_REG_EN};
			ctrl_sig_wb        <= ctrl_sig_wb       ;
			instr_addr_wb      <= instr_addr_wb     ;
			instr_wb           <= instr_wb          ;
			cancel_instr_wb    <= cancel_instr_wb   ;
			wreg_data_wb       <= wreg_data_wb      ;
			wcsr_en_wb         <= wcsr_en_wb        ;
			rs1_wb             <= rs1_wb            ;
			rs2_wb             <= rs2_wb            ;
			rd_wb              <= rd_wb             ;
			is_ecall_instr_wb  <= is_ecall_instr_wb ;
			is_mret_instr_wb   <= is_mret_instr_wb  ;
			mtime_interrupt_wb <= mtime_interrupt_wb;
			external_interrupt_wb <= external_interrupt_mem;
			commit_wb          <= !`COMMIT_INSTR    ;

			ctrl_sig_wb_aux     <= ctrl_sig_wb_aux    ;
		`ifdef VERILATOR_SIM
			instr_addr_wb_aux   <= instr_addr_wb_aux  ;
			instr_wb_aux        <= instr_wb_aux       ;
		`endif
			rd_wb_aux           <= rd_wb_aux          ;
			wreg_data_wb_aux    <= wreg_data_wb_aux   ;
			cancel_instr_wb_aux <= cancel_instr_wb_aux;
			commit_aux_wb       <= !`COMMIT_INSTR     ;
		`ifdef A_EXTENSION
			is_amo_instr_wb     <= is_amo_instr_wb    ;
		`endif
			is_fencei_wb        <= is_fencei_wb       ;
		end
		else begin
		`ifdef A_EXTENSION
			if ((is_amo_instr_mem == `IS_AMO_INSTR) && (cancel_instr_mem != `CANCEL_INSTR))
				ctrl_sig_wb     <= {ctrl_sig_mem[`IS_JALR_INDEX], ctrl_sig_mem[`IS_LOAD_OR_STORE_INSTR_INDEX], ctrl_sig_mem[`OP_SEL_RS2_INDEX], ctrl_sig_mem[`OP_SEL_RS1_INDEX], ctrl_sig_mem[`W_REG_SRC_INDEX],  `W_REG_EN};
			else if (flush_mem == `FLUSH_PIPELINE)
				ctrl_sig_wb     <= {ctrl_sig_mem[`IS_JALR_INDEX], ctrl_sig_mem[`IS_LOAD_OR_STORE_INSTR_INDEX], ctrl_sig_mem[`OP_SEL_RS2_INDEX], ctrl_sig_mem[`OP_SEL_RS1_INDEX], ctrl_sig_mem[`W_REG_SRC_INDEX], !`W_REG_EN};
		`else
			if (flush_mem == `FLUSH_PIPELINE)
				ctrl_sig_wb     <= {ctrl_sig_mem[`IS_JALR_INDEX], ctrl_sig_mem[`IS_LOAD_OR_STORE_INSTR_INDEX], ctrl_sig_mem[`OP_SEL_RS2_INDEX], ctrl_sig_mem[`OP_SEL_RS1_INDEX], ctrl_sig_mem[`W_REG_SRC_INDEX], !`W_REG_EN};
		`endif
			else
				ctrl_sig_wb     <= ctrl_sig_mem      ;

			instr_addr_wb      <= instr_addr_mem     ;
			instr_wb           <= instr_mem          ;

			if (flush_mem == `FLUSH_PIPELINE)
				cancel_instr_wb <= `CANCEL_INSTR   ;
			else
				cancel_instr_wb <= cancel_instr_mem;

		`ifdef A_EXTENSION
			if (is_sc_mem)
				wreg_data_wb       <= (is_fail_sc_mem)? `SC_FAIL_VAL : `SC_SUCC_VAL;
			else if ((amo_val_lockup == `BOOL_FALSE) && (is_amo_instr_mem == `IS_AMO_INSTR))
				wreg_data_wb       <= wreg_data_wb       ;
			else
		`endif
			wreg_data_wb       <= wreg_data_mem      ;

			wcsr_en_wb         <= wcsr_en_mem        ;
			rs1_wb             <= rs1_mem            ;
			rs2_wb             <= rs2_mem            ;
			rd_wb              <= rd_mem             ;
			is_ecall_instr_wb  <= is_ecall_instr_mem ;
			is_mret_instr_wb   <= is_mret_instr_mem  ;

			if ((cancel_instr_mem == `CANCEL_INSTR) || (flush_mem == `FLUSH_PIPELINE)) begin
				mtime_interrupt_wb    <= !`TIME_INTERRUPT      ;
				external_interrupt_wb <= !`EXTERNAL_INTERRUPT  ;
			end
			else begin
				mtime_interrupt_wb    <= mtime_interrupt_mem   ;
				external_interrupt_wb <= external_interrupt_mem;
			end

			if ((cancel_instr_mem == `CANCEL_INSTR) || (flush_mem == `FLUSH_PIPELINE))
				commit_wb     <= !`COMMIT_INSTR    ;
			else
				commit_wb     <= `COMMIT_INSTR     ;
			
			if ((flush_mem == `FLUSH_PIPELINE) || (cancel_instr_mem_aux == `CANCEL_INSTR))
				ctrl_sig_wb_aux <= {ctrl_sig_mem_aux[`IS_JALR_INDEX], ctrl_sig_mem_aux[`IS_LOAD_OR_STORE_INSTR_INDEX], ctrl_sig_mem_aux[`OP_SEL_RS2_INDEX], ctrl_sig_mem_aux[`OP_SEL_RS1_INDEX], ctrl_sig_mem_aux[`W_REG_SRC_INDEX], !`W_REG_EN};
			else
				ctrl_sig_wb_aux <= ctrl_sig_mem_aux  ;

		`ifdef VERILATOR_SIM
			instr_addr_wb_aux   <= instr_addr_mem_aux  ;
			instr_wb_aux        <= instr_mem_aux       ;
		`endif
			rd_wb_aux           <= rd_mem_aux          ;
			wreg_data_wb_aux    <= wreg_data_mem_aux   ;

			if (flush_mem == `FLUSH_PIPELINE)
				cancel_instr_wb_aux <= `CANCEL_INSTR   ;
			else
				cancel_instr_wb_aux <= cancel_instr_mem_aux;

			if ((cancel_instr_mem_aux == `CANCEL_INSTR) || (flush_mem == `FLUSH_PIPELINE))
				commit_aux_wb     <= !`COMMIT_INSTR    ;
			else
				commit_aux_wb     <= `COMMIT_INSTR     ;
			
		`ifdef A_EXTENSION
			is_amo_instr_wb     <= is_amo_instr_mem    ;
		`endif
			is_fencei_wb        <= is_fencei_mem       ;
		end
	end
endmodule
