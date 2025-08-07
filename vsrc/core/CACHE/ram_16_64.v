`include "params.v"

module ram_16_64 (
    input                    clk        ,
    input                    rstn       ,
    input [3:0]              rindex     ,
    input [3:0]              windex     ,
    input                    wen        ,
    input [`CACHE_LINE_BUS]  wdata      ,
    output [`CACHE_LINE_BUS] rdata      
);

    reg[`CACHE_LINE_BUS] regs[15:0];

    always@(posedge clk) begin
        if (wen)
            regs[windex] <=        wdata;
        else
            regs[windex] <= regs[windex];
    end

    assign rdata = regs[rindex];

endmodule
