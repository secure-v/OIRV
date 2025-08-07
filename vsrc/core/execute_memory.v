`include "params.v"

module execute_memory (
	input                                   clk                       ,
	input                                   rstn                      ,
	input                                   hold                      ,
	input                                   is_cache_mem_ex           ,
	input                                   is_device_write_ex        ,
	input [`CTRL_SIG_BUS]                   ctrl_sig_ex               ,
	input [`XLEN_BUS]                       alu_res_ex                ,
	input [`INST_BUS]                       instr_ex                  ,
	input [`INSTR_ADDR_BUS]                 instr_addr_ex             ,
	input [`XLEN_BUS]                       rs2_data_ex               ,
	// input [`XLEN_BUS]                       wdata_ex                  ,
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
	input                                   is_fail_sc_ex             ,
`endif
`ifdef C_EXTENSION
	input                                   is_cinstr_ex              ,
`endif
	// input [`WLEN_BUS]                       wlen_ex                   ,
	// input [`RLEN_BUS]                       rlen_ex                   ,
	input                                   flush_ex                  ,
	input [`CTRL_SIG_BUS]                   ctrl_sig_ex_aux           ,
	input [`INSTR_ADDR_BUS]                 instr_addr_ex_aux         ,
	input [`INST_BUS]                       instr_ex_aux              ,
	input [`REG_INDEX_BUS]                  rd_ex_aux                 ,
	input [`XLEN_BUS]                       wreg_data_ex_aux          , 
	input                                   mtime_interrupt_ex        ,
	input                                   external_interrupt_ex     ,
	output reg [`CTRL_SIG_BUS]              ctrl_sig_mem              ,
	output reg [`XLEN_BUS]                  alu_res_mem               ,
	output reg [`INST_BUS]                  instr_mem                 ,
	output reg [`INSTR_ADDR_BUS]            instr_addr_mem            ,
	output reg [`XLEN_BUS]                  rs2_data_mem              ,
	// output reg [`XLEN_BUS]                  wdata_mem                 ,
	output reg                              cancel_instr_mem          ,
	output reg                              cancel_instr_mem_aux      ,
	output reg                              wcsr_en_mem               ,
	output reg [`REG_INDEX_BUS]             rs1_mem                   ,
	output reg [`REG_INDEX_BUS]             rs2_mem                   ,
	output reg [`REG_INDEX_BUS]             rd_mem                    ,
	output reg                              is_ecall_instr_mem        ,
	output reg                              is_mret_instr_mem         ,
`ifndef PROC_BRANCH_IN_DC
	output reg                              branch_taken_mem          ,
	output reg [`INSTR_ADDR_BUS]            branch_jalr_target_pc_mem ,
`endif
`ifdef A_EXTENSION
	output reg                              is_amo_instr_mem          ,
	output reg                              is_lr_mem                 ,
	output reg                              is_sc_mem                 ,
	output reg                              is_fail_sc_mem            ,
`endif
	output reg                              is_cache_mem_mem          ,
	output reg                              is_device_write_mem       ,
`ifdef C_EXTENSION
	output reg                              is_cinstr_mem             ,
`endif
	output reg [`CTRL_SIG_BUS]              ctrl_sig_mem_aux          ,
	output reg [`INSTR_ADDR_BUS]            instr_addr_mem_aux        ,
	output reg [`INST_BUS]                  instr_mem_aux             ,
	output reg [`REG_INDEX_BUS]             rd_mem_aux                ,
	output reg [`XLEN_BUS]                  wreg_data_mem_aux         ,
	output reg                              mtime_interrupt_mem       ,
	output reg                              external_interrupt_mem    
	// output reg                              wdata_en                  ,
	// output reg                              rdata_en                  ,
	// output reg [`DATA_ADDR_BUS]             data_addr                 , 
	// output reg [`RLEN_BUS]                  rlen_mem                  ,
	// output reg [`WLEN_BUS]                  wlen_mem      
);

	wire need_cancel;
	assign need_cancel = ((mtime_interrupt_ex == `TIME_INTERRUPT) || (external_interrupt_ex == `EXTERNAL_INTERRUPT) || (wcsr_en_mem == `W_CSR_EN) || (is_ecall_instr_mem == `IS_ECALL_INSTR) || (is_mret_instr_mem == `IS_MRET_INSTR)) && (cancel_instr_mem != `CANCEL_INSTR);

	always@(posedge clk) begin
		if(rstn == `RESET_EN) begin
			ctrl_sig_mem                <= {!`IS_JALR, !`IS_LOAD_OR_STORE_INSTR, !`OP_SEL_RS2, !`OP_SEL_RS1, !`IS_FROM_ALU, !`W_REG_EN}; 
			alu_res_mem                 <= `ZERO;
			instr_mem                   <= `ZERO;
			instr_addr_mem              <= `ZERO;
			rs2_data_mem                <= `ZERO;
			cancel_instr_mem            <= `CANCEL_INSTR;
			wcsr_en_mem                 <= !`W_CSR_EN;
			rs1_mem                     <= `ZERO   ;
			rs2_mem                     <= `ZERO   ;
			rd_mem                      <= `ZERO   ;
			is_ecall_instr_mem          <= !`IS_ECALL_INSTR;
			is_mret_instr_mem           <= !`IS_MRET_INSTR ;
			`ifndef PROC_BRANCH_IN_DC
			branch_taken_mem            <= !`TAKEN         ;
			branch_jalr_target_pc_mem   <= `ZERO           ;
			`endif
			`ifdef A_EXTENSION
			is_amo_instr_mem            <= !`IS_AMO_INSTR;
			is_lr_mem                   <= `BOOL_FALSE;
			is_sc_mem                   <= `BOOL_FALSE;
			is_fail_sc_mem              <= `BOOL_FALSE;
			`endif
			`ifdef C_EXTENSION
			is_cinstr_mem               <= !`IS_CINSTR;
			`endif
			// wlen_mem                    <= `WLEN_BYTE;
			// rlen_mem                    <= `RLEN_BYTE;

			// wdata_en                    <= !`WDATA_EN;
			// rdata_en                    <= !`RDATA_EN;
			// data_addr                   <= `PC_RESET_ADDR;
			// wdata_mem                   <= `ZERO;
			ctrl_sig_mem_aux     <= {!`IS_JALR, !`IS_LOAD_OR_STORE_INSTR, !`OP_SEL_RS2, !`OP_SEL_RS1, !`IS_FROM_ALU, !`W_REG_EN}; 
		`ifdef VERILATOR_SIM
			instr_addr_mem_aux   <= `ZERO               ;
			instr_mem_aux        <= `ZERO               ;
		`endif
			rd_mem_aux           <= `ZERO               ;
			wreg_data_mem_aux    <= `ZERO               ;
			cancel_instr_mem_aux <= `CANCEL_INSTR;
			mtime_interrupt_mem    <= !`TIME_INTERRUPT    ;   
			external_interrupt_mem <= !`EXTERNAL_INTERRUPT; 
			is_cache_mem_mem       <= !`IS_CACHE_MEM;   
			is_device_write_mem    <= `ZERO;
		end
		else if (hold == `HOLD) begin
			ctrl_sig_mem                <= ctrl_sig_mem             ;
			alu_res_mem                 <= alu_res_mem              ;
			instr_mem                   <= instr_mem                ;
			instr_addr_mem              <= instr_addr_mem           ;
			rs2_data_mem                <= rs2_data_mem             ;
			cancel_instr_mem            <= cancel_instr_mem         ;
			wcsr_en_mem                 <= wcsr_en_mem              ;
			rs1_mem                     <= rs1_mem                  ;
			rs2_mem                     <= rs2_mem                  ;
			rd_mem                      <= rd_mem                   ;
			is_ecall_instr_mem          <= is_ecall_instr_mem       ;
			is_mret_instr_mem           <= is_mret_instr_mem        ;
			`ifndef PROC_BRANCH_IN_DC
			branch_taken_mem            <= branch_taken_mem         ;
			branch_jalr_target_pc_mem   <= branch_jalr_target_pc_mem;
			`endif
			`ifdef A_EXTENSION
			is_amo_instr_mem            <= is_amo_instr_mem         ;
			is_lr_mem                   <= is_lr_mem                ;
			is_sc_mem                   <= is_sc_mem                ;
			is_fail_sc_mem              <= is_fail_sc_mem           ;
			`endif
			`ifdef C_EXTENSION
			is_cinstr_mem               <= is_cinstr_mem            ;
			`endif
			// wlen_mem                    <= wlen_mem                 ;
			// rlen_mem                    <= rlen_mem                 ;
			
			// wdata_en                    <= wdata_en                 ;
			// rdata_en                    <= rdata_en                 ;
			// data_addr                   <= data_addr                ;
			// wdata_mem                   <= wdata_mem                ;
			ctrl_sig_mem_aux            <= ctrl_sig_mem_aux         ;
		`ifdef VERILATOR_SIM
			instr_addr_mem_aux          <= instr_addr_mem_aux       ;
			instr_mem_aux               <= instr_mem_aux            ;
		`endif
			rd_mem_aux                  <= rd_mem_aux               ;
			wreg_data_mem_aux           <= wreg_data_mem_aux        ;
			cancel_instr_mem_aux        <= cancel_instr_mem_aux     ;
			mtime_interrupt_mem         <= mtime_interrupt_mem      ;
			external_interrupt_mem      <= external_interrupt_mem   ;
			is_cache_mem_mem            <= is_cache_mem_mem         ;
			is_device_write_mem         <= is_device_write_mem      ;
		end
		else begin
			if ((flush_ex == `FLUSH_PIPELINE) || (cancel_instr_ex == `CANCEL_INSTR) || need_cancel)
				ctrl_sig_mem            <= {ctrl_sig_ex[`IS_JALR_INDEX], !`IS_LOAD_OR_STORE_INSTR, ctrl_sig_ex[`OP_SEL_RS2_INDEX], ctrl_sig_ex[`OP_SEL_RS1_INDEX], ctrl_sig_ex[`W_REG_SRC_INDEX], !`W_REG_EN};
			else
				ctrl_sig_mem            <= ctrl_sig_ex              ;

			alu_res_mem                 <= alu_res_ex               ;
			instr_mem                   <= instr_ex                 ;
			instr_addr_mem              <= instr_addr_ex            ;
			rs2_data_mem                <= rs2_data_ex              ;

			if ((flush_ex == `FLUSH_PIPELINE) || (cancel_instr_ex == `CANCEL_INSTR))
				cancel_instr_mem          <= `CANCEL_INSTR          ;
			else
				cancel_instr_mem          <= cancel_instr_ex        ;

			wcsr_en_mem                 <= wcsr_en_ex               ;
			rs1_mem                     <= rs1_ex                   ;
			rs2_mem                     <= rs2_ex                   ;
			rd_mem                      <= rd_ex                    ;
			is_ecall_instr_mem          <= is_ecall_instr_ex        ;
			is_mret_instr_mem           <= is_mret_instr_ex         ;
			`ifndef PROC_BRANCH_IN_DC
			if ((flush_ex == `FLUSH_PIPELINE) || (cancel_instr_ex == `CANCEL_INSTR))
				branch_taken_mem        <= `BOOL_FALSE              ;
			else
				branch_taken_mem        <= branch_taken_ex          ;
			
			`ifdef A_EXTENSION
			is_amo_instr_mem            <= is_amo_instr_ex          ;
			is_lr_mem                   <= is_lr_ex                 ;
			is_sc_mem                   <= is_sc_ex                 ;
			is_fail_sc_mem              <= is_fail_sc_ex            ;
			`endif
			branch_jalr_target_pc_mem   <= branch_jalr_target_pc_ex ;
			`endif
			`ifdef C_EXTENSION
			is_cinstr_mem               <= is_cinstr_ex             ;
			`endif
			// wlen_mem                    <= wlen_ex                  ;    
			// rlen_mem                    <= rlen_ex                  ;    
			// wdata_mem                   <= wdata_ex                 ;

			// if ((flush_ex == `FLUSH_PIPELINE) || (cancel_instr_ex == `CANCEL_INSTR) || need_cancel) begin
			// 	wdata_en                    <= !`WDATA_EN                ;
			// 	rdata_en                    <= !`RDATA_EN                ;
			// 	data_addr                   <= `PC_RESET_ADDR            ;
			// end
			// else if ((ctrl_sig_ex[`IS_LOAD_OR_STORE_INSTR_INDEX] == `IS_LOAD_OR_STORE_INSTR) && (ctrl_sig_ex[`W_REG_INDEX] != `W_REG_EN)) begin
			// 	wdata_en                    <= `WDATA_EN                 ;
			// 	rdata_en                    <= !`RDATA_EN                ;
			// 	data_addr                   <= alu_res_ex[`DATA_ADDR_BUS];
			// end
			// else if ((ctrl_sig_ex[`IS_LOAD_OR_STORE_INSTR_INDEX] == `IS_LOAD_OR_STORE_INSTR) && (ctrl_sig_ex[`W_REG_INDEX] == `W_REG_EN)) begin
			// 	wdata_en                    <= !`WDATA_EN                ;
			// 	rdata_en                    <= `RDATA_EN                 ;
			// 	data_addr                   <= alu_res_ex[`DATA_ADDR_BUS];
			// end
			// else begin
			// 	wdata_en                    <= !`WDATA_EN                ;
			// 	rdata_en                    <= !`RDATA_EN                ;
			// 	data_addr                   <= `PC_RESET_ADDR            ;
			// end

			if ((flush_ex == `FLUSH_PIPELINE) || (cancel_instr_ex_aux == `CANCEL_INSTR))
				ctrl_sig_mem_aux <= {ctrl_sig_ex_aux[`IS_JALR_INDEX], ctrl_sig_ex_aux[`IS_LOAD_OR_STORE_INSTR_INDEX], ctrl_sig_ex_aux[`OP_SEL_RS2_INDEX], ctrl_sig_ex_aux[`OP_SEL_RS1_INDEX], ctrl_sig_ex_aux[`W_REG_SRC_INDEX], !`W_REG_EN};
			else
				ctrl_sig_mem_aux <= ctrl_sig_ex_aux  ;

		`ifdef VERILATOR_SIM
			instr_addr_mem_aux          <= instr_addr_ex_aux        ;
			instr_mem_aux               <= instr_ex_aux             ;
		`endif
			rd_mem_aux                  <= rd_ex_aux                ;
			wreg_data_mem_aux           <= wreg_data_ex_aux         ;

			// if ((flush_ex == `FLUSH_PIPELINE) || need_cancel || (((wcsr_en_ex == `W_CSR_EN) || (is_ecall_instr_ex == `IS_ECALL_INSTR) || (is_mret_instr_ex == `IS_MRET_INSTR)) && (cancel_instr_ex != `CANCEL_INSTR)))
			if ((branch_taken_ex == `TAKEN) || (flush_ex == `FLUSH_PIPELINE) || need_cancel || (((wcsr_en_ex == `W_CSR_EN) || (is_ecall_instr_ex == `IS_ECALL_INSTR) || (is_mret_instr_ex == `IS_MRET_INSTR)) && (cancel_instr_ex != `CANCEL_INSTR)))
				cancel_instr_mem_aux          <= `CANCEL_INSTR          ;
			else
				cancel_instr_mem_aux        <= cancel_instr_ex_aux      ;

			if ((cancel_instr_ex == `CANCEL_INSTR) || (flush_ex == `FLUSH_PIPELINE)) begin
				mtime_interrupt_mem    <= !`TIME_INTERRUPT      ;
				external_interrupt_mem <= !`EXTERNAL_INTERRUPT  ;
			end
			else begin
				mtime_interrupt_mem    <= mtime_interrupt_ex   ;
				external_interrupt_mem <= external_interrupt_ex;
			end

			is_cache_mem_mem            <= is_cache_mem_ex          ;
			is_device_write_mem         <= is_device_write_ex       ;
		end
	end
endmodule
