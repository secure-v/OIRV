`include "params.v"

module plic (
    input                   clk                    ,
    input                   rstn                   ,
    input [`DATA_ADDR_BUS]  data_addr              ,
    input                   wen                    ,
    input [`XLEN_BUS]       wdata                  ,
    input [`WLEN_BUS]       wlen                   ,
    input                   irq1                   ,
    input                   int_under_handle       , 
    input                   hold_mem               , 
    output reg              external_interrupt     ,
    output reg              plic_ready             
    );

    reg irq1_lock;
    reg [`PLIC_PENDING_BUS] plic_pending/*verilator public*/;
    reg [`PLIC_ENABLE_BUS] plic_enable/*verilator public*/;
    reg [`PLIC_THRESHOLD_BUS] plic_threshold/*verilator public*/;

    reg [`EXTERNAL_DEVICE_PRIORITY_BUS] priority_irq1/*verilator public*/;
    reg [`CLAIM_COMPLETE_BUS] claim_complete_irq1/*verilator public*/;

    always@(posedge clk) begin
        if (rstn == `RESET_EN)
            plic_ready <= !`PLIC_READY;
        else if (irq1 || irq1_lock || (int_under_handle == `INT_UNDER_HANDLE))
            plic_ready <= !`PLIC_READY;
        else if (!irq1_lock)
            plic_ready <= `PLIC_READY;
        else
            plic_ready <= plic_ready;
    end

    always@(posedge clk) begin
        if (rstn == `RESET_EN)
            irq1_lock <= `ZERO;
        else if ((wen == `WDATA_EN) && (data_addr == (`CLAIM_COMPLETE_ADDR + 1 * 4)))
            irq1_lock <= `ZERO;
        else if ((int_under_handle == `INT_UNDER_HANDLE) && irq1_lock)
            irq1_lock <= `ZERO;                         // 
        else if (irq1_lock) // not handled
            irq1_lock <= irq1_lock;
        else if (irq1)
            irq1_lock <= 1;
        else
            irq1_lock <= irq1_lock;
    end

    always@(posedge clk) begin
        if (rstn == `RESET_EN)
            plic_enable <= `ZERO;
        else if ((wen == `WDATA_EN) && (wlen == `WLEN_WORD) && (data_addr == `PLIC_ENABLE_ADDR))
            plic_enable <= {plic_enable[63:32], wdata[31:0]};
        else if ((wen == `WDATA_EN) && (wlen == `WLEN_WORD) && (data_addr == (`PLIC_ENABLE_ADDR + 4)))
            plic_enable <= {wdata[31:0], plic_enable[31:0]};
    `ifdef RV64
        else if ((wen == `WDATA_EN) && (wlen == `WLEN_DWORD) && (data_addr == `PLIC_ENABLE_ADDR))
            plic_enable <= wdata;
    `endif
        else
            plic_enable <= plic_enable;
    end

    always@(posedge clk) begin
        if (rstn == `RESET_EN)
            plic_pending <= `ZERO;
        else if ((wen == `WDATA_EN) && (wlen == `WLEN_WORD) && (data_addr == `PLIC_PENDING_ADDR))
            plic_pending <= {plic_pending[63:32], wdata[31:0]};
        else if ((wen == `WDATA_EN) && (wlen == `WLEN_WORD) && (data_addr == (`PLIC_PENDING_ADDR + 4)))
            plic_pending <= {wdata[31:0], plic_pending[31:0]};
    `ifdef RV64
        else if ((wen == `WDATA_EN) && (wlen == `WLEN_DWORD) && (data_addr == `PLIC_PENDING_ADDR))
            plic_pending <= wdata;
    `endif
        else if (irq1)
            plic_pending <= plic_pending | (~`UART_PENDING_MASK);
        else if ((wen == `WDATA_EN) && (data_addr == (`CLAIM_COMPLETE_ADDR + 1 * 4)))
            plic_pending <= plic_pending & (`UART_PENDING_MASK);
        else
            plic_pending <= plic_pending;
    end


    always@(posedge clk) begin
        if (rstn == `RESET_EN)
            plic_threshold <= `ZERO;
        else if ((wen == `WDATA_EN) && (wlen == `WLEN_WORD) && (data_addr == `PLIC_THRESHOLD_ADDR))
            plic_threshold <= wdata[`PLIC_THRESHOLD_BUS];
        else
            plic_threshold <= plic_threshold;
    end

    always@(posedge clk) begin
        if (rstn == `RESET_EN)
            priority_irq1 <= `ZERO;
        else if ((wen == `WDATA_EN) && (wlen == `WLEN_WORD) && (data_addr == (`PLIC_BASE_ADDR + 1 * 4)))
            priority_irq1 <= wdata[`EXTERNAL_DEVICE_PRIORITY_BUS];
        else
            priority_irq1 <= priority_irq1;
    end

    always@(posedge clk) begin
        if (rstn == `RESET_EN)
            external_interrupt <= !`EXTERNAL_INTERRUPT;
        else if (hold_mem == `HOLD)
            external_interrupt <= external_interrupt;
        else if (int_under_handle == `INT_UNDER_HANDLE)
            external_interrupt <= !`EXTERNAL_INTERRUPT;
        else if (plic_enable[1] && (priority_irq1 > plic_threshold) && irq1_lock && (int_under_handle == !`INT_UNDER_HANDLE))
            external_interrupt <= `EXTERNAL_INTERRUPT;
        else if ((wen == `WDATA_EN) && (data_addr == (`CLAIM_COMPLETE_ADDR + 1 * 4)))
            external_interrupt <= !`EXTERNAL_INTERRUPT;
        else
            external_interrupt <= external_interrupt;
    end

    always@(posedge clk) begin
        if (rstn == `RESET_EN)
            claim_complete_irq1 <= `ZERO;
        else if ((wen == `WDATA_EN) && (wlen == `WLEN_WORD) && (data_addr == (`CLAIM_COMPLETE_ADDR + 1 * 4)))
            claim_complete_irq1 <= wdata[`CLAIM_COMPLETE_BUS];
        else if (plic_enable[1] && (priority_irq1 > plic_threshold) && irq1_lock && (int_under_handle == !`INT_UNDER_HANDLE))
            claim_complete_irq1 <= 1; // irq1
        else
            claim_complete_irq1 <= claim_complete_irq1;
    end

endmodule


