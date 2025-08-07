`include "params.v"

module amo_unit (
    input                       clk             ,
    input                       rstn            ,
`ifdef RV64
	input                       is_word_op_dc   , 
`endif
    input                       is_lr           ,
    input                       is_sc           ,
    input                       is_sc_mem       ,
    input                       is_amo_instr_dc ,
    input                       is_amo_instr_ex ,
    input                       is_amo_instr_ex2,
    input                       is_amo_instr_mem,
    input                       is_amo_instr_wb ,
    input                       rdata_valid     ,
    input [`XLEN_BUS]           reg_data0_dc    ,
    input                       cancel_instr_ex ,
    input                       cancel_instr_ex2,
    input                       cancel_instr_mem,
    input                       cancel_instr_wb ,
    input [`DATA_ADDR_BUS]      sc_addr         ,
    input [`WLEN_BUS]           wlen_ex2        ,
    output                      sel_amo_op      ,
    output reg                  is_fail_sc      ,
    output reg                  amo_val_lockup  ,                                 
    output reg                  amo_rdata_en    ,
    output reg [`DATA_ADDR_BUS] amo_addr        ,  
    output reg [`RLEN_BUS]      amo_rlen        ,
    output reg                  amo_cannot_issue    
);

    assign sel_amo_op = (is_amo_instr_ex == `IS_AMO_INSTR) && (cancel_instr_ex != `CANCEL_INSTR)? `BOOL_TRUE : `BOOL_FALSE;

    reg [`AMO_STAGE_BUS] amo_stage;

    always@(posedge clk) begin
        if (rstn == `RESET_EN)
            amo_stage <= `AMO_STAGE_IDLE;
        else if ((amo_stage == `AMO_STAGE_READ) && (rdata_valid == `RDATA_VALID))
            amo_stage <= `AMO_STAGE_WRTE;
        else if ((amo_stage == `AMO_STAGE_READ) && (is_sc))
            amo_stage <= `AMO_STAGE_WRTE;
        else if ((amo_stage == `AMO_STAGE_WRTE) && (cancel_instr_mem != `CANCEL_INSTR))
            amo_stage <= `AMO_STAGE_IDLE;
        else if ((amo_stage == `AMO_STAGE_IDLE) && (is_amo_instr_dc == `IS_AMO_INSTR) && (is_amo_instr_ex == `IS_AMO_INSTR) && (is_amo_instr_ex2 == `IS_AMO_INSTR) && (is_amo_instr_mem == `IS_AMO_INSTR) && (is_amo_instr_wb == `IS_AMO_INSTR))
            amo_stage <= `AMO_STAGE_READ;
        else
            amo_stage <= amo_stage;
    end

    reg amo_rdata_en_next;

    always @(posedge clk) begin
        if (rstn == `RESET_EN)
            amo_rdata_en_next <= !`RDATA_EN;
        else
            amo_rdata_en_next <= amo_rdata_en;
    end

    always@(*) begin
        if (amo_stage == `AMO_STAGE_IDLE)
            amo_val_lockup = `BOOL_FALSE;
        else if ((amo_rdata_en_next == `RDATA_EN) && (rdata_valid == `RDATA_VALID))
            amo_val_lockup = `BOOL_TRUE ;
        else
            amo_val_lockup = `BOOL_FALSE;
    end


    always@(*) begin
        if ((is_amo_instr_ex == `IS_AMO_INSTR) && (cancel_instr_ex != `CANCEL_INSTR))
            amo_cannot_issue = `BOOL_TRUE;
        else if ((is_amo_instr_ex2 == `IS_AMO_INSTR) && (cancel_instr_ex2 != `CANCEL_INSTR))
            amo_cannot_issue = `BOOL_TRUE;
        else if ((is_amo_instr_mem == `IS_AMO_INSTR) && (cancel_instr_mem != `CANCEL_INSTR))
            amo_cannot_issue = `BOOL_TRUE;
        else if ((is_amo_instr_wb == `IS_AMO_INSTR) && (cancel_instr_wb != `CANCEL_INSTR))
            amo_cannot_issue = `BOOL_TRUE;
        else if (is_amo_instr_dc != `IS_AMO_INSTR)
            amo_cannot_issue = `BOOL_FALSE;
        else if (amo_stage == `AMO_STAGE_WRTE) // issue to write mem and register
            amo_cannot_issue = `BOOL_FALSE;
        else
            amo_cannot_issue = `BOOL_TRUE;
    end
    
    always@(*) begin
        if (amo_stage == `AMO_STAGE_WRTE)
            amo_rdata_en = !`RDATA_EN;
        else if (is_sc)
            amo_rdata_en = !`RDATA_EN;
        else if (amo_stage == `AMO_STAGE_READ)
            amo_rdata_en = `RDATA_EN ;
        else if ((is_amo_instr_dc == `IS_AMO_INSTR) && (is_amo_instr_ex == `IS_AMO_INSTR) && (is_amo_instr_ex2 == `IS_AMO_INSTR) && (is_amo_instr_mem == `IS_AMO_INSTR) && (is_amo_instr_wb == `IS_AMO_INSTR))
            amo_rdata_en = `RDATA_EN ;
        else
            amo_rdata_en = !`RDATA_EN;
    end

    always@(*) begin
        if (amo_rdata_en == `RDATA_EN)
            amo_addr = reg_data0_dc[`DATA_ADDR_BUS];
        else
            amo_addr = `PC_RESET_ADDR;
    end       

    always@(*) begin
    `ifdef RV64
        if (is_word_op_dc != `IS_WORD_OP)
            amo_rlen = `RLEN_DWORD;
        else
    `endif
            amo_rlen = `RLEN_WORD;
    end

    reg [`DATA_ADDR_BUS] lr_addr;
    reg lr_width;
    reg lr_valid;

    always@(posedge clk) begin
        if ((amo_rdata_en == `RDATA_EN) && (rdata_valid == `RDATA_VALID) && (amo_stage == `AMO_STAGE_READ) && (is_lr))
            lr_addr <= amo_addr;
        else begin
            lr_addr <= lr_addr ;
        end
    end

    always@(posedge clk) begin
        if ((amo_rdata_en == `RDATA_EN) && (rdata_valid == `RDATA_VALID) && (amo_stage == `AMO_STAGE_READ) && (is_sc))
            lr_width <= (amo_rlen == `RLEN_WORD);
        else begin
            lr_width <= lr_width                ;
        end
    end

    always@(posedge clk) begin
        if (rstn == `RESET_EN)
            lr_valid <= !`LR_VALID;
        else if ((is_sc_mem) && (cancel_instr_mem != `CANCEL_INSTR))
            lr_valid <= !`LR_VALID;
        else if ((amo_rdata_en == `RDATA_EN) && (rdata_valid == `RDATA_VALID) && (amo_stage == `AMO_STAGE_READ) && (is_lr))
            lr_valid <= `LR_VALID ;
        else
            lr_valid <= lr_valid  ;
    end

    always@(*) begin
        if (is_sc_mem == `BOOL_FALSE)
            is_fail_sc = `BOOL_FALSE;
    `ifdef RV64
        else if ((is_word_op_dc != `IS_WORD_OP) && (lr_width)) // length mismatch
            is_fail_sc = `BOOL_TRUE ;
        else if ((is_word_op_dc == `IS_WORD_OP) && (lr_width == `BOOL_FALSE)) // length mismatch
            is_fail_sc = `BOOL_TRUE ;
    `endif
        else if (lr_valid != `LR_VALID)
            is_fail_sc = `BOOL_TRUE ;
        else if (sc_addr != lr_addr)
            is_fail_sc = `BOOL_TRUE ;
        else // sc
            is_fail_sc = `BOOL_FALSE;
    end

endmodule
