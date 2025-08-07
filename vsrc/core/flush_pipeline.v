`include "params.v"

module flush_pipeline (
`ifdef ZICSR_EXTENSION
	input                    wcsr_en_wb          ,
    output                   is_csr_instr_in_wb  ,  
`endif 
    input                    cancel_instr_mem    ,
    input                    cancel_instr_wb     ,
    input                    wdata_en_mem        ,
    input                    is_ecall_instr_wb   ,
    input                    is_mret_instr_wb    ,
    input                    interrupt_taken     ,
`ifndef PROC_BRANCH_IN_DC
	input                    branch_taken_ex2    ,
	input                    branch_taken_mem    ,
`endif
    input                    is_fencei_wb        ,
    output                   is_ecall_instr_in_wb,
    output                   is_mret_instr_in_wb ,
    output reg               flush_if            ,
    output reg               flush_dc            ,
    output reg               flush_ex            ,
    output reg               flush_ex2           ,
    output reg               flush_mem                   
);
	
`ifdef ZICSR_EXTENSION
	assign is_csr_instr_in_wb    = ((wcsr_en_wb == `W_CSR_EN) && (cancel_instr_wb != `CANCEL_INSTR))? `CSR_INSTR_IN_WB : !`CSR_INSTR_IN_WB;
    assign is_ecall_instr_in_wb  = ((is_ecall_instr_wb == `IS_ECALL_INSTR) && (cancel_instr_wb != `CANCEL_INSTR))? `IS_ECALL_INSTR : !`IS_ECALL_INSTR;
    assign is_mret_instr_in_wb   = ((is_mret_instr_wb == `IS_MRET_INSTR) && (cancel_instr_wb != `CANCEL_INSTR))? `IS_MRET_INSTR : !`IS_MRET_INSTR;
`endif

    always@(*) begin
        if ((is_fencei_wb) || (interrupt_taken == `INTERRUPT_TAKEN) || (is_csr_instr_in_wb == `CSR_INSTR_IN_WB) || (is_ecall_instr_in_wb == `IS_ECALL_INSTR) || (is_mret_instr_in_wb == `IS_MRET_INSTR)) begin
            flush_if  = `FLUSH_PIPELINE ;
            flush_dc  = `FLUSH_PIPELINE ;
            flush_ex  = `FLUSH_PIPELINE ;
            flush_ex2 = `FLUSH_PIPELINE ;
            flush_mem = `FLUSH_PIPELINE ;
        end
    `ifndef PROC_BRANCH_IN_DC
        // else if (branch_taken_mem == `BOOL_TRUE) begin
        //     flush_if  =  `FLUSH_PIPELINE;
        //     flush_dc  =  `FLUSH_PIPELINE;
        //     flush_ex  =  `FLUSH_PIPELINE;
        //     flush_ex2 =  `FLUSH_PIPELINE;
        //     flush_mem = !`FLUSH_PIPELINE;
        // end
        else if (branch_taken_ex2 == `BOOL_TRUE) begin
            flush_if  =  `FLUSH_PIPELINE;
            flush_dc  =  `FLUSH_PIPELINE;
            flush_ex  =  `FLUSH_PIPELINE;
            flush_ex2 = !`FLUSH_PIPELINE;
            flush_mem = !`FLUSH_PIPELINE;
        end
    `endif
        else begin
            flush_if  = !`FLUSH_PIPELINE;
            flush_dc  = !`FLUSH_PIPELINE;
            flush_ex  = !`FLUSH_PIPELINE;
            flush_ex2 = !`FLUSH_PIPELINE;
            flush_mem = !`FLUSH_PIPELINE;
        end
    end

    // always@(*) begin
    //     if ((flush_mem == `FLUSH_PIPELINE) || (cancel_instr_mem == `CANCEL_INSTR) || (interrupt_taken == `INTERRUPT_TAKEN))
    //         wdata_en = !`WDATA_EN  ;
    //     else
    //         wdata_en = wdata_en_mem;
    // end

endmodule


