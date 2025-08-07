`include "params.v"

module mem_ctrl (
	input                                   clk                       ,
	input                                   rstn                      ,
	input                                   hold                      ,
`ifdef A_EXTENSION
	input                                   amo_rdata_en              ,
	input [`DATA_ADDR_BUS]                  amo_addr                  ,
	input [`RLEN_BUS]                       amo_rlen                  ,
	input                                   is_amo_instr_ex           ,
	input                                   is_lr_ex                  ,
	input                                   is_sc_ex                  ,
	input                                   is_fail_sc                ,
	input [`XLEN_BUS]                       wreg_data_ex_aux          ,
`endif
	input                                   is_fencei_ex              ,
	input [`CTRL_SIG_BUS]                   ctrl_sig_ex               ,
	input [`XLEN_BUS]                       alu_res_ex                ,
	input                                   cancel_instr_ex           ,
	input                                   flush_ex                  ,
	input                                   mtime_interrupt_ex        ,
	input                                   external_interrupt_ex     ,
	input                                   cancel_instr_mem          ,
	input                                   wcsr_en_mem               ,
	input                                   is_ecall_instr_mem        ,
	input                                   is_mret_instr_mem         ,
    input [`RLEN_BUS]                       rlen_ex                   ,
	input [`WLEN_BUS]                       wlen_ex                   ,
    input [`XLEN_BUS]                       wdata_ex                  ,
	output reg                              is_fencei_mem             ,
    output reg [`RLEN_BUS]                  rlen                      ,
	output reg [`WLEN_BUS]                  wlen                      ,
    output reg [`XLEN_BUS]                  wdata                     ,
	output reg                              wdata_en                  ,
	output reg                              rdata_en                  ,
	output reg [`DATA_ADDR_BUS]             data_addr                 
);

	wire need_cancel_load_sotre;
	assign need_cancel_load_sotre = ((mtime_interrupt_ex == `TIME_INTERRUPT) || (external_interrupt_ex == `EXTERNAL_INTERRUPT) || (wcsr_en_mem == `W_CSR_EN) || (is_ecall_instr_mem == `IS_ECALL_INSTR) || (is_mret_instr_mem == `IS_MRET_INSTR)) && (cancel_instr_mem != `CANCEL_INSTR);
	
	always@(posedge clk) begin
		if(rstn == `RESET_EN) begin
			wdata_en                        <= !`WDATA_EN                ;
			rdata_en                        <= !`RDATA_EN                ;
			data_addr                       <= `PC_RESET_ADDR            ;
            wlen                            <= `WLEN_BYTE                ;
			rlen                            <= `RLEN_BYTE                ;
			wdata                           <= `ZERO                     ;
			is_fencei_mem                   <= `ZERO                     ;
		end
		else if (hold == `HOLD) begin
			wdata_en                        <= wdata_en                  ;
			rdata_en                        <= rdata_en                  ;
			data_addr                       <= data_addr                 ;
            wlen                            <= wlen                      ;
			rlen                            <= rlen                      ;
			wdata                           <= wdata                     ;
			is_fencei_mem                   <= is_fencei_mem             ;
		end
		else begin
			if (amo_rdata_en == `RDATA_EN) begin
				wdata_en                    <= !`WDATA_EN                ;
				rdata_en                    <= amo_rdata_en              ;
				data_addr                   <= amo_addr                  ;
				is_fencei_mem               <= `ZERO                     ;

				wlen                        <= `WLEN_WORD                ;
				rlen                        <= amo_rlen                  ;
				wdata                       <= `ZERO                     ;
			end
			else if ((flush_ex == `FLUSH_PIPELINE) || (cancel_instr_ex == `CANCEL_INSTR) || need_cancel_load_sotre || is_fencei_mem) begin
				wdata_en                    <= !`WDATA_EN                ;
				rdata_en                    <= !`RDATA_EN                ;
				data_addr                   <= `PC_RESET_ADDR            ;
				is_fencei_mem               <= `ZERO                     ;

				wlen                        <= wlen_ex                   ;
				rlen                        <= rlen_ex                   ;
				wdata                       <= wdata_ex                  ;
			end
			else if ((ctrl_sig_ex[`IS_LOAD_OR_STORE_INSTR_INDEX] == `IS_LOAD_OR_STORE_INSTR) && (ctrl_sig_ex[`W_REG_INDEX] != `W_REG_EN)) begin
				wdata_en                    <= (is_lr_ex || is_fail_sc)? !`WDATA_EN : `WDATA_EN;
				rdata_en                    <= !`RDATA_EN                ;

			`ifdef A_EXTENSION
		 	// not canceled amo instruction
				data_addr                   <= (is_amo_instr_ex == `IS_AMO_INSTR)? wreg_data_ex_aux[`DATA_ADDR_BUS] : alu_res_ex[`DATA_ADDR_BUS];
			`else
				data_addr                   <= alu_res_ex[`DATA_ADDR_BUS];
			`endif	
				is_fencei_mem               <= is_fencei_ex              ;

				wlen                        <= wlen_ex                   ;
				rlen                        <= rlen_ex                   ;
				wdata                       <= wdata_ex                  ;
			end
			else if ((ctrl_sig_ex[`IS_LOAD_OR_STORE_INSTR_INDEX] == `IS_LOAD_OR_STORE_INSTR) && (ctrl_sig_ex[`W_REG_INDEX] == `W_REG_EN)) begin
				wdata_en                    <= !`WDATA_EN                ;
				rdata_en                    <= `RDATA_EN                 ;
				data_addr                   <= alu_res_ex[`DATA_ADDR_BUS];
				is_fencei_mem               <= is_fencei_ex              ;

				wlen                        <= wlen_ex                   ;
				rlen                        <= rlen_ex                   ;
				wdata                       <= wdata_ex                  ;
			end
			else begin
				wdata_en                    <= !`WDATA_EN                ;
				rdata_en                    <= !`RDATA_EN                ;
				data_addr                   <= `PC_RESET_ADDR            ;
				is_fencei_mem               <= is_fencei_ex              ;

				wlen                        <= wlen_ex                   ;
				rlen                        <= rlen_ex                   ;
				wdata                       <= wdata_ex                  ;
			end
		end
	end
endmodule



			
			

		
			

