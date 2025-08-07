`include "params.v"

module oirv (
	input                               clk              ,
	input                               rstn             ,
	output wire [`INSTR_ADDR_BUS]       axi_araddr       ,
    output wire [1:0]                   axi_arburst      ,
    output wire [3:0]                   axi_arcache      ,
    output wire [1:0]                   axi_arid         ,
	output wire [7:0]                   axi_arlen        ,
    output wire                         axi_arlock       ,
    output wire [2:0]                   axi_arprot       ,
    output wire [3:0]                   axi_arqos        ,
    input wire                          axi_arready      ,
	output wire [2:0]                   axi_arsize       ,
	output wire [1:0]                   axi_aruser       ,
	output wire                         axi_arvalid      ,
	output wire [`INSTR_ADDR_BUS]       axi_awaddr       ,
	output wire [1:0]                   axi_awburst      ,
    output wire [3:0]                   axi_awcache      ,
    output wire [1:0]                   axi_awid         ,
	output wire                         axi_awlock       ,
    output wire [7:0]                   axi_awlen        ,
    output wire [2:0]                   axi_awprot       ,
    output wire [3:0]                   axi_awqos        ,
    input wire                          axi_awready      ,
	output wire [2:0]                   axi_awsize       ,
	output wire [1:0]                   axi_awuser       ,
	output wire                         axi_awvalid      ,
	input wire [1:0]                    axi_bid          ,
    output wire                         axi_bready       ,
	input wire [1:0]                    axi_bresp        ,
	input wire [1:0]                    axi_buser        ,
	input wire                          axi_bvalid       ,
	input wire [1:0]                    axi_rid          ,
	input wire [63:0]                   axi_rdata        ,
    input wire                          axi_rlast        ,
	input wire [1:0]                    axi_rresp        ,
	output wire                         axi_rready       ,
	input wire [1:0]                    axi_ruser        ,
	input wire                          axi_rvalid       ,
    output wire [63:0]                  axi_wdata        ,
    output wire [1:0]                   axi_wid          ,
    output wire                         axi_wlast        ,
    input wire                          axi_wready       ,
	output wire [7:0]                   axi_wstrb        ,
	output wire [1:0]                   axi_wuser        ,
	output wire                         axi_wvalid       ,
	input                               irq1             ,
	output                              plic_ready       
);

	wire [`DATA_ADDR_BUS]             data_addr_out   ;
    wire                              rdata_en_out    ;
    wire                              wdata_en_out    ;
    wire [`CACHE_LINE_BUS]            wdata_out       ;
    wire [`WLEN_BUS]                  wlen_out        ;
    wire                              wdata_ready_in  ;
    wire [`CACHE_LINE_BUS]            rdata_in        ;
    wire                              rdata_valid_in  ;

`ifdef CACHE
	wire [`INSTR_ADDR_BUS]   instr_addr   ; // the address to fetch instruction
	wire [`INST_BUS]         instr        ; // instruction
	wire                     instr_valid  ;
	wire [`DATA_ADDR_BUS]    data_addr    ; 
    wire                     rdata_en     ;
	wire                     wdata_en     ;
    wire [`XLEN_BUS]         wdata        ;
    wire [`WLEN_BUS]         wlen         ; // write length: byte/half/word/double
	wire                     wdata_ready  ;
    wire [`CACHE_LINE_BUS]   rdata        ; // from memory
    wire                     rdata_valid  ;

	wire [`DATA_ADDR_BUS]    data_addr_in0   ;
    wire                     rdata_en_in0    ;
    wire                     wdata_en_in0    ;
    wire [`CACHE_LINE_BUS]   wdata_in0       ;
    wire [`WLEN_BUS]         wlen_in0        ;
    wire                     wdata_ready_out0;
    wire [`CACHE_LINE_BUS]   rdata_out0      ;
    wire                     rdata_valid_out0;
	wire [`DATA_ADDR_BUS]    data_addr_in1   ;
    wire                     rdata_en_in1    ;
    wire                     wdata_en_in1    ;
    wire [`CACHE_LINE_BUS]   wdata_in1       ;
    wire [`WLEN_BUS]         wlen_in1        ;
    wire                     wdata_ready_out1;
    wire [`CACHE_LINE_BUS]   rdata_out1      ;
    wire                     rdata_valid_out1;
`endif

// wire [`INSTR_ADDR_BUS]       pc;
wire [`INSTR_ADDR_BUS]  next_pc/*verilator public*/;


wire [`OP_TYPE_BUS]      op_type;     
wire [`XLEN_BUS]         op0/*verilator public*/; // instr[`RS1_FIELD]         
wire [`XLEN_BUS]         op1/*verilator public*/; // instr[`RS2_FIELD]      
wire [`XLEN_BUS]     alu_res;       
wire [`DATA_ADDR_BUS] data_addr_ex2;
wire                  rdata_en_ex2 ;


// wire                      wen0; // ctrl_sig[`W_REG_INDEX]
// wire [`REG_INDEX_BUS]     reg_id0; // instr[`RS1_FIELD]
// wire [`REG_INDEX_BUS]     reg_id1; // instr[`RS2_FIELD]
wire [`XLEN_BUS]     wreg_data_mem;
wire [`XLEN_BUS]         wreg_data;
wire [`XLEN_BUS]      wreg_data_wb;
wire [`XLEN_BUS]         reg_data0;
wire [`XLEN_BUS]         reg_data1;


wire [`XLEN_BUS]      sext_imm;

wire [`CTRL_SIG_BUS] ctrl_sig/*verilator public*/;

wire [`INST_TYPE_BUS] instr_type;

wire [`XLEN_BUS] ext_rdata;

`ifdef RV64
wire is_word_op;
`endif


`ifdef M_EXTENSION
	wire [`MUL_TYPE_BUS]          mul_type    ;
	wire [`DIV_TYPE_BUS]          div_type    ;
`endif

`ifdef C_EXTENSION
	wire                      is_cinstr    ;
	wire                      is_cinstr_dc ;
	wire                      is_cinstr_ex ;
	wire                      is_cinstr_mem;
	wire     [`XLEN_BUS]      cimm         ;
	wire     [`XLEN_BUS]      cimm_ex      ;
`endif

`ifndef PROC_BRANCH_IN_DC
	wire                          is_branch_instr    ; // from decoder
	wire                          is_branch_instr_ex ;
	wire                          branch_taken_ex    ;
	wire                          branch_taken_mem   ;
	wire     [`INSTR_ADDR_BUS]    branch_jalr_target_pc    ;
	wire     [`INSTR_ADDR_BUS]    branch_jalr_target_pc_mem;
`endif

wire     [`REG_INDEX_BUS] rs1       ;
wire     [`REG_INDEX_BUS] rs2       ;
wire     [`REG_INDEX_BUS] rd        ;

wire     [`REG_INDEX_BUS] rs1_ex    ;
wire     [`REG_INDEX_BUS] rs2_ex    ;
wire     [`REG_INDEX_BUS] rd_ex     ;

wire     [`REG_INDEX_BUS] rs1_mem   ;
wire     [`REG_INDEX_BUS] rs2_mem   ;
wire     [`REG_INDEX_BUS] rd_mem    ;

wire     [`REG_INDEX_BUS] rs1_wb    ;
wire     [`REG_INDEX_BUS] rs2_wb    ;
wire     [`REG_INDEX_BUS] rd_wb     ;


wire [`INSTR_ADDR_BUS]            instr_addr_dc;
wire [`INST_BUS]                  instr_dc     ;
wire                              wdata_en_dc  ;
wire [`WLEN_BUS]                  wlen_dc      ; 
wire [`RLEN_BUS]                  rlen_dc      ; 
wire [`XLEN_BUS]                  reg_data0_dc  ;
wire [`XLEN_BUS]                  reg_data1_dc  ;

wire [`CTRL_SIG_BUS]              ctrl_sig_ex   /*verilator public*/;
wire [`OP_TYPE_BUS]               op_type_ex    ;
`ifdef RV64
wire                              is_word_op_ex ;
`endif

`ifdef M_EXTENSION
wire [`MUL_TYPE_BUS]              mul_type_ex   ;
wire [`MUL_TYPE_BUS]              div_type_ex   ;
wire                              div_fin       ;
`endif

wire [`INST_TYPE_BUS]             instr_type_ex ;
wire [`INST_BUS]                  instr_ex      ;
wire [`INSTR_ADDR_BUS]            instr_addr_ex ;
wire [`XLEN_BUS]                  sext_imm_ex   ;

wire [`XLEN_BUS]                  reg_data0_ex  ;
wire [`XLEN_BUS]                  reg_data1_ex  ;

wire [`CTRL_SIG_BUS]              ctrl_sig_mem  /*verilator public*/;
wire [`XLEN_BUS]                  alu_res_mem   ;
wire [`INST_BUS]                  instr_mem     ;
wire [`INSTR_ADDR_BUS]            instr_addr_mem;
wire [`CTRL_SIG_BUS]              ctrl_sig_wb   /*verilator public*/;
wire [`INSTR_ADDR_BUS]            instr_addr_wb /*verilator public*/;
wire [`INST_BUS]                  instr_wb/*verilator public_flat_rd*/;     

wire [`XLEN_BUS]                  op0_may_bypass/*verilator public*/;
wire [`XLEN_BUS]                  op1_may_bypass/*verilator public*/;

wire [`XLEN_BUS]                  wdata_no_bypass;

wire                              wdata_en_ex    ;
wire [`WLEN_BUS]                  wlen_ex        ; 
wire [`RLEN_BUS]                  rlen_ex        ;

wire [`XLEN_BUS]                  rs2_data_mem   ;

wire [`XLEN_BUS]                  rdata_wb       ;

wire [`XLEN_BUS]                  alu_res_wb     ;

