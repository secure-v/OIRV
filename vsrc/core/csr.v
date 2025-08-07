`include "params.v"

module csr (
	input                               clk                   ,
	input                               rstn                  ,
	input                               wcsr_en               ,
	input [`INSTR_ADDR_BUS]             instr_addr            ,
	input [`CSR_BUS]                    rcsr_id               ,
	input [`CSR_BUS]                    wcsr_id               ,
	input [`MXLEN_BUS]                  wcsr_data             ,
	input [`CSR_UIMM_BUS]               csr_uimm              ,
	input [`CSR_OP_TYPE_BUS]            csr_op_type           , // func3 field
	input                               is_ecall_instr        ,
	input                               is_mret_instr         ,
	input                               external_interrupt_mem,
	input                               mtime_interrupt_mem   ,
	input                               is_ecall_instr_mem    ,
	input                               is_mret_instr_mem     ,
	input                               is_ecall_instr_wb     ,
	input                               is_mret_instr_wb      ,
	input                               mtime_interrupt       ,
	input                               external_interrupt    ,
	input                               commit                ,
	input                               commit_aux            ,
	input                               hold_mem              ,
	output reg                          mstatus_mie           ,
	output reg                          int_under_handle      ,
	output                              interrupt_taken       ,
	output reg [`INSTR_ADDR_BUS]        exception_entry       ,
	output reg [`MXLEN_BUS]             csr_data                   
);

    reg [`MXLEN_BUS] mstatus;
    reg [`MXLEN_BUS] mtvec; // BASE[`XLEN-1:2] MODE[1:0]: MODE == 1: Vector Mode; MODE == 0: Direct Mode; MODE == 2\3: Reserved
    reg[`MXLEN_BUS] mepc;
    reg[`MXLEN_BUS] mcause;

	// reg [`MXLEN_BUS] mtimecmp;
	reg [`MXLEN_BUS] mcycle  ;
	reg [`MXLEN_BUS] minstret;
	// reg [`MXLEN_BUS] mtime   ;

    // reg [`MXLEN_BUS] misa;
	// reg [`MXLEN_BUS] mie;
	// 52'b0, meie, 1'b0, seie, 1'b0, mtie, 1'b0, stie, 1'b0, msie, 1'b0, ssie, 1'b0;
	// 52'b0, meip, 1'b0, seip, 1'b0, mtip, 1'b0, stip, 1'b0, msip, 1'b0, ssip, 1'b0;

	reg [`MXLEN_BUS] mscratch;
	// reg [`MXLEN_BUS] mip;
    // reg [`WORD_BUS] mvendorid;

	// mstatus：
	reg mstatus_sd        ;
`ifdef RV64
	reg mstatus_mbe       ;
	reg mstatus_sbe       ;
	reg [1:0] mstatus_sxl ;
	reg [1:0] mstatus_uxl ;
`endif
	reg mstatus_tsr       ;
	reg mstatus_tw        ;
	reg mstatus_tvm       ;
	reg mstatus_mxr       ;
	reg mstatus_sum       ;
	reg mstatus_mprv      ;
	reg [1:0] mstatus_xs  ;
	reg [1:0] mstatus_fs  ;
	reg [1:0] mstatus_mpp ;
	reg [1:0] mstatus_vs  ;
	reg mstatus_spp       ;
	reg mstatus_mpie      ;
	reg mstatus_ube       ;
	reg mstatus_spie      ;
	// reg mstatus_mie       ; // output
	reg mstatus_sie       ;

`ifdef RV64
	assign mstatus = {mstatus_sd, 25'b`ZERO, mstatus_mbe, mstatus_sbe, mstatus_sxl, mstatus_uxl, 9'b`ZERO, mstatus_tsr, mstatus_tw, mstatus_tvm, mstatus_mxr, mstatus_sum, mstatus_mprv, mstatus_xs, mstatus_fs, mstatus_mpp, mstatus_vs, mstatus_spp, mstatus_mpie, mstatus_ube, mstatus_spie, 1'b`ZERO, mstatus_mie, 1'b`ZERO, mstatus_sie, 1'b`ZERO};
