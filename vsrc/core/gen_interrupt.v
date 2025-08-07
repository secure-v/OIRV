`include "params.v"

module gen_interrupt (
    input         cancel_instr_ex2        ,
    input         mstatus_mie             ,
`ifdef A_EXTENSION
    input         is_amo_instr_mem        ,
`endif
    input         mtime_interrupt         , // from clint
    input         external_interrupt      , // from plic
    output        mtime_interrupt_ex2     ,
    output        external_interrupt_ex2        
);

`ifdef A_EXTENSION
    assign mtime_interrupt_ex2 = ((is_amo_instr_mem != `IS_AMO_INSTR) && (mstatus_mie == !`INT_DISABLE) && (mtime_interrupt == `TIME_INTERRUPT) && (cancel_instr_ex2 != `CANCEL_INSTR))? `TIME_INTERRUPT : !`TIME_INTERRUPT;
    assign external_interrupt_ex2 = ((is_amo_instr_mem != `IS_AMO_INSTR) && (mstatus_mie == !`INT_DISABLE) && (external_interrupt == `TIME_INTERRUPT) && (cancel_instr_ex2 != `CANCEL_INSTR))? `EXTERNAL_INTERRUPT : !`EXTERNAL_INTERRUPT;
`else
    assign mtime_interrupt_ex2 = ((mstatus_mie == !`INT_DISABLE) && (mtime_interrupt == `TIME_INTERRUPT) && (cancel_instr_ex2 != `CANCEL_INSTR))? `TIME_INTERRUPT : !`TIME_INTERRUPT;
    assign external_interrupt_ex2 = ((mstatus_mie == !`INT_DISABLE) && (external_interrupt == `TIME_INTERRUPT) && (cancel_instr_ex2 != `CANCEL_INSTR))? `EXTERNAL_INTERRUPT : !`EXTERNAL_INTERRUPT;
`endif    
    
endmodule