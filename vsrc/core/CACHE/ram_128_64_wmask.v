`include "params.v"

module ram_128_64_wmask (
    input                    clk        ,
    input                    rstn       ,
    input [`ENTRY_INDEX_BUS] entry_index,
    input                    wen        ,
    input [`CACHE_LINE_BUS]  wmask      ,
    input [`CACHE_LINE_BUS]  wdata      ,
    output [`CACHE_LINE_BUS] rdata      
);

    reg[`CACHE_LINE_BUS] regs[`ENTRY_BUS];

    always@(posedge clk) begin
        if (wen)
            regs[entry_index] <= (wmask & wdata) | ((~wmask) & regs[entry_index]);
        else
            regs[entry_index] <= regs[entry_index]                               ;
    end

    assign rdata = regs[entry_index];

endmodule