`else
	assign mstatus = {mstatus_sd, 8'b`ZERO, mstatus_tsr, mstatus_tw, mstatus_tvm, mstatus_mxr, mstatus_sum, mstatus_mprv, mstatus_xs, mstatus_fs, mstatus_mpp, mstatus_vs, mstatus_spp, mstatus_mpie, mstatus_ube, mstatus_spie, 1'b`ZERO, mstatus_mie, 1'b`ZERO, mstatus_sie, 1'b`ZERO};
`endif
	assign interrupt_taken = ((int_under_handle != `INT_UNDER_HANDLE) && ((mtime_interrupt == `TIME_INTERRUPT) || (external_interrupt == `EXTERNAL_INTERRUPT)) && (mstatus_mie == !`INT_DISABLE))? `INTERRUPT_TAKEN : !`INTERRUPT_TAKEN;

	reg[`MXLEN_BUS] wcsr_val;
	reg[1:0] prv_level; // privilege level

	always@(posedge clk) begin
        if (rstn == `RESET_EN)
            int_under_handle <= !`INT_UNDER_HANDLE;
		else if (hold_mem == `HOLD)
			int_under_handle <= int_under_handle;
        else if (is_mret_instr == `IS_MRET_INSTR)
            int_under_handle <= !`INT_UNDER_HANDLE;
        else if (interrupt_taken == `INTERRUPT_TAKEN)
            int_under_handle <= `INT_UNDER_HANDLE;
        else
            int_under_handle <= int_under_handle;
    end


	always@(*) begin
		if (wcsr_en == `W_CSR_EN) begin
			case (csr_op_type)
				`CSR_WOP : wcsr_val = wcsr_data                                 ;
				`CSR_SOP : wcsr_val = csr_data | wcsr_data                      ;
				`CSR_COP : wcsr_val = csr_data & (~wcsr_data)                   ;
				`CSR_WIOP: wcsr_val = {`CSR_UIMM_ZEXT, csr_uimm}                ;
				`CSR_SIOP: wcsr_val = csr_data | {`CSR_UIMM_ZEXT, csr_uimm}     ;
				`CSR_CIOP: wcsr_val = csr_data & (~({`CSR_UIMM_ZEXT, csr_uimm}));
				default :  wcsr_val = `ZERO                                     ;
			endcase
		end
		else
			wcsr_val = `ZERO;
	end

    always@(posedge clk) begin
		if(rstn == `RESET_EN) begin
			// mcause <= `ZERO;
			mtvec    <= `ZERO;
			mepc     <= `ZERO;
			mcycle   <= `ZERO;
			minstret <= `ZERO;
		end
		else if ((external_interrupt == `EXTERNAL_INTERRUPT) && (mstatus_mie == !`INT_DISABLE) && (int_under_handle == !`INT_UNDER_HANDLE)) begin
		`ifdef RV64
			mepc <= {`ADDR_TO_XLEN_ZEXT, instr_addr};
		`else
			mepc <= instr_addr;
		`endif
			mcycle <= mcycle + 1;
		end
		else if ((mtime_interrupt == `TIME_INTERRUPT) && (mstatus_mie == !`INT_DISABLE) && (int_under_handle == !`INT_UNDER_HANDLE)) begin
		`ifdef RV64
			mepc <= {`ADDR_TO_XLEN_ZEXT, instr_addr};
		`else
			mepc <= instr_addr;
		`endif
			mcycle <= mcycle + 1;
		end
		else if (wcsr_en == `W_CSR_EN) begin
            case (wcsr_id)
				// `MSTATUS_ID: mstatus <= wcsr_val ;
				`MTVEC_ID   : begin mtvec    <= wcsr_val & (~(`XLEN'd1)); mcycle <= mcycle + 1; end
				`MEPC_ID    : begin mepc     <= wcsr_val                ; mcycle <= mcycle + 1; end
				`MCYCLE_ID  : begin mcycle   <= wcsr_val                                      ; end
				`MINSTRET_ID: minstret <= wcsr_val ;

				// `MCAUSE_ID : mcause  <= wcsr_val ;
				
				
				default: begin
							// mstatus <=   mstatus;
							 mtvec   <=   mtvec     ;
							 mepc    <=   mepc      ;
							 mcycle  <=   mcycle + 1;
							// mcause  <=   mcause ;		 
				end
			endcase
		end
		else if (is_ecall_instr == `IS_ECALL_INSTR) begin
		`ifdef RV64
			mepc <= {`ADDR_TO_XLEN_ZEXT, instr_addr}  ;
		`else
			mepc <= instr_addr;
		`endif
			mcycle <= mcycle + 1;
		end
		else if ((commit == `COMMIT_INSTR) || (commit_aux == `COMMIT_INSTR)) begin
			if ((commit == `COMMIT_INSTR) && (commit_aux == `COMMIT_INSTR))
				minstret <= minstret + 2;
			else
				minstret <= minstret + 1;
			
			mcycle   <= mcycle + 1  ;
		end
		else begin
			mtvec   <=   mtvec     ;
			mepc    <=   mepc      ;
			mcycle  <=   mcycle + 1;
			// mcause  <=   mcause ;
		end		
	end

	always@(posedge clk) begin
		if(rstn == `RESET_EN)
			mscratch <= `ZERO      ;
		else if ((wcsr_en == `W_CSR_EN) && (wcsr_id == `MSCRATCH_ID))
			mscratch <= wcsr_val   ;
		else
			mscratch <= mscratch   ;	
	end

	always@(*) begin
		begin
            case (rcsr_id)
				`MSTATUS_ID  : csr_data = mstatus ;
				`MTVEC_ID    : csr_data = mtvec   ;
				`MSCRATCH_ID : csr_data = mscratch;
				`MEPC_ID     : csr_data = mepc    ;
				`MCAUSE_ID   : csr_data = mcause  ;
				default      : csr_data = `ZERO   ;
			endcase
		end
	end


	// mstatus
	always@(posedge clk) begin
		if (rstn == `RESET_EN) begin
			mstatus_sd          <= `ZERO;
		`ifdef RV64
			mstatus_mbe         <= `ZERO;
			mstatus_sbe         <= `ZERO;
			mstatus_sxl         <= `ZERO;
			mstatus_uxl         <= `ZERO;
		`endif
			mstatus_tsr         <= `ZERO;
			mstatus_tw          <= `ZERO;
			mstatus_tvm         <= `ZERO;
			mstatus_mxr         <= `ZERO;
			mstatus_sum         <= `ZERO;
			mstatus_mprv        <= `ZERO;
			mstatus_xs          <= `ZERO;
			mstatus_fs          <= `ZERO;
			mstatus_mpp         <= `ZERO;
			mstatus_vs          <= `ZERO;
			mstatus_spp         <= `ZERO;
			mstatus_mpie        <= `ZERO;
			mstatus_ube         <= `ZERO;
			mstatus_spie        <= `ZERO;
			mstatus_mie         <= `INT_DISABLE;
			mstatus_sie         <= `ZERO;
		end
		else if (hold_mem == `HOLD) begin
			mstatus_sd          <= mstatus_sd       ;
		`ifdef RV64
			mstatus_mbe         <= mstatus_mbe      ;
			mstatus_sbe         <= mstatus_sbe      ;
			mstatus_sxl         <= mstatus_sxl      ;
			mstatus_uxl         <= mstatus_uxl      ;
		`endif
			mstatus_tsr         <= mstatus_tsr      ;
			mstatus_tw          <= mstatus_tw       ;
			mstatus_tvm         <= mstatus_tvm      ;
			mstatus_mxr         <= mstatus_mxr      ;
			mstatus_sum         <= mstatus_sum      ;
			mstatus_mprv        <= mstatus_mprv     ;
			mstatus_xs          <= mstatus_xs       ;
			mstatus_fs          <= mstatus_fs       ;
			mstatus_mpp         <= mstatus_mpp      ;
			mstatus_vs          <= mstatus_vs       ;
			mstatus_spp         <= mstatus_spp      ;
			mstatus_mpie        <= mstatus_mpie     ;
			mstatus_ube         <= mstatus_ube      ;
			mstatus_spie        <= mstatus_spie     ;
			mstatus_mie         <= mstatus_mie      ;
			mstatus_sie         <= mstatus_sie      ;
		end
		else if ((external_interrupt == `EXTERNAL_INTERRUPT) && (mstatus_mie == !`INT_DISABLE) && (int_under_handle == !`INT_UNDER_HANDLE)) begin
			mstatus_sd          <= mstatus_sd   ;
		`ifdef RV64
			mstatus_mbe         <= mstatus_mbe  ;
			mstatus_sbe         <= mstatus_sbe  ;
			mstatus_sxl         <= mstatus_sxl  ;
			mstatus_uxl         <= mstatus_uxl  ;
		`endif
			mstatus_tsr         <= mstatus_tsr  ;
			mstatus_tw          <= mstatus_tw   ;
			mstatus_tvm         <= mstatus_tvm  ;
			mstatus_mxr         <= mstatus_mxr  ;
			mstatus_sum         <= mstatus_sum  ;
			mstatus_mprv        <= mstatus_mprv ;
			mstatus_xs          <= mstatus_xs   ;
			mstatus_fs          <= mstatus_fs   ;
			mstatus_mpp         <= prv_level    ; // time interrupt: prv_level -> mpp
			mstatus_vs          <= mstatus_vs   ;
			mstatus_spp         <= mstatus_spp  ;
			mstatus_mpie        <= mstatus_mie  ; // time interrupt: mie -> mpie
			mstatus_ube         <= mstatus_ube  ;
			mstatus_spie        <= mstatus_spie ;
			mstatus_mie         <= `INT_DISABLE ; // time interrupt: off -> mie
			mstatus_sie         <= mstatus_sie  ;
		end
		else if ((mtime_interrupt == `TIME_INTERRUPT) && (mstatus_mie == !`INT_DISABLE) && (int_under_handle == !`INT_UNDER_HANDLE)) begin
			mstatus_sd          <= mstatus_sd   ;
		`ifdef RV64
			mstatus_mbe         <= mstatus_mbe  ;
			mstatus_sbe         <= mstatus_sbe  ;
			mstatus_sxl         <= mstatus_sxl  ;
			mstatus_uxl         <= mstatus_uxl  ;
		`endif
			mstatus_tsr         <= mstatus_tsr  ;
			mstatus_tw          <= mstatus_tw   ;
			mstatus_tvm         <= mstatus_tvm  ;
			mstatus_mxr         <= mstatus_mxr  ;
			mstatus_sum         <= mstatus_sum  ;
			mstatus_mprv        <= mstatus_mprv ;
			mstatus_xs          <= mstatus_xs   ;
			mstatus_fs          <= mstatus_fs   ;
			mstatus_mpp         <= prv_level    ; // time interrupt: prv_level -> mpp
			mstatus_vs          <= mstatus_vs   ;
			mstatus_spp         <= mstatus_spp  ;
			mstatus_mpie        <= mstatus_mie  ; // time interrupt: mie -> mpie
			mstatus_ube         <= mstatus_ube  ;
			mstatus_spie        <= mstatus_spie ;
			mstatus_mie         <= `INT_DISABLE ; // time interrupt: off -> mie
			mstatus_sie         <= mstatus_sie  ;
		end
		else if ((wcsr_en == `W_CSR_EN) && (wcsr_id == `MSTATUS_ID)) begin
            mstatus_sd          <=  wcsr_val[`MSTATUS_SD_FIELD]  ;
		`ifdef RV64
			mstatus_mbe         <=  wcsr_val[`MSTATUS_MBE_FIELD] ;
			mstatus_sbe         <=  wcsr_val[`MSTATUS_SBE_FIELD] ;
			mstatus_sxl         <=  wcsr_val[`MSTATUS_SXL_FIELD] ;
			mstatus_uxl         <=  wcsr_val[`MSTATUS_UXL_FIELD] ;
		`endif
			mstatus_tsr         <=  wcsr_val[`MSTATUS_TSR_FIELD] ;
			mstatus_tw          <=  wcsr_val[`MSTATUS_TW_FIELD]  ;
			mstatus_tvm         <=  wcsr_val[`MSTATUS_TVM_FIELD] ;
			mstatus_mxr         <=  wcsr_val[`MSTATUS_MXR_FIELD] ;
			mstatus_sum         <=  wcsr_val[`MSTATUS_SUM_FIELD] ;
			mstatus_mprv        <=  wcsr_val[`MSTATUS_MPRV_FIELD];
			mstatus_xs          <=  wcsr_val[`MSTATUS_XS_FIELD]  ;
			mstatus_fs          <=  wcsr_val[`MSTATUS_FS_FIELD]  ;
			mstatus_mpp         <=  wcsr_val[`MSTATUS_MPP_FIELD] ;
			mstatus_vs          <=  wcsr_val[`MSTATUS_VS_FIELD]  ;
			mstatus_spp         <=  wcsr_val[`MSTATUS_SPP_FIELD] ;
			mstatus_mpie        <=  wcsr_val[`MSTATUS_MPIE_FIELD];
			mstatus_ube         <=  wcsr_val[`MSTATUS_UBE_FIELD] ;
			mstatus_spie        <=  wcsr_val[`MSTATUS_SPIE_FIELD];
			mstatus_mie         <=  wcsr_val[`MSTATUS_MIE_FIELD] ;
			mstatus_sie         <=  wcsr_val[`MSTATUS_SIE_FIELD] ;
		end
		else if (is_ecall_instr == `IS_ECALL_INSTR) begin // machine level
			mstatus_sd          <= mstatus_sd   ;
		`ifdef RV64
			mstatus_mbe         <= mstatus_mbe  ;
			mstatus_sbe         <= mstatus_sbe  ;
			mstatus_sxl         <= mstatus_sxl  ;
			mstatus_uxl         <= mstatus_uxl  ;
		`endif
			mstatus_tsr         <= mstatus_tsr  ;
			mstatus_tw          <= mstatus_tw   ;
			mstatus_tvm         <= mstatus_tvm  ;
			mstatus_mxr         <= mstatus_mxr  ;
			mstatus_sum         <= mstatus_sum  ;
			mstatus_mprv        <= mstatus_mprv ;
			mstatus_xs          <= mstatus_xs   ;
			mstatus_fs          <= mstatus_fs   ;
			mstatus_mpp         <= prv_level    ; // ecall: prv_level -> mpp
			mstatus_vs          <= mstatus_vs   ;
			mstatus_spp         <= mstatus_spp  ;
			mstatus_mpie        <= mstatus_mie  ; // ecall: mie -> mpie
			mstatus_ube         <= mstatus_ube  ;
			mstatus_spie        <= mstatus_spie ;
			mstatus_mie         <= `INT_DISABLE ; // ecall: off -> mie
			mstatus_sie         <= mstatus_sie  ;
		end
		else if (is_mret_instr == `IS_MRET_INSTR) begin // machine level
			mstatus_sd          <= mstatus_sd   ;
		`ifdef RV64
			mstatus_mbe         <= mstatus_mbe  ;
			mstatus_sbe         <= mstatus_sbe  ;
			mstatus_sxl         <= mstatus_sxl  ;
			mstatus_uxl         <= mstatus_uxl  ;
		`endif
			mstatus_tsr         <= mstatus_tsr  ;
			mstatus_tw          <= mstatus_tw   ;
			mstatus_tvm         <= mstatus_tvm  ;
			mstatus_mxr         <= mstatus_mxr  ;
			mstatus_sum         <= mstatus_sum  ;
			mstatus_mprv        <= mstatus_mprv ;
			mstatus_xs          <= mstatus_xs   ;
			mstatus_fs          <= mstatus_fs   ;
			mstatus_mpp         <= mstatus_mpp  ;
			mstatus_vs          <= mstatus_vs   ;
			mstatus_spp         <= mstatus_spp  ;
			mstatus_mpie        <= !`INT_DISABLE; // mret: on -> mpie
			mstatus_ube         <= mstatus_ube  ;
			mstatus_spie        <= mstatus_spie ;
			mstatus_mie         <= mstatus_mpie ; // mret: mpie -> mie
			mstatus_sie         <= mstatus_sie  ;
		end
		else begin
			mstatus_sd          <= mstatus_sd       ;
		`ifdef RV64
			mstatus_mbe         <= mstatus_mbe      ;
			mstatus_sbe         <= mstatus_sbe      ;
			mstatus_sxl         <= mstatus_sxl      ;
			mstatus_uxl         <= mstatus_uxl      ;
		`endif
			mstatus_tsr         <= mstatus_tsr      ;
			mstatus_tw          <= mstatus_tw       ;
			mstatus_tvm         <= mstatus_tvm      ;
			mstatus_mxr         <= mstatus_mxr      ;
			mstatus_sum         <= mstatus_sum      ;
			mstatus_mprv        <= mstatus_mprv     ;
			mstatus_xs          <= mstatus_xs       ;
			mstatus_fs          <= mstatus_fs       ;
			mstatus_mpp         <= mstatus_mpp      ;
			mstatus_vs          <= mstatus_vs       ;
			mstatus_spp         <= mstatus_spp      ;
			mstatus_mpie        <= mstatus_mpie     ;
			mstatus_ube         <= mstatus_ube      ;
			mstatus_spie        <= mstatus_spie     ;
			mstatus_mie         <= mstatus_mie      ;
			mstatus_sie         <= mstatus_sie      ;
		end		
	end

	// mcause
	always@(posedge clk) begin
		if(rstn == `RESET_EN) begin
			mcause <= `ZERO;
		end
		else if ((external_interrupt == `EXTERNAL_INTERRUPT) && (mstatus_mie == !`INT_DISABLE) && (int_under_handle == !`INT_UNDER_HANDLE)) begin
			mcause  <=   (`XLEN'd1 << (`XLEN - 1)) + 11;
		end
		else if ((mtime_interrupt == `TIME_INTERRUPT) && (mstatus_mie == !`INT_DISABLE) && (int_under_handle == !`INT_UNDER_HANDLE)) begin
			mcause  <=   (`XLEN'd1 << (`XLEN - 1)) + 7;
		end
		else if ((wcsr_en == `W_CSR_EN) && (wcsr_id == `MCAUSE_ID)) begin
            mcause  <=   wcsr_val ;
		end
		else if (is_ecall_instr == `IS_ECALL_INSTR) begin // machine level ecall
			mcause  <=   `XLEN'd11;
		end
		else
			mcause  <=   mcause   ;	
	end

	reg [`XLEN_BUS] exception_entry_tmp;

	always @(*) begin
		if (external_interrupt_mem == `EXTERNAL_INTERRUPT) begin
			if ((mtvec & 1) == `XLEN'd1) // vector
				exception_entry_tmp = mtvec + `XLEN'd44;
			else                         // direct
				exception_entry_tmp = mtvec            ;
		end
		else if (mtime_interrupt_mem == `TIME_INTERRUPT) begin
			if ((mtvec & 1) == `XLEN'd1) // vector
				exception_entry_tmp = mtvec + `XLEN'd28;
			else                         // direct
				exception_entry_tmp = mtvec            ;
		end
		else if (is_ecall_instr_mem == `IS_ECALL_INSTR) begin
			if ((mtvec & 1) == `XLEN'd1) // vector
				exception_entry_tmp = mtvec + `XLEN'd44; // exception_entry_tmp = mtvec + {mcause[`XLEN - 3:0], 2'b00}; // mcause has not been modified, it will be changed in the same time!
			else                         // direct
				exception_entry_tmp = mtvec            ;
		end
		else if (is_mret_instr_mem == `IS_MRET_INSTR)
			exception_entry_tmp = mepc;
		else
			exception_entry_tmp = `ZERO;
	end

	always @(posedge clk) begin
		if (rstn == `RESET_EN)
			exception_entry <= `PC_RESET_ADDR;
		else if ((external_interrupt_mem == `EXTERNAL_INTERRUPT) || (mtime_interrupt_mem == `TIME_INTERRUPT) || (is_ecall_instr_mem == `IS_ECALL_INSTR) || (is_mret_instr_mem == `IS_MRET_INSTR))
			exception_entry <= exception_entry_tmp[`INSTR_ADDR_BUS];
		else
			exception_entry <= exception_entry;
	end

	always@(posedge clk) begin
		if(rstn == `RESET_EN) 
			prv_level <= `MACHINE_LEVEL;
		else if ((external_interrupt == `EXTERNAL_INTERRUPT) && (mstatus_mie == !`INT_DISABLE) && (int_under_handle == !`INT_UNDER_HANDLE))
            prv_level <= `MACHINE_LEVEL;
		else if ((mtime_interrupt == `TIME_INTERRUPT) && (mstatus_mie == !`INT_DISABLE) && (int_under_handle == !`INT_UNDER_HANDLE))
            prv_level <= `MACHINE_LEVEL;
		else if (is_ecall_instr == `IS_ECALL_INSTR)
            prv_level <= `MACHINE_LEVEL;
		else if (is_mret_instr == `IS_MRET_INSTR)
            prv_level <= mstatus_mpp   ;
		else // TODO: sret
			prv_level <= prv_level     ;
	end

endmodule