wire                              is_load_mem    ;


wire [`XLEN_BUS]                  bypassed_reg_data0/*verilator public*/;
wire [`XLEN_BUS]                  bypassed_reg_data1/*verilator public*/;
wire [`XLEN_BUS]                  bypassed_reg_data0_ex;

wire                              cancel_instr_if;
wire                              cancel_instr/*verilator public*/;
wire                              cancel_instr_dc/*verilator public*/;
wire                              cancel_instr_ex/*verilator public*/;
wire                              cancel_instr_mem/*verilator public*/;
wire                              cancel_instr_wb/*verilator public*/;

wire                              is_branch_ex_hazard0;
wire                              is_branch_ex_hazard1;
wire                              is_branch_ex2_hazard0;
wire                              is_branch_ex2_hazard1;
wire                              is_branch_mem_hazard0;
wire                              is_branch_mem_hazard1;

wire                              ci_for_branch_after_load;
wire                              hold_pc/*verilator public*/;
wire                              hold_if;
wire                              hold_dc;
wire                              hold_ex;
wire                              hold_mem;

wire                              commit/*verilator public*/;

wire [`XLEN_BUS]                  csr_data_ex;


wire                               wcsr_en_dc ;
wire                               wcsr_en_ex ;
wire                               wcsr_en_mem;
wire                               wcsr_en_wb ;
wire [`XLEN_BUS]                   csr_data;    
wire [`MXLEN_BUS]                  wcsr_data;

wire                               wreg_en_wb_hold_release;
wire                               wcsr_en_wb_hold_release;


`ifdef ZICSR_EXTENSION
    wire                          is_csr_instr_in_wb;
`endif 

wire                              flush_if          ;
wire                              flush_dc          ;
wire                              flush_ex          ;
wire                              flush_mem         ;

wire                                 is_ecall_instr                ;
wire                                 is_ecall_instr_ex             ;
wire                                 is_ecall_instr_mem            ;
wire                                 is_ecall_instr_wb             ;
wire                                 is_ecall_instr_in_wb          ; // not canceled ecall in wb stage
wire                                 is_ecall_instr_wb_hold_release;

wire                                 is_mret_instr                 ;
wire                                 is_mret_instr_ex              ;
wire                                 is_mret_instr_mem             ;
wire                                 is_mret_instr_wb              ;
wire                                 is_mret_instr_in_wb           ; // not canceled mret in wb stage
wire                                 is_mret_instr_wb_hold_release ;

wire [`INSTR_ADDR_BUS]               exception_entry               ;


wire                                 mtime_interrupt               ; // attach to a uncancelled instruction!
wire                                 mtime_interrupt_ex2           ;
wire                                 mtime_interrupt_mem           ;
wire                                 mtime_interrupt_wb            ;
wire                                 int_under_handle              ;

wire                                 external_interrupt            ;
wire                                 external_interrupt_ex2        ;
wire                                 external_interrupt_mem        ;
wire                                 external_interrupt_wb         ;
wire                                 interrupt_taken               ;


wire                              hold_ex2                  ;
wire                              flush_ex2                 ;
wire [`CTRL_SIG_BUS]              ctrl_sig_ex2              ;
wire [`OP_TYPE_BUS]               op_type_ex2               ;
wire [`XLEN_BUS]                  alu_res_ex2               ;
`ifdef M_EXTENSION
	wire [`MUL_TYPE_BUS]              mul_type_ex2              ;
