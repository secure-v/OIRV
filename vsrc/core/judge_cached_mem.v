`include "params.v"

module judge_cached_mem (
    input                         clk            ,
    input                         rstn           ,
    input [`DATA_ADDR_BUS]        data_addr      , // ex2 stage
    output                        is_cache_mem   ,
    output                        is_device_write
);

    assign is_cache_mem = ((data_addr != `UART_ADDR) && (data_addr != `MTIME_ADDR) && (data_addr != `MTIMECMP_ADDR) && (data_addr != `PLIC_BASE_ADDR) && (data_addr != `UART_PRIORITY_ADDR) && (data_addr != `PLIC_THRESHOLD_ADDR) && (data_addr != `CLAIM_COMPLETE_ADDR) && (data_addr != `UART_CLAIM_COMPLETE) && (data_addr != `PLIC_PENDING_ADDR) && (data_addr != `PLIC_ENABLE_ADDR))? `IS_CACHE_MEM : !`IS_CACHE_MEM;
    assign is_device_write = ((data_addr == `PLIC_THRESHOLD_ADDR) || (data_addr == `MTIME_ADDR) || (data_addr == `UART_PRIORITY_ADDR) || (data_addr == `PLIC_PENDING_ADDR) || (data_addr == `UART_CLAIM_COMPLETE) || (data_addr == `PLIC_ENABLE_ADDR) || (data_addr == `PLIC_THRESHOLD_ADDR));
    
endmodule
