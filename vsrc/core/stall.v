`include "params.v"

module stall (
	input                    rdata_valid                   ,
    input [`CTRL_SIG_BUS]    ctrl_sig_dc                   ,
    input                    is_load_or_store_instr_ex     ,
    input                    is_load_or_store_instr_ex2    ,
    input                    wdata_en_ex                   ,
    input                    wdata_en_ex2                  ,
    input                    is_load_or_store_instr_mem    ,
    input                    is_load_or_store_instr_wb     ,
    input                    wdata_en_mem                  ,
    input                    wdata_ready                   ,
    input                    is_jalr_dc                    ,
    input [`INST_TYPE_BUS]   instr_type_dc                 ,
    input                    is_branch_ex_hazard0          ,
    input                    is_branch_ex_hazard1          ,
    input                    is_branch_ex2_hazard0         ,
    input                    is_branch_ex2_hazard1         ,
    input                    is_branch_mem_hazard0         ,
	input                    is_branch_mem_hazard1         ,
`ifndef PROC_BRANCH_IN_DC
	input                    branch_taken_ex2              ,
	input                    branch_taken_mem              ,
`endif
`ifdef A_EXTENSION
    input                    amo_cannot_issue              ,
`endif
    input [`OP_TYPE_BUS]     op_type_ex                    ,
    input                    fencei_stall                  ,
    input                    div_fin                       ,
    input                    instr_valid                   ,
    input                    wreg_en_ex                    ,
    input                    wreg_en_ex2                   ,
    input                    wreg_en_mem                   ,
    input                    wreg_en_wb                    ,
    input                    wreg_en_wb_aux                ,
    input                    wcsr_en_wb                    ,
    input                    cancel_instr_ex               ,
    input                    cancel_instr_mem              ,
    input                    cancel_instr_wb               ,
    input                    is_ecall_instr_wb             ,
    input                    is_mret_instr_wb              ,
    // input                    mtime_interrupt_wb            ,
    // input                    external_interrupt_wb         ,
    input                    interrupt_taken               ,
    // output                   mtime_interrupt               ,
    // output                   external_interrupt            ,
    output                   load_in_ex_ex2_hazard         ,
    output                   can_not_issue                 ,
    output                   is_load_mem                   ,
    output reg               ci_for_branch_after_load      , // cancel the instruction in ex-stage if hazard happen in branch after load // insert a nop instruciton
    output reg               hold_pc                       ,
    output reg               hold_if                       ,
    output reg               hold_dc                       ,
    output reg               hold_ex                       ,
    output reg               hold_ex2                      ,
    output reg               hold_mem                      ,
    output                   wreg_en_wb_hold_release       ,    
    output                   wreg_en_wb_aux_hold_release   ,    
    output                   wcsr_en_wb_hold_release       ,
    output                   is_ecall_instr_wb_hold_release,         
    output                   is_mret_instr_wb_hold_release         
);

    wire is_load_dc;
    wire is_load_ex;
    wire is_load_ex2;
    wire is_store_instr_ex2;
    wire is_branch_ex_hazard;
    wire is_branch_ex2_hazard;
    wire is_branch_mem_hazard;
    wire hold_pipeline/*verilator public*/;

`ifdef A_EXTENSION
    assign can_not_issue = ((is_load_dc == `IS_LOAD) && (wdata_en_ex == `WDATA_EN)) || load_in_ex_ex2_hazard || (amo_cannot_issue == `BOOL_TRUE);