`endif
wire [`INST_BUS]                  instr_ex2                 ;
wire [`INSTR_ADDR_BUS]            instr_addr_ex2            ;
wire [`XLEN_BUS]                  rs2_data_ex2              ;
wire                              wdata_en_ex2              ;
wire                              cancel_instr_ex2          ;
wire                              wcsr_en_ex2               ;
wire [`REG_INDEX_BUS]             rs1_ex2                   ;
wire [`REG_INDEX_BUS]             rs2_ex2                   ;
wire [`REG_INDEX_BUS]             rd_ex2                    ;
wire                              is_ecall_instr_ex2        ;
wire                              is_mret_instr_ex2         ;
`ifndef PROC_BRANCH_IN_DC
	wire                              branch_taken_ex2          ;
	wire [`INSTR_ADDR_BUS]            branch_jalr_target_pc_ex2 ;
`endif
`ifdef C_EXTENSION
	wire                              is_cinstr_ex2             ;
`endif
wire [`WLEN_BUS]                  wlen_ex2                  ;
wire [`RLEN_BUS]                  rlen_ex2                  ;
wire [`RLEN_BUS]                  rlen                      ; // rlen_mem

wire [`XLEN * 2 - 1:0]     part_mul_res0         ;
wire [`XLEN * 2 - 1:0]     part_mul_res1         ;
wire [`XLEN * 2 - 1:0]     part_mul_res0_ex2     ;
wire [`XLEN * 2 - 1:0]     part_mul_res1_ex2     ;

wire [`REG_INDEX_BUS]              rs1_aux                    ;
wire [`REG_INDEX_BUS]              rs2_aux                    ;
wire [`XLEN_BUS]                   reg_data2                  ;
wire [`XLEN_BUS]                   reg_data3                  ;

wire [`INST_BUS]          instr_aux        ;
wire [`CTRL_SIG_BUS]      ctrl_sig_aux     ;
wire [`OP_TYPE_BUS]       op_type_aux      ;
wire [`INST_TYPE_BUS]     instr_type_aux   ;
`ifdef RV64
wire                      is_word_op_aux   ;
`endif
`ifdef C_EXTENSION
wire [`XLEN_BUS]          cimm_aux         ;
`endif
wire [`REG_INDEX_BUS]     rd_aux           ;
wire                      aux_can_issue    ;
wire [`OP_TYPE_BUS]       op_type_ex_aux   ;
wire [`XLEN_BUS]          op0_aux          ;
wire [`XLEN_BUS]          op1_aux          ;
`ifdef RV64
wire                      is_word_op_ex_aux;
`endif
wire [`XLEN_BUS]          alu_res_aux      ;     

wire [`CACHE_LINE_BUS]      ifu_data     ;
wire [`CACHE_LINE_BUS]      ifu_data_if  ;
wire [`CACHE_LINE_BUS]      ifu_data_dc  ;
wire                        sel_instr_aux;
wire                        is_cinstr_aux;

wire [`INSTR_ADDR_BUS]    instr_addr_dc_aux   ;
wire [`INST_BUS]          instr_ex_aux        ;
wire [`INST_TYPE_BUS]     instr_type_ex_aux   ; ///////////////////////
wire [`REG_INDEX_BUS]     rs1_ex_aux          ;
wire [`REG_INDEX_BUS]     rs2_ex_aux          ;

`ifdef C_EXTENSION
wire [`XLEN_BUS]          cimm_ex_aux         ;
`endif

wire [`CTRL_SIG_BUS]      ctrl_sig_ex_aux  ;
wire [`INSTR_ADDR_BUS]    instr_addr_ex_aux;
wire [`REG_INDEX_BUS]     rd_ex_aux        ;  

wire                      flush_ex2_aux     ;
wire [`CTRL_SIG_BUS]      ctrl_sig_ex2_aux  ;
wire [`INSTR_ADDR_BUS]    instr_addr_ex2_aux;
wire [`INST_BUS]          instr_ex2_aux     ;
wire [`REG_INDEX_BUS]     rd_ex2_aux        ;
wire [`XLEN_BUS]          wreg_data_ex2_aux ; 

wire                      flush_mem_aux     ;
wire [`CTRL_SIG_BUS]      ctrl_sig_mem_aux  ;
wire [`INSTR_ADDR_BUS]    instr_addr_mem_aux;
wire [`INST_BUS]          instr_mem_aux     ;
wire [`REG_INDEX_BUS]     rd_mem_aux        ;
wire [`XLEN_BUS]          wreg_data_mem_aux ;  
wire [`CTRL_SIG_BUS]      ctrl_sig_wb_aux   ;
wire [`INSTR_ADDR_BUS]    instr_addr_wb_aux ;
wire [`INST_BUS]          instr_wb_aux      ;
wire [`REG_INDEX_BUS]     rd_wb_aux         ;
wire [`XLEN_BUS]          wreg_data_wb_aux  ;

wire [`XLEN_BUS]          op0_dc_aux        ;
wire [`XLEN_BUS]          op1_dc_aux        ;
wire [`XLEN_BUS]          op0_ex_aux        ;
wire [`XLEN_BUS]          op1_ex_aux        ;

wire [`XLEN_BUS]          sext_imm_aux      ;
wire                      is_cinstr_dc_aux  ;

wire                      wreg_en_wb_aux_hold_release;

wire                      cancel_instr_if_aux ;
wire                      cancel_instr_dc_aux ;
wire                      cancel_instr_ex_aux ;
wire                      cancel_instr_ex2_aux;
wire                      cancel_instr_mem_aux;
wire                      cancel_instr_wb_aux ;

wire                      commit_aux/*verilator public*/;
wire [`INSTR_ADDR_BUS]    instr_addr_if;

wire [`XLEN_BUS]          op0_ex_aux_may_bypass;
wire [`XLEN_BUS]          op1_ex_aux_may_bypass;

wire                      is_cinstr_ifu_data   ;

wire [`XLEN_BUS]          instr_buffer_data    ;
wire [`DATA_ADDR_BUS]     instr_addr_ifu       ; // to ifu
wire                      ifu_rdata_valid      ;

wire [`INSTR_ADDR_BUS]    bpu_target           ;
wire                      bpu_taken            ;

wire                      is_store_instr       ;

wire [`XLEN_BUS]          wdata_ex             ;
wire [`XLEN_BUS]          wdata_ex2            ;


wire is_cache_mem       ;
wire is_device_write    ;

wire is_cache_mem_mem   ;
wire is_device_write_mem;

wire is_fencei;
wire is_fencei_ex;
wire is_fencei_ex2;
wire is_fencei_mem;
wire is_fencei_wb;
wire fencei_stall;
wire fencei_flush;

wire load_in_ex_ex2_hazard;
wire can_not_issue;

wire mstatus_mie;

wire [`INSTR_ADDR_BUS] next_instr_addr;
wire ifu_miss;

`ifdef A_EXTENSION
	wire is_amo_instr_dc;
	wire is_amo_instr_ex;
	wire is_amo_instr_ex2;
	wire is_amo_instr_mem;
	wire is_amo_instr_wb;
	wire amo_cannot_issue;
	wire amo_rdata_en;
	wire [`DATA_ADDR_BUS] amo_addr;
	wire [`RLEN_BUS] amo_rlen;
	wire amo_val_lockup;
	wire sel_amo_op;
	wire is_lr; // dc
	wire is_lr_ex;
	wire is_lr_ex2;
	wire is_lr_mem;

	wire is_sc; // dc
	wire is_sc_ex;
	wire is_sc_ex2;
	wire is_sc_mem;

	wire is_fail_sc;
	wire is_fail_sc_mem;
`endif

// instrfetch_decode instrfetch_decode_inst0 (
// 	.clk                (clk                ),
// 	.rstn               (rstn               ),
// 	.bpu_taken          (bpu_taken          ),
// 	.hold               (hold_if            ),
// 	.instr_addr_if      (instr_addr_if      ),
// 	.ifu_data_if        (ifu_data_if        ),
// 	`ifdef C_EXTENSION
// 	.is_cinstr_if       (is_cinstr          ),
// 	.is_cinstr_if_aux   (is_cinstr_aux      ),
// 	`endif
// 	.cancel_instr       (cancel_instr       ),
// 	.cancel_instr_if    (cancel_instr_if    ),
// 	.cancel_instr_if_aux(cancel_instr_if_aux),
// 	.flush_if           (flush_if           ),
//     .instr_addr_dc      (instr_addr_dc      ),
// 	.ifu_data_dc        (ifu_data_dc        ),
// 	`ifdef C_EXTENSION
// 	.is_cinstr_dc       (is_cinstr_dc       ),
// 	.is_cinstr_dc_aux   (is_cinstr_dc_aux   ),
// 	`endif
// 	.cancel_instr_dc_aux(cancel_instr_dc_aux),
// 	.cancel_instr_dc    (cancel_instr_dc    )
// );

instr_fetch_buffer instr_fetch_buffer_inst0 (
	.clk                  (clk                         ),
	.rstn                 (rstn                        ),
	.hold                 (hold_if                     ), // hold_if
	.interrupt_taken      (interrupt_taken             ),
	.is_ecall_instr_wb    (is_ecall_instr_in_wb        ),
	.is_mret_instr_wb     (is_mret_instr_in_wb         ),
	.is_csr_instr_in_wb   (is_csr_instr_in_wb          ),
	.is_fencei_wb         (is_fencei_wb                ),
	.branch_taken_ex2     (branch_taken_ex2            ),
	.exception_entry      (exception_entry             ),
	.instr_addr_wb        (instr_addr_wb               ),
	.branch_jalr_target_pc(branch_jalr_target_pc_ex2   ),
	.can_not_issue        (can_not_issue               ),
	.instr_type           (instr_type                  ), // from ctrl
    .sext_imm_dc          (sext_imm                    ),
    .cimm_dc              (cimm                        ),
	.aux_can_issue        (aux_can_issue               ),
	.ifu_miss             (ifu_miss                    ),
	.instr_valid          (instr_valid                 ),
    .instr_addr_ifu       (instr_addr_ifu              ), // to ifu
	.ifu_data             (ifu_data                    ),
	.ifu_rdata_valid      (ifu_rdata_valid             ),
	.next_instr_addr      (next_instr_addr             ),
	.instr_addr_dc        (instr_addr_dc               ),
    .instr_addr_dc_aux    (instr_addr_dc_aux           ),
	.instr_dc             (instr_dc                    ), // to ctrl
    .instr_aux            (instr_aux                   ), // to ctrl_aux
    .is_cinstr            (is_cinstr_dc                ),
    .is_cinstr_aux        (is_cinstr_dc_aux            ),
	.cancel_instr_dc      (cancel_instr_dc             ),
	.cancel_instr_dc_aux  (cancel_instr_dc_aux         )
);

decode_execute decode_execute_inst0 (
	.clk                     (clk                     ),
	.rstn                    (rstn                    ),
	.is_fencei_dc            (is_fencei               ),
	.hold                    (hold_dc                 ),
	.ctrl_sig_dc             (ctrl_sig                ),
	.op_type_dc              (op_type                 ),
	`ifdef RV64
	.is_word_op_dc           (is_word_op              ),
	`endif
	`ifdef M_EXTENSION
	.mul_type_dc             (mul_type                ),
	.div_type_dc             (div_type                ),
	`endif
	.instr_type_dc           (instr_type              ),
	.wdata_en_dc             (wdata_en_dc             ),
	.wlen_dc                 (wlen_dc                 ),
	.rlen_dc                 (rlen_dc                 ),
	.instr_dc                (instr_dc                ),
	.instr_addr_dc           (instr_addr_dc           ),
	.reg_data0_dc            (reg_data0_dc            ),
	.reg_data1_dc            (reg_data1_dc            ),
	.op0_dc_aux              (op0_dc_aux              ),
	.op1_dc_aux              (op1_dc_aux              ),
	.cancel_instr_dc         (cancel_instr_dc         ),
	.wcsr_en_dc              (wcsr_en_dc              ),
	.sext_imm_dc             (sext_imm                ),
	.rs1_dc                  (rs1                     ),
	.rs2_dc                  (rs2                     ),
	.rd_dc                   (rd                      ),
`ifndef PROC_BRANCH_IN_DC
	.is_branch_instr_dc      (is_branch_instr         ),
`endif
`ifdef A_EXTENSION
	.is_amo_instr_dc         (is_amo_instr_dc         ),
	.is_lr_dc                (is_lr                   ),
	.is_sc_dc                (is_sc                   ),
`endif
`ifdef C_EXTENSION
	.is_cinstr_dc            (is_cinstr_dc            ),
	.cimm_dc                 (cimm                    ),
`endif
	.csr_data_dc             (csr_data                ),
	.is_ecall_instr_dc       (is_ecall_instr          ),
	.is_mret_instr_dc        (is_mret_instr           ),
	.flush_dc                (flush_dc                ),
	.ci_for_branch_after_load(ci_for_branch_after_load),
	.instr_dc_aux            (instr_aux               ),
	.instr_addr_dc_aux       (instr_addr_dc_aux       ),
	.ctrl_sig_dc_aux         (ctrl_sig_aux            ),
	.op_type_dc_aux          (op_type_aux             ),
	.instr_type_dc_aux       (instr_type_aux          ),
	`ifdef RV64
	.is_word_op_dc_aux       (is_word_op_aux          ),
	`endif
	`ifdef C_EXTENSION
	.cimm_dc_aux             (cimm_aux                ),
	`endif
	.cancel_instr_dc_aux     (cancel_instr_dc_aux     ),
	.rs1_dc_aux              (rs1_aux                 ),
	.rs2_dc_aux              (rs2_aux                 ),
	.rd_dc_aux               (rd_aux                  ),
	.aux_can_issue_dc_aux    (aux_can_issue           ),
	.ctrl_sig_ex             (ctrl_sig_ex             ),
	.op_type_ex              (op_type_ex              ),
	`ifdef RV64
	.is_word_op_ex           (is_word_op_ex           ),
	`endif
	`ifdef M_EXTENSION
	.mul_type_ex             (mul_type_ex             ),
	.div_type_ex             (div_type_ex             ),
	`endif
	.instr_type_ex           (instr_type_ex           ),
	.wdata_en_ex             (wdata_en_ex             ),
	.wlen_ex                 (wlen_ex                 ),
	.rlen_ex                 (rlen_ex                 ),
	.instr_ex                (instr_ex                ),
	.instr_addr_ex           (instr_addr_ex           ),
	.reg_data0_ex            (reg_data0_ex            ),
	.reg_data1_ex            (reg_data1_ex            ),
	.op0_ex_aux              (op0_ex_aux              ),
	.op1_ex_aux              (op1_ex_aux              ),
	.cancel_instr_ex         (cancel_instr_ex         ),
	.wcsr_en_ex              (wcsr_en_ex              ),
	.sext_imm_ex             (sext_imm_ex             ),
	.rs1_ex                  (rs1_ex                  ),
	.rs2_ex                  (rs2_ex                  ),
	.rd_ex                   (rd_ex                   ),
`ifndef PROC_BRANCH_IN_DC
	.is_branch_instr_ex      (is_branch_instr_ex      ),
`endif
`ifdef A_EXTENSION
	.is_amo_instr_ex         (is_amo_instr_ex         ),
	.is_lr_ex                (is_lr_ex                ),
	.is_sc_ex                (is_sc_ex                ),
`endif
	.is_fencei_ex            (is_fencei_ex            ),
`ifdef C_EXTENSION
	.is_cinstr_ex            (is_cinstr_ex            ),
	.cimm_ex                 (cimm_ex                 ),
`endif
	.cancel_instr_ex_aux     (cancel_instr_ex_aux     ),
	.is_ecall_instr_ex       (is_ecall_instr_ex       ),
	.is_mret_instr_ex        (is_mret_instr_ex        ),
	.csr_data_ex             (csr_data_ex             ),
	.instr_ex_aux            (instr_ex_aux            ),
	.instr_addr_ex_aux       (instr_addr_ex_aux       ),
	.ctrl_sig_ex_aux         (ctrl_sig_ex_aux         ),
	.op_type_ex_aux          (op_type_ex_aux          ),
	.instr_type_ex_aux       (instr_type_ex_aux       ),
	`ifdef RV64
	.is_word_op_ex_aux       (is_word_op_ex_aux       ),
	`endif
	`ifdef C_EXTENSION
	.cimm_ex_aux             (cimm_ex_aux             ),
	`endif
	.rs1_ex_aux              (rs1_ex_aux              ),
	.rs2_ex_aux              (rs2_ex_aux              ),
	.rd_ex_aux               (rd_ex_aux               )
);

execute_execute2 execute_execute2_inst0 (
	.clk                       (clk                      ),
	.rstn                      (rstn                     ),
	.is_fencei_ex              (is_fencei_ex             ),
	.hold                      (hold_ex                  ),
	.flush_ex                  (flush_ex                 ),
	.ctrl_sig_ex               (ctrl_sig_ex              ),
	.op_type_ex                (op_type_ex               ),
	`ifdef M_EXTENSION
	.mul_type_ex               (mul_type_ex              ),
	`endif
	.instr_ex                  (instr_ex                 ),
	.instr_addr_ex             (instr_addr_ex            ),
	.rs2_data_ex               (reg_data1_ex             ),
	.wdata_en_ex               (wdata_en_ex              ),
	.cancel_instr_ex           (cancel_instr_ex          ),
	.cancel_instr_ex_aux       (cancel_instr_ex_aux      ),
	.wcsr_en_ex                (wcsr_en_ex               ),
	.rs1_ex                    (rs1_ex                   ),
	.rs2_ex                    (rs2_ex                   ),
	.rd_ex                     (rd_ex                    ),
	.is_ecall_instr_ex         (is_ecall_instr_ex        ),
	.is_mret_instr_ex          (is_mret_instr_ex         ),
`ifndef PROC_BRANCH_IN_DC
	.branch_taken_ex           (branch_taken_ex          ),
	.branch_jalr_target_pc_ex  (branch_jalr_target_pc    ),
`endif
`ifdef A_EXTENSION
	.is_amo_instr_ex           (is_amo_instr_ex          ),
	.is_lr_ex                  (is_lr_ex                 ),
	.is_sc_ex                  (is_sc_ex                 ),
	.reg_data0_ex              (reg_data0_ex             ),
	.reg_data1_ex              (reg_data1_ex             ),
`endif
`ifdef C_EXTENSION
	.is_cinstr_ex              (is_cinstr_ex             ),
`endif
	.wlen_ex                   (wlen_ex                  ),
	.rlen_ex                   (rlen_ex                  ),
	.wdata_ex                  (wdata_ex                 ),
	.ctrl_sig_ex_aux           (ctrl_sig_ex_aux          ),  
	.instr_addr_ex_aux         (instr_addr_ex_aux        ),  
	.instr_ex_aux              (instr_ex_aux             ),  
	.rd_ex_aux                 (rd_ex_aux                ),  
	.wreg_data_ex_aux          (alu_res_aux              ),  
	.ctrl_sig_ex2              (ctrl_sig_ex2             ),
	.op_type_ex2               (op_type_ex2              ),
	`ifdef M_EXTENSION
	.mul_type_ex2              (mul_type_ex2             ),
	`endif
	.is_fencei_ex2             (is_fencei_ex2            ),
	.instr_ex2                 (instr_ex2                ),
	.instr_addr_ex2            (instr_addr_ex2           ),
	.rs2_data_ex2              (rs2_data_ex2             ),
	.wdata_en_ex2              (wdata_en_ex2             ),
	.cancel_instr_ex2          (cancel_instr_ex2         ),
	.cancel_instr_ex2_aux      (cancel_instr_ex2_aux     ),
	.wcsr_en_ex2               (wcsr_en_ex2              ),
	.rs1_ex2                   (rs1_ex2                  ),
	.rs2_ex2                   (rs2_ex2                  ),
	.rd_ex2                    (rd_ex2                   ),
	.is_ecall_instr_ex2        (is_ecall_instr_ex2       ),
	.is_mret_instr_ex2         (is_mret_instr_ex2        ),
`ifndef PROC_BRANCH_IN_DC
	.branch_taken_ex2          (branch_taken_ex2         ),
	.branch_jalr_target_pc_ex2 (branch_jalr_target_pc_ex2),
`endif
`ifdef A_EXTENSION
	.is_amo_instr_ex2          (is_amo_instr_ex2         ),
	.is_lr_ex2                 (is_lr_ex2                ),
	.is_sc_ex2                 (is_sc_ex2                ),
`endif
`ifdef C_EXTENSION
	.is_cinstr_ex2             (is_cinstr_ex2            ),
`endif
	.ctrl_sig_ex2_aux          (ctrl_sig_ex2_aux         ),
	.instr_addr_ex2_aux        (instr_addr_ex2_aux       ),
	.instr_ex2_aux             (instr_ex2_aux            ),
	.rd_ex2_aux                (rd_ex2_aux               ),
	.wreg_data_ex2_aux         (wreg_data_ex2_aux        ),
	.wdata_ex2                 (wdata_ex2                ), 
	.rdata_en_ex2              (rdata_en_ex2             ),
	.rlen_ex2                  (rlen_ex2                 ),
	.wlen_ex2                  (wlen_ex2                 ) 
);

mem_ctrl mem_ctrl_inst0 (
	.clk                       (clk                       ),
	.rstn                      (rstn                      ),
	.hold                      (hold_ex2                  ),
`ifdef A_EXTENSION
	.amo_rdata_en              (amo_rdata_en              ),
	.amo_addr                  (amo_addr                  ),
	.amo_rlen                  (amo_rlen                  ),     
	.is_amo_instr_ex           (is_amo_instr_ex2          ),     
	.is_lr_ex                  (is_lr_ex2                 ),     
	.is_sc_ex                  (is_sc_ex2                 ),
	.is_fail_sc                (is_fail_sc                ),     
	.wreg_data_ex_aux          (wreg_data_ex2_aux         ), 
`endif
	.ctrl_sig_ex               (ctrl_sig_ex2              ),
	.alu_res_ex                (alu_res_ex2               ),
	.cancel_instr_ex           (cancel_instr_ex2          ),
	.is_fencei_ex              (is_fencei_ex2             ),
	.flush_ex                  (flush_ex2                 ),
	.mtime_interrupt_ex        (mtime_interrupt_ex2       ),
	.external_interrupt_ex     (external_interrupt_ex2    ),
	.rlen_ex                   (rlen_ex2                  ),
	.wlen_ex                   (wlen_ex2                  ),
    .wdata_ex                  (wdata_ex2                 ),
	.cancel_instr_mem          (cancel_instr_mem          ),
	.wcsr_en_mem               (wcsr_en_mem               ),
	.is_ecall_instr_mem        (is_ecall_instr_mem        ),
	.is_mret_instr_mem         (is_mret_instr_mem         ),
    .rlen                      (rlen                      ),
	.wlen                      (wlen                      ),
	.is_fencei_mem             (is_fencei_mem             ),
    .wdata                     (wdata                     ),
	.wdata_en                  (wdata_en                  ),
	.rdata_en                  (rdata_en                  ),
	.data_addr                 (data_addr                 )
);

execute_memory execute_memory_inst0 ( // the module name need modified to execute2_memory
	.clk                       (clk                      ),
	.rstn                      (rstn                     ),
	.is_cache_mem_ex           (is_cache_mem             ),
	.is_device_write_ex        (is_device_write          ),
	.hold                      (hold_ex2                 ),
	.ctrl_sig_ex               (ctrl_sig_ex2             ),
	.alu_res_ex                (alu_res_ex2              ),
	.instr_ex                  (instr_ex2                ),
	.instr_addr_ex             (instr_addr_ex2           ),
	.rs2_data_ex               (rs2_data_ex2             ),
	.cancel_instr_ex           (cancel_instr_ex2         ),
	.wcsr_en_ex                (wcsr_en_ex2              ),
	.rs1_ex                    (rs1_ex2                  ),
	.rs2_ex                    (rs2_ex2                  ),
	.rd_ex                     (rd_ex2                   ),
	.is_ecall_instr_ex         (is_ecall_instr_ex2       ),
	.is_mret_instr_ex          (is_mret_instr_ex2        ),
`ifndef PROC_BRANCH_IN_DC
	.branch_taken_ex           (branch_taken_ex2         ),
	.branch_jalr_target_pc_ex  (branch_jalr_target_pc_ex2),
`endif
`ifdef A_EXTENSION
	.is_amo_instr_ex           (is_amo_instr_ex2         ),
	.is_lr_ex                  (is_lr_ex2                ),
	.is_sc_ex                  (is_sc_ex2                ),
	.is_fail_sc_ex             (is_fail_sc               ),
`endif
`ifdef C_EXTENSION
	.is_cinstr_ex              (is_cinstr_ex2            ),
`endif
	.flush_ex                  (flush_ex2                ),
	.ctrl_sig_ex_aux           (ctrl_sig_ex2_aux         ),
	.instr_addr_ex_aux         (instr_addr_ex2_aux       ),
	.instr_ex_aux              (instr_ex2_aux            ),
	.rd_ex_aux                 (rd_ex2_aux               ),
	.cancel_instr_ex_aux       (cancel_instr_ex2_aux     ),
	.wreg_data_ex_aux          (wreg_data_ex2_aux        ), 
	.mtime_interrupt_ex        (mtime_interrupt_ex2      ),
	.external_interrupt_ex     (external_interrupt_ex2   ),
	.ctrl_sig_mem              (ctrl_sig_mem             ),
	.alu_res_mem               (alu_res_mem              ),
	.instr_mem                 (instr_mem                ),
	.instr_addr_mem            (instr_addr_mem           ),
	.rs2_data_mem              (rs2_data_mem             ),
	.cancel_instr_mem          (cancel_instr_mem         ),
	.wcsr_en_mem               (wcsr_en_mem              ),
	.rs1_mem                   (rs1_mem                  ),
	.rs2_mem                   (rs2_mem                  ),
	.rd_mem                    (rd_mem                   ),
	.is_ecall_instr_mem        (is_ecall_instr_mem       ),
	.is_mret_instr_mem         (is_mret_instr_mem        ),
`ifndef PROC_BRANCH_IN_DC
	.branch_taken_mem          (branch_taken_mem         ),
	.branch_jalr_target_pc_mem (branch_jalr_target_pc_mem),
`endif
`ifdef A_EXTENSION
	.is_amo_instr_mem          (is_amo_instr_mem         ),
	.is_lr_mem                 (is_lr_mem                ),
	.is_sc_mem                 (is_sc_mem                ),
	.is_fail_sc_mem            (is_fail_sc_mem           ),
`endif
	.is_cache_mem_mem          (is_cache_mem_mem         ),
	.is_device_write_mem       (is_device_write_mem      ),
`ifdef C_EXTENSION
	.is_cinstr_mem             (is_cinstr_mem            ),
`endif
	.ctrl_sig_mem_aux          (ctrl_sig_mem_aux         ),
	.instr_addr_mem_aux        (instr_addr_mem_aux       ),
	.cancel_instr_mem_aux      (cancel_instr_mem_aux     ),
	.instr_mem_aux             (instr_mem_aux            ),
	.rd_mem_aux                (rd_mem_aux               ),
	.wreg_data_mem_aux         (wreg_data_mem_aux        ),
	.mtime_interrupt_mem       (mtime_interrupt_mem      ),
	.external_interrupt_mem    (external_interrupt_mem   )
);

memory_writeback memory_writeback_inst0 (
	.clk                     (clk                     ),
	.rstn                    (rstn                    ),
`ifdef A_EXTENSION
	.is_amo_instr_mem        (is_amo_instr_mem        ),
	.amo_val_lockup          (amo_val_lockup          ),
	.is_sc_mem               (is_sc_mem               ),
	.is_fail_sc_mem          (is_fail_sc_mem          ),
`endif
	.is_fencei_mem           (is_fencei_mem           ),
	.hold                    (hold_mem                ),
	.interrupt_taken         (interrupt_taken         ),
	.ctrl_sig_mem            (ctrl_sig_mem            ),
	.instr_addr_mem          (instr_addr_mem          ),
	.instr_mem               (instr_mem               ),
	.cancel_instr_mem        (cancel_instr_mem        ),
	.wcsr_en_mem             (wcsr_en_mem             ),
	.rs1_mem                 (rs1_mem                 ),
	.rs2_mem                 (rs2_mem                 ),
	.rd_mem                  (rd_mem                  ),
	.is_ecall_instr_mem      (is_ecall_instr_mem      ),
	.is_mret_instr_mem       (is_mret_instr_mem       ),
	.wreg_data_mem           (wreg_data_mem           ),
	.mtime_interrupt_mem     (mtime_interrupt_mem     ),
	.external_interrupt_mem  (external_interrupt_mem  ),
	.flush_mem               (flush_mem               ),
	.flush_mem_aux           (flush_mem_aux           ),
	.ctrl_sig_mem_aux        (ctrl_sig_mem_aux        ),
	.instr_addr_mem_aux      (instr_addr_mem_aux      ),
	.instr_mem_aux           (instr_mem_aux           ),
	.rd_mem_aux              (rd_mem_aux              ),
	.cancel_instr_mem_aux    (cancel_instr_mem_aux    ),
	.wreg_data_mem_aux       (wreg_data_mem_aux       ),
	.ctrl_sig_wb             (ctrl_sig_wb             ),
	.instr_addr_wb           (instr_addr_wb           ),
	.instr_wb                (instr_wb                ),
	.cancel_instr_wb         (cancel_instr_wb         ),
	.wreg_data_wb            (wreg_data_wb            ),
	.wcsr_en_wb              (wcsr_en_wb              ),
	.rs1_wb                  (rs1_wb                  ),
	.rs2_wb                  (rs2_wb                  ),
	.rd_wb                   (rd_wb                   ),
	.is_ecall_instr_wb       (is_ecall_instr_wb       ),
	.is_mret_instr_wb        (is_mret_instr_wb        ),
	.mtime_interrupt_wb      (mtime_interrupt_wb      ),
	.external_interrupt_wb   (external_interrupt_wb   ),
`ifdef A_EXTENSION
	.is_amo_instr_wb         (is_amo_instr_wb         ),
`endif
	.is_fencei_wb            (is_fencei_wb            ),
	.ctrl_sig_wb_aux         (ctrl_sig_wb_aux         ),
	.instr_addr_wb_aux       (instr_addr_wb_aux       ),
	.instr_wb_aux            (instr_wb_aux            ),
	.rd_wb_aux               (rd_wb_aux               ),
	.wreg_data_wb_aux        (wreg_data_wb_aux        ),
	.cancel_instr_wb_aux     (cancel_instr_wb_aux     ),
	.commit                  (commit                  ),
	.commit_aux              (commit_aux              )
);

alu alu_inst0 (
	.op_type              (op_type_ex                 ),
	.op0                  (op0_may_bypass             ),
	.op1                  (op1_may_bypass             ),
	`ifdef RV64
	.is_word_op           (is_word_op_ex              ),
	`endif
	`ifdef M_EXTENSION
	.mul_type             (mul_type_ex                ),
	.clk                  (clk                        ),
	.rstn                 (rstn                       ),
	.div_type             (div_type_ex                ),
	.div_fin              (div_fin                    ),
	.hold                 (hold_ex                    ),
	.alu_res_ex2          (alu_res_ex2                ),
	.mul_type_ex2         (mul_type_ex2               ),
	`endif
	`ifdef A_EXTENSION
	.is_amo_instr         (is_amo_instr_ex            ),
	`endif
	`ifdef C_EXTENSION
	.is_cinstr            (is_cinstr_ex               ),
	.cimm                 (cimm_ex                    ),
	`endif
`ifndef PROC_BRANCH_IN_DC
	.pc                   (instr_addr_ex              ),
	.sext_imm             (sext_imm_ex                ),
	.is_jalr              (ctrl_sig_ex[`IS_JALR_INDEX]),
	.reg_data0            (bypassed_reg_data0_ex      ),
	.is_branch_instr      (is_branch_instr_ex         ),
	.branch_taken         (branch_taken_ex            ),
	.branch_jalr_target_pc(branch_jalr_target_pc      ),
`endif
	.data_addr_ex2        (data_addr_ex2              ),
	.alu_res              (alu_res                    )
);

reg_file reg_file_inst0 (
	.clk       (clk                        ),
	.rstn      (rstn                       ),
	.wen0      (wreg_en_wb_hold_release    ),
	.wen1      (wreg_en_wb_aux_hold_release),
	.wcsr_en   (wcsr_en_wb_hold_release    ),
	.reg_id0   (rs1                        ),
	.reg_id1   (rs2                        ),
	.reg_id2   (rs1_aux                    ),
	.reg_id3   (rs2_aux                    ),
	.wreg_id0  (rd_wb                      ),
	.wreg_id1  (rd_wb_aux                  ),
	.reg_id_csr(rs1_wb                     ),   
	.wreg_data0(wreg_data                  ),
	.wreg_data1(wreg_data_wb_aux           ),
	.reg_data0 (reg_data0                  ),
	.reg_data1 (reg_data1                  ),
	.reg_data2 (reg_data2                  ),
	.reg_data3 (reg_data3                  ),
	.wcsr_data (wcsr_data                  )
);

instr_sign_ext instr_sign_ext_inst0 (
	.instr     (instr_dc    ),
	.instr_type(instr_type  ),
	.sext_imm  (sext_imm    )
);

sel_op_to_alu sel_op_to_alu_inst0 (
	.reg_data0 (reg_data0_ex                  ),
	.reg_data1 (reg_data1_ex                  ),
	.op0_sel   (ctrl_sig_ex[`OP_SEL_RS1_INDEX]),
    .op1_sel   (ctrl_sig_ex[`OP_SEL_RS2_INDEX]),
	.pc        (instr_addr_ex                 ),
    .sext_imm  (sext_imm_ex                   ),
	.instr_type(instr_type_ex                 ),
	.is_jalr   (ctrl_sig_ex[`IS_JALR_INDEX]   ),
	`ifdef C_EXTENSION
	.is_cinstr (is_cinstr_ex                  ),
	.cimm      (cimm_ex                       ),
	`endif
	`ifdef A_EXTENSION
	.sel_amo_op(sel_amo_op                    ),
	.amo_val   (wreg_data_wb                  ),
	`endif
	.op0       (op0                           ),
	.op1       (op1                           )
);

ctrl ctrl_inst0 (
	.instr          (instr_dc       ),
	.ctrl_sig       (ctrl_sig       ),
	.op_type        (op_type        ),
	.instr_type     (instr_type     ),
	`ifdef RV64
	.is_word_op     (is_word_op     ),
	`endif
	.wdata_en       (wdata_en_dc    ),
	.wcsr_en        (wcsr_en_dc     ),
	`ifdef M_EXTENSION
	.mul_type       (mul_type       ),
	.div_type       (div_type       ),
	`endif
	`ifdef C_EXTENSION
	.cimm           (cimm           ),
	`endif
	.rs1            (rs1            ),
	.rs2            (rs2            ),
	.rd             (rd             ),
	.is_ecall_instr (is_ecall_instr ),
	.is_mret_instr  (is_mret_instr  ),
`ifndef PROC_BRANCH_IN_DC
	.is_branch_instr(is_branch_instr),
`endif
`ifdef A_EXTENSION
	.is_amo_instr   (is_amo_instr_dc),
	.is_lr          (is_lr          ),
	.is_sc          (is_sc          ),
`endif
	.is_fencei      (is_fencei      ),
	.is_store_instr (is_store_instr ),
	.rlen           (rlen_dc        ),
	.wlen           (wlen_dc        )
);

sel_wdata_to_reg sel_wdata_to_reg_inst0 (
	.wreg_src   (ctrl_sig_mem[`W_REG_SRC_INDEX]),
	.mem_data   (ext_rdata                     ),
    .alu_res    (alu_res_mem                   ),
    .wreg_data  (wreg_data_mem                 )
);

// gen_data_addr gen_data_addr_inst0 (
// 	.is_load_or_store_instr (ctrl_sig_mem[`IS_LOAD_OR_STORE_INSTR_INDEX]),
// 	.wdata_en               (wdata_en                                   ),
// 	.flush_mem              (flush_mem                                  ),
// 	.cancel_instr_mem       (cancel_instr_mem                           ),
// 	.alu_res                (alu_res_mem                                ),
// 	.data_addr              (data_addr                                  ),
// 	.rdata_en               (rdata_en                                   ) 
// );

rdata_ext rdata_ext_inst0 ( // adjust it between mem - wb
	.rdata     (rdata[`XLEN_BUS]       ),
	.func3     (instr_mem[`FUNC3_FIELD]), //
`ifdef C_EXTENSION
	.is_cinstr (is_cinstr_mem          ),
`endif
	.ext_rdata (ext_rdata              ) 
);

data_bypass data_bypass_inst0 (
	.rd_ex2                (rd_ex2                             ),
	.rd_mem                (rd_mem                             ),
	.rs1_dc                (rs1                                ),
	.rs2_dc                (rs2                                ),
	.rs1_dc_aux            (rs1_aux                            ),
	.rs2_dc_aux            (rs2_aux                            ),
	.op0_ex_aux            (op0_ex_aux                         ),    
	.op1_ex_aux            (op1_ex_aux                         ),    
	.op_sel_rs1_ex_aux     (ctrl_sig_ex_aux[`OP_SEL_RS1_INDEX] ),    
	.op_sel_rs2_ex_aux     (ctrl_sig_ex_aux[`OP_SEL_RS2_INDEX] ),    
	.rs1_ex_aux            (rs1_ex_aux                         ),    
	.rs2_ex_aux            (rs2_ex_aux                         ),
	.op_sel_rs1_dc_aux     (ctrl_sig_aux[`OP_SEL_RS1_INDEX]    ),
	.op_sel_rs2_dc_aux     (ctrl_sig_aux[`OP_SEL_RS2_INDEX]    ),
	.wreg_en_ex_aux        (ctrl_sig_ex_aux[`W_REG_INDEX]      ),
	.wreg_en_ex2_aux       (ctrl_sig_ex2_aux[`W_REG_INDEX]     ),
	.wreg_en_mem_aux       (ctrl_sig_mem_aux[`W_REG_INDEX]     ),
	.wreg_en_wb_aux        (ctrl_sig_wb_aux[`W_REG_INDEX]      ),
	.rd_ex_aux             (rd_ex_aux                          ),
	.rd_ex2_aux            (rd_ex2_aux                         ),
	.rd_mem_aux            (rd_mem_aux                         ),
	.rd_wb_aux             (rd_wb_aux                          ),
	.wreg_data_ex_aux      (alu_res_aux                        ),
	.wreg_data_ex2_aux     (wreg_data_ex2_aux                  ),
	.wreg_data_mem_aux     (wreg_data_mem_aux                  ),
	.wreg_data_wb_aux      (wreg_data_wb_aux                   ),
	.wreg_en_ex            (ctrl_sig_ex[`W_REG_INDEX]          ),
	.rd_ex                 (rd_ex                              ),
	.wreg_data_ex          (alu_res                            ),
	.rs1_ex                (rs1_ex                             ),
	.rs2_ex                (rs2_ex                             ),
	.rs2_mem               (rs2_mem                            ),
	.wreg_en_ex2           (ctrl_sig_ex2[`W_REG_INDEX]         ),
	.wreg_en_mem           (ctrl_sig_mem[`W_REG_INDEX]         ),
	.op_sel_rs1_ex         (ctrl_sig_ex[`OP_SEL_RS1_INDEX]     ),
	.op_sel_rs2_ex         (ctrl_sig_ex[`OP_SEL_RS2_INDEX]     ),
	.op0_ex                (op0                                ),
	.op1_ex                (op1                                ),
	.wreg_data_ex2         (alu_res_ex2                        ),
	.alu_res_mem           (alu_res_mem                        ),
	.wreg_data_mem         (wreg_data_mem                      ),
	.rd_wb                 (rd_wb                              ),
	.wreg_en_wb            (ctrl_sig_wb[`W_REG_INDEX]          ),
	.wreg_data_wb          (wreg_data                          ),
	.wdata_no_bypass       (rs2_data_mem                       ),
	.ext_rdata             (ext_rdata                          ),
	.reg_data0             (reg_data0                          ),    
	.reg_data1             (reg_data1                          ),    
	.op0_aux               (op0_aux                            ),    
	.op1_aux               (op1_aux                            ),    
	.reg_data1_ex          (reg_data1_ex                       ), 
`ifdef A_EXTENSION
	.is_amo_instr_ex       (is_amo_instr_ex                    ),
	.alu_res_ex            (alu_res                            ),
`endif
	.reg_data0_dc          (reg_data0_dc                       ), 
	.reg_data1_dc          (reg_data1_dc                       ),       
	.op0_may_bypass_aux    (op0_dc_aux                         ),    
	.op1_may_bypass_aux    (op1_dc_aux                         ),    
	.op0_may_bypass        (op0_may_bypass                     ),
	.op1_may_bypass        (op1_may_bypass                     ),
`ifndef PROC_BRANCH_IN_DC
	.is_jalr_ex            (ctrl_sig_ex[`IS_JALR_INDEX]        ),
	.reg_data0_ex          (reg_data0_ex                       ),
	.bypassed_reg_data0_ex (bypassed_reg_data0_ex              ),
`endif
	.op0_ex_aux_may_bypass (op0_ex_aux_may_bypass              ),
	.op1_ex_aux_may_bypass (op1_ex_aux_may_bypass              ),
	.wdata_ex              (wdata_ex                           )
	// .wdata_may_bypass      (wdata                              )   
);


stall stall_inst0 (
	.rdata_valid                   (rdata_valid                                ),
	.ctrl_sig_dc                   (ctrl_sig                                   ),
	.is_load_or_store_instr_ex     (ctrl_sig_ex[`IS_LOAD_OR_STORE_INSTR_INDEX] ),
	.is_load_or_store_instr_ex2    (ctrl_sig_ex2[`IS_LOAD_OR_STORE_INSTR_INDEX]),
    .wdata_en_ex                   (wdata_en_ex                                ),
    .wdata_en_ex2                  (wdata_en_ex2                               ),
    .is_load_or_store_instr_mem    (ctrl_sig_mem[`IS_LOAD_OR_STORE_INSTR_INDEX]),
    .is_load_or_store_instr_wb     (ctrl_sig_wb[`IS_LOAD_OR_STORE_INSTR_INDEX] ),
    .wdata_en_mem                  (wdata_en                                   ),
	.wdata_ready                   (wdata_ready                                ),
	.is_jalr_dc                    (ctrl_sig[`IS_JALR_INDEX]                   ),
	.instr_type_dc                 (instr_type                                 ),
	.is_branch_ex_hazard0          (is_branch_ex_hazard0                       ),
	.is_branch_ex_hazard1          (is_branch_ex_hazard1                       ),
	.is_branch_ex2_hazard0         (is_branch_ex2_hazard0                      ),
	.is_branch_ex2_hazard1         (is_branch_ex2_hazard1                      ),
	.is_branch_mem_hazard0         (is_branch_mem_hazard0                      ),
	.is_branch_mem_hazard1         (is_branch_mem_hazard1                      ),
