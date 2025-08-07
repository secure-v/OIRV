`include "params.v"

module sram_128_64 (
    input                       clk        ,
    input                       rstn       ,
    input [`ENTRY_INDEX_BUS]    entry_index,
    input                       ren        ,
    input                       wen        ,
    input [`CACHE_LINE_BUS]     wmask      ,
    input [`CACHE_LINE_BUS]     wdata      ,
    output reg[`CACHE_LINE_BUS] rdata      
);

    reg[`CACHE_LINE_BUS] regs[`ENTRY_BUS];
    reg[`ENTRY_INDEX_BUS] index;

    always@(posedge clk) begin
        if (wen)
            regs[entry_index] <= (wmask & wdata) | ((~wmask) & regs[entry_index]);
        else
            regs[entry_index] <= regs[entry_index]                               ;
    end

    always@(posedge clk) begin
        if (ren && (!wen))
            index <= entry_index;
        else
            index <= `ZERO      ;
    end

    always@(*) begin
        rdata = regs[index];
    end

endmodule