`else
    assign can_not_issue = ((is_load_dc == `IS_LOAD) && (wdata_en_ex == `WDATA_EN)) || load_in_ex_ex2_hazard;
`endif
    // assign can_not_issue = ((is_load_dc == `IS_LOAD) && (wdata_en_ex == `WDATA_EN)) || load_in_ex_ex2_hazard || (op_type_ex[`OP_MUL_INDEX] && (cancel_instr_ex != `CANCEL_INSTR));
    // assign load_in_ex_ex2_mem_hazard = (((is_load_ex == `IS_LOAD) && is_branch_ex_hazard) || ((is_load_ex2 == `IS_LOAD) && is_branch_ex2_hazard) || ((is_load_mem == `IS_LOAD) && is_branch_mem_hazard)) && (branch_taken_ex2 == `BOOL_FALSE);
    assign load_in_ex_ex2_hazard = (((is_load_ex == `IS_LOAD) && is_branch_ex_hazard) || ((is_load_ex2 == `IS_LOAD) && is_branch_ex2_hazard)) && (branch_taken_ex2 == `BOOL_FALSE);
    assign is_load_dc = ((ctrl_sig_dc[`IS_LOAD_OR_STORE_INSTR_INDEX] == `IS_LOAD_OR_STORE_INSTR) && (ctrl_sig_dc[`W_REG_INDEX] == `W_REG_EN))? `IS_LOAD : !`IS_LOAD; // load
    assign is_load_mem = ((is_load_or_store_instr_mem == `IS_LOAD_OR_STORE_INSTR) && (wdata_en_mem != `WDATA_EN)) ? `IS_LOAD : !`IS_LOAD; // load
    assign is_load_ex = ((is_load_or_store_instr_ex == `IS_LOAD_OR_STORE_INSTR) && (wdata_en_ex != `WDATA_EN) && (wreg_en_ex == `W_REG_EN)) ? `IS_LOAD : !`IS_LOAD; // load
    assign is_load_ex2 = ((is_load_or_store_instr_ex2 == `IS_LOAD_OR_STORE_INSTR) && (wdata_en_ex2 != `WDATA_EN) && (wreg_en_ex2 == `W_REG_EN)) ? `IS_LOAD : !`IS_LOAD; // load
    assign is_branch_ex_hazard = (is_branch_ex_hazard0 | is_branch_ex_hazard1);
    assign is_branch_ex2_hazard = (is_branch_ex2_hazard0 | is_branch_ex2_hazard1);
    assign is_branch_mem_hazard = (is_branch_mem_hazard0 | is_branch_mem_hazard1);

    assign wreg_en_wb_hold_release = ((wreg_en_wb == `W_REG_EN) && (hold_mem != `HOLD) && (cancel_instr_wb != `CANCEL_INSTR) && (interrupt_taken != `INTERRUPT_TAKEN))? `W_REG_EN : !`W_REG_EN;
    assign wreg_en_wb_aux_hold_release = ((wreg_en_wb_aux == `W_REG_EN) && (hold_mem != `HOLD) && (cancel_instr_wb != `CANCEL_INSTR) && (interrupt_taken != `INTERRUPT_TAKEN))? `W_REG_EN : !`W_REG_EN;
    assign wcsr_en_wb_hold_release = ((wcsr_en_wb == `W_REG_EN) && (hold_mem != `HOLD) && (cancel_instr_wb != `CANCEL_INSTR))? `W_CSR_EN : !`W_CSR_EN;
    assign is_ecall_instr_wb_hold_release = ((is_ecall_instr_wb == `IS_ECALL_INSTR) && (hold_mem != `HOLD) && (cancel_instr_wb != `CANCEL_INSTR))? `IS_ECALL_INSTR : !`IS_ECALL_INSTR;
    assign is_mret_instr_wb_hold_release = ((is_mret_instr_wb == `IS_MRET_INSTR) && (hold_mem != `HOLD) && (cancel_instr_wb != `CANCEL_INSTR))? `IS_MRET_INSTR : !`IS_MRET_INSTR;
    
    wire is_load_miss = ((is_load_mem == `IS_LOAD) && (rdata_valid != `RDATA_VALID) && (cancel_instr_mem != `CANCEL_INSTR));
    wire is_store_miss = ((wdata_en_mem == `WDATA_EN) && (wdata_ready != `WDATA_READY));
    wire is_div_not_finish = (div_fin != `DIV_FIN);
    wire is_instr_miss = (instr_valid != `INSTR_VALID);

    wire dcache_miss/*verilator public*/;
    wire icache_miss/*verilator public*/;
    wire dcache_visit/*verilator public*/;
    assign dcache_miss = is_load_miss || is_store_miss;
    assign icache_miss = is_instr_miss;
    assign dcache_visit = is_load_or_store_instr_mem;

    assign hold_pipeline = (is_load_miss || is_store_miss || is_div_not_finish || is_instr_miss)? `HOLD : !`HOLD;

    always@(*) begin
        if ((hold_pipeline == `HOLD) || fencei_stall) begin
            ci_for_branch_after_load = !`CANCEL_INSTR;
            hold_pc   = `HOLD;
            hold_if   = `HOLD;
            hold_dc   = `HOLD;
            hold_ex   = `HOLD;
            hold_ex2  = `HOLD;
            hold_mem  = `HOLD;
        end
        else begin
            ci_for_branch_after_load = !`CANCEL_INSTR;
            hold_pc  = !`HOLD;
            hold_if  = !`HOLD;
            hold_dc  = !`HOLD;
            hold_ex  = !`HOLD;
            hold_ex2 = !`HOLD;
            hold_mem = !`HOLD;
        end
    end

endmodule