`ifndef PROC_BRANCH_IN_DC
	.branch_taken_ex2              (branch_taken_ex2                           ),
	.branch_taken_mem              (branch_taken_mem                           ),
`endif
`ifdef A_EXTENSION
	.amo_cannot_issue              (amo_cannot_issue                           ),
`endif
	.op_type_ex                    (op_type_ex                                 ),
	.fencei_stall                  (fencei_stall                               ),
	.div_fin                       (div_fin                                    ),
	.load_in_ex_ex2_hazard         (load_in_ex_ex2_hazard                      ),
	.can_not_issue                 (can_not_issue                              ),
	.is_load_mem                   (is_load_mem                                ),
	.cancel_instr_ex               (cancel_instr_ex                            ),
	.cancel_instr_mem              (cancel_instr_mem                           ),
	.cancel_instr_wb               (cancel_instr_wb                            ),
	.instr_valid                   (instr_valid                                ),
	.wreg_en_ex                    (ctrl_sig_ex[`W_REG_INDEX]                  ),
    .wreg_en_ex2                   (ctrl_sig_ex2[`W_REG_INDEX]                 ),
    .wreg_en_mem                   (ctrl_sig_mem[`W_REG_INDEX]                 ),
	.wreg_en_wb                    (ctrl_sig_wb[`W_REG_INDEX]                  ),
	.wreg_en_wb_aux                (ctrl_sig_wb_aux[`W_REG_INDEX]              ),
	.wcsr_en_wb                    (wcsr_en_wb                                 ),
	.interrupt_taken               (interrupt_taken                            ),
	.is_ecall_instr_wb             (is_ecall_instr_in_wb                       ),
	.is_mret_instr_wb              (is_mret_instr_in_wb                        ),
	// .mtime_interrupt_wb            (mtime_interrupt_wb                         ),
	// .external_interrupt_wb         (external_interrupt_wb                      ),
	// .mtime_interrupt               (mtime_interrupt                            ),
	// .external_interrupt            (external_interrupt                         ),
    .wreg_en_wb_hold_release       (wreg_en_wb_hold_release                    ),
    .wreg_en_wb_aux_hold_release   (wreg_en_wb_aux_hold_release                ),
	.wcsr_en_wb_hold_release       (wcsr_en_wb_hold_release                    ),
	.is_ecall_instr_wb_hold_release(is_ecall_instr_wb_hold_release             ),
	.is_mret_instr_wb_hold_release (is_mret_instr_wb_hold_release              ),
	.ci_for_branch_after_load      (ci_for_branch_after_load                   ),
	.hold_pc                       (hold_pc                                    ),
	.hold_if                       (hold_if                                    ),
	.hold_dc                       (hold_dc                                    ),
	.hold_ex                       (hold_ex                                    ),
	.hold_ex2                      (hold_ex2                                   ),
	.hold_mem                      (hold_mem                                   )       
);

data_bypass2 data_bypass2_inst0(
	.rd_ex                    (rd_ex                                     ),
	.rd_mem                   (rd_mem                                    ),
	.rs1_dc                   (rs1                                       ),
	.rs2_dc                   (rs2                                       ),
	.rs1_dc_aux               (rs1_aux                                   ),
	.rs2_dc_aux               (rs2_aux                                   ),
	.rs2_mem                  (rs2_mem                                   ),
	.wreg_en_ex               (ctrl_sig_ex[`W_REG_INDEX]                 ),
	.wreg_en_mem              (ctrl_sig_mem[`W_REG_INDEX]                ),
	.op_sel_rs1_ex            (ctrl_sig_ex[`OP_SEL_RS1_INDEX]            ),
	.op_sel_rs2_ex            (ctrl_sig_ex[`OP_SEL_RS2_INDEX]            ),
	.is_load_or_store_instr_ex(ctrl_sig_ex[`IS_LOAD_OR_STORE_INSTR_INDEX]),
	.alu_res_ex               (alu_res                                   ),
	.op0_ex                   (op0                                       ),
	.op1_ex                   (op1                                       ),
	.wreg_data_ex2            (alu_res_ex2                               ),
	.wreg_data_mem            (wreg_data_mem                             ),
	.rd_ex2                   (rd_ex2                                    ),
	.rd_wb                    (rd_wb                                     ),
	.wreg_en_wb               (ctrl_sig_wb[`W_REG_INDEX]                 ),
	.wreg_en_ex2              (ctrl_sig_ex2[`W_REG_INDEX]                ),
	.wreg_data_wb             (wreg_data                                 ),
	.ext_rdata                (ext_rdata                                 ),
	.reg_data0                (reg_data0                                 ),
	.reg_data1                (reg_data1                                 ),
	.flush_ex                 (flush_ex                                  ),         
	.flush_ex2                (flush_ex2                                 ),
	.flush_mem                (flush_mem                                 ),
	.cancel_instr_dc          (cancel_instr_dc                           ),
	.cancel_instr_dc_aux      (cancel_instr_dc_aux                       ),
	.op_sel_rs1               (ctrl_sig[`OP_SEL_RS1_INDEX]               ),
	.op_sel_rs2               (ctrl_sig[`OP_SEL_RS2_INDEX]               ),
	.op_sel_rs1_dc_aux        (ctrl_sig_aux[`OP_SEL_RS1_INDEX]           ),
	.op_sel_rs2_dc_aux        (ctrl_sig_aux[`OP_SEL_RS2_INDEX]           ),
	.is_jalr_dc               (ctrl_sig[`IS_JALR_INDEX]                  ),
	.is_store_instr           (is_store_instr                            ),
	.cancel_instr_ex          (cancel_instr_ex                           ),         
	.cancel_instr_ex2         (cancel_instr_ex2                          ),         
	.cancel_instr_mem         (cancel_instr_mem                          ),         
	.is_branch_ex_hazard0     (is_branch_ex_hazard0                      ),
	.is_branch_ex_hazard1     (is_branch_ex_hazard1                      ),
	.is_branch_ex2_hazard0    (is_branch_ex2_hazard0                     ),
	.is_branch_ex2_hazard1    (is_branch_ex2_hazard1                     ),
	.is_branch_mem_hazard0    (is_branch_mem_hazard0                     ),
	.is_branch_mem_hazard1    (is_branch_mem_hazard1                     ),
	.bypassed_reg_data0       (bypassed_reg_data0                        ),
	.bypassed_reg_data1       (bypassed_reg_data1                        )
);

sel_data_to_gpr sel_data_to_gpr_inst0 (
	.csr_data    (csr_data    ),
	.wcsr_en_wb  (wcsr_en_wb  ),
	.wreg_data_wb(wreg_data_wb),
	.wreg_data   (wreg_data   )    
);

csr csr_inst0 (
	.clk                     (clk                           ),
	.rstn                    (rstn                          ),
	.wcsr_en                 (wcsr_en_wb_hold_release       ),
	.instr_addr              (instr_addr_wb                 ),
	.rcsr_id                 (instr_wb[`CSR_FIELD]          ),
	.wcsr_id                 (instr_wb[`CSR_FIELD]          ),
	.wcsr_data               (wcsr_data                     ),
	.csr_uimm                (instr_wb[`CSR_UIMM_FIELD]     ),
	.csr_op_type             (instr_wb[`CSR_OP_TYPE_FIELD]  ),
	.is_ecall_instr          (is_ecall_instr_wb_hold_release),
	.is_mret_instr           (is_mret_instr_wb_hold_release ),
	.external_interrupt_mem  (external_interrupt_mem        ),
	.mtime_interrupt_mem     (mtime_interrupt_mem           ),
	.is_ecall_instr_mem      (is_ecall_instr_mem            ),
	.is_mret_instr_mem       (is_mret_instr_mem             ),
	.is_ecall_instr_wb       (is_ecall_instr_in_wb          ),
	.is_mret_instr_wb        (is_mret_instr_in_wb           ),
	.mtime_interrupt         (mtime_interrupt_wb            ),
	.external_interrupt      (external_interrupt_wb         ),
	.commit                  (commit                        ),
	.commit_aux              (commit_aux                    ),
	.hold_mem                (hold_mem                      ),
	.mstatus_mie             (mstatus_mie                   ),
	.int_under_handle        (int_under_handle              ),
	.interrupt_taken         (interrupt_taken               ),
	.exception_entry         (exception_entry               ),
	.csr_data                (csr_data                      )
);

flush_pipeline flush_pipeline_inst0 (
`ifdef ZICSR_EXTENSION
	.wcsr_en_wb          (wcsr_en_wb          ),
    .is_csr_instr_in_wb  (is_csr_instr_in_wb  ),  
`endif 
    .is_ecall_instr_wb   (is_ecall_instr_wb   ),
    .is_mret_instr_wb    (is_mret_instr_wb    ),
    .is_ecall_instr_in_wb(is_ecall_instr_in_wb),
    .is_mret_instr_in_wb (is_mret_instr_in_wb ),
	.cancel_instr_mem    (cancel_instr_mem    ),
	.cancel_instr_wb     (cancel_instr_wb     ),
	.interrupt_taken     (interrupt_taken     ),
`ifndef PROC_BRANCH_IN_DC
	.branch_taken_ex2    (branch_taken_ex2    ),
	.branch_taken_mem    (branch_taken_mem    ),
`endif
	.is_fencei_wb        (is_fencei_wb        ),
	.wdata_en_mem        (wdata_en            ),
    .flush_if            (flush_if            ),
    .flush_dc            (flush_dc            ),
    .flush_ex            (flush_ex            ),
    .flush_ex2           (flush_ex2           ),
    .flush_mem           (flush_mem           )
);

///////////////////////////////////////////////////////////
clint clint_inst0 (
    .clk                 (clk                 ),
    .rstn                (rstn                ),
    .data_addr           (data_addr           ),
    .wen                 (wdata_en            ),
    .wdata               (wdata               ),
    .wlen                (wlen                ),
    .is_mret_instr       (is_mret_instr       ),
    .mtime_interrupt     (mtime_interrupt     )
    );

plic plic_inst0 (
    .clk                    (clk                  ),
    .rstn                   (rstn                 ),
    .data_addr              (data_addr            ),
    .wen                    (wdata_en             ),
    .wdata                  (wdata                ),
    .wlen                   (wlen                 ),
    .irq1                   (irq1                 ),
	.hold_mem               (hold_mem             ),
    .int_under_handle       (int_under_handle     ),  
    .external_interrupt     (external_interrupt   ),
    .plic_ready             (plic_ready           )
    );
///////////////////////////////////////////////////////////

gen_interrupt gen_interrupt_inst0 (
    .cancel_instr_ex2      (cancel_instr_ex2      ),
	.mstatus_mie           (mstatus_mie           ),
`ifdef A_EXTENSION
	.is_amo_instr_mem      (is_amo_instr_mem      ),
`endif
    .mtime_interrupt       (mtime_interrupt       ), // from clint
    .external_interrupt    (external_interrupt    ), // from plic
    .mtime_interrupt_ex2   (mtime_interrupt_ex2   ),
    .external_interrupt_ex2(external_interrupt_ex2)       
);

`ifdef CACHE

judge_cached_mem judge_cached_mem_inst0 (
    .clk            (clk                           ),
    .rstn           (rstn                          ),
    .data_addr      (alu_res_ex2[`DATA_ADDR_BUS]   ),
    .is_cache_mem   (is_cache_mem                  ),
    .is_device_write(is_device_write               )
);

cached_mem cached_mem_inst0 (
    .clk            (clk                 ),
    .rstn           (rstn                ),
	.hold           (hold_mem            ),
	.data_addr_ex2  (data_addr_ex2       ),
	.rdata_en_ex2   (rdata_en_ex2        ),
	.is_cache_mem   (is_cache_mem_mem    ),
	.is_device_write(is_device_write_mem ),

	.is_fencei           (is_fencei_mem       ),
	.fencei_stall        (fencei_stall        ),
	.fencei_flush        (fencei_flush        ),

    .data_addr_in   (data_addr           ),
    .rdata_en_in    (rdata_en            ),
    .wdata_en_in    (wdata_en            ),
`ifdef RV64
    .wdata_in       (wdata               ),
`else
	.wdata_in       ({32'b0, wdata}      ),
`endif
    .wlen_in        (wlen                ),
    .rlen_in        (rlen                ),
    .wdata_ready_out(wdata_ready         ),
    .rdata_out      (rdata               ),
    .rdata_valid_out(rdata_valid         ),
    .data_addr_out  (data_addr_in1       ),
    .rdata_en_out   (rdata_en_in1        ),
    .wdata_en_out   (wdata_en_in1        ),
    .wdata_out      (wdata_in1           ),
    .wlen_out       (wlen_in1            ),
    .wdata_ready_in (wdata_ready_out1    ),
    .rdata_in       (rdata_out1          ),
    .rdata_valid_in (rdata_valid_out1    )
);

ifu ifu_inst0 (
    .clk            (clk             ),
    .rstn           (rstn            ),
	.next_instr_addr(next_instr_addr ),
    .instr_addr     (instr_addr_ifu  ),
	.ifu_data       (ifu_data        ),
	.instr_valid    (ifu_rdata_valid ),
	.ifu_miss       (ifu_miss        ),
	.fencei_flush   (fencei_flush    ),
    .data_addr_out  (data_addr_in0   ),
    .rdata_en_out   (rdata_en_in0    ),
    .wdata_en_out   (wdata_en_in0    ),
    .wdata_out      (wdata_in0       ),
    .wlen_out       (wlen_in0        ),
    .wdata_ready_in (wdata_ready_out0),
    .rdata_in       (rdata_out0      ),
    .rdata_valid_in (rdata_valid_out0)
);

`endif

ctrl_aux ctrl_aux_inst0 (
	.instr                    (instr_aux                ),
	.instr_addr_dc_aux        (instr_addr_dc_aux        ),
	.rd_from_ctrl             (rd                       ),                
	.ctrl_sig_from_ctrl       (ctrl_sig                 ),
	.wcsr_en_from_ctrl        (wcsr_en_dc               ),
	.op_type_from_ctrl        (op_type                  ),
	.is_ecall_instr_from_ctrl (is_ecall_instr           ),
	.is_mret_instr_from_ctrl  (is_mret_instr            ),
`ifndef PROC_BRANCH_IN_DC
	.is_branch_instr_from_ctrl(is_branch_instr          ),
`endif   
`ifdef A_EXTENSION
	.is_amo_instr_dc          (is_amo_instr_dc          ),
`endif     
	.ctrl_sig                 (ctrl_sig_aux             ),
	.op_type                  (op_type_aux              ),
	.instr_type               (instr_type_aux           ),
	`ifdef RV64
	.is_word_op               (is_word_op_aux           ),
	`endif
	`ifdef C_EXTENSION
	.cimm                     (cimm_aux                 ),
	`endif
	.rs1                      (rs1_aux                  ),
	.rs2                      (rs2_aux                  ),
	.rd                       (rd_aux                   ),
	.aux_can_issue            (aux_can_issue            ) 
);

alu_aux alu_aux_inst0 (
	.op_type      (op_type_ex_aux       ),
	.op0          (op0_ex_aux_may_bypass),
	.op1          (op1_ex_aux_may_bypass),
	`ifdef RV64
	.is_word_op   (is_word_op_ex_aux    ),
	`endif
	.alu_res      (alu_res_aux          )           
);

instr_sign_ext_aux instr_sign_ext_aux_inst0 (
	.instr     (instr_aux     ),
	.instr_type(instr_type_aux),
	.sext_imm  (sext_imm_aux  )
);

sel_op_to_alu_aux sel_op_to_alu_aux_inst0 (
	.reg_data0 (reg_data2                       ),
	.reg_data1 (reg_data3                       ),
	.op0_sel   (ctrl_sig_aux[`OP_SEL_RS1_INDEX] ),
    .op1_sel   (ctrl_sig_aux[`OP_SEL_RS2_INDEX] ),
	.pc        (instr_addr_dc_aux               ),
    .sext_imm  (sext_imm_aux                    ),
	`ifdef C_EXTENSION
	.is_cinstr (is_cinstr_dc_aux                ),
	.cimm      (cimm_aux                        ),
	`endif
	.op0       (op0_aux                         ),
	.op1       (op1_aux                         )
);

core_bus core_bus_inst0 (
	.clk                    (clk                    ),
	.rstn                   (rstn                   ),
	.araddr                 (axi_araddr             ),
    .arburst                (axi_arburst            ),
    .arcache                (axi_arcache            ),
    .arid                   (axi_arid               ),
	.arlen                  (axi_arlen              ),
    .arlock                 (axi_arlock             ),
    .arprot                 (axi_arprot             ),
    .arqos                  (axi_arqos              ),
    .arready                (axi_arready            ),
	.arsize                 (axi_arsize             ),
	.aruser                 (axi_aruser             ),
	.arvalid                (axi_arvalid            ),
	.awaddr                 (axi_awaddr             ),
	.awburst                (axi_awburst            ),
    .awcache                (axi_awcache            ),
    .awid                   (axi_awid               ),
	.awlock                 (axi_awlock             ),
    .awlen                  (axi_awlen              ),
    .awprot                 (axi_awprot             ),
    .awqos                  (axi_awqos              ),
    .awready                (axi_awready            ),
	.awsize                 (axi_awsize             ),
	.awuser                 (axi_awuser             ),
	.awvalid                (axi_awvalid            ),
	.bid                    (axi_bid                ),
    .bready                 (axi_bready             ),
	.bresp                  (axi_bresp              ),
	.buser                  (axi_buser              ),
	.bvalid                 (axi_bvalid             ),
	.rid                    (axi_rid                ),
	.rdata                  (axi_rdata              ),
    .rlast                  (axi_rlast              ),
	.rresp                  (axi_rresp              ),
	.rready                 (axi_rready             ),
	.ruser                  (axi_ruser              ),
	.rvalid                 (axi_rvalid             ),
    .wdata                  (axi_wdata              ),
    .wid                    (axi_wid                ),
    .wlast                  (axi_wlast              ),
    .wready                 (axi_wready             ),
	.wstrb                  (axi_wstrb              ),
	.wuser                  (axi_wuser              ),
	.wvalid                 (axi_wvalid             ),
	.hold_if                (hold_if                ),
	.hold_mem               (hold_mem               ),
    .data_addr_in0          (data_addr_in0          ),
    .rdata_en_in0           (rdata_en_in0           ),
    .wdata_en_in0           (wdata_en_in0           ),
    .wdata_in0              (wdata_in0              ),
    .wlen_in0               (wlen_in0               ),
    .wdata_ready_out0       (wdata_ready_out0       ),
    .rdata_out0             (rdata_out0             ),
    .rdata_valid_out0       (rdata_valid_out0       ),
	.fencei_flush           (fencei_flush           ),
    .data_addr_in1          (data_addr_in1          ),
    .rdata_en_in1           (rdata_en_in1           ),
    .wdata_en_in1           (wdata_en_in1           ),
    .wdata_in1              (wdata_in1              ),
    .wlen_in1               (wlen_in1               ),
    .wdata_ready_out1       (wdata_ready_out1       ),
    .rdata_out1             (rdata_out1             ),
    .rdata_valid_out1       (rdata_valid_out1       )
);

`ifdef A_EXTENSION
amo_unit amo_unit_inst0 (
    .clk             (clk                              ),
    .rstn            (rstn                             ),
`ifdef RV64
	.is_word_op_dc   (is_word_op                       ), 
`endif
	.is_lr           (is_lr                            ),
	.is_sc           (is_sc                            ),
	.is_sc_mem       (is_sc_mem                        ),
    .is_amo_instr_dc (is_amo_instr_dc                  ),
    .is_amo_instr_ex (is_amo_instr_ex                  ),
    .is_amo_instr_ex2(is_amo_instr_ex2                 ),
    .is_amo_instr_mem(is_amo_instr_mem                 ),
    .is_amo_instr_wb (is_amo_instr_wb                  ),
	.rdata_valid     (rdata_valid                      ),
	.reg_data0_dc    (reg_data0                        ),
	.cancel_instr_ex (cancel_instr_ex                  ),
	.cancel_instr_ex2(cancel_instr_ex2                 ),
	.cancel_instr_mem(cancel_instr_mem                 ),
	.cancel_instr_wb (cancel_instr_wb                  ),
	.sc_addr         (wreg_data_ex2_aux[`DATA_ADDR_BUS]),
	.wlen_ex2        (wlen_ex2                         ),
	.sel_amo_op      (sel_amo_op                       ),
	.is_fail_sc      (is_fail_sc                       ),
    .amo_val_lockup  (amo_val_lockup                   ), 
	.amo_rdata_en    (amo_rdata_en                     ),
	.amo_addr        (amo_addr                         ),
	.amo_rlen        (amo_rlen                         ),
    .amo_cannot_issue(amo_cannot_issue                 )    
);
`endif

endmodule
